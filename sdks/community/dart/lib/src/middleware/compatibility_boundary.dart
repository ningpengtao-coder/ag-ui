/// The always-on pre-1.0 compatibility boundary and the protocol-version
/// negotiation helpers it relies on.
///
/// The boundary is the translator, not the gate: a legacy-shaped event
/// arriving is itself the proof the peer is old, so every retired shape the
/// client still understands is upgraded here regardless of the peer's declared
/// ceiling. Anything nothing translates is left for the enforcement stage to
/// drop with a warning. Version-gated downgrades live in the era shims.
library;

import 'dart:async';

import '../agent/agent.dart';
import '../diagnostics.dart';
import '../events/events.dart';
import '../types/types.dart';
import 'legacy_content.dart';
import 'middleware.dart';

/// The protocol version this client speaks, declared on a run input the way
/// the 1.0 contract requires.
const String agUiProtocolVersion = '1.0';

/// How a producer's `RUN_STARTED.protocolVersion` compares to what this client
/// speaks.
enum DeclaredProtocolComparison {
  /// The producer declares a version above this client's: material this client
  /// cannot read may arrive, so it warns rather than staying silent.
  newer,

  /// The producer declares this client's version or an older one. Older or
  /// absent is the downgrade signal the versioning rules expect a consumer to
  /// notice quietly.
  notNewer,

  /// The declaration is outside the published `MAJOR.MINOR` grammar, so it
  /// cannot be compared and is handled like a newer one.
  uninterpretable,
}

/// Judges [declared] against [spoken].
///
/// The grammar — two numeric components — is checked before any comparison so
/// that `1`, `1.0.0` or `1.x` are reported as uninterpretable instead of being
/// read as equal to `1.0`.
DeclaredProtocolComparison compareDeclaredProtocol(
  String declared,
  String spoken,
) {
  final grammar = RegExp(r'^\d+\.\d+$');
  if (!grammar.hasMatch(declared)) {
    return DeclaredProtocolComparison.uninterpretable;
  }
  return _compareVersions(declared, spoken) > 0
      ? DeclaredProtocolComparison.newer
      : DeclaredProtocolComparison.notNewer;
}

/// Announces a producer declaration this client is not indifferent to.
void warnOnProducerDeclaration(String? declared) {
  if (declared == null || declared == agUiProtocolVersion) {
    return;
  }
  switch (compareDeclaredProtocol(declared, agUiProtocolVersion)) {
    case DeclaredProtocolComparison.uninterpretable:
      AgUiDiagnostics.warn(
        "The producer declared protocol version '$declared', which this "
        'client cannot interpret.',
      );
    case DeclaredProtocolComparison.newer:
      AgUiDiagnostics.warn(
        'The producer speaks protocol $declared; this client speaks '
        '$agUiProtocolVersion. Unrecognised material will be stripped with '
        'warnings.',
      );
    case DeclaredProtocolComparison.notNewer:
      return;
  }
}

/// Mints the ids the boundary needs when a producer's legacy event names none.
///
/// The TypeScript boundary calls `randomUUID()` here. This port must not
/// invent random data, so each id is derived from the run it belongs to plus a
/// per-boundary sequence: deterministic for a given run, and traceable back to
/// the run that produced it.
class CompatIdMinter {
  CompatIdMinter(this.runId);

  final String runId;
  int _sequence = 0;

  String next(String kind) => 'compat-$kind-$runId-${++_sequence}';
}

/// The always-on pre-1.0 compatibility boundary.
///
/// Inbound conversions, each one warned:
/// - `THINKING_*` events -> their `REASONING_*` equivalents. The version-gated
///   [BackwardCompatibility_0_0_45] runs the same state machine with its own
///   0.0.45 threshold, but this middleware is appended innermost, sees every
///   thinking event first, and so usually leaves the shim nothing to do.
/// - Legacy binary content parts inside inbound messages (`MESSAGES_SNAPSHOT`,
///   `RUN_STARTED.input`) -> the modern media parts.
///
/// Outgoing legacy binary attachments are upgraded too, before the transport
/// sees them: their shape identifies the conversion regardless of the peer
/// ceiling.
///
/// Whole optional nulls need no conversion here. The Dart model decodes an
/// explicit `null` in a whole-optional field as absent
/// ([JsonDecoder.optionalField] answers `null` for both) and never serializes
/// it back, so the normalization the TypeScript boundary performs field by
/// field has already happened by the time a typed event exists.
class CompatibilityBoundary extends Middleware {
  CompatIdMinter _ids = CompatIdMinter('');
  String? _currentReasoningId;
  String? _currentMessageId;

