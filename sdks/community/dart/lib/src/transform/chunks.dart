/// Expands the chunk shorthand into the explicit START/CONTENT/END triads.
///
/// Dart port of the TypeScript client's `chunks/transform.ts`. The shorthand
/// lets a producer send one chunk event per partial message instead of three
/// explicit events; this stage turns each one into the events the rest of the
/// pipeline expects.
///
/// The stream a lane is assembling is identified only by "the same as before",
/// so assembly state is kept per lane — a lane being the subagent its chunks are
/// attributed to, with `null` the parent agent. A run that never attributes
/// anything uses only the `null` lane.
library;

import 'dart:async';

import '../debug_logger.dart';
import '../events/events.dart';
import '../types/base.dart';

/// The kind of entity a lane is assembling.
enum _PendingKind { text, tool, reasoning }

/// The text-message properties a chunk shorthand establishes for one lane.
final class _TextMessageFields {
  const _TextMessageFields({
    required this.messageId,
    required this.role,
    this.name,
    this.subagentRunId,
  });

  final String messageId;

  /// The role the opener ESTABLISHED — explicit, or the assistant default the
  /// synthesized START carried. Kept so a later chunk that repeats the field can
  /// be judged against what the stream already said.
  final TextMessageRole role;
  final String? name;
  final String? subagentRunId;
}

/// The tool-call properties a chunk shorthand establishes for one lane.
final class _ToolCallFields {
  const _ToolCallFields({
    required this.toolCallId,
    required this.toolCallName,
    this.parentMessageId,
    this.subagentRunId,
  });

  final String toolCallId;
  final String toolCallName;
  final String? parentMessageId;
  final String? subagentRunId;
}

/// The reasoning-message properties a chunk shorthand establishes for one lane.
final class _ReasoningMessageFields {
  const _ReasoningMessageFields({required this.messageId, this.subagentRunId});

  final String messageId;
  final String? subagentRunId;
}

/// The stream one lane is currently assembling from chunks.
///
/// A lane holds at most one, because the chunk shorthand identifies a
/// continuation only by "the same as before".
sealed class _PendingStream {
  const _PendingStream();

  _PendingKind get kind;

  /// The id the pending stream is keyed by, whichever kind it is.
  String get entityId;

  /// The owner of the pending stream, `null` being the parent agent.
  String? get subagentRunId;

  /// The END event that closes the message this stream was assembling.
  BaseEvent toEndEvent();
}

/// The id field a first chunk of [kind] must carry.
String _missingIdFieldName(_PendingKind kind) =>
    kind == _PendingKind.tool ? 'toolCallId' : 'messageId';

final class _TextPendingStream extends _PendingStream {
  const _TextPendingStream(this.fields);

  final _TextMessageFields fields;

  @override
  _PendingKind get kind => _PendingKind.text;

  @override
  String get entityId => fields.messageId;

  @override
  String? get subagentRunId => fields.subagentRunId;

  @override
  BaseEvent toEndEvent() => TextMessageEndEvent(
        messageId: fields.messageId,
        subagentRunId: fields.subagentRunId,
      );
}

final class _ToolPendingStream extends _PendingStream {
  const _ToolPendingStream(this.fields);

  final _ToolCallFields fields;

  @override
  _PendingKind get kind => _PendingKind.tool;

  @override
  String get entityId => fields.toolCallId;

  @override
  String? get subagentRunId => fields.subagentRunId;

  @override
  BaseEvent toEndEvent() => ToolCallEndEvent(
        toolCallId: fields.toolCallId,
        subagentRunId: fields.subagentRunId,
      );
}

final class _ReasoningPendingStream extends _PendingStream {
  const _ReasoningPendingStream(this.fields);

  final _ReasoningMessageFields fields;

  @override
  _PendingKind get kind => _PendingKind.reasoning;

  @override
  String get entityId => fields.messageId;

  @override
  String? get subagentRunId => fields.subagentRunId;

  @override
  BaseEvent toEndEvent() => ReasoningMessageEndEvent(
        messageId: fields.messageId,
        subagentRunId: fields.subagentRunId,
      );
}

