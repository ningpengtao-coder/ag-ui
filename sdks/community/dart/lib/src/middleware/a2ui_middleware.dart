library;

import 'dart:convert';

import '../a2ui/index.dart';
import '../agent/agent.dart';
import '../events/events.dart';
import '../types/types.dart';
import 'middleware.dart';

/// Activity type for A2UI surface events.
const String a2uiActivityType = 'a2ui-surface';

/// Context entry used to expose the A2UI component schema to the agent.
const String a2uiSchemaContextDescription =
    'A2UI Component Schema — available components for generating UI '
    'surfaces. Use these component names and properties when creating '
    'A2UI operations.';

class A2UIMiddleware extends Middleware {
  A2UIMiddleware([
    this.config = const A2UIMiddlewareConfig(),
  ]);

  final A2UIMiddlewareConfig config;

  @override
  Stream<BaseEvent> run(RunAgentInput input, AbstractAgent next) async* {
    final a2uiToolNames = _resolveA2UIToolNames(config);
    final streamingToolCalls = <String, _StreamingRenderToolCall>{};
    EventWithState? heldRunFinished;
    final enhancedInput = _injectToolGuidelines(
      _injectTool(
        _injectSchemaContext(
          _processUserAction(input),
        ),
      ),
    );

    await for (final item in runNextWithState(enhancedInput, next)) {
      final event = item.event;

      if (event is ToolCallStartEvent &&
          a2uiToolNames.contains(event.toolCallName)) {
        streamingToolCalls[event.toolCallId] = _StreamingRenderToolCall();
      }

      if (event is ToolCallArgsEvent) {
        final streaming = streamingToolCalls[event.toolCallId];
        if (streaming != null) {
          streaming.args.write(event.delta);
        }
      }

      if (heldRunFinished != null) {
        yield heldRunFinished.event;
        heldRunFinished = null;
      }

      if (event is RunFinishedEvent) {
        heldRunFinished = item;
        continue;
      }

      yield event;

      if (event is ToolCallArgsEvent) {
        final streaming = streamingToolCalls[event.toolCallId];
        if (streaming != null) {
          for (final activityEvent in _handleStreamingToolArgs(
            toolCallId: event.toolCallId,
            streaming: streaming,
          )) {
            yield activityEvent;
          }
        }
      }

      if (event is ToolCallResultEvent) {
        final streaming = streamingToolCalls[event.toolCallId];
        if (streaming?.schemaEmitted ?? false) {
          continue;
        }

        final parsed = tryParseA2UIOperations(event.content);
        if (parsed == null) {
          continue;
        }

        for (final activityEvent in _createA2UIActivityEvents(
          parsed.operations,
          toolCallId: event.toolCallId,
        )) {
          yield activityEvent;
        }
      }
    }

    if (heldRunFinished != null) {
      final pendingToolCalls = _findPendingToolCalls(heldRunFinished.messages);
      for (final toolCall in pendingToolCalls) {
        if (!a2uiToolNames.contains(toolCall.function.name)) {
          continue;
        }

        yield ToolCallResultEvent(
          messageId: _generateSyntheticId('a2ui-tool-result'),
          toolCallId: toolCall.id,
          content: '{"status":"rendered"}',
        );
      }

      yield heldRunFinished.event;
    }
  }

  RunAgentInput _processUserAction(RunAgentInput input) {
    final userAction = _extractUserAction(input.forwardedProps);
    if (userAction == null) {
      return input;
    }

    final assistantMessageId = _generateSyntheticId('a2ui-assistant');
    final toolCallId = _generateSyntheticId('a2ui-tool-call');
    final toolMessageId = _generateSyntheticId('a2ui-tool-message');

    final syntheticAssistantMessage = AssistantMessage(
      id: assistantMessageId,
      content: '',
      toolCalls: [
        ToolCall(
          id: toolCallId,
          function: FunctionCall(
            name: logA2UIEventToolName,
            arguments: jsonEncode(userAction.toJson()),
          ),
        ),
      ],
    );

    final syntheticToolMessage = ToolMessage(
      id: toolMessageId,
      toolCallId: toolCallId,
      content: _formatUserActionResult(userAction),
    );

    return input.copyWith(
      messages: [
        ...input.messages,
        syntheticAssistantMessage,
        syntheticToolMessage,
      ],
    );
  }

