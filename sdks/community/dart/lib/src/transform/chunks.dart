library;

import 'dart:async';

import '../debug_logger.dart';
import '../events/events.dart';

Stream<BaseEvent> transformChunks(Stream<BaseEvent> events, {Object? debugLogger}) {
  final controller = StreamController<BaseEvent>(sync: true);
  final log = resolveDebugLogger(debugLogger);

  String? textMessageId;
  TextMessageRole? textMessageRole;
  String? textMessageName;

  String? toolCallId;
  String? toolCallName;
  String? toolCallParentMessageId;

  String? reasoningMessageId;

  void emit(BaseEvent event) {
    log?.event('TRANSFORM', event.type, event, {'type': event.type});
    controller.add(event);
  }

  void closePending() {
    if (textMessageId != null) {
      emit(TextMessageEndEvent(messageId: textMessageId!));
      textMessageId = null;
      textMessageRole = null;
      textMessageName = null;
    }
    if (toolCallId != null) {
      emit(ToolCallEndEvent(toolCallId: toolCallId!));
      toolCallId = null;
      toolCallName = null;
      toolCallParentMessageId = null;
    }
    if (reasoningMessageId != null) {
      emit(ReasoningMessageEndEvent(messageId: reasoningMessageId!));
      reasoningMessageId = null;
    }
  }

  events.listen(
    (event) {
      switch (event.eventType) {
        case EventType.textMessageChunk:
          final chunk = event as TextMessageChunkEvent;
          if (textMessageId == null || (chunk.messageId != null && chunk.messageId != textMessageId)) {
            closePending();
            if (chunk.messageId == null) {
              controller.addError(StateError('First TEXT_MESSAGE_CHUNK must have a messageId'));
              return;
            }
            textMessageId = chunk.messageId;
            textMessageRole = chunk.role ?? TextMessageRole.assistant;
            textMessageName = chunk.name;
            emit(
              TextMessageStartEvent(
                messageId: textMessageId!,
                role: textMessageRole!,
                name: textMessageName,
              ),
            );
          }
          if (chunk.delta != null) {
            emit(TextMessageContentEvent(messageId: textMessageId!, delta: chunk.delta!));
          }
          return;
        case EventType.toolCallChunk:
          final chunk = event as ToolCallChunkEvent;
          if (toolCallId == null || (chunk.toolCallId != null && chunk.toolCallId != toolCallId)) {
            closePending();
            if (chunk.toolCallId == null || chunk.toolCallName == null) {
              controller.addError(
                StateError('First TOOL_CALL_CHUNK must have both toolCallId and toolCallName'),
              );
              return;
            }
            toolCallId = chunk.toolCallId;
            toolCallName = chunk.toolCallName;
            toolCallParentMessageId = chunk.parentMessageId;
            emit(
              ToolCallStartEvent(
                toolCallId: toolCallId!,
                toolCallName: toolCallName!,
                parentMessageId: toolCallParentMessageId,
              ),
            );
          }
          if (chunk.delta != null) {
            emit(ToolCallArgsEvent(toolCallId: toolCallId!, delta: chunk.delta!));
          }
          return;
        case EventType.reasoningMessageChunk:
          final chunk = event as ReasoningMessageChunkEvent;
          if (reasoningMessageId == null ||
              (chunk.messageId != null && chunk.messageId != reasoningMessageId)) {
            closePending();
            if (chunk.messageId == null) {
              controller.addError(
                StateError('First REASONING_MESSAGE_CHUNK must have a messageId'),
              );
              return;
            }
            reasoningMessageId = chunk.messageId;
            emit(ReasoningMessageStartEvent(messageId: reasoningMessageId!));
          }
          if (chunk.delta != null) {
            emit(
              ReasoningMessageContentEvent(
                messageId: reasoningMessageId!,
                delta: chunk.delta!,
              ),
            );
          }
          return;
        case EventType.raw:
        case EventType.activitySnapshot:
        case EventType.activityDelta:
        case EventType.reasoningEncryptedValue:
          emit(event);
          return;
        default:
          closePending();
          emit(event);
      }
    },
    onError: controller.addError,
    onDone: () {
      closePending();
      controller.close();
    },
    cancelOnError: false,
  );

  return controller.stream;
}
