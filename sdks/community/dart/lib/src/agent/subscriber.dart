library;

import 'dart:async';
import 'dart:collection';

import '../apply/json_patch.dart';
import '../events/events.dart';
import '../types/types.dart';
import 'types.dart';

class AgentStateMutation {
  final List<Message>? messages;
  final Object? state;
  final bool? stopPropagation;

  const AgentStateMutation({
    this.messages,
    this.state,
    this.stopPropagation,
  });

  bool get hasChanges =>
      messages != null || state != null || stopPropagation != null;
}

class AgentSubscriberContext {
  final List<Message> messages;
  final Object? state;
  final dynamic agent;
  final RunAgentInput? input;

  const AgentSubscriberContext({
    required this.messages,
    required this.state,
    required this.agent,
    required this.input,
  });
}

class AgentErrorContext extends AgentSubscriberContext {
  final Object error;

  const AgentErrorContext({
    required super.messages,
    required super.state,
    required super.agent,
    required super.input,
    required this.error,
  });
}

class AgentEventContext<T extends BaseEvent> extends AgentSubscriberContext {
  final T event;
  final String? textMessageBuffer;
  final String? toolCallBuffer;
  final String? toolCallName;
  final Object? partialToolCallArgs;
  final Object? toolCallArgs;
  final ActivityMessage? activityMessage;
  final Message? existingMessage;
  final String? reasoningMessageBuffer;
  final Object? result;
  final List<Interrupt>? interrupts;
  final String? outcome;

  const AgentEventContext({
    required super.messages,
    required super.state,
    required super.agent,
    required super.input,
    required this.event,
    this.textMessageBuffer,
    this.toolCallBuffer,
    this.toolCallName,
    this.partialToolCallArgs,
    this.toolCallArgs,
    this.activityMessage,
    this.existingMessage,
    this.reasoningMessageBuffer,
    this.result,
    this.interrupts,
    this.outcome,
  });
}

class NewMessageContext extends AgentSubscriberContext {
  final Message message;

  const NewMessageContext({
    required super.messages,
    required super.state,
    required super.agent,
    required super.input,
    required this.message,
  });
}

class NewToolCallContext extends AgentSubscriberContext {
  final ToolCall toolCall;

  const NewToolCallContext({
    required super.messages,
    required super.state,
    required super.agent,
    required super.input,
    required this.toolCall,
  });
}

typedef AgentMutationCallback<T> = FutureOr<AgentStateMutation?> Function(T params);
typedef AgentVoidCallback<T> = FutureOr<void> Function(T params);

class AgentSubscriber {
  final AgentMutationCallback<AgentSubscriberContext>? onRunInitialized;
  final AgentMutationCallback<AgentErrorContext>? onRunFailed;
  final AgentMutationCallback<AgentSubscriberContext>? onRunFinalized;
  final AgentMutationCallback<AgentEventContext<BaseEvent>>? onEvent;
  final AgentMutationCallback<AgentEventContext<RunStartedEvent>>? onRunStartedEvent;
  final AgentMutationCallback<AgentEventContext<RunFinishedEvent>>? onRunFinishedEvent;
  final AgentMutationCallback<AgentEventContext<RunErrorEvent>>? onRunErrorEvent;
  final AgentMutationCallback<AgentEventContext<StepStartedEvent>>? onStepStartedEvent;
  final AgentMutationCallback<AgentEventContext<StepFinishedEvent>>? onStepFinishedEvent;
  final AgentMutationCallback<AgentEventContext<TextMessageStartEvent>>? onTextMessageStartEvent;
  final AgentMutationCallback<AgentEventContext<TextMessageContentEvent>>? onTextMessageContentEvent;
  final AgentMutationCallback<AgentEventContext<TextMessageEndEvent>>? onTextMessageEndEvent;
  final AgentMutationCallback<AgentEventContext<ToolCallStartEvent>>? onToolCallStartEvent;
  final AgentMutationCallback<AgentEventContext<ToolCallArgsEvent>>? onToolCallArgsEvent;
  final AgentMutationCallback<AgentEventContext<ToolCallEndEvent>>? onToolCallEndEvent;
  final AgentMutationCallback<AgentEventContext<ToolCallResultEvent>>? onToolCallResultEvent;
  final AgentMutationCallback<AgentEventContext<StateSnapshotEvent>>? onStateSnapshotEvent;
  final AgentMutationCallback<AgentEventContext<StateDeltaEvent>>? onStateDeltaEvent;
  final AgentMutationCallback<AgentEventContext<MessagesSnapshotEvent>>? onMessagesSnapshotEvent;
  final AgentMutationCallback<AgentEventContext<ActivitySnapshotEvent>>? onActivitySnapshotEvent;
  final AgentMutationCallback<AgentEventContext<ActivityDeltaEvent>>? onActivityDeltaEvent;
  final AgentMutationCallback<AgentEventContext<RawEvent>>? onRawEvent;
  final AgentMutationCallback<AgentEventContext<CustomEvent>>? onCustomEvent;
  final AgentMutationCallback<AgentEventContext<ReasoningStartEvent>>? onReasoningStartEvent;
  final AgentMutationCallback<AgentEventContext<ReasoningMessageStartEvent>>? onReasoningMessageStartEvent;
  final AgentMutationCallback<AgentEventContext<ReasoningMessageContentEvent>>? onReasoningMessageContentEvent;
  final AgentMutationCallback<AgentEventContext<ReasoningMessageEndEvent>>? onReasoningMessageEndEvent;
  final AgentMutationCallback<AgentEventContext<ReasoningEndEvent>>? onReasoningEndEvent;
  final AgentMutationCallback<AgentEventContext<ReasoningEncryptedValueEvent>>? onReasoningEncryptedValueEvent;
  final AgentVoidCallback<AgentSubscriberContext>? onMessagesChanged;
  final AgentVoidCallback<AgentSubscriberContext>? onStateChanged;
  final AgentVoidCallback<NewMessageContext>? onNewMessage;
  final AgentVoidCallback<NewToolCallContext>? onNewToolCall;