  @override
  Stream<BaseEvent> run(RunAgentInput input, AbstractAgent next) {
    final upgraded = upgradeRunInput(input);
    // Deliberately `next.run`, not `runNext`: the boundary must read the raw
    // stream. A legacy shape on an unexpanded chunk has to be translated
    // before chunk expansion decides what to do with it.
    return apply(upgraded, next.run(upgraded));
  }

  /// The boundary as a plain stream operator, for the connect flow, which has
  /// no middleware chain to install it into. A fresh instance per call keeps
  /// the translation state per stream.
  Stream<BaseEvent> apply(
      RunAgentInput input, Stream<BaseEvent> source) async* {
    _ids = CompatIdMinter(input.runId);
    _currentReasoningId = null;
    _currentMessageId = null;
    await for (final event in source) {
      yield transformEvent(event);
    }
  }

  /// [input] with its outgoing messages upgraded to modern content parts.
  ///
  /// Returns the same instance when no message needed a conversion.
  RunAgentInput upgradeRunInput(RunAgentInput input) {
    final messages = _upgradeMessages(input.messages, warnOnBinary: false);
    if (identical(messages, input.messages)) {
      return input;
    }
    return input.copyWith(messages: messages);
  }

  /// Translates one inbound event into its 1.0 shape.
  BaseEvent transformEvent(BaseEvent event) {
    if (event is RunStartedEvent) {
      // A stream may carry several sequential runs; state never crosses one.
      _currentReasoningId = null;
      _currentMessageId = null;
      warnOnProducerDeclaration(event.protocolVersion);
      final input = event.input;
      if (input == null) {
        return event;
      }
      final messages = _upgradeMessages(input.messages, warnOnBinary: true);
      if (identical(messages, input.messages)) {
        return event;
      }
      return event.copyWith(input: input.copyWith(messages: messages));
    }

    switch (event) {
      case ThinkingStartEvent():
        _currentReasoningId = _ids.next('reasoning');
        _warnConversion('THINKING_START', 'REASONING_START');
        final title = event.title;
        if (title != null) {
          // REASONING_START has no title field, so the span's label cannot be
          // carried and nothing downstream can recover it. That is a loss, not
          // a translation, so it is announced in its own sentence.
          _warnAside(
            'Dropping THINKING_START.title "$title": REASONING_START has no '
            "title field, so the span's label cannot be carried and nothing "
            'downstream can recover it.',
          );
        }
        return ReasoningStartEvent(
          messageId: _currentReasoningId!,
          timestamp: event.timestamp,
          rawEvent: event.rawEvent,
          metadata: event.metadata,
          subagentRunId: event.subagentRunId,
        );

      case ThinkingTextMessageStartEvent():
        _currentMessageId = _ids.next('reasoning-message');
        _warnConversion(
          'THINKING_TEXT_MESSAGE_START',
          'REASONING_MESSAGE_START',
        );
        return ReasoningMessageStartEvent(
          messageId: _currentMessageId!,
          // The event's default `role` is "reasoning", which is what the
          // schema pins; the translation used to say "assistant".
          timestamp: event.timestamp,
          rawEvent: event.rawEvent,
          metadata: event.metadata,
          subagentRunId: event.subagentRunId,
        );

      case ThinkingTextMessageContentEvent():
        _warnConversion(
          'THINKING_TEXT_MESSAGE_CONTENT',
          'REASONING_MESSAGE_CONTENT',
        );
        return ReasoningMessageContentEvent(
          messageId: _continuationId(
            'THINKING_TEXT_MESSAGE_CONTENT',
            _currentMessageId,
            'reasoning-message',
          ),
          delta: event.delta,
          timestamp: event.timestamp,
          rawEvent: event.rawEvent,
          metadata: event.metadata,
          subagentRunId: event.subagentRunId,
        );

      case ThinkingContentEvent():
        // A shape only the Dart wire format ever carried; translated exactly
        // like the message-content event it stands in for.
        _warnConversion('THINKING_CONTENT', 'REASONING_MESSAGE_CONTENT');
        return ReasoningMessageContentEvent(
          messageId: _continuationId(
            'THINKING_CONTENT',
            _currentMessageId,
            'reasoning-message',
          ),
          delta: event.delta,
          timestamp: event.timestamp,
          rawEvent: event.rawEvent,
          metadata: event.metadata,
          subagentRunId: event.subagentRunId,
        );

      case ThinkingTextMessageEndEvent():
        final messageId = _continuationId(
          'THINKING_TEXT_MESSAGE_END',
          _currentMessageId,
          'reasoning-message',
        );
        _currentMessageId = null;
        _warnConversion('THINKING_TEXT_MESSAGE_END', 'REASONING_MESSAGE_END');
        return ReasoningMessageEndEvent(
          messageId: messageId,
          timestamp: event.timestamp,
          rawEvent: event.rawEvent,
          metadata: event.metadata,
          subagentRunId: event.subagentRunId,
        );

      case ThinkingEndEvent():
        final messageId = _continuationId(
          'THINKING_END',
          _currentReasoningId,
          'reasoning',
        );
        _currentReasoningId = null;
        _warnConversion('THINKING_END', 'REASONING_END');
        return ReasoningEndEvent(
          messageId: messageId,
          timestamp: event.timestamp,
          rawEvent: event.rawEvent,
          metadata: event.metadata,
          subagentRunId: event.subagentRunId,
        );

      case MessagesSnapshotEvent():
        final messages = _upgradeMessages(event.messages, warnOnBinary: true);
        if (identical(messages, event.messages)) {
          return event;
        }
        return event.copyWith(messages: messages);

      default:
        return event;
    }
  }

