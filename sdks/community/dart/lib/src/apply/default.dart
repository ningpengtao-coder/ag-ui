library;

import '../activity_history.dart';
import '../debug_logger.dart';
import '../diagnostics.dart';
import '../events/events.dart';
import '../types/types.dart';
import 'json_patch.dart';

/// Distinguishes "argument not supplied" from an explicit `null`.
const Object _unset = Object();

/// Distinguishes "state not supplied" from an explicit `null` state.
const Object _stateSentinel = Object();

/// The RFC 6902 operations the reducer can apply.
const Set<String> _knownPatchOperations = {
  'add',
  'copy',
  'move',
  'remove',
  'replace',
  'test',
};

/// Lifecycle of one nested run announced by `SUBAGENT_STARTED`.
enum SubagentRunStatus {
  started('started'),
  finished('finished'),
  error('error');

  const SubagentRunStatus(this.value);

  final String value;
}

/// A nested run tracked by the reducer: opened by `SUBAGENT_STARTED`, closed by
/// `SUBAGENT_FINISHED` or `SUBAGENT_ERROR`.
class SubagentRunState {
  const SubagentRunState({
    required this.subagentRunId,
    this.name,
    this.description,
    this.parentSubagentRunId,
    this.parentToolCallId,
    this.parentMessageId,
    this.status = SubagentRunStatus.started,
    this.outcome,
    this.result,
    this.error,
    this.errorCode,
  });

  final String subagentRunId;
  final String? name;
  final String? description;
  final String? parentSubagentRunId;
  final String? parentToolCallId;
  final String? parentMessageId;
  final SubagentRunStatus status;

  /// The `type` of the closing outcome (`success`, `suspended`, ...).
  final String? outcome;
  final Object? result;
  final String? error;
  final String? errorCode;

  SubagentRunState copyWith({
    SubagentRunStatus? status,
    String? outcome,
    Object? result,
    String? error,
    String? errorCode,
  }) {
    return SubagentRunState(
      subagentRunId: subagentRunId,
      name: name,
      description: description,
      parentSubagentRunId: parentSubagentRunId,
      parentToolCallId: parentToolCallId,
      parentMessageId: parentMessageId,
      status: status ?? this.status,
      outcome: outcome ?? this.outcome,
      result: result ?? this.result,
      error: error ?? this.error,
      errorCode: errorCode ?? this.errorCode,
    );
  }
}

class AppliedState {
  final List<Message> messages;
  final Object? state;
  final List<Interrupt> pendingInterrupts;

  /// Token accounting accumulated from every `RUN_FINISHED` / `RUN_ERROR`
  /// carrying a `usage` array, in arrival order.
  final List<TokenUsage> usage;

  /// Nested runs seen on this stream, keyed by `subagentRunId`.
  final Map<String, SubagentRunState> subagents;

  const AppliedState({
    required this.messages,
    required this.state,
    this.pendingInterrupts = const [],
    this.usage = const [],
    this.subagents = const {},
  });

  AppliedState copyWith({
    List<Message>? messages,
    Object? state = _stateSentinel,
    List<Interrupt>? pendingInterrupts,
    List<TokenUsage>? usage,
    Map<String, SubagentRunState>? subagents,
  }) {
    return AppliedState(
      messages: messages ?? this.messages,
      state: identical(state, _stateSentinel) ? this.state : state,
      pendingInterrupts: pendingInterrupts ?? this.pendingInterrupts,
      usage: usage ?? this.usage,
      subagents: subagents ?? this.subagents,
    );
  }
}

