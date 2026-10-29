library;

import '../apply/json_patch.dart';
import '../diagnostics.dart';
import '../events/events.dart';

/// Compacts a stored stream by folding each run of deltas into one event.
///
/// Text messages and tool calls collapse to a single content/args event; a
/// run's state events collapse to one `STATE_SNAPSHOT`. The result must replay
/// to the same messages, state and metadata as the original stream, so this
/// mirrors the reference bridge — including the cases where the safest move is
/// to change nothing.
List<BaseEvent> compactEvents(List<BaseEvent> events) {
  final compacted = <BaseEvent>[];
  final pendingTextMessages = <String, _PendingTextMessage>{};
  final pendingToolCalls = <String, _PendingToolCall>{};
  // One cross-type opening order for incomplete streams: separate maps make
  // compaction by id convenient, but flushing every text stream before every
  // tool stream at a run boundary would invent an ordering change.
  final pendingStreamOrder = <({String kind, String id})>[];
  var stateEvents = <BaseEvent>[];

  void rememberPendingStream(String kind, String id) {
    pendingStreamOrder.add((kind: kind, id: id));
  }

  void forgetPendingStream(String kind, String id) {
    pendingStreamOrder.removeWhere(
      (entry) => entry.kind == kind && entry.id == id,
    );
  }

  void flushPendingStreams() {
    for (final entry in pendingStreamOrder) {
      if (entry.kind == 'text') {
        final pending = pendingTextMessages.remove(entry.id);
        if (pending != null) {
          _flushTextMessage(entry.id, pending, compacted);
        }
      } else {
        final pending = pendingToolCalls.remove(entry.id);
        if (pending != null) {
          _flushToolCall(entry.id, pending, compacted);
        }
      }
    }
    pendingStreamOrder.clear();
  }

  for (final event in events) {
    if (event is TextMessageStartEvent) {
      final pending = pendingTextMessages.putIfAbsent(event.messageId, () {
        rememberPendingStream('text', event.messageId);
        return _PendingTextMessage(event.messageId);
      });
      if (pending.contents.isEmpty) {
        pending.start = _carryTextStartMetadata(pending.start, event);
      } else {
        // Compaction hoists START ahead of the collapsed delta, so a start
        // replayed after deltas keeps its fields but stages its metadata.
        pending.start = _replaceTextStartFields(pending.start, event);
        pending.postStartMetadata =
            _mergeMetadata(pending.postStartMetadata, event.metadata);
      }
      continue;
    }

    if (event is TextMessageContentEvent) {
      final pending = pendingTextMessages.putIfAbsent(event.messageId, () {
        rememberPendingStream('text', event.messageId);
        return _PendingTextMessage(event.messageId);
      });
      pending.contents.add(event);
      pending.postStartMetadata =
          _mergeMetadata(pending.postStartMetadata, event.metadata);
      continue;
    }

    if (event is TextMessageEndEvent) {
      final pending = pendingTextMessages.putIfAbsent(event.messageId, () {
        rememberPendingStream('text', event.messageId);
        return _PendingTextMessage(event.messageId);
      })..end = event;
      _flushTextMessage(event.messageId, pending, compacted);
      pendingTextMessages.remove(event.messageId);
      forgetPendingStream('text', event.messageId);
      continue;
    }

    if (event is ToolCallStartEvent) {
      final pending = pendingToolCalls.putIfAbsent(event.toolCallId, () {
        rememberPendingStream('tool', event.toolCallId);
        return _PendingToolCall(event.toolCallId);
      });
      if (pending.args.isEmpty) {
        pending.start = _carryToolStartMetadata(pending.start, event);
      } else {
        // Same ordering rule as the text case above.
        pending.start = _replaceToolStartFields(pending.start, event);
        pending.postStartMetadata =
            _mergeMetadata(pending.postStartMetadata, event.metadata);
      }
      continue;
    }

    if (event is ToolCallArgsEvent) {
      final pending = pendingToolCalls.putIfAbsent(event.toolCallId, () {
        rememberPendingStream('tool', event.toolCallId);
        return _PendingToolCall(event.toolCallId);
      });
      pending.args.add(event);
      pending.postStartMetadata =
          _mergeMetadata(pending.postStartMetadata, event.metadata);
      continue;
    }

    if (event is ToolCallEndEvent) {
      final pending = pendingToolCalls.putIfAbsent(event.toolCallId, () {
        rememberPendingStream('tool', event.toolCallId);
        return _PendingToolCall(event.toolCallId);
      })..end = event;
      _flushToolCall(event.toolCallId, pending, compacted);
      pendingToolCalls.remove(event.toolCallId);
      forgetPendingStream('tool', event.toolCallId);
      continue;
    }

    if (event is RunStartedEvent) {
      _flushState(stateEvents, compacted);
      stateEvents = <BaseEvent>[];
      compacted.add(event);
      continue;
    }

    if (event is RunFinishedEvent || event is RunErrorEvent) {
      // An incomplete text or tool stream is still part of the run that is
      // ending. Flushing it first keeps the terminal event last, which is what
      // verification requires on replay.
      flushPendingStreams();

      _flushState(stateEvents, compacted);
      stateEvents = <BaseEvent>[];
      compacted.add(event);
      continue;
    }

    if (event is StateSnapshotEvent || event is StateDeltaEvent) {
      stateEvents.add(event);
      continue;
    }

    var buffered = false;
    for (final pending in pendingTextMessages.values) {
      if (pending.start != null && pending.end == null) {
        pending.otherEvents.add(event);
        buffered = true;
        break;
      }
    }

    if (!buffered) {
      for (final pending in pendingToolCalls.values) {
        if (pending.start != null && pending.end == null) {
          pending.otherEvents.add(event);
          buffered = true;
          break;
        }
      }
    }

    if (!buffered) {
      compacted.add(event);
    }
  }

  // Preserve cross-type opening order even when the stored history ends
  // without a run terminal.
  flushPendingStreams();
  _flushState(stateEvents, compacted);

  return compacted;
}

