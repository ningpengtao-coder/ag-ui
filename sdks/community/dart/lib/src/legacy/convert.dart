library;

import 'dart:async';
import 'dart:convert';

import '../apply/json_patch.dart';
import '../diagnostics.dart';
import '../events/events.dart';
import '../types/message.dart';
import '../types/tool.dart';

typedef LegacyRuntimeProtocolEvent = Map<String, dynamic>;

typedef LegacyEventTransformer = Stream<LegacyRuntimeProtocolEvent> Function(
  Stream<BaseEvent> events,
);

LegacyEventTransformer convertToLegacyEvents(
  String threadId,
  String runId,
  String agentName,
) {
  return (Stream<BaseEvent> events) async* {
    Object? currentState = <String, dynamic>{};
    var running = true;
    var active = true;
    var nodeName = '';
    List<Message>? syncedMessages;
    List<Map<String, dynamic>>? predictState;
    final currentToolCalls = <String, ToolCall>{};
    final toolCallNames = <String, String>{};

    await for (final event in events) {
      if (event is TextMessageStartEvent) {
        yield {
          'type': 'TextMessageStart',
          'messageId': event.messageId,
          'role': event.role.value,
        };
        continue;
      }

      if (event is TextMessageContentEvent) {
        yield {
          'type': 'TextMessageContent',
          'messageId': event.messageId,
          'content': event.delta,
        };
        continue;
      }

      if (event is TextMessageEndEvent) {
        yield {
          'type': 'TextMessageEnd',
          'messageId': event.messageId,
        };
        continue;
      }

      if (event is ToolCallStartEvent) {
        currentToolCalls[event.toolCallId] = ToolCall(
          id: event.toolCallId,
          type: 'function',
          function: FunctionCall(
            name: event.toolCallName,
            arguments: '',
          ),
        );
        active = true;
        toolCallNames[event.toolCallId] = event.toolCallName;
        yield {
          'type': 'ActionExecutionStart',
          'actionExecutionId': event.toolCallId,
          'actionName': event.toolCallName,
          if (event.parentMessageId != null) 'parentMessageId': event.parentMessageId,
        };
        continue;
      }

      if (event is ToolCallArgsEvent) {
        final currentToolCall = currentToolCalls[event.toolCallId];
        if (currentToolCall == null) {
          continue;
        }

        currentToolCalls[event.toolCallId] = currentToolCall.copyWith(
          function: currentToolCall.function.copyWith(
            arguments: currentToolCall.function.arguments + event.delta,
          ),
        );

        yield {
          'type': 'ActionExecutionArgs',
          'actionExecutionId': event.toolCallId,
          'args': event.delta,
        };

        final updatedState = _predictStateUpdate(
          currentState,
          currentToolCalls[event.toolCallId]!,
          predictState,
        );
        if (updatedState != null) {
          currentState = updatedState;
          yield _legacyStateMessage(
            threadId: threadId,
            agentName: agentName,
            nodeName: nodeName,
            runId: runId,
            running: running,
            active: active,
            state: currentState,
          );
        }
        continue;
      }

      if (event is ToolCallEndEvent) {
        yield {
          'type': 'ActionExecutionEnd',
          'actionExecutionId': event.toolCallId,
        };
        continue;
      }

      if (event is ToolCallResultEvent) {
        yield {
          'type': 'ActionExecutionResult',
          'actionExecutionId': event.toolCallId,
          'result': _flattenLegacyResult(event.toolCallId, event.content),
          'actionName': toolCallNames[event.toolCallId] ?? 'unknown',
        };
        continue;
      }

      if (event is RawEvent) {
        continue;
      }

      if (event is CustomEvent) {
        if (event.name == 'Exit') {
          running = false;
        }
        if (event.name == 'PredictState' && event.value is List) {
          predictState = (event.value as List)
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        }
        yield {
          'type': 'MetaEvent',
          'name': event.name,
          'value': event.value,
        };
        continue;
      }

      if (event is StateSnapshotEvent) {
        currentState = _sanitizeState(event.snapshot);
        yield _legacyStateMessage(
          threadId: threadId,
          agentName: agentName,
          nodeName: nodeName,
          runId: runId,
          running: running,
          active: active,
          state: currentState,
        );
        continue;
      }

      if (event is StateDeltaEvent) {
        Object? patched;
        try {
          patched = applyJsonPatch(currentState, event.delta);
        } on Object catch (error) {
          // One unappliable patch must not take the bridge down mid-run, so it
          // is warned about and skipped, matching the reducer in apply/.
          AgUiDiagnostics.warn('Failed to apply legacy state patch: $error');
          continue;
        }
        currentState = _sanitizeState(patched);
        yield _legacyStateMessage(
          threadId: threadId,
          agentName: agentName,
          nodeName: nodeName,
          runId: runId,
          running: running,
          active: active,
          state: currentState,
        );
        continue;
      }

      if (event is MessagesSnapshotEvent) {
        syncedMessages = event.messages;
        yield _legacyStateMessage(
          threadId: threadId,
          agentName: agentName,
          nodeName: nodeName,
          runId: runId,
          running: running,
          active: true,
          state: {
            ...?_asJsonObject(currentState),
            // The raw AG-UI messages, as the reference bridge sends them here;
            // the legacy-shaped ones go out with RUN_FINISHED instead. The two
            // shapes are not interchangeable, so they are reproduced as-is.
            'messages': event.messages
                .map((message) => message.toJson())
                .toList(),
          },
        );
        continue;
      }

      if (event is RunStartedEvent) {
        continue;
      }

      if (event is RunFinishedEvent) {
        List<Map<String, dynamic>>? legacyMessages;
        if (syncedMessages != null) {
          try {
            legacyMessages = convertMessagesToLegacyFormat(syncedMessages);
          } on Object catch (error) {
            // Surface the failure on the stream instead of tearing it down with
            // an opaque exception: a tool call whose arguments are not JSON is
            // the producer's defect, and the consumer still needs a terminal
            // event it can act on.
            yield {'type': 'RunError', 'message': error.toString()};
            continue;
          }
        }
        final finalState = <String, dynamic>{
          ...?_asJsonObject(currentState),
          if (legacyMessages != null) 'messages': legacyMessages,
        };
        if (finalState.isNotEmpty) {
          yield _legacyStateMessage(
            threadId: threadId,
            agentName: agentName,
            nodeName: nodeName,
            runId: runId,
            running: running,
            active: false,
            state: finalState,
          );
        }
        continue;
      }

      if (event is RunErrorEvent) {
        yield {
          'type': 'RunError',
          'message': event.message,
          if (event.code != null) 'code': event.code,
        };
        continue;
      }

      if (event is StepStartedEvent) {
        nodeName = event.stepName;
        currentToolCalls.clear();
        predictState = null;
        yield _legacyStateMessage(
          threadId: threadId,
          agentName: agentName,
          nodeName: nodeName,
          runId: runId,
          running: running,
          active: true,
          state: currentState,
        );
        continue;
      }

      if (event is StepFinishedEvent) {
        currentToolCalls.clear();
        predictState = null;
        yield _legacyStateMessage(
          threadId: threadId,
          agentName: agentName,
          nodeName: nodeName,
          runId: runId,
          running: running,
          active: false,
          state: currentState,
        );
      }
    }
  };
}