  List<Message> _upgradeMessages(
    List<Message> messages, {
    required bool warnOnBinary,
  }) {
    var changed = false;
    final upgraded = <Message>[];
    for (final message in messages) {
      final next = _upgradeInboundMessage(message, warnOnBinary: warnOnBinary);
      if (!identical(next, message)) {
        changed = true;
      }
      upgraded.add(next);
    }
    return changed ? upgraded : messages;
  }

  Message _upgradeInboundMessage(
    Message message, {
    required bool warnOnBinary,
  }) {
    final parts = _contentPartsOf(message);
    if (parts == null || !parts.any(isLegacyBinaryContent)) {
      return message;
    }
    if (warnOnBinary) {
      _warnConversion(
        'binary input content',
        'the modern media content parts',
      );
    }
    return upgradeMessageContent(message);
  }

  /// A `THINKING_*` continuation names nothing: the id it belongs to lives in
  /// this boundary's state, put there by the matching opener. When no opener
  /// preceded it there is no id to reuse and one is minted, which turns a
  /// producer's "content with no start" into an event naming an id nothing
  /// ever opened — so the mint is announced here.
  String _continuationId(String from, String? established, String kind) {
    if (established != null) {
      return established;
    }
    final minted = _ids.next(kind);
    _warnAside(
      "Minting a messageId ('$minted') for $from: no THINKING opener preceded "
      "it, so there was no id to continue. The id is this client's own "
      "invention, not the producer's, and verification will reject the "
      'translated event for naming something nothing opened.',
    );
    return minted;
  }

  void _warnConversion(String what, String replacement) {
    AgUiDiagnostics.warn(
      'Converting deprecated $what to $replacement. The old shape leaves the '
      'protocol after its shim window; upgrade the peer to keep it.',
    );
  }

  void _warnAside(String sentence) {
    AgUiDiagnostics.warn(sentence);
  }
}

/// The boundary as a plain stream operator for pipelines that have no
/// middleware chain to install it into.
Stream<BaseEvent> compatibilityBoundaryOperator(
  RunAgentInput input,
  Stream<BaseEvent> source,
) {
  final boundary = CompatibilityBoundary();
  return boundary.apply(boundary.upgradeRunInput(input), source);
}

List<InputContent>? _contentPartsOf(Message message) {
  return switch (message) {
    UserMessage() => message.content.partsOrNull,
    ToolMessage() => message.contentParts,
    _ => null,
  };
}

int _compareVersions(String left, String right) {
  final leftParts =
      left.split('.').map((part) => int.tryParse(part) ?? 0).toList();
  final rightParts =
      right.split('.').map((part) => int.tryParse(part) ?? 0).toList();
  final length = leftParts.length > rightParts.length
      ? leftParts.length
      : rightParts.length;
  for (var index = 0; index < length; index++) {
    final leftValue = index < leftParts.length ? leftParts[index] : 0;
    final rightValue = index < rightParts.length ? rightParts[index] : 0;
    if (leftValue != rightValue) {
      return leftValue.compareTo(rightValue);
    }
  }
  return 0;
}
