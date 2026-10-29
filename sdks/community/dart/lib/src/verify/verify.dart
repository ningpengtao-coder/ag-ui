library;

import 'dart:async';

import '../debug_logger.dart';
import '../events/events.dart';
import '../types/base.dart';
import '../types/message.dart';

/// Verifies a 1.0 event stream's streaming discipline.
///
/// This is the Dart port of the TypeScript `verifyEvents` operator. Every
/// violation is reported as an [AGUIError] on the returned stream, the
/// offending event is not forwarded, and the source subscription keeps
/// running (`cancelOnError: false`), so later events are still checked.
///
/// Chunk expansion (`TEXT_MESSAGE_CHUNK` / `TOOL_CALL_CHUNK`) is NOT done
/// here: the pipeline expands chunks upstream, so those events pass through.
Stream<BaseEvent> verifyEvents(Stream<BaseEvent> source,
    {Object? debugLogger}) {
  final controller = StreamController<BaseEvent>(sync: true);
  final verifier = _Verifier(resolveDebugLogger(debugLogger));

  source.listen(
    (event) {
      final error = verifier.check(event);
      if (error != null) {
        controller.addError(AGUIError(error));
        return;
      }
      controller.add(event);
    },
    onError: controller.addError,
    onDone: controller.close,
    cancelOnError: false,
  );

  return controller.stream;
}

/// The subagent an entity belongs to; a `null` id means the parent agent.
///
/// Ownership is tracked separately from the "is this entity open?" sets, and
/// is retained for the whole run: a tagged continuation can legitimately
/// arrive after its entity closed (e.g. `REASONING_ENCRYPTED_VALUE` with
/// subtype `tool-call` after `TOOL_CALL_END`).
class _Owner {
  const _Owner(this.subagentRunId);

  final String? subagentRunId;
}

class _Verifier {
  _Verifier(this.log);

  final DebugLogger? log;

  final Set<String> _activeMessages = <String>{};
  final Set<String> _activeToolCalls = <String>{};
  final Set<String> _activeReasoningSpans = <String>{};
  final Set<String> _activeReasoningMessages = <String>{};
  final Map<String, _Owner> _messageOwners = <String, _Owner>{};
  final Map<String, _Owner> _toolCallOwners = <String, _Owner>{};
  final Map<String, _Owner> _activityOwners = <String, _Owner>{};
  final Map<String, _Owner> _reasoningOwners = <String, _Owner>{};

  /// Owner (null = the parent agent) -> open step names.
  ///
  /// Nested rather than one joined key so that a parent (no owner) never
  /// collides with a subagent whose id is the empty string.
  final Map<String?, Map<String, bool>> _activeSteps =
      <String?, Map<String, bool>>{};
  final Map<String, bool> _activeSubagents = <String, bool>{};
  final Set<String> _closedSubagents = <String>{};

  bool _runStarted = false;
  bool _runFinished = false;
  bool _runError = false;
  bool _firstEventReceived = false;

  /// Returns the violation message for [event], or `null` when it is legal.
  ///
  /// State is only mutated for events that pass, so a rejected event leaves
  /// the machine exactly as it was.
  String? check(BaseEvent event) {
    final eventType = event.eventType;
    log?.event('VERIFY', 'Event:', event, {'type': event.type});

    // A run that errored is over rather than active — but a new RUN_STARTED
    // starts a new run, exactly as RUN_FINISHED does.
    if (_runError && eventType != EventType.runStarted) {
      return "Cannot send event type '${event.type}': The run has already errored with 'RUN_ERROR'. No further events can be sent.";
    }

    // A run that finished is over. RUN_ERROR after RUN_FINISHED is admitted (a
    // failure that surfaced after the run reported success), as is a new run.
    if (_runFinished &&
        eventType != EventType.runError &&
        eventType != EventType.runStarted) {
      return "Cannot send event type '${event.type}': The run has already finished with 'RUN_FINISHED'. Start a new run with 'RUN_STARTED'.";
    }

    if (!_firstEventReceived) {
      _firstEventReceived = true;
      // A stream may open with RUN_ERROR: a run can fail before it begins.
      if (eventType != EventType.runStarted &&
          eventType != EventType.runError) {
        return "First event must be 'RUN_STARTED'";
      }
    } else if (eventType == EventType.runStarted) {
      if (_runStarted && !_runFinished && !_runError) {
        return "Cannot send 'RUN_STARTED' while a run is still active. The previous run must be finished with 'RUN_FINISHED' before starting a new run.";
      }
      if (_runFinished || _runError) {
        _resetRunState();
      }
    }

    return _validate(event);
  }