void _flushTextMessage(
  String messageId,
  _PendingTextMessage pending,
  List<BaseEvent> compacted,
) {
  final start = pending.start;
  if (start != null) {
    compacted.add(start);
  }
  if (pending.contents.isNotEmpty) {
    compacted.add(
      TextMessageContentEvent(
        messageId: messageId,
        delta: pending.contents.map((event) => event.delta).join(),
        metadata: pending.postStartMetadata,
      ),
    );
  }
  final end = pending.end;
  if (end != null) {
    compacted.add(end);
  }
  compacted.addAll(pending.otherEvents);
}

void _flushToolCall(
  String toolCallId,
  _PendingToolCall pending,
  List<BaseEvent> compacted,
) {
  final start = pending.start;
  if (start != null) {
    compacted.add(start);
  }
  if (pending.args.isNotEmpty) {
    compacted.add(
      ToolCallArgsEvent(
        toolCallId: toolCallId,
        delta: pending.args.map((event) => event.delta).join(),
        metadata: pending.postStartMetadata,
      ),
    );
  }
  final end = pending.end;
  if (end != null) {
    compacted.add(end);
  }
  compacted.addAll(pending.otherEvents);
}

/// Folds a run of state events into one snapshot.
///
/// A window with no snapshot of its own is passed through unchanged: replaying
/// a snapshot built from `{}` would wipe state the consumer legitimately holds
/// from before the window, which costs correctness for a saving of two events.
void _flushState(List<BaseEvent> stateEvents, List<BaseEvent> compacted) {
  if (stateEvents.isEmpty) {
    return;
  }

  // The LAST snapshot, not merely "is there one": everything before it is
  // unobservable, because a snapshot restates the whole document. Folding those
  // deltas anyway would apply them to the seeded `{}`, where their paths do not
  // resolve — the catch below would then warn about a patch whose failure
  // changed nothing.
  var lastSnapshot = -1;
  for (var index = stateEvents.length - 1; index >= 0; index--) {
    if (stateEvents[index] is StateSnapshotEvent) {
      lastSnapshot = index;
      break;
    }
  }
  if (lastSnapshot == -1) {
    compacted.addAll(stateEvents);
    return;
  }

  Object? state = <String, dynamic>{};
  for (final event in stateEvents.skip(lastSnapshot)) {
    if (event is StateSnapshotEvent) {
      state = cloneJsonValue(event.snapshot);
      continue;
    }
    if (event is StateDeltaEvent) {
      try {
        state = applyJsonPatch(state, event.delta);
      } on Object catch (error) {
        // One unappliable patch must not take down every consumer that
        // compacts a stream; warned and skipped, matching the reducer.
        AgUiDiagnostics.warn(
          'Failed to apply state patch while compacting: $error',
        );
      }
    }
  }

  compacted.add(
    StateSnapshotEvent(
      snapshot: state,
      metadata: _collapseMetadata(stateEvents),
    ),
  );
}

