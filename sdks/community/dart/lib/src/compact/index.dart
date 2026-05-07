library;

import '../apply/json_patch.dart';
import '../events/events.dart';

List<BaseEvent> compactEvents(List<BaseEvent> events) {
  final compacted = <BaseEvent>[];
  final pendingTextMessages = <String, _PendingTextMessage>{};
  final pendingToolCalls = <String, _PendingToolCall>{};
  var stateEvents = <BaseEvent>[];

  for (final event in events) {
    if (event is TextMessageStartEvent) {
      pendingTextMessages
          .putIfAbsent(event.messageId, () => _PendingTextMessage(event.messageId))
          .start = event;
      continue;
    }

    if (event is TextMessageContentEvent) {
      pendingTextMessages
          .putIfAbsent(event.messageId, () => _PendingTextMessage(event.messageId))
          .contents
          .add(event);
      continue;
    }

    if (event is TextMessageEndEvent) {
      final pending = pendingTextMessages.putIfAbsent(
        event.messageId,
        () => _PendingTextMessage(event.messageId),
      )..end = event;
      _flushTextMessage(event.messageId, pending, compacted);
      pendingTextMessages.remove(event.messageId);
      continue;
    }

    if (event is ToolCallStartEvent) {
      pendingToolCalls
          .putIfAbsent(event.toolCallId, () => _PendingToolCall(event.toolCallId))
          .start = event;
      continue;
    }

    if (event is ToolCallArgsEvent) {
      pendingToolCalls
          .putIfAbsent(event.toolCallId, () => _PendingToolCall(event.toolCallId))
          .args
          .add(event);
      continue;
    }

    if (event is ToolCallEndEvent) {
      final pending = pendingToolCalls.putIfAbsent(
        event.toolCallId,
        () => _PendingToolCall(event.toolCallId),
      )..end = event;
      _flushToolCall(event.toolCallId, pending, compacted);
      pendingToolCalls.remove(event.toolCallId);
      continue;
    }

    if (event is RunStartedEvent) {
      _flushState(stateEvents, compacted);
      stateEvents = <BaseEvent>[];
      compacted.add(event);
      continue;
    }

    if (event is RunFinishedEvent || event is RunErrorEvent) {
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

  for (final entry in pendingTextMessages.entries) {
    _flushTextMessage(entry.key, entry.value, compacted);
  }
  for (final entry in pendingToolCalls.entries) {
    _flushToolCall(entry.key, entry.value, compacted);
  }
  _flushState(stateEvents, compacted);

  return compacted;
}

void _flushTextMessage(
  String messageId,
  _PendingTextMessage pending,
  List<BaseEvent> compacted,
) {
  if (pending.start != null) {
    compacted.add(pending.start!);
  }
  if (pending.contents.isNotEmpty) {
    compacted.add(
      TextMessageContentEvent(
        messageId: messageId,
        delta: pending.contents.map((event) => event.delta).join(),
      ),
    );
  }
  if (pending.end != null) {
    compacted.add(pending.end!);
  }
  compacted.addAll(pending.otherEvents);
}

void _flushToolCall(
  String toolCallId,
  _PendingToolCall pending,
  List<BaseEvent> compacted,
) {
  if (pending.start != null) {
    compacted.add(pending.start!);
  }
  if (pending.args.isNotEmpty) {
    compacted.add(
      ToolCallArgsEvent(
        toolCallId: toolCallId,
        delta: pending.args.map((event) => event.delta).join(),
      ),
    );
  }
  if (pending.end != null) {
    compacted.add(pending.end!);
  }
  compacted.addAll(pending.otherEvents);
}

void _flushState(List<BaseEvent> stateEvents, List<BaseEvent> compacted) {
  if (stateEvents.isEmpty) {
    return;
  }

  Object? state = <String, dynamic>{};
  for (final event in stateEvents) {
    if (event is StateSnapshotEvent) {
      state = cloneJsonValue(event.snapshot);
      continue;
    }
    if (event is StateDeltaEvent) {
      state = applyJsonPatch(state, event.delta);
    }
  }

  compacted.add(
    StateSnapshotEvent(
      snapshot: state,
    ),
  );
}

class _PendingTextMessage {
  _PendingTextMessage(this.messageId);

  final String messageId;
  TextMessageStartEvent? start;
  final List<TextMessageContentEvent> contents = <TextMessageContentEvent>[];
  TextMessageEndEvent? end;
  final List<BaseEvent> otherEvents = <BaseEvent>[];
}

class _PendingToolCall {
  _PendingToolCall(this.toolCallId);

  final String toolCallId;
  ToolCallStartEvent? start;
  final List<ToolCallArgsEvent> args = <ToolCallArgsEvent>[];
  ToolCallEndEvent? end;
  final List<BaseEvent> otherEvents = <BaseEvent>[];
}