  void _resetRunState() {
    _activeMessages.clear();
    _activeToolCalls.clear();
    _activeReasoningSpans.clear();
    _activeReasoningMessages.clear();
    _messageOwners.clear();
    _toolCallOwners.clear();
    _activityOwners.clear();
    _reasoningOwners.clear();
    _activeSteps.clear();
    _activeSubagents.clear();
    _closedSubagents.clear();
    _runFinished = false;
    _runError = false;
    _runStarted = true;
  }

  Map<String, bool> _stepsFor(String? owner) {
    return _activeSteps.putIfAbsent(owner, () => <String, bool>{});
  }

  bool get _anyStepsActive {
    for (final names in _activeSteps.values) {
      if (names.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  /// A continuation/close must not disagree with the subagent that owns its
  /// entity. An absent tag is always allowed: attribution may be used without
  /// the `SUBAGENT_*` lifecycle, so an unannounced id is not required to be
  /// active here — only to agree.
  String? _subagentTagError(
    EventType eventType,
    String? eventSubagentRunId,
    _Owner? owner,
    String entityKind,
    String entityId,
  ) {
    if (eventSubagentRunId == null) {
      return null;
    }
    if (owner != null && owner.subagentRunId != eventSubagentRunId) {
      return "Cannot send '${eventType.value}': subagentRunId '$eventSubagentRunId' does not match the $entityKind '$entityId' opener's subagent '${owner.subagentRunId ?? '(the parent agent)'}'.";
    }
    return null;
  }

  /// Records ownership for messages replayed by MESSAGES_SNAPSHOT and by the
  /// RUN_STARTED input echo, including each assistant message's tool calls.
  ///
  /// `authoritative` distinguishes the two sources: a snapshot restates the
  /// conversation and replaces each message, so its owner replaces the
  /// recorded one; the input echo is plain history and only seeds ids nothing
  /// else has claimed.
  void _seedOwnersFromMessages(
    List<Message> messages, {
    required bool authoritative,
  }) {
    for (final message in messages) {
      final bucket = switch (message.role) {
        MessageRole.reasoning => _reasoningOwners,
        MessageRole.activity => _activityOwners,
        _ => _messageOwners,
      };
      if (authoritative || !bucket.containsKey(message.id)) {
        bucket[message.id] = _Owner(message.subagentRunId);
      }
      if (message is AssistantMessage) {
        final toolCalls = message.toolCalls;
        if (toolCalls == null) {
          continue;
        }
        for (final toolCall in toolCalls) {
          if (authoritative || !_toolCallOwners.containsKey(toolCall.id)) {
            _toolCallOwners[toolCall.id] = _Owner(message.subagentRunId);
          }
        }
      }
    }
  }

  String? _validate(BaseEvent event) {
    switch (event.eventType) {
      case EventType.textMessageStart:
        return _onTextMessageStart(event as TextMessageStartEvent);
      case EventType.textMessageContent:
        return _onTextMessageContent(event as TextMessageContentEvent);
      case EventType.textMessageEnd:
        return _onTextMessageEnd(event as TextMessageEndEvent);
      case EventType.toolCallStart:
        return _onToolCallStart(event as ToolCallStartEvent);
      case EventType.toolCallArgs:
        return _onToolCallArgs(event as ToolCallArgsEvent);
      case EventType.toolCallEnd:
        return _onToolCallEnd(event as ToolCallEndEvent);
      case EventType.toolCallResult:
        final typed = event as ToolCallResultEvent;
        _messageOwners[typed.messageId] = _Owner(typed.subagentRunId);
        return null;
      case EventType.stepStarted:
        return _onStepStarted(event as StepStartedEvent);
      case EventType.stepFinished:
        return _onStepFinished(event as StepFinishedEvent);
      case EventType.reasoningStart:
        final typed = event as ReasoningStartEvent;
        return _openReasoning(
          isSpan: true,
          eventType: typed.eventType,
          messageId: typed.messageId,
          subagentRunId: typed.subagentRunId,
        );
      case EventType.reasoningMessageStart:
        final typed = event as ReasoningMessageStartEvent;
        final roleError = _reasoningRoleError(typed);
        if (roleError != null) {
          return roleError;
        }
        return _openReasoning(
          isSpan: false,
          eventType: typed.eventType,
          messageId: typed.messageId,
          subagentRunId: typed.subagentRunId,
        );
      case EventType.reasoningMessageContent:
        final typed = event as ReasoningMessageContentEvent;
        return _continueReasoning(
          isSpan: false,
          eventType: typed.eventType,
          messageId: typed.messageId,
          subagentRunId: typed.subagentRunId,
        );
      case EventType.reasoningMessageEnd:
        final typed = event as ReasoningMessageEndEvent;
        return _continueReasoning(
          isSpan: false,
          eventType: typed.eventType,
          messageId: typed.messageId,
          subagentRunId: typed.subagentRunId,
        );
      case EventType.reasoningEnd:
        final typed = event as ReasoningEndEvent;
        return _continueReasoning(
          isSpan: true,
          eventType: typed.eventType,
          messageId: typed.messageId,
          subagentRunId: typed.subagentRunId,
        );
      case EventType.reasoningEncryptedValue:
        return _onReasoningEncryptedValue(
          event as ReasoningEncryptedValueEvent,
        );
      case EventType.activitySnapshot:
        final typed = event as ActivitySnapshotEvent;
        final isNew = !_activityOwners.containsKey(typed.messageId);
        if (isNew || typed.replace) {
          _activityOwners[typed.messageId] = _Owner(typed.subagentRunId);
        }
        return null;
      case EventType.activityDelta:
        final typed = event as ActivityDeltaEvent;
        return _subagentTagError(
          typed.eventType,
          typed.subagentRunId,
          _activityOwners[typed.messageId],
          'activity',
          typed.messageId,
        );
      case EventType.subagentStarted:
        return _onSubagentStarted(event as SubagentStartedEvent);
      case EventType.subagentFinished:
        return _closeSubagent(
          (event as SubagentFinishedEvent).eventType,
          event.subagentRunId,
          null,
        );
      case EventType.subagentError:
        final typed = event as SubagentErrorEvent;
        return _closeSubagent(
          typed.eventType,
          typed.subagentRunId,
          typed.message,
        );
      case EventType.messagesSnapshot:
        _seedOwnersFromMessages(
          (event as MessagesSnapshotEvent).messages,
          authoritative: true,
        );
        return null;
      case EventType.runStarted:
        _runStarted = true;
        final input = (event as RunStartedEvent).input;
        if (input != null) {
          _seedOwnersFromMessages(input.messages, authoritative: false);
        }
        return null;
      case EventType.runFinished:
        return _onRunFinished();
      case EventType.runError:
        // RUN_ERROR can happen at any time; it ends the run.
        _runError = true;
        return null;
      default:
        // STATE_SNAPSHOT / STATE_DELTA carry provenance-only attribution and
        // are not ownership-checked; RAW / CUSTOM / unknown events pass
        // through untouched (enforcement handles what it does not know).
        return null;
    }
  }

  String? _onTextMessageStart(TextMessageStartEvent event) {
    final messageId = event.messageId;
    if (_activeMessages.contains(messageId)) {
      return "Cannot send 'TEXT_MESSAGE_START' event: A text message with ID '$messageId' is already in progress. Complete it with 'TEXT_MESSAGE_END' first.";
    }

    // First writer wins: the retained owner still names whoever opened this
    // id, and a different producer reopening it would have its content
    // appended into the first producer's message.
    final existingOwner = _messageOwners[messageId];
    if (existingOwner != null) {
      final tagError = _subagentTagError(
        event.eventType,
        event.subagentRunId,
        existingOwner,
        'message',
        messageId,
      );
      if (tagError != null) {
        return tagError;
      }
    }

    _activeMessages.add(messageId);
    if (existingOwner == null) {
      _messageOwners[messageId] = _Owner(event.subagentRunId);
    }
    return null;
  }

  String? _onTextMessageContent(TextMessageContentEvent event) {
    final messageId = event.messageId;
    if (!_activeMessages.contains(messageId)) {
      return "Cannot send 'TEXT_MESSAGE_CONTENT' event: No active text message found with ID '$messageId'. Start a text message with 'TEXT_MESSAGE_START' first.";
    }
    return _subagentTagError(
      event.eventType,
      event.subagentRunId,
      _messageOwners[messageId],
      'message',
      messageId,
    );
  }

  String? _onTextMessageEnd(TextMessageEndEvent event) {
    final messageId = event.messageId;
    if (!_activeMessages.contains(messageId)) {
      return "Cannot send 'TEXT_MESSAGE_END' event: No active text message found with ID '$messageId'. A 'TEXT_MESSAGE_START' event must be sent first.";
    }
    final tagError = _subagentTagError(
      event.eventType,
      event.subagentRunId,
      _messageOwners[messageId],
      'message',
      messageId,
    );
    if (tagError != null) {
      return tagError;
    }
    _activeMessages.remove(messageId);
    return null;
  }

  String? _onToolCallStart(ToolCallStartEvent event) {
    final toolCallId = event.toolCallId;
    if (_activeToolCalls.contains(toolCallId)) {
      return "Cannot send 'TOOL_CALL_START' event: A tool call with ID '$toolCallId' is already in progress. Complete it with 'TOOL_CALL_END' first.";
    }

    // A tool call lives inside the assistant message `parentMessageId` names,
    // and a ToolCall carries no attribution of its own — so a tag that
    // disagrees with that message's owner cannot be represented.
    final parentMessageId = event.parentMessageId;
    final eventTag = event.subagentRunId;
    _Owner? inheritedOwner;
    if (parentMessageId != null) {
      final parentOwner = _messageOwners[parentMessageId];
      if (parentOwner != null) {
        if (eventTag != null && eventTag != parentOwner.subagentRunId) {
          return "Cannot send 'TOOL_CALL_START': subagentRunId '$eventTag' does not match its parent message '$parentMessageId' owner '${parentOwner.subagentRunId ?? '(the parent agent)'}'. A tool call belongs to the message that carries it.";
        }
        inheritedOwner = parentOwner;
      }
    }

    final existingOwner = _toolCallOwners[toolCallId];
    if (existingOwner != null) {
      final tagError = _subagentTagError(
        event.eventType,
        eventTag,
        existingOwner,
        'tool call',
        toolCallId,
      );
      if (tagError != null) {
        return tagError;
      }
      // An untagged reopen's effective owner is the one it inherits from its
      // parent message, so comparing only the (absent) raw tag would let a
      // reopen under a different parent through.
      if (eventTag == null &&
          inheritedOwner != null &&
          inheritedOwner.subagentRunId != existingOwner.subagentRunId) {
        return "Cannot send 'TOOL_CALL_START': tool call '$toolCallId' is owned by '${existingOwner.subagentRunId ?? '(the parent agent)'}' but its parent message '$parentMessageId' is owned by '${inheritedOwner.subagentRunId ?? '(the parent agent)'}'. A tool call belongs to the message that carries it.";
      }
    }

    _activeToolCalls.add(toolCallId);
    if (existingOwner == null) {
      _toolCallOwners[toolCallId] = eventTag != null
          ? _Owner(eventTag)
          : (inheritedOwner ?? const _Owner(null));
    }
    return null;
  }

  String? _onToolCallArgs(ToolCallArgsEvent event) {
    final toolCallId = event.toolCallId;
    if (!_activeToolCalls.contains(toolCallId)) {
      return "Cannot send 'TOOL_CALL_ARGS' event: No active tool call found with ID '$toolCallId'. Start a tool call with 'TOOL_CALL_START' first.";
    }
    return _subagentTagError(
      event.eventType,
      event.subagentRunId,
      _toolCallOwners[toolCallId],
      'tool call',
      toolCallId,
    );
  }

  String? _onToolCallEnd(ToolCallEndEvent event) {
    final toolCallId = event.toolCallId;
    if (!_activeToolCalls.contains(toolCallId)) {
      return "Cannot send 'TOOL_CALL_END' event: No active tool call found with ID '$toolCallId'. A 'TOOL_CALL_START' event must be sent first.";
    }
    final tagError = _subagentTagError(
      event.eventType,
      event.subagentRunId,
      _toolCallOwners[toolCallId],
      'tool call',
      toolCallId,
    );
    if (tagError != null) {
      return tagError;
    }
    _activeToolCalls.remove(toolCallId);
    return null;
  }

  String? _onStepStarted(StepStartedEvent event) {
    final stepName = event.stepName;
    final stepOwner = event.subagentRunId;
    final steps = _stepsFor(stepOwner);
    if (steps.containsKey(stepName)) {
      final ownerSuffix = stepOwner != null ? " in subagent '$stepOwner'" : '';
      return 'Step "$stepName" is already active for \'STEP_STARTED\'$ownerSuffix';
    }
    steps[stepName] = true;
    return null;
  }

  String? _onStepFinished(StepFinishedEvent event) {
    final stepName = event.stepName;
    final stepOwner = event.subagentRunId;
    final steps = _stepsFor(stepOwner);
    if (!steps.containsKey(stepName)) {
      // A step with this name may be open under a DIFFERENT owner. Reported
      // separately because it is a distinct and more likely mistake than a
      // step that was never started.
      String? otherOwner;
      var foundOther = false;
      for (final entry in _activeSteps.entries) {
        if (entry.key != stepOwner && entry.value.containsKey(stepName)) {
          otherOwner = entry.key;
          foundOther = true;
          break;
        }
      }
      if (foundOther) {
        final attributed =
            stepOwner != null ? "subagent '$stepOwner'" : 'the parent agent';
        final holder =
            otherOwner != null ? "subagent '$otherOwner'" : 'the parent agent';
        return 'Cannot send \'STEP_FINISHED\' for step "$stepName" attributed to $attributed: that step is open under $holder. A step must be finished by whoever started it.';
      }
      return 'Cannot send \'STEP_FINISHED\' for step "$stepName" that was not started';
    }
    steps.remove(stepName);
    return null;
  }

  /// `REASONING_MESSAGE_START`'s role is pinned by the schema to the fixed
  /// value `reasoning`; any other value is a malformed known value.
  ///
  /// The quoted literal is spelled the way the reference implementation's
  /// validator renders it — JSON-escaped, backslashes included — because the
  /// shared conformance corpus matches that exact text.
  String? _reasoningRoleError(ReasoningMessageStartEvent event) {
    if (event.role != 'reasoning') {
      return 'Cannot send \'REASONING_MESSAGE_START\' with role '
          '\'${event.role}\', expected \\"reasoning\\".';
    }
    return null;
  }

  /// Opens a reasoning SPAN ([isSpan]) or reasoning MESSAGE.
  String? _openReasoning({
    required bool isSpan,
    required EventType eventType,
    required String messageId,
    required String? subagentRunId,
  }) {
    // Checked against the opener's OWN set: a span and the message inside it
    // may share an id, so one shared set would reject the canonical shape.
    final open = isSpan ? _activeReasoningSpans : _activeReasoningMessages;
    if (open.contains(messageId)) {
      return isSpan
          ? "Cannot send 'REASONING_START' event: A reasoning span with ID '$messageId' is already in progress. Complete it with 'REASONING_END' first."
          : "Cannot send 'REASONING_MESSAGE_START' event: A reasoning message with ID '$messageId' is already in progress. Complete it with 'REASONING_MESSAGE_END' first.";
    }

    // First writer records the owner; the owner outlives the close, so an
    // untagged reopen after REASONING_END cannot hand it back to the parent.
    final existingOwner = _reasoningOwners[messageId];
    if (existingOwner != null) {
      final tagError = _subagentTagError(
        eventType,
        subagentRunId,
        existingOwner,
        'reasoning message',
        messageId,
      );
      if (tagError != null) {
        return tagError;
      }
    }

    open.add(messageId);
    if (existingOwner == null) {
      _reasoningOwners[messageId] = _Owner(subagentRunId);
    }
    return null;
  }

  /// Continues or closes a reasoning MESSAGE (content/end) or SPAN (end).
  String? _continueReasoning({
    required bool isSpan,
    required EventType eventType,
    required String messageId,
    required String? subagentRunId,
  }) {
    final open = isSpan ? _activeReasoningSpans : _activeReasoningMessages;
    if (!open.contains(messageId)) {
      return isSpan
          ? "Cannot send 'REASONING_END' event: No active reasoning span found with ID '$messageId'. A 'REASONING_START' event must be sent first."
          : "Cannot send '${eventType.value}' event: No active reasoning message found with ID '$messageId'. Start a reasoning message with 'REASONING_MESSAGE_START' first.";
    }

    final tagError = _subagentTagError(
      eventType,
      subagentRunId,
      _reasoningOwners[messageId],
      'reasoning message',
      messageId,
    );
    if (tagError != null) {
      return tagError;
    }

    // Each terminal closes only its own entity; the owner stays on record.
    if (isSpan || eventType == EventType.reasoningMessageEnd) {
      open.remove(messageId);
    }
    return null;
  }

  String? _onReasoningEncryptedValue(ReasoningEncryptedValueEvent event) {
    // `subtype` says which kind of entity this continues: a `tool-call`
    // encrypted value belongs to a TOOL CALL, a `message` one to a text or
    // reasoning message (at most one of the two buckets holds this id).
    final entityId = event.entityId;
    final isToolCall = event.subtype == ReasoningEncryptedValueSubtype.toolCall;
    final owner = isToolCall
        ? _toolCallOwners[entityId]
        : (_messageOwners[entityId] ?? _reasoningOwners[entityId]);
    return _subagentTagError(
      event.eventType,
      event.subagentRunId,
      owner,
      isToolCall ? 'tool call' : 'message',
      entityId,
    );
  }

  String? _onSubagentStarted(SubagentStartedEvent event) {
    final subagentRunId = event.subagentRunId;
    if (subagentRunId == null) {
      return "Cannot send 'SUBAGENT_STARTED' without a 'subagentRunId'.";
    }
    // `name` is required by the schema and is this invocation's identity; the
    // typed model makes absence unrepresentable, so an empty name is the only
    // shape that can still reach the verifier.
    if (event.name.isEmpty) {
      return "Cannot send 'SUBAGENT_STARTED' without a 'name'.";
    }

    final parentSubagentRunId = event.parentSubagentRunId;
    if (_activeSubagents.containsKey(subagentRunId)) {
      return "Cannot send 'SUBAGENT_STARTED': subagent '$subagentRunId' is already active. Finish it with 'SUBAGENT_FINISHED' first.";
    }
    // Ids are per-invocation: reopening a closed id would give one invocation
    // two starts and two terminals.
    if (_closedSubagents.contains(subagentRunId)) {
      return "Cannot send 'SUBAGENT_STARTED': subagent '$subagentRunId' has already finished in this run. Subagent IDs are per-invocation and cannot be reused.";
    }
    if (parentSubagentRunId != null &&
        !_activeSubagents.containsKey(parentSubagentRunId) &&
        !_closedSubagents.contains(parentSubagentRunId)) {
      return "Cannot send 'SUBAGENT_STARTED': parentSubagentRunId '$parentSubagentRunId' has not been started in this run.";
    }

    _activeSubagents[subagentRunId] = true;
    return null;
  }

  String? _closeSubagent(
    EventType eventType,
    String? subagentRunId,
    String? message,
  ) {
    if (subagentRunId == null) {
      return "Cannot send '${eventType.value}' without a 'subagentRunId'.";
    }
    if (eventType == EventType.subagentError &&
        (message == null || message.isEmpty)) {
      return "Cannot send 'SUBAGENT_ERROR' without a 'message'.";
    }
    if (!_activeSubagents.containsKey(subagentRunId)) {
      return "Cannot send '${eventType.value}': no active subagent found with ID '$subagentRunId'. A 'SUBAGENT_STARTED' event must be sent first.";
    }
    _activeSubagents.remove(subagentRunId);
    _closedSubagents.add(subagentRunId);
    return null;
  }

  String? _onRunFinished() {
    if (_anyStepsActive) {
      final parts = <String>[];
      for (final entry in _activeSteps.entries) {
        for (final name in entry.value.keys) {
          final owner = entry.key;
          parts.add(owner != null ? "$name (subagent '$owner')" : name);
        }
      }
      return "Cannot send 'RUN_FINISHED' while steps are still active: ${parts.join(', ')}";
    }

    if (_activeMessages.isNotEmpty) {
      return "Cannot send 'RUN_FINISHED' while text messages are still active: ${_activeMessages.join(', ')}";
    }

    if (_activeReasoningMessages.isNotEmpty) {
      return "Cannot send 'RUN_FINISHED' while reasoning messages are still active: ${_activeReasoningMessages.join(', ')}";
    }

    if (_activeReasoningSpans.isNotEmpty) {
      return "Cannot send 'RUN_FINISHED' while reasoning spans are still active: ${_activeReasoningSpans.join(', ')}";
    }

    if (_activeToolCalls.isNotEmpty) {
      return "Cannot send 'RUN_FINISHED' while tool calls are still active: ${_activeToolCalls.join(', ')}";
    }

    if (_activeSubagents.isNotEmpty) {
      return "Cannot send 'RUN_FINISHED' while subagents are still active: ${_activeSubagents.keys.join(', ')}";
    }

    _runFinished = true;
    return null;
  }
}