  RunAgentInput _injectSchemaContext(RunAgentInput input) {
    final schema = config.schema;
    if (schema == null || _isEmptySchema(schema)) {
      return input;
    }

    final schemaContext = Context(
      description: a2uiSchemaContextDescription,
      value: jsonEncode(_serializeSchema(schema)),
    );

    final filtered = input.context
        .where((item) => item.description != a2uiSchemaContextDescription)
        .toList();

    return input.copyWith(
      context: [...filtered, schemaContext],
    );
  }

  RunAgentInput _injectTool(RunAgentInput input) {
    final toolName = _resolveInjectedToolName(config.injectA2UITool);
    if (toolName == null) {
      return input;
    }

    final filtered = input.tools.where((tool) => tool.name != toolName).toList();
    return input.copyWith(
      tools: [
        ...filtered,
        renderA2UITool.copyWith(name: toolName),
      ],
    );
  }

  RunAgentInput _injectToolGuidelines(RunAgentInput input) {
    final toolName = _resolveInjectedToolName(config.injectA2UITool);
    if (toolName == null) {
      return input;
    }

    final description =
        'A2UI render tool usage guide — how to call $toolName with valid '
        'arguments.';
    final filtered = input.context
        .where((item) => item.description != description)
        .toList();

    return input.copyWith(
      context: [
        ...filtered,
        Context(
          description: description,
          value: renderA2UIToolGuidelines(toolName),
        ),
      ],
    );
  }

  A2UIUserAction? _extractUserAction(Object? forwardedProps) {
    if (forwardedProps is! Map) {
      return null;
    }

    final a2uiAction = forwardedProps['a2uiAction'];
    if (a2uiAction is! Map) {
      return null;
    }

    final userAction = a2uiAction['userAction'];
    if (userAction is! Map) {
      return null;
    }

    return A2UIUserAction.fromJson(Map<String, dynamic>.from(userAction));
  }

  String _formatUserActionResult(A2UIUserAction action) {
    final actionName = action.name ?? 'unknown_action';
    final surfaceId = action.surfaceId ?? 'unknown_surface';
    final componentId = action.sourceComponentId;
    final contextValue = action.context == null ? '{}' : jsonEncode(action.context);

    var message =
        'User performed action "$actionName" on surface "$surfaceId"';
    if (componentId != null && componentId.isNotEmpty) {
      message += ' (component: $componentId)';
    }
    return '$message. Context: $contextValue';
  }

  List<BaseEvent> _createA2UIActivityEvents(
    List<Map<String, dynamic>> operations, {
    String? toolCallId,
  }) {
    final operationsBySurface = <String, List<Map<String, dynamic>>>{};
    for (final operation in operations) {
      final surfaceId = getOperationSurfaceId(operation) ?? 'default';
      operationsBySurface.putIfAbsent(surfaceId, () => <Map<String, dynamic>>[]);
      operationsBySurface[surfaceId]!.add(operation);
    }

    return operationsBySurface.entries.map((entry) {
      return ActivitySnapshotEvent(
        messageId: toolCallId == null
            ? 'a2ui-surface-${entry.key}'
            : 'a2ui-surface-${entry.key}-$toolCallId',
        activityType: a2uiActivityType,
        content: {
          a2uiOperationsKey: entry.value,
        },
      );
    }).toList();
  }