/// A continuation chunk MAY repeat a field its opener established, but only
/// with the same value. A conflicting repeat is a malformed known value, and
/// fatal — rejected here rather than left to verification because the repeated
/// field never survives expansion: the synthesized content event does not carry
/// it, so downstream stages would never see the disagreement.
void _requireOpenerAgreement(
  String entityKind,
  String entityId,
  String field,
  String? incoming,
  String? established,
) {
  if (incoming != null && incoming != established) {
    final expected = established == null ? '(absent)' : "'$established'";
    throw AGUIError(
      "Cannot continue $entityKind '$entityId': chunk $field '$incoming' "
      "does not match the open stream's $field $expected.",
    );
  }
}

/// Holds the per-lane assembly state and expands one event at a time.
final class _ChunkTransformer {
  final Map<String?, _PendingStream> _lanes = <String?, _PendingStream>{};

  /// Drops whatever is still mid-assembly. The END events [closeLane] builds
  /// are discarded — the source has already completed, so there is nowhere to
  /// emit them; this only clears state that would otherwise outlive a
  /// subscription.
  void reset() => _lanes.clear();

  /// Emit the END for whatever [owner] has open, and clear the lane.
  List<BaseEvent> closeLane(String? owner) {
    final pending = _lanes.remove(owner);
    if (pending == null) {
      return const <BaseEvent>[];
    }
    return <BaseEvent>[pending.toEndEvent()];
  }

  /// Close every lane, in the order they opened.
  List<BaseEvent> _closeAllLanes() {
    final owners = _lanes.keys.toList(growable: false);
    return <BaseEvent>[for (final owner in owners) ...closeLane(owner)];
  }

  /// The lane holding an open stream of [kind] under [entityId], if any.
  ({String? owner})? _laneHolding(_PendingKind kind, String entityId) {
    for (final entry in _lanes.entries) {
      final pending = entry.value;
      if (pending.kind == kind && pending.entityId == entityId) {
        return (owner: entry.key);
      }
    }
    return null;
  }

  /// Decide which lane a chunk belongs to.
  ///
  /// Every chunk carries its own `subagentRunId`, which is what makes per-lane
  /// assembly possible at all — but the shorthand lets a continuation omit both
  /// the id and the tag, so the lane has to be inferred.
  String? _resolveLane(
    _PendingKind kind,
    String? entityId,
    String? tag,
    String chunkType,
    String entityKind,
  ) {
    if (entityId != null) {
      // A named id continues wherever it is already open, regardless of who
      // sends it, so the id remains the strongest signal. A tag that disagrees
      // with that lane is the contradiction the continuation-owner rule
      // forbids: rejected here rather than left to verification, because a
      // chunk carrying attribution but no delta synthesizes nothing, so the
      // disagreement would never reach the verifier.
      final holder = _laneHolding(kind, entityId);
      if (holder != null) {
        final owner = holder.owner;
        if (tag != null && tag != owner) {
          throw AGUIError(
            "Cannot continue $entityKind '$entityId': chunk subagentRunId "
            "'$tag' does not match the open stream's subagent "
            "'${owner ?? '(the parent agent)'}'.",
          );
        }
        return owner;
      }
      // An id nobody holds opens a new stream, in the lane its own tag names.
      return tag;
    }

    // Continuation shorthand. A tag names its lane outright.
    if (tag != null) {
      return tag;
    }

    // Untagged means the parent agent, so prefer the parent's own open stream.
    final parentPending = _lanes[null];
    if (parentPending != null && parentPending.kind == kind) {
      return null;
    }

    // Otherwise fall back to the sole open stream of this kind, so producers
    // that attribute only the opening chunk keep working. An id-less chunk can
    // never OPEN a stream (a first chunk must carry its id), so when the parent
    // has no stream of this kind to continue, the sole open stream is the
    // chunk's only possible referent.
    final candidates = _lanes.entries
        .where((entry) => entry.value.kind == kind)
        .toList(growable: false);
    if (candidates.length == 1) {
      return candidates.first.key;
    }
    if (candidates.length > 1) {
      throw AGUIError(
        'Ambiguous $chunkType: it carries neither a '
        '${_missingIdFieldName(kind)} nor a subagentRunId, but '
        '${candidates.length} lanes have an open '
        '$entityKind. Attribute the chunk to the subagent it belongs to.',
      );
    }
    // No lane has an open stream of this kind, so there is nothing to continue:
    // the caller opens a new stream in the parent lane, or reports the missing
    // id.
    return null;
  }

