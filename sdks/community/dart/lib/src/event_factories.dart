library;

import 'events/events.dart';
import 'types/context.dart';
import 'types/message.dart';
import 'types/token_usage.dart';

TextMessageStartEvent createTextMessageStartEvent({
  required String messageId,
  TextMessageRole role = TextMessageRole.assistant,
  String? name,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return TextMessageStartEvent(
    messageId: messageId,
    role: role,
    name: name,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

TextMessageContentEvent createTextMessageContentEvent({
  required String messageId,
  required String delta,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return TextMessageContentEvent(
    messageId: messageId,
    delta: delta,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

TextMessageEndEvent createTextMessageEndEvent({
  required String messageId,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return TextMessageEndEvent(
    messageId: messageId,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

TextMessageChunkEvent createTextMessageChunkEvent({
  String? messageId,
  TextMessageRole? role,
  String? delta,
  String? name,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return TextMessageChunkEvent(
    messageId: messageId,
    role: role,
    delta: delta,
    name: name,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

ThinkingTextMessageStartEvent createThinkingTextMessageStartEvent({
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return ThinkingTextMessageStartEvent(
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

ThinkingTextMessageContentEvent createThinkingTextMessageContentEvent({
  required String delta,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return ThinkingTextMessageContentEvent(
    delta: delta,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

ThinkingTextMessageEndEvent createThinkingTextMessageEndEvent({
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return ThinkingTextMessageEndEvent(
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

ToolCallStartEvent createToolCallStartEvent({
  required String toolCallId,
  required String toolCallName,
  String? parentMessageId,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return ToolCallStartEvent(
    toolCallId: toolCallId,
    toolCallName: toolCallName,
    parentMessageId: parentMessageId,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

ToolCallArgsEvent createToolCallArgsEvent({
  required String toolCallId,
  required String delta,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return ToolCallArgsEvent(
    toolCallId: toolCallId,
    delta: delta,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

ToolCallEndEvent createToolCallEndEvent({
  required String toolCallId,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return ToolCallEndEvent(
    toolCallId: toolCallId,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

ToolCallChunkEvent createToolCallChunkEvent({
  String? toolCallId,
  String? toolCallName,
  String? parentMessageId,
  String? delta,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return ToolCallChunkEvent(
    toolCallId: toolCallId,
    toolCallName: toolCallName,
    parentMessageId: parentMessageId,
    delta: delta,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

/// Creates a `TOOL_CALL_RESULT`.
///
/// [content] is the 1.0 union: either the result as text, or a list of
/// [InputContent] parts when the result carries media.
ToolCallResultEvent createToolCallResultEvent({
  required String messageId,
  required String toolCallId,
  required Object content,
  String? role,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return ToolCallResultEvent(
    messageId: messageId,
    toolCallId: toolCallId,
    content: content,
    role: role,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

ThinkingStartEvent createThinkingStartEvent({
  String? title,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return ThinkingStartEvent(
    title: title,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

ThinkingEndEvent createThinkingEndEvent({
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return ThinkingEndEvent(
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

StateSnapshotEvent createStateSnapshotEvent({
  required Object? snapshot,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return StateSnapshotEvent(
    snapshot: snapshot,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

StateDeltaEvent createStateDeltaEvent({
  required List<dynamic> delta,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return StateDeltaEvent(
    delta: delta,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

MessagesSnapshotEvent createMessagesSnapshotEvent({
  required List<Message> messages,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return MessagesSnapshotEvent(
    messages: messages,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

ActivitySnapshotEvent createActivitySnapshotEvent({
  required String messageId,
  required String activityType,
  required Map<String, dynamic> content,
  bool replace = true,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return ActivitySnapshotEvent(
    messageId: messageId,
    activityType: activityType,
    content: content,
    replace: replace,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

ActivityDeltaEvent createActivityDeltaEvent({
  required String messageId,
  required String activityType,
  required List<dynamic> patch,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return ActivityDeltaEvent(
    messageId: messageId,
    activityType: activityType,
    patch: patch,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

RawEvent createRawEvent({
  required Object? event,
  String? source,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return RawEvent(
    event: event,
    source: source,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

CustomEvent createCustomEvent({
  required String name,
  Object? value,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return CustomEvent(
    name: name,
    value: value,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

RunStartedEvent createRunStartedEvent({
  required String threadId,
  required String runId,
  String? parentRunId,
  RunAgentInput? input,
  String? protocolVersion,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return RunStartedEvent(
    threadId: threadId,
    runId: runId,
    parentRunId: parentRunId,
    input: input,
    protocolVersion: protocolVersion,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

RunFinishedEvent createRunFinishedEvent({
  required String threadId,
  required String runId,
  Object? result,
  RunFinishedOutcome? outcome,
  List<TokenUsage> usage = const [],
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return RunFinishedEvent(
    threadId: threadId,
    runId: runId,
    result: result,
    outcome: outcome,
    usage: usage,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

RunFinishedEvent createRunFinishedSuccessEvent({
  required String threadId,
  required String runId,
  Object? result,
  List<String> pendingToolCallIds = const [],
  List<TokenUsage> usage = const [],
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return createRunFinishedEvent(
    threadId: threadId,
    runId: runId,
    result: result,
    outcome: RunFinishedSuccessOutcome(
      pendingToolCallIds: pendingToolCallIds,
    ),
    usage: usage,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

RunFinishedEvent createRunFinishedInterruptEvent({
  required String threadId,
  required String runId,
  required List<Interrupt> interrupts,
  Object? result,
  List<TokenUsage> usage = const [],
  Map<String, dynamic>? metadata,
  Object? rawEvent,
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
    usage: usage,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

RunFinishedEvent createRunFinishedCancelledEvent({
  required String threadId,
  required String runId,
  List<TokenUsage> usage = const [],
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return createRunFinishedEvent(
    threadId: threadId,
    runId: runId,
    outcome: const RunFinishedCancelledOutcome(),
    usage: usage,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

RunErrorEvent createRunErrorEvent({
  required String message,
  String? code,
  List<TokenUsage> usage = const [],
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return RunErrorEvent(
    message: message,
    code: code,
    usage: usage,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

StepStartedEvent createStepStartedEvent({
  required String stepName,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return StepStartedEvent(
    stepName: stepName,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

StepFinishedEvent createStepFinishedEvent({
  required String stepName,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return StepFinishedEvent(
    stepName: stepName,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

ReasoningStartEvent createReasoningStartEvent({
  required String messageId,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return ReasoningStartEvent(
    messageId: messageId,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

ReasoningMessageStartEvent createReasoningMessageStartEvent({
  required String messageId,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return ReasoningMessageStartEvent(
    messageId: messageId,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

ReasoningMessageContentEvent createReasoningMessageContentEvent({
  required String messageId,
  required String delta,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return ReasoningMessageContentEvent(
    messageId: messageId,
    delta: delta,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

ReasoningMessageEndEvent createReasoningMessageEndEvent({
  required String messageId,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return ReasoningMessageEndEvent(
    messageId: messageId,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

ReasoningMessageChunkEvent createReasoningMessageChunkEvent({
  String? messageId,
  String? delta,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return ReasoningMessageChunkEvent(
    messageId: messageId,
    delta: delta,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

ReasoningEndEvent createReasoningEndEvent({
  required String messageId,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return ReasoningEndEvent(
    messageId: messageId,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

ReasoningEncryptedValueEvent createReasoningEncryptedValueEvent({
  required ReasoningEncryptedValueSubtype subtype,
  required String entityId,
  required String encryptedValue,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return ReasoningEncryptedValueEvent(
    subtype: subtype,
    entityId: entityId,
    encryptedValue: encryptedValue,
    subagentRunId: subagentRunId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

SubagentStartedEvent createSubagentStartedEvent({
  required String subagentRunId,
  required String name,
  String? description,
  String? parentSubagentRunId,
  String? parentToolCallId,
  String? parentMessageId,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return SubagentStartedEvent(
    subagentRunId: subagentRunId,
    name: name,
    description: description,
    parentSubagentRunId: parentSubagentRunId,
    parentToolCallId: parentToolCallId,
    parentMessageId: parentMessageId,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

SubagentFinishedEvent createSubagentFinishedEvent({
  required String subagentRunId,
  Object? result,
  SubagentFinishedOutcome? outcome,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return SubagentFinishedEvent(
    subagentRunId: subagentRunId,
    result: result,
    outcome: outcome,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}

SubagentErrorEvent createSubagentErrorEvent({
  required String subagentRunId,
  required String message,
  String? code,
  Map<String, dynamic>? metadata,
  Object? rawEvent,
  int? timestamp,
}) {
  return SubagentErrorEvent(
    subagentRunId: subagentRunId,
    message: message,
    code: code,
    metadata: metadata,
    rawEvent: rawEvent,
    timestamp: timestamp,
  );
}
