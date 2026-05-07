library;

import '../debug_logger.dart';
import '../events/events.dart';
import '../types/types.dart';
import 'json_patch.dart';

class AppliedState {
  final List<Message> messages;
  final Object? state;
  final List<Interrupt> pendingInterrupts;

  const AppliedState({
    required this.messages,
    required this.state,
    this.pendingInterrupts = const [],
  });

  AppliedState copyWith({
    List<Message>? messages,
    Object? state = _sentinel,
    List<Interrupt>? pendingInterrupts,
  }) {
    return AppliedState(
      messages: messages ?? this.messages,
      state: identical(state, _sentinel) ? this.state : state,
      pendingInterrupts: pendingInterrupts ?? this.pendingInterrupts,
    );
  }
}

const Object _sentinel = Object();

Stream<AppliedState> defaultApplyEvents(
  RunAgentInput input,
  Stream<BaseEvent> events, {
  Object? debugLogger,
}) async* {
  final log = resolveDebugLogger(debugLogger);
  var current = AppliedState(
    messages: List<Message>.from(input.messages),
    state: cloneJsonValue(input.state),
  );

  await for (final event in events) {
    log?.event('APPLY', 'Event applied:', event, {'type': event.type});
    final next = _applyEvent(current, event);
    if (!_statesEqual(current, next)) {
      current = next;
      yield current;
    }
  }
}

bool _statesEqual(AppliedState a, AppliedState b) {
  return identical(a.messages, b.messages) &&
      identical(a.state, b.state) &&
      identical(a.pendingInterrupts, b.pendingInterrupts);
}

AppliedState _applyEvent(AppliedState current, BaseEvent event) {
  switch (event.eventType) {
    case EventType.textMessageStart:
      return _applyTextMessageStart(current, event as TextMessageStartEvent);
    case EventType.textMessageContent:
      return _applyTextMessageContent(current, event as TextMessageContentEvent);
    case EventType.textMessageEnd:
      return current;
    case EventType.toolCallStart:
      return _applyToolCallStart(current, event as ToolCallStartEvent);
    case EventType.toolCallArgs:
      return _applyToolCallArgs(current, event as ToolCallArgsEvent);
    case EventType.toolCallEnd:
      return current;
    case EventType.toolCallResult:
      return _applyToolCallResult(current, event as ToolCallResultEvent);
    case EventType.stateSnapshot:
      return current.copyWith(state: cloneJsonValue((event as StateSnapshotEvent).snapshot));
    case EventType.stateDelta:
      return _applyStateDelta(current, event as StateDeltaEvent);
    case EventType.messagesSnapshot:
      return _applyMessagesSnapshot(current, event as MessagesSnapshotEvent);
    case EventType.activitySnapshot:
      return _applyActivitySnapshot(current, event as ActivitySnapshotEvent);
    case EventType.activityDelta:
      return _applyActivityDelta(current, event as ActivityDeltaEvent);
    case EventType.runStarted:
      return _applyRunStarted(current, event as RunStartedEvent);
    case EventType.runFinished:
      return _applyRunFinished(current, event as RunFinishedEvent);
    case EventType.reasoningMessageStart:
      return _applyReasoningMessageStart(current, event as ReasoningMessageStartEvent);
    case EventType.reasoningMessageContent:
      return _applyReasoningMessageContent(current, event as ReasoningMessageContentEvent);
    case EventType.reasoningMessageEnd:
      return current;
    case EventType.reasoningEncryptedValue:
      return _applyReasoningEncryptedValue(current, event as ReasoningEncryptedValueEvent);
    case EventType.textMessageChunk:
      throw StateError('TEXT_MESSAGE_CHUNK must be transformed before being applied');
    case EventType.toolCallChunk:
      throw StateError('TOOL_CALL_CHUNK must be transformed before being applied');
    case EventType.reasoningMessageChunk:
      throw StateError('REASONING_MESSAGE_CHUNK must be transformed before being applied');
    case EventType.thinkingTextMessageStart:
    case EventType.thinkingTextMessageContent:
    case EventType.thinkingTextMessageEnd:
    case EventType.thinkingStart:
    case EventType.thinkingContent:
    case EventType.thinkingEnd:
    case EventType.raw:
    case EventType.custom:
    case EventType.runError:
    case EventType.stepStarted:
    case EventType.stepFinished:
    case EventType.reasoningStart:
    case EventType.reasoningMessageEnd:
    case EventType.reasoningEnd:
      return current;
  }
}

AppliedState _applyTextMessageStart(AppliedState current, TextMessageStartEvent event) {
  if (current.messages.any((message) => message.id == event.messageId)) {
    return current;
  }

  final messages = List<Message>.from(current.messages)
    ..add(_createTextMessage(event.messageId, event.role, event.name));
  return current.copyWith(messages: messages);
}