  /// Expand one event into the events this stage delivers.
  ///
  /// Throws [AGUIError] for a fatal chunk-stream violation; the caller turns
  /// that into a stream error.
  List<BaseEvent> expand(BaseEvent event) {
    switch (event.eventType) {
      case EventType.textMessageStart:
      case EventType.textMessageContent:
      case EventType.textMessageEnd:
      case EventType.toolCallStart:
      case EventType.toolCallArgs:
      case EventType.toolCallEnd:
      case EventType.toolCallResult:
      case EventType.stateSnapshot:
      case EventType.stateDelta:
      case EventType.custom:
      case EventType.stepStarted:
      case EventType.stepFinished:
      case EventType.reasoningStart:
      case EventType.reasoningMessageStart:
      case EventType.reasoningMessageContent:
      case EventType.reasoningMessageEnd:
      case EventType.reasoningEnd:
        // An explicit event closes only ITS OWN lane's pending stream. Events
        // that carry no tag read as the parent lane, which is what they are.
        return <BaseEvent>[...closeLane(event.subagentRunId), event];

      // Run-level events describe the run as a whole rather than any one
      // producer within it, so every lane closes — otherwise a subagent's chunk
      // stream would outlive the run that carried it. MESSAGES_SNAPSHOT belongs
      // here too: it restates the entire conversation, and attributes per
      // message rather than carrying one owner of its own.
      case EventType.runStarted:
      case EventType.runFinished:
      case EventType.runError:
      case EventType.messagesSnapshot:
        return <BaseEvent>[..._closeAllLanes(), event];

      // These stand aside from chunk assembly: RAW is provider payload, not
      // protocol traffic, and the rest describe something other than a
      // streamed message.
      case EventType.raw:
      case EventType.activitySnapshot:
      case EventType.activityDelta:
      case EventType.reasoningEncryptedValue:
      case EventType.subagentStarted:
        return <BaseEvent>[event];

      // A subagent's terminal closes any stream still being assembled from
      // chunks in its own lane. A terminal with no id is malformed and must not
      // be read as closing the parent lane.
      case EventType.subagentFinished:
      case EventType.subagentError:
        final terminalOwner = event.subagentRunId;
        if (terminalOwner == null) {
          return <BaseEvent>[event];
        }
        return <BaseEvent>[...closeLane(terminalOwner), event];

      case EventType.textMessageChunk:
        return _expandText(event as TextMessageChunkEvent);

      case EventType.toolCallChunk:
        return _expandToolCall(event as ToolCallChunkEvent);

      case EventType.reasoningMessageChunk:
        return _expandReasoning(event as ReasoningMessageChunkEvent);

      // Not a chunk event: a legacy type a compat middleware still translates,
      // a future one, or simply an event this stage has no assembly to do for.
      // Not this stage's to judge — it passes through untouched and downstream
      // layers decide.
      default:
        return <BaseEvent>[event];
    }
  }