List<Map<String, dynamic>> convertMessagesToLegacyFormat(List<Message> messages) {
  final result = <Map<String, dynamic>>[];

  for (final message in messages) {
    if (message is AssistantMessage || message is UserMessage || message is SystemMessage) {
      final textContent = _flattenMessageContentToText(message.content);
      if (textContent != null && textContent.isNotEmpty) {
        result.add({
          'id': message.id,
          'role': message.role.value,
          'content': textContent,
        });
      }
      if (message is AssistantMessage && message.toolCalls != null) {
        for (final toolCall in message.toolCalls!) {
          result.add({
            'id': toolCall.id,
            'name': toolCall.function.name,
            'arguments': json.decode(toolCall.function.arguments),
            'parentMessageId': message.id,
          });
        }
      }
      continue;
    }

    if (message is ToolMessage) {
      var actionName = 'unknown';
      for (final candidate in messages.whereType<AssistantMessage>()) {
        final toolCall = candidate.toolCalls?.where((call) => call.id == message.toolCallId).firstOrNull;
        if (toolCall != null) {
          actionName = toolCall.function.name;
          break;
        }
      }
      result.add({
        'id': message.id,
        'result': message.content,
        'actionExecutionId': message.toolCallId,
        'actionName': actionName,
      });
    }
  }

  return result;
}