Message _createTextMessage(String id, TextMessageRole role, String? name) {
  switch (role) {
    case TextMessageRole.developer:
      return DeveloperMessage(id: id, content: '', name: name);
    case TextMessageRole.system:
      return SystemMessage(id: id, content: '', name: name);
    case TextMessageRole.assistant:
      return AssistantMessage(id: id, content: '', name: name);
    case TextMessageRole.user:
      return UserMessage(id: id, content: '', name: name);
  }
}

AppliedState _applyTextMessageContent(AppliedState current, TextMessageContentEvent event) {
  final index = current.messages.indexWhere((message) => message.id == event.messageId);
  if (index == -1) {
    return current;
  }

  final target = current.messages[index];
  final existingContent = target.content is String ? target.content as String : '';
  final updated = _copyMessageWithStringContent(target, '$existingContent${event.delta}');
  final messages = List<Message>.from(current.messages)..[index] = updated;
  return current.copyWith(messages: messages);
}

Message _copyMessageWithStringContent(Message message, String content) {
  switch (message) {
    case DeveloperMessage():
      return message.copyWith(content: content);
    case SystemMessage():
      return message.copyWith(content: content);
    case AssistantMessage():
      return message.copyWith(content: content);
    case UserMessage():
      return message.copyWith(content: content);
    case ToolMessage():
      return message.copyWith(content: content);
    case ReasoningMessage():
      return message.copyWith(content: content);
    case ActivityMessage():
      return message;
  }
}

AppliedState _applyToolCallStart(AppliedState current, ToolCallStartEvent event) {
  final messages = List<Message>.from(current.messages);
  final assistantIndex = _resolveOrCreateAssistantMessage(messages, event.parentMessageId, event.toolCallId);
  final assistant = messages[assistantIndex] as AssistantMessage;
  final toolCalls = List<ToolCall>.from(assistant.toolCalls ?? const <ToolCall>[])
    ..add(
      ToolCall(
        id: event.toolCallId,
        function: FunctionCall(name: event.toolCallName, arguments: ''),
      ),
    );
  messages[assistantIndex] = assistant.copyWith(toolCalls: toolCalls);
  return current.copyWith(messages: messages);
}

int _resolveOrCreateAssistantMessage(
  List<Message> messages,
  String? parentMessageId,
  String toolCallId,
) {
  if (parentMessageId != null) {
    final existingIndex = messages.indexWhere((message) => message.id == parentMessageId);
    if (existingIndex != -1 && messages[existingIndex] is AssistantMessage) {
      return existingIndex;
    }

    final created = AssistantMessage(
      id: existingIndex == -1 ? parentMessageId : toolCallId,
      toolCalls: const [],
    );
    messages.add(created);
    return messages.length - 1;
  }

  messages.add(AssistantMessage(id: toolCallId, toolCalls: const []));
  return messages.length - 1;
}

AppliedState _applyToolCallArgs(AppliedState current, ToolCallArgsEvent event) {
  final messages = List<Message>.from(current.messages);

  for (var messageIndex = 0; messageIndex < messages.length; messageIndex++) {
    final message = messages[messageIndex];
    if (message is! AssistantMessage || message.toolCalls == null) {
      continue;
    }

    final toolCallIndex = message.toolCalls!.indexWhere((toolCall) => toolCall.id == event.toolCallId);
    if (toolCallIndex == -1) {
      continue;
    }

    final toolCalls = List<ToolCall>.from(message.toolCalls!);
    final target = toolCalls[toolCallIndex];
    toolCalls[toolCallIndex] = target.copyWith(
      function: target.function.copyWith(
        arguments: '${target.function.arguments}${event.delta}',
      ),
    );
    messages[messageIndex] = message.copyWith(toolCalls: toolCalls);
    return current.copyWith(messages: messages);
  }

  return current;
}

AppliedState _applyToolCallResult(AppliedState current, ToolCallResultEvent event) {
  final messages = List<Message>.from(current.messages)
    ..add(
      ToolMessage(
        id: event.messageId,
        toolCallId: event.toolCallId,
        content: event.content,
        encryptedValue: null,
      ),
    );
  return current.copyWith(messages: messages);
}

AppliedState _applyStateDelta(AppliedState current, StateDeltaEvent event) {
  final nextState = applyJsonPatch(current.state, event.delta);
  return current.copyWith(state: nextState);
}

AppliedState _applyMessagesSnapshot(AppliedState current, MessagesSnapshotEvent event) {
  final snapshotById = {for (final message in event.messages) message.id: message};
  final merged = <Message>[];

  for (final message in current.messages) {
    final clientOnly = message.role == MessageRole.activity || message.role == MessageRole.reasoning;
    if (clientOnly) {
      merged.add(message);
      continue;
    }

    final replacement = snapshotById.remove(message.id);
    if (replacement != null) {
      merged.add(replacement);
    }
  }

  merged.addAll(snapshotById.values);
  return current.copyWith(messages: merged);
}