  List<BaseEvent> _expandText(TextMessageChunkEvent chunk) {
    final lane = _resolveLane(
      _PendingKind.text,
      chunk.messageId,
      chunk.subagentRunId,
      'TEXT_MESSAGE_CHUNK',
      'text message',
    );
    final open = _lanes[lane];
    final result = <BaseEvent>[];
    final _TextMessageFields fields;

    if (open is _TextPendingStream &&
        // An absent id continues; a present one must be the same message.
        (chunk.messageId == null || chunk.messageId == open.fields.messageId)) {
      _requireOpenerAgreement(
        'text message',
        open.fields.messageId,
        'role',
        chunk.role?.value,
        open.fields.role.value,
      );
      _requireOpenerAgreement(
        'text message',
        open.fields.messageId,
        'name',
        chunk.name,
        open.fields.name,
      );
      fields = open.fields;
    } else {
      // Whatever else this lane had open ends before the new stream begins.
      result.addAll(closeLane(lane));

      final messageId = chunk.messageId;
      if (messageId == null) {
        throw const AGUIError('First TEXT_MESSAGE_CHUNK must have a messageId');
      }

      // An ABSENT role means assistant, which the spec states normatively. A
      // role that is present but wrong is not repaired here: it has not been
      // judged yet on the middleware path, and substituting for it would fix a
      // producer defect that is fatal when the same value is sent unchunked.
      fields = _TextMessageFields(
        messageId: messageId,
        role: chunk.role ?? TextMessageRole.assistant,
        name: chunk.name,
        subagentRunId: chunk.subagentRunId,
      );
      _lanes[lane] = _TextPendingStream(fields);

      result.add(
        TextMessageStartEvent(
          messageId: messageId,
          role: fields.role,
          name: chunk.name,
          metadata: chunk.metadata,
          subagentRunId: chunk.subagentRunId,
        ),
      );
    }

    // A content event is emitted when the chunk carries a delta OR a provider
    // payload. The synthesized START deliberately claims no rawEvent, so a
    // first chunk carrying rawEvent but no delta needs this event as the
    // payload's carrier, exactly as a continuation does.
    if (chunk.delta != null || chunk.rawEvent != null) {
      final contentOwner = chunk.subagentRunId ?? fields.subagentRunId;
      result.add(
        TextMessageContentEvent(
          messageId: fields.messageId,
          delta: chunk.delta ?? '',
          rawEvent: chunk.rawEvent,
          metadata: chunk.metadata,
          // Prefer the INCOMING chunk's tag over the opener's, so a producer
          // that attributes every chunk sees its own attribution on the output
          // rather than a value this transform remembered.
          subagentRunId: contentOwner,
        ),
      );
    }

    // A continuation chunk carrying only metadata — a final chunk with usage
    // and a finish reason — synthesizes nothing above. Emit a zero-delta
    // content event so the metadata still reaches the reducer. The gate also
    // fires for a chunk carrying only `rawEvent`, a provider payload being
    // content whichever field it rides.
    if (result.isEmpty && (chunk.metadata != null || chunk.rawEvent != null)) {
      final metadataOwner = chunk.subagentRunId ?? fields.subagentRunId;
      result.add(
        TextMessageContentEvent(
          messageId: fields.messageId,
          delta: '',
          rawEvent: chunk.rawEvent,
          metadata: chunk.metadata,
          subagentRunId: metadataOwner,
        ),
      );
    }

    return result;
  }

  List<BaseEvent> _expandToolCall(ToolCallChunkEvent chunk) {
    final lane = _resolveLane(
      _PendingKind.tool,
      chunk.toolCallId,
      chunk.subagentRunId,
      'TOOL_CALL_CHUNK',
      'tool call',
    );
    final open = _lanes[lane];
    final result = <BaseEvent>[];
    final _ToolCallFields fields;

    if (open is _ToolPendingStream &&
        (chunk.toolCallId == null ||
            chunk.toolCallId == open.fields.toolCallId)) {
      _requireOpenerAgreement(
        'tool call',
        open.fields.toolCallId,
        'toolCallName',
        chunk.toolCallName,
        open.fields.toolCallName,
      );
      _requireOpenerAgreement(
        'tool call',
        open.fields.toolCallId,
        'parentMessageId',
        chunk.parentMessageId,
        open.fields.parentMessageId,
      );
      fields = open.fields;
    } else {
      result.addAll(closeLane(lane));

      final toolCallId = chunk.toolCallId;
      final toolCallName = chunk.toolCallName;
      if (toolCallId == null) {
        throw const AGUIError('First TOOL_CALL_CHUNK must have a toolCallId');
      }
      if (toolCallName == null) {
        throw const AGUIError('First TOOL_CALL_CHUNK must have a toolCallName');
      }
      fields = _ToolCallFields(
        toolCallId: toolCallId,
        toolCallName: toolCallName,
        parentMessageId: chunk.parentMessageId,
        subagentRunId: chunk.subagentRunId,
      );
      _lanes[lane] = _ToolPendingStream(fields);

      result.add(
        ToolCallStartEvent(
          toolCallId: toolCallId,
          toolCallName: toolCallName,
          parentMessageId: chunk.parentMessageId,
          metadata: chunk.metadata,
          subagentRunId: chunk.subagentRunId,
        ),
      );
    }

    if (chunk.delta != null || chunk.rawEvent != null) {
      final argsOwner = chunk.subagentRunId ?? fields.subagentRunId;
      result.add(
        ToolCallArgsEvent(
          toolCallId: fields.toolCallId,
          delta: chunk.delta ?? '',
          rawEvent: chunk.rawEvent,
          metadata: chunk.metadata,
          subagentRunId: argsOwner,
        ),
      );
    }

    // Same as the text case above.
    if (result.isEmpty && (chunk.metadata != null || chunk.rawEvent != null)) {
      final metadataOwner = chunk.subagentRunId ?? fields.subagentRunId;
      result.add(
        ToolCallArgsEvent(
          toolCallId: fields.toolCallId,
          delta: '',
          rawEvent: chunk.rawEvent,
          metadata: chunk.metadata,
          subagentRunId: metadataOwner,
        ),
      );
    }

    return result;
  }