Map<String, dynamic> _legacyStateMessage({
  required String threadId,
  required String agentName,
  required String nodeName,
  required String runId,
  required bool running,
  required bool active,
  required Object? state,
}) {
  return {
    'type': 'AgentStateMessage',
    'threadId': threadId,
    'agentName': agentName,
    'nodeName': nodeName,
    'runId': runId,
    'running': running,
    'role': 'assistant',
    // Serialized as given: [currentState] was sanitized where it was assigned,
    // and the snapshot / finished branches carry `messages` they added on
    // purpose, which sanitizing here would strip back out.
    'state': json.encode(state),
    'active': active,
  };
}

/// The string a legacy `ActionExecutionResult` can hold, from content that may
/// be parts. Text parts are concatenated; anything else is dropped with a
/// warning naming the call, because the legacy consumer cannot receive it.
String _flattenLegacyResult(String toolCallId, Object content) {
  if (content is! List) {
    return content is String ? content : '';
  }

  final parts = content.whereType<InputContent>().toList();
  if (parts.any((part) => part is! TextInputContent)) {
    AgUiDiagnostics.warn(
      "The result of tool call '$toolCallId' carries content parts the legacy "
      'protocol cannot represent; only its text parts are bridged and the rest '
      'is dropped.',
    );
  }
  return parts.whereType<TextInputContent>().map((part) => part.text).join();
}

Object? _predictStateUpdate(
  Object? currentState,
  ToolCall toolCall,
  List<Map<String, dynamic>>? predictState,
) {
  if (predictState == null) {
    return null;
  }

  final rule = predictState.where((item) => item['tool'] == toolCall.function.name).firstOrNull;
  if (rule == null) {
    return null;
  }

  try {
    final currentArgs = _parsePossiblyTruncatedJson(toolCall.function.arguments);
    if (currentArgs is! Map<String, dynamic>) {
      return null;
    }

    final stateKey = rule['state_key'] as String?;
    if (stateKey == null) {
      return null;
    }

    final toolArgument = rule['tool_argument'] as String?;
    final nextState = <String, dynamic>{...?_asJsonObject(currentState)};
    if (toolArgument != null && currentArgs.containsKey(toolArgument)) {
      nextState[stateKey] = currentArgs[toolArgument];
      return nextState;
    }
    if (toolArgument == null) {
      nextState[stateKey] = currentArgs;
      return nextState;
    }
  } catch (_) {
    return null;
  }

  return null;
}

Object? _sanitizeState(Object? state) {
  if (state is Map<String, dynamic>) {
    final clone = Map<String, dynamic>.from(state);
    clone.remove('messages');
    return clone;
  }
  return <String, dynamic>{};
}

Map<String, dynamic>? _asJsonObject(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  return null;
}

String? _flattenMessageContentToText(Object? content) {
  if (content is String) {
    return content;
  }
  if (content is UserMessageContent) {
    if (content.textOrNull != null) {
      return content.textOrNull;
    }
    final parts = (content.partsOrNull ?? const <InputContent>[])
        .whereType<TextInputContent>()
        .map((part) => part.text)
        .where((text) => text.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return null;
    }
    return parts.join('\n');
  }
  if (content is! List) {
    return null;
  }

  final parts = content
      .whereType<TextInputContent>()
      .map((part) => part.text)
      .where((text) => text.isNotEmpty)
      .toList();
  if (parts.isEmpty) {
    return null;
  }
  return parts.join('\n');
}

Object? _parsePossiblyTruncatedJson(String value) {
  try {
    return json.decode(value);
  } catch (_) {
    final buffer = StringBuffer();
    var inString = false;
    var escaped = false;
    var braces = 0;
    var brackets = 0;

    for (final codeUnit in value.codeUnits) {
      final char = String.fromCharCode(codeUnit);
      buffer.write(char);

      if (escaped) {
        escaped = false;
        continue;
      }

      if (char == r'\') {
        escaped = true;
        continue;
      }

      if (char == '"') {
        inString = !inString;
        continue;
      }

      if (inString) {
        continue;
      }

      if (char == '{') braces++;
      if (char == '}') braces--;
      if (char == '[') brackets++;
      if (char == ']') brackets--;
    }

    var normalized = buffer.toString().trimRight();
    while (normalized.endsWith(':') || normalized.endsWith(',')) {
      normalized = normalized.substring(0, normalized.length - 1).trimRight();
    }
    if (inString) {
      normalized = '$normalized"';
    }
    normalized += ']' * brackets;
    normalized += '}' * braces;
    return json.decode(normalized);
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
