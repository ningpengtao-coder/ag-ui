library;

import 'events/events.dart';
import 'types/context.dart';

TextMessageStartEvent createTextMessageStartEvent({
  required String messageId,
  TextMessageRole role = TextMessageRole.assistant,
  String? name,
  int? timestamp,
}) {
  return TextMessageStartEvent(
    messageId: messageId,
    role: role,
    name: name,
    timestamp: timestamp,
  );
}

TextMessageContentEvent createTextMessageContentEvent({
  required String messageId,
  required String delta,
  int? timestamp,
}) {
  return TextMessageContentEvent(
    messageId: messageId,
    delta: delta,
    timestamp: timestamp,
  );
}

TextMessageEndEvent createTextMessageEndEvent({
  required String messageId,
  int? timestamp,
}) {
  return TextMessageEndEvent(messageId: messageId, timestamp: timestamp);
}

TextMessageChunkEvent createTextMessageChunkEvent({
  String? messageId,
  TextMessageRole? role,
  String? delta,
  String? name,
  int? timestamp,
}) {
  return TextMessageChunkEvent(
    messageId: messageId,
    role: role,
    delta: delta,
    name: name,
    timestamp: timestamp,
  );
}

ThinkingTextMessageStartEvent createThinkingTextMessageStartEvent({int? timestamp}) {
  return ThinkingTextMessageStartEvent(timestamp: timestamp);
}

ThinkingTextMessageContentEvent createThinkingTextMessageContentEvent({
  required String delta,
  int? timestamp,
}) {
  return ThinkingTextMessageContentEvent(delta: delta, timestamp: timestamp);
}

ThinkingTextMessageEndEvent createThinkingTextMessageEndEvent({int? timestamp}) {
  return ThinkingTextMessageEndEvent(timestamp: timestamp);
}

ToolCallStartEvent createToolCallStartEvent({
  required String toolCallId,
  required String toolCallName,
  String? parentMessageId,
  int? timestamp,
}) {
  return ToolCallStartEvent(
    toolCallId: toolCallId,
    toolCallName: toolCallName,
    parentMessageId: parentMessageId,
    timestamp: timestamp,
  );
}

ToolCallArgsEvent createToolCallArgsEvent({
  required String toolCallId,
  required String delta,
  int? timestamp,
}) {
  return ToolCallArgsEvent(
    toolCallId: toolCallId,
    delta: delta,
    timestamp: timestamp,
  );
}

ToolCallEndEvent createToolCallEndEvent({
  required String toolCallId,
  int? timestamp,
}) {
  return ToolCallEndEvent(toolCallId: toolCallId, timestamp: timestamp);
}

ToolCallChunkEvent createToolCallChunkEvent({
  String? toolCallId,
  String? toolCallName,
  String? parentMessageId,
  String? delta,
  int? timestamp,
}) {
  return ToolCallChunkEvent(
    toolCallId: toolCallId,
    toolCallName: toolCallName,
    parentMessageId: parentMessageId,
    delta: delta,
    timestamp: timestamp,
  );
}

ToolCallResultEvent createToolCallResultEvent({
  required String messageId,
  required String toolCallId,
  required String content,
  String? role,
  int? timestamp,
}) {
  return ToolCallResultEvent(
    messageId: messageId,
    toolCallId: toolCallId,
    content: content,
    role: role,
    timestamp: timestamp,
  );
}

ThinkingStartEvent createThinkingStartEvent({String? title, int? timestamp}) {
  return ThinkingStartEvent(title: title, timestamp: timestamp);
}

ThinkingEndEvent createThinkingEndEvent({int? timestamp}) {
  return ThinkingEndEvent(timestamp: timestamp);
}

StateSnapshotEvent createStateSnapshotEvent({
  required Object? snapshot,
  int? timestamp,
}) {
  return StateSnapshotEvent(snapshot: snapshot, timestamp: timestamp);
}

StateDeltaEvent createStateDeltaEvent({
  required List<dynamic> delta,
  int? timestamp,
}) {
  return StateDeltaEvent(delta: delta, timestamp: timestamp);
}

MessagesSnapshotEvent createMessagesSnapshotEvent({
  required List messages,
  int? timestamp,
}) {
  return MessagesSnapshotEvent(messages: messages.cast(), timestamp: timestamp);
}

ActivitySnapshotEvent createActivitySnapshotEvent({
  required String messageId,
  required String activityType,
  required Map<String, dynamic> content,
  bool replace = true,
  int? timestamp,
}) {
  return ActivitySnapshotEvent(
    messageId: messageId,
    activityType: activityType,
    content: content,
    replace: replace,
    timestamp: timestamp,
  );
}

ActivityDeltaEvent createActivityDeltaEvent({
  required String messageId,
  required String activityType,
  required List<dynamic> patch,
  int? timestamp,
}) {
  return ActivityDeltaEvent(
    messageId: messageId,
    activityType: activityType,
    patch: patch,
    timestamp: timestamp,
  );
}

RawEvent createRawEvent({
  required Object? event,
  String? source,
  int? timestamp,
}) {
  return RawEvent(event: event, source: source, timestamp: timestamp);
}

CustomEvent createCustomEvent({
  required String name,
  Object? value,
  int? timestamp,
}) {
  return CustomEvent(name: name, value: value, timestamp: timestamp);
}

RunStartedEvent createRunStartedEvent({
  required String threadId,
  required String runId,
  String? parentRunId,
  RunAgentInput? input,
  int? timestamp,
}) {
  return RunStartedEvent(
    threadId: threadId,
    runId: runId,
    parentRunId: parentRunId,
    input: input,
    timestamp: timestamp,
  );
}

RunFinishedEvent createRunFinishedEvent({
  required String threadId,
  required String runId,
  Object? result,
  RunFinishedOutcome? outcome,
  int? timestamp,
}) {
  return RunFinishedEvent(
    threadId: threadId,
    runId: runId,
    result: result,
    outcome: outcome,
    timestamp: timestamp,
  );
}

RunFinishedEvent createRunFinishedSuccessEvent({
  required String threadId,
  required String runId,
  Object? result,
  int? timestamp,
}) {
  return createRunFinishedEvent(
    threadId: threadId,
    runId: runId,
    result: result,
    outcome: const RunFinishedSuccessOutcome(),
    timestamp: timestamp,
  );
}

RunFinishedEvent createRunFinishedInterruptEvent({
  required String threadId,
  required String runId,
  required List<Interrupt> interrupts,
  Object? result,
  int? timestamp,
}) {
  if (interrupts.isEmpty) {
    throw ArgumentError('interrupts must not be empty');
  }
  return createRunFinishedEvent(
    threadId: threadId,
    runId: runId,
    result: result,
    outcome: RunFinishedInterruptOutcome(interrupts: interrupts),
    timestamp: timestamp,
  );
}

RunErrorEvent createRunErrorEvent({
  required String message,
  String? code,
  int? timestamp,
}) {
  return RunErrorEvent(
    message: message,
    code: code,
    timestamp: timestamp,
  );
}

StepStartedEvent createStepStartedEvent({
  required String stepName,
  int? timestamp,
}) {
  return StepStartedEvent(stepName: stepName, timestamp: timestamp);
}

StepFinishedEvent createStepFinishedEvent({
  required String stepName,
  int? timestamp,
}) {
  return StepFinishedEvent(stepName: stepName, timestamp: timestamp);
}