  List<BaseEvent> _expandReasoning(ReasoningMessageChunkEvent chunk) {
    final lane = _resolveLane(
      _PendingKind.reasoning,
      chunk.messageId,
      chunk.subagentRunId,
      'REASONING_MESSAGE_CHUNK',
      'reasoning message',
    );
    final open = _lanes[lane];
    final result = <BaseEvent>[];
    final _ReasoningMessageFields fields;

    if (open is _ReasoningPendingStream &&
        // `!= null`, not truthiness, to match the text and tool branches: an
        // explicitly empty id is a present id that denotes a NEW stream.
        (chunk.messageId == null || chunk.messageId == open.fields.messageId)) {
      fields = open.fields;
    } else {
      result.addAll(closeLane(lane));

      final messageId = chunk.messageId;
      if (messageId == null) {
        throw const AGUIError(
          'First REASONING_MESSAGE_CHUNK must have a messageId',
        );
      }

      fields = _ReasoningMessageFields(
        messageId: messageId,
        subagentRunId: chunk.subagentRunId,
      );
      _lanes[lane] = _ReasoningPendingStream(fields);

      result.add(
        ReasoningMessageStartEvent(
          messageId: messageId,
          metadata: chunk.metadata,
          subagentRunId: chunk.subagentRunId,
        ),
      );
    }

    if (chunk.delta != null || chunk.rawEvent != null) {
      final contentOwner = chunk.subagentRunId ?? fields.subagentRunId;
      result.add(
        ReasoningMessageContentEvent(
          messageId: fields.messageId,
          delta: chunk.delta ?? '',
          rawEvent: chunk.rawEvent,
          metadata: chunk.metadata,
          subagentRunId: contentOwner,
        ),
      );
    }

    // Same as the text case above.
    if (result.isEmpty && (chunk.metadata != null || chunk.rawEvent != null)) {
      final metadataOwner = chunk.subagentRunId ?? fields.subagentRunId;
      result.add(
        ReasoningMessageContentEvent(
          messageId: fields.messageId,
          delta: '',
          rawEvent: chunk.rawEvent,
          metadata: chunk.metadata,
          subagentRunId: metadataOwner,
        ),
      );
    }

    return result;
  }
}

/// Expands the chunk shorthand carried by [events] into the explicit
/// START/CONTENT/END triads.
///
/// A chunk-stream violation surfaces as an error on the returned stream and
/// terminates it, matching the TypeScript client's `mergeMap` projection
/// throwing.
Stream<BaseEvent> transformChunks(
  Stream<BaseEvent> events, {
  Object? debugLogger,
}) async* {
  final log = resolveDebugLogger(debugLogger);
  final transformer = _ChunkTransformer();

  await for (final event in events) {
    for (final transformed in transformer.expand(event)) {
      log?.event('TRANSFORM', transformed.type, transformed, {
        'type': transformed.type,
      });
      yield transformed;
    }
  }

  // A stream that ends without a run terminal leaves its last lane open, and
  // the synthesized END has nowhere to go: the stream has already terminated.
  // Only the state is cleared, which matters for an operator instance that
  // outlives one subscription.
  transformer.reset();
}