/// The metadata of every event a synthesized event replaces, folded with the
/// reducer's last-write-wins, replace-wholesale rule — so a compacted replay
/// ends up with the same metadata as the original stream.
Map<String, dynamic>? _collapseMetadata(List<BaseEvent> events) {
  Map<String, dynamic>? merged;
  for (final event in events) {
    merged = _mergeMetadata(merged, event.metadata);
  }
  return merged;
}

Map<String, dynamic>? _mergeMetadata(
  Map<String, dynamic>? existing,
  Map<String, dynamic>? incoming,
) {
  if (incoming == null) {
    return existing;
  }
  if (existing == null) {
    return Map<String, dynamic>.from(incoming);
  }
  return <String, dynamic>{...existing, ...incoming};
}

/// A start replayed before its end merges into the message rather than
/// replacing the earlier start's keys.
TextMessageStartEvent _carryTextStartMetadata(
  TextMessageStartEvent? previous,
  TextMessageStartEvent next,
) {
  if (previous == null) {
    return next;
  }
  final metadata = _mergeMetadata(previous.metadata, next.metadata);
  if (metadata == null) {
    return next;
  }
  return TextMessageStartEvent(
    messageId: next.messageId,
    role: next.role,
    name: next.name,
    timestamp: next.timestamp,
    rawEvent: next.rawEvent,
    metadata: metadata,
    subagentRunId: next.subagentRunId,
  );
}

/// A start replayed after deltas: its fields win — the reducer deliberately
/// renames an existing tool call on such a replay — while its metadata is
/// staged separately so arrival order survives the hoisting.
TextMessageStartEvent _replaceTextStartFields(
  TextMessageStartEvent? previous,
  TextMessageStartEvent next,
) {
  return TextMessageStartEvent(
    messageId: next.messageId,
    role: next.role,
    name: next.name,
    timestamp: next.timestamp,
    rawEvent: next.rawEvent,
    metadata: previous?.metadata,
    subagentRunId: next.subagentRunId,
  );
}

ToolCallStartEvent _carryToolStartMetadata(
  ToolCallStartEvent? previous,
  ToolCallStartEvent next,
) {
  if (previous == null) {
    return next;
  }
  final metadata = _mergeMetadata(previous.metadata, next.metadata);
  if (metadata == null) {
    return next;
  }
  return ToolCallStartEvent(
    toolCallId: next.toolCallId,
    toolCallName: next.toolCallName,
    parentMessageId: next.parentMessageId,
    timestamp: next.timestamp,
    rawEvent: next.rawEvent,
    metadata: metadata,
    subagentRunId: next.subagentRunId,
  );
}

ToolCallStartEvent _replaceToolStartFields(
  ToolCallStartEvent? previous,
  ToolCallStartEvent next,
) {
  return ToolCallStartEvent(
    toolCallId: next.toolCallId,
    toolCallName: next.toolCallName,
    parentMessageId: next.parentMessageId,
    timestamp: next.timestamp,
    rawEvent: next.rawEvent,
    metadata: previous?.metadata,
    subagentRunId: next.subagentRunId,
  );
}

class _PendingTextMessage {
  _PendingTextMessage(this.messageId);

  final String messageId;
  TextMessageStartEvent? start;
  final List<TextMessageContentEvent> contents = <TextMessageContentEvent>[];
  TextMessageEndEvent? end;
  final List<BaseEvent> otherEvents = <BaseEvent>[];
  Map<String, dynamic>? postStartMetadata;
}

class _PendingToolCall {
  _PendingToolCall(this.toolCallId);

  final String toolCallId;
  ToolCallStartEvent? start;
  final List<ToolCallArgsEvent> args = <ToolCallArgsEvent>[];
  ToolCallEndEvent? end;
  final List<BaseEvent> otherEvents = <BaseEvent>[];
  Map<String, dynamic>? postStartMetadata;
}