AppliedState _applyActivitySnapshot(AppliedState current, ActivitySnapshotEvent event) {
  final messages = List<Message>.from(current.messages);
  final index = messages.indexWhere((message) => message.id == event.messageId);
  final activity = ActivityMessage(
    id: event.messageId,
    activityType: event.activityType,
    content: Map<String, dynamic>.from(event.content),
  );

  if (index == -1) {
    messages.add(activity);
  } else if (messages[index] is ActivityMessage && !event.replace) {
    return current;
  } else {
    messages[index] = activity;
  }

  return current.copyWith(messages: messages);
}

AppliedState _applyActivityDelta(AppliedState current, ActivityDeltaEvent event) {
  final messages = List<Message>.from(current.messages);
  final index = messages.indexWhere((message) => message.id == event.messageId);
  if (index == -1) {
    return current;
  }

  final existing = messages[index];
  if (existing is! ActivityMessage) {
    return current;
  }

  final patched = applyJsonPatch(existing.content, event.patch);
  messages[index] = existing.copyWith(
    activityType: event.activityType,
    content: Map<String, dynamic>.from((patched as Map?) ?? const {}),
  );
  return current.copyWith(messages: messages);
}

AppliedState _applyRunStarted(AppliedState current, RunStartedEvent event) {
  final input = event.input;
  if (input == null || input.messages.isEmpty) {
    return current;
  }

  final messages = List<Message>.from(current.messages);
  final existingIds = messages.map((message) => message.id).toSet();
  for (final message in input.messages) {
    if (!existingIds.contains(message.id)) {
      messages.add(message);
    }
  }
  return current.copyWith(messages: messages);
}

AppliedState _applyRunFinished(AppliedState current, RunFinishedEvent event) {
  final outcome = event.outcome;
  if (outcome is RunFinishedInterruptOutcome) {
    return current.copyWith(pendingInterrupts: List<Interrupt>.from(outcome.interrupts));
  }
  return current.copyWith(pendingInterrupts: const []);
}

AppliedState _applyReasoningMessageStart(
  AppliedState current,
  ReasoningMessageStartEvent event,
) {
  if (current.messages.any((message) => message.id == event.messageId)) {
    return current;
  }

  final messages = List<Message>.from(current.messages)
    ..add(ReasoningMessage(id: event.messageId, content: ''));
  return current.copyWith(messages: messages);
}

AppliedState _applyReasoningMessageContent(
  AppliedState current,
  ReasoningMessageContentEvent event,
) {
  final index = current.messages.indexWhere((message) => message.id == event.messageId);
  if (index == -1) {
    return current;
  }

  final message = current.messages[index];
  if (message is! ReasoningMessage) {
    return current;
  }

  final messages = List<Message>.from(current.messages)
    ..[index] = message.copyWith(content: '${message.content}${event.delta}');
  return current.copyWith(messages: messages);
}

AppliedState _applyReasoningEncryptedValue(
  AppliedState current,
  ReasoningEncryptedValueEvent event,
) {
  final messages = List<Message>.from(current.messages);

  if (event.subtype == ReasoningEncryptedValueSubtype.toolCall) {
    for (var messageIndex = 0; messageIndex < messages.length; messageIndex++) {
      final message = messages[messageIndex];
      if (message is! AssistantMessage || message.toolCalls == null) {
        continue;
      }

      final toolCallIndex = message.toolCalls!.indexWhere((toolCall) => toolCall.id == event.entityId);
      if (toolCallIndex == -1) {
        continue;
      }

      final toolCalls = List<ToolCall>.from(message.toolCalls!);
      toolCalls[toolCallIndex] = toolCalls[toolCallIndex].copyWith(
        encryptedValue: event.encryptedValue,
      );
      messages[messageIndex] = message.copyWith(toolCalls: toolCalls);
      return current.copyWith(messages: messages);
    }
    return current;
  }

  final index = messages.indexWhere((message) => message.id == event.entityId);
  if (index == -1) {
    return current;
  }

  final message = messages[index];
  if (message is ActivityMessage) {
    return current;
  }

  messages[index] = switch (message) {
    DeveloperMessage() => message.copyWith(encryptedValue: event.encryptedValue),
    SystemMessage() => message.copyWith(encryptedValue: event.encryptedValue),
    AssistantMessage() => message.copyWith(encryptedValue: event.encryptedValue),
    UserMessage() => message.copyWith(encryptedValue: event.encryptedValue),
    ToolMessage() => message.copyWith(encryptedValue: event.encryptedValue),
    ReasoningMessage() => message.copyWith(encryptedValue: event.encryptedValue),
    ActivityMessage() => message,
  };
  return current.copyWith(messages: messages);
}
