library;

import 'dart:async';

import '../debug_logger.dart';
import '../events/events.dart';
import '../types/base.dart';

Stream<BaseEvent> verifyEvents(Stream<BaseEvent> source, {Object? debugLogger}) {
  final controller = StreamController<BaseEvent>(sync: true);
  final log = resolveDebugLogger(debugLogger);

  final activeMessages = <String>{};
  final activeToolCalls = <String>{};
  final activeSteps = <String>{};
  var firstEventReceived = false;
  var runStarted = false;
  var runFinished = false;
  var runErrored = false;
  var activeThinking = false;
  var activeThinkingMessage = false;

  void addError(String message) {
    controller.addError(AGUIError(message));
  }

  void resetRunState() {
    activeMessages.clear();
    activeToolCalls.clear();
    activeSteps.clear();
    activeThinking = false;
    activeThinkingMessage = false;
    runFinished = false;
    runErrored = false;
    runStarted = true;
  }

  source.listen(
    (event) {
      final type = event.eventType;
      log?.event('VERIFY', 'Event:', event, {'type': event.type});

      if (runErrored) {
        addError(
          "Cannot send event type '${type.value}': The run has already errored with 'RUN_ERROR'. No further events can be sent.",
        );
        return;
      }

      if (runFinished && type != EventType.runStarted && type != EventType.runError) {
        addError(
          "Cannot send event type '${type.value}': The run has already finished with 'RUN_FINISHED'. Start a new run with 'RUN_STARTED'.",
        );
        return;
      }

      if (!firstEventReceived) {
        firstEventReceived = true;
        if (type != EventType.runStarted && type != EventType.runError) {
          addError("First event must be 'RUN_STARTED'");
          return;
        }
      } else if (type == EventType.runStarted) {
        if (runStarted && !runFinished) {
          addError(
            "Cannot send 'RUN_STARTED' while a run is still active. The previous run must be finished with 'RUN_FINISHED' before starting a new run.",
          );
          return;
        }
        if (runFinished) {
          resetRunState();
        }
      }

      switch (type) {
        case EventType.textMessageStart:
          final id = (event as TextMessageStartEvent).messageId;
          if (activeMessages.contains(id)) {
            addError(
              "Cannot send 'TEXT_MESSAGE_START' event: A text message with ID '$id' is already in progress. Complete it with 'TEXT_MESSAGE_END' first.",
            );
            return;
          }
          activeMessages.add(id);
        case EventType.textMessageContent:
          final id = (event as TextMessageContentEvent).messageId;
          if (!activeMessages.contains(id)) {
            addError(
              "Cannot send 'TEXT_MESSAGE_CONTENT' event: No active text message found with ID '$id'. Start a text message with 'TEXT_MESSAGE_START' first.",
            );
            return;
          }
        case EventType.textMessageEnd:
          final id = (event as TextMessageEndEvent).messageId;
          if (!activeMessages.remove(id)) {
            addError(
              "Cannot send 'TEXT_MESSAGE_END' event: No active text message found with ID '$id'. A 'TEXT_MESSAGE_START' event must be sent first.",
            );
            return;
          }
        case EventType.toolCallStart:
          final id = (event as ToolCallStartEvent).toolCallId;
          if (activeToolCalls.contains(id)) {
            addError(
              "Cannot send 'TOOL_CALL_START' event: A tool call with ID '$id' is already in progress. Complete it with 'TOOL_CALL_END' first.",
            );
            return;
          }
          activeToolCalls.add(id);
        case EventType.toolCallArgs:
          final id = (event as ToolCallArgsEvent).toolCallId;
          if (!activeToolCalls.contains(id)) {
            addError(
              "Cannot send 'TOOL_CALL_ARGS' event: No active tool call found with ID '$id'. Start a tool call with 'TOOL_CALL_START' first.",
            );
            return;
          }
        case EventType.toolCallEnd:
          final id = (event as ToolCallEndEvent).toolCallId;
          if (!activeToolCalls.remove(id)) {
            addError(
              "Cannot send 'TOOL_CALL_END' event: No active tool call found with ID '$id'. A 'TOOL_CALL_START' event must be sent first.",
            );
            return;
          }
        case EventType.stepStarted:
          final stepName = (event as StepStartedEvent).stepName;
          if (activeSteps.contains(stepName)) {
            addError('Step "$stepName" is already active for \'STEP_STARTED\'');
            return;
          }
          activeSteps.add(stepName);
        case EventType.stepFinished:
          final stepName = (event as StepFinishedEvent).stepName;
          if (!activeSteps.remove(stepName)) {
            addError(
              "Cannot send 'STEP_FINISHED' for step \"$stepName\" that was not started",
            );
            return;
          }
        case EventType.runStarted:
          runStarted = true;
        case EventType.runFinished:
          if (activeSteps.isNotEmpty) {
            addError(
              "Cannot send 'RUN_FINISHED' while steps are still active: ${activeSteps.join(', ')}",
            );
            return;
          }
          if (activeMessages.isNotEmpty) {
            addError(
              "Cannot send 'RUN_FINISHED' while text messages are still active: ${activeMessages.join(', ')}",
            );
            return;
          }
          if (activeToolCalls.isNotEmpty) {
            addError(
              "Cannot send 'RUN_FINISHED' while tool calls are still active: ${activeToolCalls.join(', ')}",
            );
            return;
          }
          runFinished = true;
        case EventType.runError:
          runErrored = true;
        case EventType.thinkingStart:
          if (activeThinking) {
            addError(
              "Cannot send 'THINKING_START' event: A thinking step is already in progress. End it with 'THINKING_END' first.",
            );
            return;
          }
          activeThinking = true;
        case EventType.thinkingEnd:
          if (!activeThinking) {
            addError(
              "Cannot send 'THINKING_END' event: No active thinking step found. A 'THINKING_START' event must be sent first.",
            );
            return;
          }
          activeThinking = false;
        case EventType.thinkingTextMessageStart:
          if (!activeThinking) {
            addError(
              "Cannot send 'THINKING_TEXT_MESSAGE_START' event: A thinking step is not in progress. Create one with 'THINKING_START' first.",
            );
            return;
          }
          if (activeThinkingMessage) {
            addError(
              "Cannot send 'THINKING_TEXT_MESSAGE_START' event: A thinking message is already in progress. Complete it with 'THINKING_TEXT_MESSAGE_END' first.",
            );
            return;
          }
          activeThinkingMessage = true;
        case EventType.thinkingTextMessageContent:
          if (!activeThinkingMessage) {
            addError(
              "Cannot send 'THINKING_TEXT_MESSAGE_CONTENT' event: No active thinking message found. Start a message with 'THINKING_TEXT_MESSAGE_START' first.",
            );
            return;
          }
        case EventType.thinkingTextMessageEnd:
          if (!activeThinkingMessage) {
            addError(
              "Cannot send 'THINKING_TEXT_MESSAGE_END' event: No active thinking message found. A 'THINKING_TEXT_MESSAGE_START' event must be sent first.",
            );
            return;
          }
          activeThinkingMessage = false;
        case EventType.reasoningStart:
        case EventType.reasoningMessageStart:
        case EventType.reasoningMessageContent:
        case EventType.reasoningMessageEnd:
        case EventType.reasoningMessageChunk:
        case EventType.reasoningEnd:
        case EventType.reasoningEncryptedValue:
        case EventType.textMessageChunk:
        case EventType.toolCallChunk:
        case EventType.toolCallResult:
        case EventType.stateSnapshot:
        case EventType.stateDelta:
        case EventType.messagesSnapshot:
        case EventType.activitySnapshot:
        case EventType.activityDelta:
        case EventType.raw:
        case EventType.custom:
        case EventType.thinkingContent:
          break;
      }

      controller.add(event);
    },
    onError: controller.addError,
    onDone: controller.close,
    cancelOnError: false,
  );

  return controller.stream;
}