  List<BaseEvent> _handleStreamingToolArgs({
    required String toolCallId,
    required _StreamingRenderToolCall streaming,
  }) {
    final args = streaming.args.toString();
    final hasStructuralChar = args.contains('}') || args.contains(']');
    if (!hasStructuralChar) {
      return const [];
    }

    final result = extractCompleteItemsWithStatus(args, 'components');
    final surfaceId = extractStringField(args, 'surfaceId');
    final rawCatalogId = extractStringField(args, 'catalogId');
    final catalogId = _normalizeCatalogId(rawCatalogId);
    final emittedEvents = <BaseEvent>[];

    if (result != null && result.items.length > streaming.emittedCount && surfaceId != null) {
      final components = result.items
          .whereType<Map<Object?, Object?>>()
          .map(Map<String, dynamic>.from)
          .toList();

      if (components.isNotEmpty) {
        streaming
          ..surfaceId = surfaceId
          ..catalogId = catalogId
          ..components = components
          ..emittedCount = components.length
          ..schemaEmitted = true;

        final operations = <Map<String, dynamic>>[
          {
            'version': 'v0.9',
            'createSurface': {
              'surfaceId': surfaceId,
              'catalogId': catalogId,
            },
          },
          {
            'version': 'v0.9',
            'updateComponents': {
              'surfaceId': surfaceId,
              'components': components,
            },
          },
        ];

        final data = extractCompleteObject(args, 'data');
        if (data != null) {
          streaming.dataEmitted = true;
          operations.add({
            'version': 'v0.9',
            'updateDataModel': {
              'surfaceId': surfaceId,
              'path': '/',
              'value': data,
            },
          });
        }

        emittedEvents.add(
          ActivitySnapshotEvent(
            messageId: 'a2ui-surface-$surfaceId-$toolCallId',
            activityType: a2uiActivityType,
            content: {
              a2uiOperationsKey: operations,
            },
          ),
        );
      }
    }

    if (streaming.schemaEmitted &&
        !streaming.dataEmitted &&
        streaming.surfaceId != null &&
        streaming.components != null) {
      final data = extractCompleteObject(args, 'data');
      if (data != null) {
        streaming.dataEmitted = true;
        emittedEvents.add(
          ActivitySnapshotEvent(
            messageId: 'a2ui-surface-${streaming.surfaceId}-$toolCallId',
            activityType: a2uiActivityType,
            content: {
              a2uiOperationsKey: [
                {
                  'version': 'v0.9',
                  'createSurface': {
                    'surfaceId': streaming.surfaceId,
                    'catalogId': streaming.catalogId,
                  },
                },
                {
                  'version': 'v0.9',
                  'updateComponents': {
                    'surfaceId': streaming.surfaceId,
                    'components': streaming.components,
                  },
                },
                {
                  'version': 'v0.9',
                  'updateDataModel': {
                    'surfaceId': streaming.surfaceId,
                    'path': '/',
                    'value': data,
                  },
                },
              ],
            },
          ),
        );
      }
    }

    return emittedEvents;
  }

  List<ToolCall> _findPendingToolCalls(List<Message> messages) {
    final allToolCalls = <ToolCall>[];
    final resolvedToolCallIds = <String>{};

    for (final message in messages) {
      if (message is AssistantMessage && message.toolCalls != null) {
        allToolCalls.addAll(message.toolCalls!);
      }
      if (message is ToolMessage) {
        resolvedToolCallIds.add(message.toolCallId);
      }
    }

    return allToolCalls
        .where((toolCall) => !resolvedToolCallIds.contains(toolCall.id))
        .toList();
  }
}

String? _resolveInjectedToolName(Object? value) {
  if (value == true) {
    return renderA2UIToolName;
  }
  if (value is String && value.isNotEmpty) {
    return value;
  }
  return null;
}

Set<String> _resolveA2UIToolNames(A2UIMiddlewareConfig config) {
  final configured = config.a2uiToolNames;
  if (configured != null && configured.isNotEmpty) {
    return configured.toSet();
  }

  final injectedToolName = _resolveInjectedToolName(config.injectA2UITool);
  return {
    injectedToolName ?? renderA2UIToolName,
  };
}

String _normalizeCatalogId(String? value) {
  if (value == null || value.isEmpty || value == 'basic') {
    return 'https://a2ui.org/specification/v0_9/basic_catalog.json';
  }
  return value;
}

bool _isEmptySchema(Object schema) {
  if (schema is A2UIInlineCatalogSchema) {
    return schema.components.isEmpty;
  }
  if (schema is List<A2UIComponentSchema>) {
    return schema.isEmpty;
  }
  if (schema is Map) {
    final components = schema['components'];
    if (components is Map) {
      return components.isEmpty;
    }
  }
  if (schema is List) {
    return schema.isEmpty;
  }
  return false;
}

Object _serializeSchema(Object schema) {
  if (schema is A2UIInlineCatalogSchema) {
    return schema.toJson();
  }
  if (schema is List<A2UIComponentSchema>) {
    return schema.map((item) => item.toJson()).toList();
  }
  if (schema is Map) {
    return Map<String, dynamic>.from(schema);
  }
  if (schema is List) {
    return List<Object?>.from(schema);
  }
  return schema;
}

int _a2uiSyntheticIdCounter = 0;

String _generateSyntheticId(String prefix) {
  _a2uiSyntheticIdCounter += 1;
  return '$prefix-${DateTime.now().microsecondsSinceEpoch}-'
      '$_a2uiSyntheticIdCounter';
}

class _StreamingRenderToolCall {
  final StringBuffer args = StringBuffer();
  int emittedCount = 0;
  bool schemaEmitted = false;
  bool dataEmitted = false;
  String? surfaceId;
  String? catalogId;
  List<Map<String, dynamic>>? components;
}