  const AgentSubscriber({
    this.onRunInitialized,
    this.onRunFailed,
    this.onRunFinalized,
    this.onEvent,
    this.onRunStartedEvent,
    this.onRunFinishedEvent,
    this.onRunErrorEvent,
    this.onStepStartedEvent,
    this.onStepFinishedEvent,
    this.onTextMessageStartEvent,
    this.onTextMessageContentEvent,
    this.onTextMessageEndEvent,
    this.onToolCallStartEvent,
    this.onToolCallArgsEvent,
    this.onToolCallEndEvent,
    this.onToolCallResultEvent,
    this.onStateSnapshotEvent,
    this.onStateDeltaEvent,
    this.onMessagesSnapshotEvent,
    this.onActivitySnapshotEvent,
    this.onActivityDeltaEvent,
    this.onRawEvent,
    this.onCustomEvent,
    this.onReasoningStartEvent,
    this.onReasoningMessageStartEvent,
    this.onReasoningMessageContentEvent,
    this.onReasoningMessageEndEvent,
    this.onReasoningEndEvent,
    this.onReasoningEncryptedValueEvent,
    this.onMessagesChanged,
    this.onStateChanged,
    this.onNewMessage,
    this.onNewToolCall,
  });
}

Future<AgentStateMutation> runSubscribersWithMutation<T>({
  required List<AgentSubscriber> subscribers,
  required List<Message> initialMessages,
  required Object? initialState,
  required FutureOr<AgentStateMutation?> Function(
    AgentSubscriber subscriber,
    List<Message> messages,
    Object? state,
  )
  executor,
}) async {
  final baselineMessages = List<Message>.from(initialMessages);
  final baselineState = cloneJsonValue(initialState);
  var messages = baselineMessages;
  var state = baselineState;
  bool? stopPropagation;

  for (final subscriber in subscribers) {
    try {
      final readonlyMessages = UnmodifiableListView<Message>(messages);
      final mutation = await executor(
        subscriber,
        readonlyMessages,
        state,
      );

      if (mutation == null) {
        continue;
      }

      if (mutation.messages != null && !identical(mutation.messages, messages)) {
        messages = List<Message>.from(mutation.messages!);
      }
      if (mutation.state != null && !identical(mutation.state, state)) {
        state = cloneJsonValue(mutation.state);
      }
      stopPropagation = mutation.stopPropagation;
      if (stopPropagation == true) {
        break;
      }
    } catch (_) {
      continue;
    }
  }

  return AgentStateMutation(
    messages: identical(messages, baselineMessages) ? null : messages,
    state: identical(state, baselineState) ? null : state,
    stopPropagation: stopPropagation,
  );
}