Stream<AppliedState> defaultApplyEvents(
  RunAgentInput input,
  Stream<BaseEvent> events, {
  Object? debugLogger,
  List<Interrupt> initialPendingInterrupts = const [],
}) async* {
  final log = resolveDebugLogger(debugLogger);
  var current = AppliedState(
    messages: List<Message>.from(input.messages),
    state: cloneJsonValue(input.state),
    pendingInterrupts: List<Interrupt>.from(initialPendingInterrupts),
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
      identical(a.pendingInterrupts, b.pendingInterrupts) &&
      identical(a.usage, b.usage) &&
      identical(a.subagents, b.subagents);
}

AppliedState _applyEvent(AppliedState current, BaseEvent event) {
  switch (event.eventType) {
    case EventType.textMessageStart:
      return _applyTextMessageStart(current, event as TextMessageStartEvent);
    case EventType.textMessageContent:
      return _applyTextMessageContent(
          current, event as TextMessageContentEvent);
    case EventType.textMessageEnd:
      return _applyTextMessageEnd(current, event as TextMessageEndEvent);
    case EventType.toolCallStart:
      return _applyToolCallStart(current, event as ToolCallStartEvent);
    case EventType.toolCallArgs:
      return _applyToolCallArgs(current, event as ToolCallArgsEvent);
    case EventType.toolCallEnd:
      return _applyToolCallEnd(current, event as ToolCallEndEvent);
    case EventType.toolCallResult:
      return _applyToolCallResult(current, event as ToolCallResultEvent);
    case EventType.stateSnapshot:
      return _applyStateSnapshot(current, event as StateSnapshotEvent);
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
    case EventType.runError:
      return _applyRunError(current, event as RunErrorEvent);
    case EventType.reasoningMessageStart:
      return _applyReasoningMessageStart(
          current, event as ReasoningMessageStartEvent);
    case EventType.reasoningMessageContent:
      return _applyReasoningMessageContent(
          current, event as ReasoningMessageContentEvent);
    case EventType.reasoningMessageEnd:
      return _applyReasoningMessageEnd(
          current, event as ReasoningMessageEndEvent);
    case EventType.reasoningEncryptedValue:
      return _applyReasoningEncryptedValue(
          current, event as ReasoningEncryptedValueEvent);
    case EventType.subagentStarted:
      return _applySubagentStarted(current, event as SubagentStartedEvent);
    case EventType.subagentFinished:
      return _applySubagentFinished(current, event as SubagentFinishedEvent);
    case EventType.subagentError:
      return _applySubagentError(current, event as SubagentErrorEvent);
    case EventType.textMessageChunk:
      throw StateError(
          'TEXT_MESSAGE_CHUNK must be transformed before being applied');
    case EventType.toolCallChunk:
      throw StateError(
          'TOOL_CALL_CHUNK must be transformed before being applied');
    case EventType.reasoningMessageChunk:
      throw StateError(
          'REASONING_MESSAGE_CHUNK must be transformed before being applied');
    case EventType.thinkingTextMessageStart:
    case EventType.thinkingTextMessageContent:
    case EventType.thinkingTextMessageEnd:
    case EventType.thinkingStart:
    case EventType.thinkingContent:
    case EventType.thinkingEnd:
    case EventType.raw:
    case EventType.custom:
    case EventType.stepStarted:
    case EventType.stepFinished:
    case EventType.reasoningStart:
    case EventType.reasoningEnd:
    case EventType.unknown:
      return current;
  }
}

// --- Text messages -------------------------------------------------------

AppliedState _applyTextMessageStart(
    AppliedState current, TextMessageStartEvent event) {
  final index = _messageIndex(current.messages, event.messageId);
  if (index != -1) {
    final existing = current.messages[index];
    if (existing is ActivityMessage) {
      AgUiDiagnostics.warn(
          _activityCollision('TEXT_MESSAGE_START', event.messageId, 'text'));
      return current;
    }
    // A closed message is closed, not sealed: a second start continues it.
    final updated = _mergeEventMetadata(existing, event.metadata);
    return identical(updated, existing)
        ? current
        : _replaceMessage(current, index, updated);
  }

  final created = _createTextMessage(
    event.messageId,
    event.role,
    event.name,
    event.subagentRunId,
    event.metadata,
  );
  final messages = List<Message>.from(current.messages)..add(created);
  return current.copyWith(messages: messages);
}

Message _createTextMessage(
  String id,
  TextMessageRole role,
  String? name,
  String? subagentRunId,
  Map<String, dynamic>? metadata,
) {
  final mergedMetadata = _mergeMetadata(null, metadata);
  switch (role) {
    case TextMessageRole.developer:
      return DeveloperMessage(
        id: id,
        content: '',
        name: name,
        metadata: mergedMetadata,
        subagentRunId: subagentRunId,
      );
    case TextMessageRole.system:
      return SystemMessage(
        id: id,
        content: '',
        name: name,
        metadata: mergedMetadata,
        subagentRunId: subagentRunId,
      );
    case TextMessageRole.assistant:
      return AssistantMessage(
        id: id,
        content: '',
        name: name,
        metadata: mergedMetadata,
        subagentRunId: subagentRunId,
      );
    case TextMessageRole.user:
      return UserMessage(
        id: id,
        content: '',
        name: name,
        metadata: mergedMetadata,
        subagentRunId: subagentRunId,
      );
  }
}

AppliedState _applyTextMessageContent(
    AppliedState current, TextMessageContentEvent event) {
  final index = _messageIndex(current.messages, event.messageId);
  if (index == -1) {
    AgUiDiagnostics.warn(
        'TEXT_MESSAGE_CONTENT: No message found with ID "${event.messageId}"');
    return current;
  }

  final target = current.messages[index];
  if (target is ActivityMessage) {
    AgUiDiagnostics.warn(
        _activityCollision('TEXT_MESSAGE_CONTENT', event.messageId, 'text'));
    return current;
  }

  final updated = _mergeEventMetadata(
    _rebuildMessage(target, content: '${_textContentOf(target)}${event.delta}'),
    event.metadata,
  );
  return _replaceMessage(current, index, updated);
}

AppliedState _applyTextMessageEnd(
    AppliedState current, TextMessageEndEvent event) {
  final index = _messageIndex(current.messages, event.messageId);
  if (index == -1) {
    AgUiDiagnostics.warn(
        'TEXT_MESSAGE_END: No message found with ID "${event.messageId}"');
    return current;
  }

  final target = current.messages[index];
  if (target is ActivityMessage) {
    AgUiDiagnostics.warn(
        _activityCollision('TEXT_MESSAGE_END', event.messageId, 'text'));
    return current;
  }

  final updated = _mergeEventMetadata(target, event.metadata);
  return identical(updated, target)
      ? current
      : _replaceMessage(current, index, updated);
}

// --- Tool calls ----------------------------------------------------------

AppliedState _applyToolCallStart(
    AppliedState current, ToolCallStartEvent event) {
  final messages = List<Message>.from(current.messages);
  final ownerIndex = _toolCallOwnerIndex(messages, event.toolCallId);

  if (ownerIndex != null) {
    // A start event is idempotent: update the entry already in state instead of
    // appending a second one, and leave its streamed arguments untouched.
    final assistant = messages[ownerIndex] as AssistantMessage;
    final toolCalls =
        List<ToolCall>.from(assistant.toolCalls ?? const <ToolCall>[]);
    final toolCallIndex =
        toolCalls.indexWhere((toolCall) => toolCall.id == event.toolCallId);
    final existing = toolCalls[toolCallIndex];
    final renamed = existing.function.name != event.toolCallName;

    if (renamed) {
      AgUiDiagnostics.warn(
        'TOOL_CALL_START: tool call "${event.toolCallId}" already exists with name '
        '"${existing.function.name}" - updating it to "${event.toolCallName}"',
      );
    }
    if (!renamed && event.metadata == null) {
      return current;
    }

    final updated = _mergeToolCallMetadata(
      renamed
          ? existing.copyWith(
              function: existing.function.copyWith(name: event.toolCallName),
            )
          : existing,
      event.metadata,
    );
    toolCalls[toolCallIndex] = updated;
    messages[ownerIndex] = assistant.copyWith(toolCalls: toolCalls);
    return current.copyWith(messages: messages);
  }

  // A tool call raised by a subagent belongs to a message that subagent owns.
  // A message created here inherits the attribution the call carried, because
  // nothing else on the message can supply it — while an existing message keeps
  // whatever attribution it already had.
  final preexistingIds = <String>{for (final message in messages) message.id};
  final assistantIndex = _resolveOrCreateAssistantIndex(
    messages,
    event.parentMessageId,
    event.toolCallId,
  );
  var assistant = messages[assistantIndex] as AssistantMessage;
  if (!preexistingIds.contains(assistant.id) &&
      event.subagentRunId != null &&
      assistant.subagentRunId == null) {
    assistant = AssistantMessage(
      id: assistant.id,
      content: assistant.content,
      name: assistant.name,
      encryptedValue: assistant.encryptedValue,
      metadata: assistant.metadata,
      subagentRunId: event.subagentRunId,
      toolCalls: assistant.toolCalls,
    );
    messages[assistantIndex] = assistant;
  }
  final toolCalls =
      List<ToolCall>.from(assistant.toolCalls ?? const <ToolCall>[])
        ..add(
          ToolCall(
            id: event.toolCallId,
            function: FunctionCall(name: event.toolCallName, arguments: ''),
            metadata: _mergeMetadata(null, event.metadata),
          ),
        );
  messages[assistantIndex] = assistant.copyWith(toolCalls: toolCalls);
  return current.copyWith(messages: messages);
}

int _resolveOrCreateAssistantIndex(
  List<Message> messages,
  String? parentMessageId,
  String toolCallId,
) {
  if (parentMessageId != null) {
    final existingIndex = _messageIndex(messages, parentMessageId);
    if (existingIndex != -1 && messages[existingIndex] is AssistantMessage) {
      return existingIndex;
    }

    if (existingIndex != -1) {
      AgUiDiagnostics.warn(
        'TOOL_CALL_START: parentMessageId "$parentMessageId" matches a '
        '"${messages[existingIndex].role.value}" message, not assistant - '
        'falling back to toolCallId',
      );
    }

    messages.add(
      AssistantMessage(
        id: existingIndex == -1 ? parentMessageId : toolCallId,
        toolCalls: const <ToolCall>[],
      ),
    );
    return messages.length - 1;
  }

  messages.add(AssistantMessage(id: toolCallId, toolCalls: const <ToolCall>[]));
  return messages.length - 1;
}

AppliedState _applyToolCallArgs(AppliedState current, ToolCallArgsEvent event) {
  final messages = List<Message>.from(current.messages);

  for (var messageIndex = 0; messageIndex < messages.length; messageIndex++) {
    final message = messages[messageIndex];
    if (message is! AssistantMessage) {
      continue;
    }
    final toolCalls = message.toolCalls;
    if (toolCalls == null) {
      continue;
    }
    final toolCallIndex =
        toolCalls.indexWhere((toolCall) => toolCall.id == event.toolCallId);
    if (toolCallIndex == -1) {
      continue;
    }

    final target = toolCalls[toolCallIndex];
    final updatedCalls = List<ToolCall>.from(toolCalls)
      ..[toolCallIndex] = _mergeToolCallMetadata(
        target.copyWith(
          function: target.function.copyWith(
            arguments: '${target.function.arguments}${event.delta}',
          ),
        ),
        event.metadata,
      );
    messages[messageIndex] = message.copyWith(toolCalls: updatedCalls);
    return current.copyWith(messages: messages);
  }

  AgUiDiagnostics.warn(
      'TOOL_CALL_ARGS: No tool call found with ID "${event.toolCallId}"');
  return current;
}

AppliedState _applyToolCallEnd(AppliedState current, ToolCallEndEvent event) {
  final messages = List<Message>.from(current.messages);
  final ownerIndex = _toolCallOwnerIndex(messages, event.toolCallId);
  if (ownerIndex == null) {
    AgUiDiagnostics.warn(
        'TOOL_CALL_END: No tool call found with ID "${event.toolCallId}"');
    return current;
  }

  final assistant = messages[ownerIndex] as AssistantMessage;
  final toolCalls =
      List<ToolCall>.from(assistant.toolCalls ?? const <ToolCall>[]);
  final toolCallIndex =
      toolCalls.indexWhere((toolCall) => toolCall.id == event.toolCallId);
  final existing = toolCalls[toolCallIndex];
  final updated = _mergeToolCallMetadata(existing, event.metadata);
  if (identical(updated, existing)) {
    return current;
  }

  toolCalls[toolCallIndex] = updated;
  messages[ownerIndex] = assistant.copyWith(toolCalls: toolCalls);
  return current.copyWith(messages: messages);
}

AppliedState _applyToolCallResult(
    AppliedState current, ToolCallResultEvent event) {
  final messages = List<Message>.from(current.messages);
  final existingIndex = messages.indexWhere(
    (message) =>
        message.id == event.messageId &&
        message is ToolMessage &&
        message.toolCallId == event.toolCallId,
  );
  final existing =
      existingIndex == -1 ? null : messages[existingIndex] as ToolMessage;

  final toolMessage = ToolMessage(
    id: event.messageId,
    toolCallId: event.toolCallId,
    content: event.content,
    error: existing?.error,
    encryptedValue: existing?.encryptedValue,
    metadata: _mergeMetadata(existing?.metadata, event.metadata),
    subagentRunId: event.subagentRunId,
  );

  if (existingIndex != -1) {
    // A resumed run may correct a result already in history: keep its position.
    messages[existingIndex] = toolMessage;
    return current.copyWith(messages: messages);
  }

  // Providers require a tool result to follow the assistant message that issued
  // the call, so the result is placed there rather than appended.
  final ownerIndex = _toolResultOwnerIndex(messages, event.toolCallId);
  if (ownerIndex == -1) {
    messages.add(toolMessage);
    return current.copyWith(messages: messages);
  }

  var insertAt = ownerIndex + 1;
  while (insertAt < messages.length) {
    final entry = messages[insertAt];
    if (entry is ToolMessage || entry is ActivityMessage) {
      insertAt++;
    } else {
      break;
    }
  }
  messages.insert(insertAt, toolMessage);
  return current.copyWith(messages: messages);
}

/// The newest message holding [toolCallId] that is not already answered by a
/// tool message of that id, falling back to the newest holder.
int _toolResultOwnerIndex(List<Message> messages, String toolCallId) {
  var ownerIndex = -1;
  var newestHolder = -1;
  var answered = false;

  for (var index = messages.length - 1; index >= 0; index--) {
    final message = messages[index];
    if (message is ToolMessage && message.toolCallId == toolCallId) {
      answered = true;
    } else if (_issuedCallIds(message).contains(toolCallId)) {
      if (newestHolder == -1) {
        newestHolder = index;
      }
      if (!answered) {
        ownerIndex = index;
        break;
      }
      answered = false;
    }
  }

  return ownerIndex == -1 ? newestHolder : ownerIndex;
}

List<String> _issuedCallIds(Message message) {
  if (message is! AssistantMessage) {
    return const [];
  }
  return [
    for (final toolCall in message.toolCalls ?? const <ToolCall>[]) toolCall.id,
  ];
}

int? _toolCallOwnerIndex(List<Message> messages, String toolCallId) {
  for (var index = 0; index < messages.length; index++) {
    if (_issuedCallIds(messages[index]).contains(toolCallId)) {
      return index;
    }
  }
  return null;
}

// --- State ---------------------------------------------------------------

AppliedState _applyStateSnapshot(
    AppliedState current, StateSnapshotEvent event) {
  // A falsy or null snapshot replaces the state like any other value.
  return current.copyWith(state: cloneJsonValue(event.snapshot));
}

AppliedState _applyStateDelta(AppliedState current, StateDeltaEvent event) {
  final operations =
      _supportedPatchOperations(event.delta, 'STATE_DELTA', 'delta');
  if (operations.isEmpty) {
    return current;
  }

  try {
    return current.copyWith(state: applyJsonPatch(current.state, operations));
  } on Object catch (error) {
    AgUiDiagnostics.warn('Failed to apply state patch: $error');
    return current;
  }
}

// --- Messages snapshot ---------------------------------------------------

AppliedState _applyMessagesSnapshot(
    AppliedState current, MessagesSnapshotEvent event) {
  final snapshotById = <String, Message>{
    for (final message in event.messages) message.id: message,
  };
  final scope = authoritativeActivityTypes(event);
  final snapshotHasActivity =
      event.messages.any((message) => message is ActivityMessage);
  final snapshotHasReasoning =
      event.messages.any((message) => message is ReasoningMessage);

  final merged = <Message>[];
  for (final message in current.messages) {
    final replacement = snapshotById[message.id];
    if (replacement != null) {
      merged.add(replacement);
      continue;
    }
    if (_preserveClientOnly(
        message, scope, snapshotHasActivity, snapshotHasReasoning)) {
      merged.add(message);
    }
  }

  final seen = <String>{for (final message in merged) message.id};
  for (final message in event.messages) {
    if (seen.add(message.id)) {
      merged.add(message);
    }
  }

  return current.copyWith(messages: keepToolResultsWithCalls(merged));
}

/// Activity and reasoning messages are only sometimes client-only: a snapshot
/// that never carries them leaves the local copies alone, one that does becomes
/// their source of truth.
bool _preserveClientOnly(
  Message message,
  ({bool declared, List<String>? types}) scope,
  bool snapshotHasActivity,
  bool snapshotHasReasoning,
) {
  if (message is ActivityMessage) {
    if (!scope.declared) {
      return !snapshotHasActivity;
    }
    final types = scope.types;
    if (types == null) {
      return false;
    }
    return !types.contains(message.activityType);
  }
  if (message is ReasoningMessage) {
    return !snapshotHasReasoning;
  }
  return false;
}

// --- Activities ----------------------------------------------------------

AppliedState _applyActivitySnapshot(
    AppliedState current, ActivitySnapshotEvent event) {
  final messages = List<Message>.from(current.messages);
  final index = _messageIndex(messages, event.messageId);
  final content = _cloneActivityContent(event.content);

  if (index == -1) {
    messages.add(
      ActivityMessage(
        id: event.messageId,
        activityType: event.activityType,
        content: content,
        metadata: _mergeMetadata(null, event.metadata),
        subagentRunId: event.subagentRunId,
      ),
    );
    return current.copyWith(messages: messages);
  }

  final existing = messages[index];
  if (existing is ActivityMessage) {
    if (event.replace) {
      messages[index] = ActivityMessage(
        id: event.messageId,
        activityType: event.activityType,
        content: content,
        metadata: _mergeMetadata(existing.metadata, event.metadata),
        subagentRunId: event.subagentRunId,
      );
      return current.copyWith(messages: messages);
    }

    // `replace: false` keeps the message as it stands - content and type both -
    // and only folds the event's metadata in.
    final updated = _mergeEventMetadata(existing, event.metadata);
    if (identical(updated, existing)) {
      return current;
    }
    messages[index] = updated;
    return current.copyWith(messages: messages);
  }

  if (!event.replace) {
    return current;
  }

  messages[index] = ActivityMessage(
    id: event.messageId,
    activityType: event.activityType,
    content: content,
    metadata: _mergeMetadata(null, event.metadata),
    subagentRunId: event.subagentRunId,
  );
  return current.copyWith(messages: messages);
}

AppliedState _applyActivityDelta(
    AppliedState current, ActivityDeltaEvent event) {
  final messages = List<Message>.from(current.messages);
  final index = _messageIndex(messages, event.messageId);
  if (index == -1) {
    // A delta naming a message that was never created invents no message.
    return current;
  }

  final existing = messages[index];
  if (existing is! ActivityMessage) {
    AgUiDiagnostics.warn(
      'ACTIVITY_DELTA: Message "${event.messageId}" is not an activity message',
    );
    return current;
  }

  var updated = _mergeEventMetadata(existing, event.metadata);
  final operations =
      _supportedPatchOperations(event.patch, 'ACTIVITY_DELTA', 'patch');
  if (operations.isNotEmpty) {
    try {
      updated = _rebuildActivity(
        updated as ActivityMessage,
        activityType: event.activityType,
        content:
            _asActivityContent(applyJsonPatch(existing.content, operations)),
      );
    } on Object catch (error) {
      AgUiDiagnostics.warn(
        'Failed to apply activity patch for "${event.messageId}": $error',
      );
    }
  }

  if (identical(updated, existing)) {
    return current;
  }
  messages[index] = updated;
  return current.copyWith(messages: messages);
}

ActivityMessage _rebuildActivity(
  ActivityMessage message, {
  String? activityType,
  Map<String, dynamic>? content,
}) {
  return ActivityMessage(
    id: message.id,
    activityType: activityType ?? message.activityType,
    content: content ?? message.content,
    metadata: message.metadata,
    subagentRunId: message.subagentRunId,
  );
}

Map<String, dynamic> _asActivityContent(Object? value) {
  return value is Map<String, dynamic> ? value : <String, dynamic>{};
}

Map<String, dynamic> _cloneActivityContent(Map<String, dynamic> content) {
  return _asActivityContent(cloneJsonValue(content));
}

// --- Run lifecycle -------------------------------------------------------

AppliedState _applyRunStarted(AppliedState current, RunStartedEvent event) {
  final input = event.input;
  if (input == null || input.messages.isEmpty) {
    return current;
  }

  final messages = List<Message>.from(current.messages);
  final existingIds = {for (final message in messages) message.id};
  for (final message in input.messages) {
    if (existingIds.add(message.id)) {
      messages.add(message);
    }
  }
  return current.copyWith(messages: messages);
}

AppliedState _applyRunFinished(AppliedState current, RunFinishedEvent event) {
  final outcome = event.outcome;
  final interrupts = outcome is RunFinishedInterruptOutcome
      ? List<Interrupt>.from(outcome.interrupts)
      : const <Interrupt>[];

  final interruptsChanged =
      interrupts.isNotEmpty || current.pendingInterrupts.isNotEmpty;
  final usageChanged = event.usage.isNotEmpty;
  if (!interruptsChanged && !usageChanged) {
    return current;
  }

  return current.copyWith(
    pendingInterrupts: interrupts,
    usage: usageChanged
        ? <TokenUsage>[...current.usage, ...event.usage]
        : current.usage,
  );
}

AppliedState _applyRunError(AppliedState current, RunErrorEvent event) {
  if (event.usage.isEmpty) {
    return current;
  }
  return current
      .copyWith(usage: <TokenUsage>[...current.usage, ...event.usage]);
}

// --- Reasoning -----------------------------------------------------------

AppliedState _applyReasoningMessageStart(
  AppliedState current,
  ReasoningMessageStartEvent event,
) {
  final index = _messageIndex(current.messages, event.messageId);
  if (index != -1) {
    final existing = current.messages[index];
    if (existing is ActivityMessage) {
      AgUiDiagnostics.warn(
        _activityCollision(
            'REASONING_MESSAGE_START', event.messageId, 'reasoning'),
      );
      return current;
    }
    final updated = _mergeEventMetadata(existing, event.metadata);
    return identical(updated, existing)
        ? current
        : _replaceMessage(current, index, updated);
  }

  final messages = List<Message>.from(current.messages)
    ..add(
      ReasoningMessage(
        id: event.messageId,
        content: '',
        metadata: _mergeMetadata(null, event.metadata),
        subagentRunId: event.subagentRunId,
      ),
    );
  return current.copyWith(messages: messages);
}

AppliedState _applyReasoningMessageContent(
  AppliedState current,
  ReasoningMessageContentEvent event,
) {
  final index = _messageIndex(current.messages, event.messageId);
  if (index == -1) {
    AgUiDiagnostics.warn(
      'REASONING_MESSAGE_CONTENT: No message found with ID "${event.messageId}"',
    );
    return current;
  }

  final target = current.messages[index];
  if (target is ActivityMessage) {
    AgUiDiagnostics.warn(
      _activityCollision(
          'REASONING_MESSAGE_CONTENT', event.messageId, 'reasoning'),
    );
    return current;
  }

  final updated = _mergeEventMetadata(
    _rebuildMessage(target, content: '${_textContentOf(target)}${event.delta}'),
    event.metadata,
  );
  return _replaceMessage(current, index, updated);
}

AppliedState _applyReasoningMessageEnd(
  AppliedState current,
  ReasoningMessageEndEvent event,
) {
  final index = _messageIndex(current.messages, event.messageId);
  if (index == -1) {
    AgUiDiagnostics.warn(
      'REASONING_MESSAGE_END: No message found with ID "${event.messageId}"',
    );
    return current;
  }

  final target = current.messages[index];
  if (target is ActivityMessage) {
    AgUiDiagnostics.warn(
      _activityCollision('REASONING_MESSAGE_END', event.messageId, 'reasoning'),
    );
    return current;
  }

  final updated = _mergeEventMetadata(target, event.metadata);
  return identical(updated, target)
      ? current
      : _replaceMessage(current, index, updated);
}

AppliedState _applyReasoningEncryptedValue(
  AppliedState current,
  ReasoningEncryptedValueEvent event,
) {
  final messages = List<Message>.from(current.messages);

  if (event.subtype == ReasoningEncryptedValueSubtype.toolCall) {
    final ownerIndex = _toolCallOwnerIndex(messages, event.entityId);
    if (ownerIndex == null) {
      return current;
    }
    final assistant = messages[ownerIndex] as AssistantMessage;
    final toolCalls =
        List<ToolCall>.from(assistant.toolCalls ?? const <ToolCall>[]);
    final toolCallIndex =
        toolCalls.indexWhere((toolCall) => toolCall.id == event.entityId);
    toolCalls[toolCallIndex] = toolCalls[toolCallIndex].copyWith(
      encryptedValue: event.encryptedValue,
    );
    messages[ownerIndex] = assistant.copyWith(toolCalls: toolCalls);
    return current.copyWith(messages: messages);
  }

  final index = _messageIndex(messages, event.entityId);
  if (index == -1) {
    return current;
  }

  final message = messages[index];
  if (message is ActivityMessage) {
    return current;
  }

  messages[index] =
      _rebuildMessage(message, encryptedValue: event.encryptedValue);
  return current.copyWith(messages: messages);
}

// --- Subagents -----------------------------------------------------------

AppliedState _applySubagentStarted(
    AppliedState current, SubagentStartedEvent event) {
  final subagentRunId = event.subagentRunId;
  if (subagentRunId == null) {
    return current;
  }

  final subagents = Map<String, SubagentRunState>.from(current.subagents);
  subagents[subagentRunId] = SubagentRunState(
    subagentRunId: subagentRunId,
    name: event.name,
    description: event.description,
    parentSubagentRunId: event.parentSubagentRunId,
    parentToolCallId: event.parentToolCallId,
    parentMessageId: event.parentMessageId,
  );
  return current.copyWith(subagents: subagents);
}

AppliedState _applySubagentFinished(
    AppliedState current, SubagentFinishedEvent event) {
  final subagentRunId = event.subagentRunId;
  if (subagentRunId == null) {
    return current;
  }

  final existing = current.subagents[subagentRunId];
  final subagents = Map<String, SubagentRunState>.from(current.subagents);
  subagents[subagentRunId] =
      (existing ?? SubagentRunState(subagentRunId: subagentRunId)).copyWith(
    status: SubagentRunStatus.finished,
    outcome: event.outcome?.type ?? 'success',
    result: event.result,
  );
  return current.copyWith(subagents: subagents);
}

AppliedState _applySubagentError(
    AppliedState current, SubagentErrorEvent event) {
  final subagentRunId = event.subagentRunId;
  if (subagentRunId == null) {
    return current;
  }

  final existing = current.subagents[subagentRunId];
  final subagents = Map<String, SubagentRunState>.from(current.subagents);
  subagents[subagentRunId] =
      (existing ?? SubagentRunState(subagentRunId: subagentRunId)).copyWith(
    status: SubagentRunStatus.error,
    error: event.message,
    errorCode: event.code,
  );
  return current.copyWith(subagents: subagents);
}

// --- Patch helpers -------------------------------------------------------

/// Drops the operations RFC 6902 does not define, warning for each, so the rest
/// of the patch still applies.
List<dynamic> _supportedPatchOperations(
  List<dynamic> operations,
  String eventName,
  String pointer,
) {
  final supported = <dynamic>[];
  for (var index = 0; index < operations.length; index++) {
    final operation = operations[index];
    final op = operation is Map<String, dynamic> ? operation['op'] : null;
    if (op is String && _knownPatchOperations.contains(op)) {
      supported.add(operation);
    } else {
      AgUiDiagnostics.warn(
        '$eventName: dropped operation at /$pointer/$index: '
        'unrecognised op ${op is String ? '"$op"' : '<missing>'}',
      );
    }
  }
  return supported;
}

// --- Message helpers -----------------------------------------------------

int _messageIndex(List<Message> messages, String id) {
  return messages.indexWhere((message) => message.id == id);
}

AppliedState _replaceMessage(AppliedState current, int index, Message message) {
  final messages = List<Message>.from(current.messages)..[index] = message;
  return current.copyWith(messages: messages);
}

String _textContentOf(Message message) {
  if (message is UserMessage) {
    return message.textContent ?? '';
  }
  final content = message.content;
  if (content is String) {
    return content;
  }
  return '';
}

Map<String, dynamic>? _mergeMetadata(
  Map<String, dynamic>? existing,
  Map<String, dynamic>? incoming,
) {
  if (incoming == null) {
    return existing;
  }
  return <String, dynamic>{
    if (existing != null) ...existing,
    ..._cloneMetadata(incoming),
  };
}

Map<String, dynamic> _cloneMetadata(Map<String, dynamic> metadata) {
  final cloned = cloneJsonValue(metadata);
  return cloned is Map<String, dynamic> ? cloned : <String, dynamic>{};
}

/// Folds an event's metadata into the message it builds, last write winning.
Message _mergeEventMetadata(
    Message message, Map<String, dynamic>? eventMetadata) {
  if (eventMetadata == null) {
    return message;
  }
  return _rebuildMessage(
    message,
    metadata: _mergeMetadata(message.metadata, eventMetadata),
  );
}

ToolCall _mergeToolCallMetadata(
    ToolCall toolCall, Map<String, dynamic>? eventMetadata) {
  if (eventMetadata == null) {
    return toolCall;
  }
  return toolCall.copyWith(
      metadata: _mergeMetadata(toolCall.metadata, eventMetadata));
}

/// Rebuilds a message with the supplied fields replaced.
Message _rebuildMessage(
  Message message, {
  Object? content = _unset,
  Object? encryptedValue = _unset,
  Object? metadata = _unset,
  Object? subagentRunId = _unset,
}) {
  final nextContent = identical(content, _unset) ? message.content : content;
  final nextEncryptedValue = identical(encryptedValue, _unset)
      ? message.encryptedValue
      : encryptedValue as String?;
  final nextMetadata = identical(metadata, _unset)
      ? message.metadata
      : metadata as Map<String, dynamic>?;
  final nextSubagentRunId = identical(subagentRunId, _unset)
      ? message.subagentRunId
      : subagentRunId as String?;

  switch (message) {
    case DeveloperMessage():
      return DeveloperMessage(
        id: message.id,
        content: nextContent is String ? nextContent : message.content,
        name: message.name,
        encryptedValue: nextEncryptedValue,
        metadata: nextMetadata,
        subagentRunId: nextSubagentRunId,
      );
    case SystemMessage():
      return SystemMessage(
        id: message.id,
        content: nextContent is String ? nextContent : message.content,
        name: message.name,
        encryptedValue: nextEncryptedValue,
        metadata: nextMetadata,
        subagentRunId: nextSubagentRunId,
      );
    case AssistantMessage():
      return AssistantMessage(
        id: message.id,
        content: nextContent is String ? nextContent : null,
        name: message.name,
        encryptedValue: nextEncryptedValue,
        metadata: nextMetadata,
        subagentRunId: nextSubagentRunId,
        toolCalls: message.toolCalls,
      );
    case UserMessage():
      return UserMessage(
        id: message.id,
        content: nextContent ?? message.content,
        name: message.name,
        encryptedValue: nextEncryptedValue,
        metadata: nextMetadata,
        subagentRunId: nextSubagentRunId,
      );
    case ToolMessage():
      return ToolMessage(
        id: message.id,
        content: nextContent ?? message.content,
        toolCallId: message.toolCallId,
        error: message.error,
        encryptedValue: nextEncryptedValue,
        metadata: nextMetadata,
        subagentRunId: nextSubagentRunId,
      );
    case ActivityMessage():
      return ActivityMessage(
        id: message.id,
        activityType: message.activityType,
        content:
            nextContent is Map<String, dynamic> ? nextContent : message.content,
        metadata: nextMetadata,
        subagentRunId: nextSubagentRunId,
      );
    case ReasoningMessage():
      return ReasoningMessage(
        id: message.id,
        content: nextContent is String ? nextContent : message.content,
        encryptedValue: nextEncryptedValue,
        metadata: nextMetadata,
        subagentRunId: nextSubagentRunId,
      );
  }
}

String _activityCollision(String eventName, String messageId, String kind) {
  return '$eventName: Message "$messageId" is an activity message - '
      'message ids must be unique across activity and $kind messages';
}

// --- Tool-result placement ------------------------------------------------

class _CallSlot {
  final int issuer;
  bool answered = false;

  _CallSlot(this.issuer);
}

/// Moves tool results next to the assistant message that issued their call.
///
/// A snapshot can re-id the assistant message while keeping the result's call
/// id, or a provider can answer a call in a later turn; either way the list
/// reaches the backend as `tool` before `assistant(tool_call)`, which OpenAI
/// compatible providers reject. This is the Dart port of the reference
/// `keepToolResultsWithCalls`: it only moves results whose call slot can be
/// identified unambiguously, and returns the same list when nothing moves.
///
/// Slots are matched by call id alone; a parent call and a subagent call that
/// reuse one id are indistinguishable, so their drifted results can be
/// swapped — the same known limitation the reference implementation records.
List<Message> keepToolResultsWithCalls(List<Message> messages) {
  final slots = <String, List<_CallSlot>>{};
  final unanswered = <String, int>{};
  final detached = <String, List<int>>{};
  final early = <String, List<int>>{};

  void append<T>(Map<String, List<T>> map, String key, T value) {
    final list = map[key];
    if (list != null) {
      list.add(value);
    } else {
      map[key] = <T>[value];
    }
  }

  void answer(String id, _CallSlot slot) {
    slot.answered = true;
    unanswered[id] = (unanswered[id] ?? 0) - 1;
  }

  var anchor = -1;
  for (var index = 0; index < messages.length; index++) {
    final message = messages[index];
    if (message.role == MessageRole.tool) {
      final id = (message as ToolMessage).toolCallId;
      final idSlots = slots[id];
      if (idSlots == null) {
        append(early, id, index);
        continue;
      }
      _CallSlot? inPlace;
      for (var s = idSlots.length - 1;
          s >= 0 && idSlots[s].issuer == anchor;
          s--) {
        if (!idSlots[s].answered) inPlace = idSlots[s];
      }
      if (inPlace != null) {
        answer(id, inPlace);
        continue;
      }
      if ((unanswered[id] ?? 0) > 0) append(detached, id, index);
    } else if (message.role != MessageRole.activity &&
        message.role != MessageRole.reasoning) {
      anchor = index;
      for (final id in _issuedCallIds(message)) {
        append(slots, id, _CallSlot(index));
        unanswered[id] = (unanswered[id] ?? 0) + 1;
      }
    }
  }

  final owedTo = <int, List<int>>{};
  final moved = List<bool>.filled(messages.length, false);

  void move(String id, int index, _CallSlot slot) {
    answer(id, slot);
    final owed = owedTo[slot.issuer];
    if (owed != null) {
      owed.add(index);
    } else {
      owedTo[slot.issuer] = <int>[index];
    }
    moved[index] = true;
  }

  for (final entry in detached.entries) {
    final idSlots = slots[entry.key]!;
    var s = idSlots.length - 1;
    for (var r = entry.value.length - 1; r >= 0; r--) {
      final index = entry.value[r];
      while (s >= 0 && (idSlots[s].answered || idSlots[s].issuer >= index)) {
        s--;
      }
      if (s < 0) break;
      move(entry.key, index, idSlots[s]);
    }
  }

  for (final entry in early.entries) {
    final idSlots = slots[entry.key];
    if (idSlots == null || idSlots.length != 1 || idSlots[0].answered) {
      continue;
    }
    move(entry.key, entry.value.first, idSlots[0]);
  }

  if (owedTo.isEmpty) return messages;

  for (final owed in owedTo.values) {
    owed.sort();
  }

  final repaired = <Message>[];
  List<int>? pending;

  void flush() {
    final owed = pending;
    if (owed == null) return;
    var at = repaired.length;
    for (var tail = repaired.length - 1; tail >= 0; tail--) {
      final role = repaired[tail].role;
      if (role != MessageRole.activity && role != MessageRole.reasoning) {
        break;
      }
      if (role == MessageRole.reasoning) at = tail;
    }
    final tailEntries = repaired.sublist(at);
    repaired.removeRange(at, repaired.length);
    for (final index in owed) {
      repaired.add(messages[index]);
    }
    repaired.addAll(tailEntries);
    pending = null;
  }

  for (var index = 0; index < messages.length; index++) {
    if (moved[index]) continue;
    final message = messages[index];
    final role = message.role;
    final separates = role != MessageRole.tool &&
        role != MessageRole.activity &&
        role != MessageRole.reasoning;
    if (separates) flush();
    repaired.add(message);
    pending = owedTo[index] ?? pending;
  }
  flush();

  return repaired;
}
