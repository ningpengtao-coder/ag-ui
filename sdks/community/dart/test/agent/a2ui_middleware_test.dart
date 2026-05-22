import 'dart:convert';

import 'package:ag_ui/ag_ui.dart';
import 'package:test/test.dart';

class CapturingAgent extends AbstractAgent {
  CapturingAgent({
    this.eventsToEmit = const [],
  }) : super(config: const AgentConfig(threadId: 'thread-1'));

  final List<BaseEvent> eventsToEmit;
  RunAgentInput? receivedInput;

  @override
  AbstractAgent createClone() => CapturingAgent(eventsToEmit: eventsToEmit);

  @override
  Stream<BaseEvent> run(RunAgentInput input) {
    receivedInput = input;
    return Stream<BaseEvent>.fromIterable(eventsToEmit);
  }
}

const _salesCatalogId = 'myapp://sales-catalog';

class SalesSkillTestAgent extends AbstractAgent {
  SalesSkillTestAgent() : super(config: const AgentConfig(threadId: 'thread-1'));

  RunAgentInput? receivedInput;

  @override
  AbstractAgent createClone() => SalesSkillTestAgent();

  @override
  Stream<BaseEvent> run(RunAgentInput input) async* {
    receivedInput = input;
    yield RunStartedEvent(threadId: input.threadId, runId: input.runId);

    final action = _extractForwardedAction(input.messages);
    if (action != null) {
      const messageId = 'assistant-msg-a2ui-action';
      final actionName = action.name ?? 'unknown_action';
      final surfaceId = action.surfaceId ?? 'unknown_surface';
      final region = action.context?['region'];

      yield const TextMessageStartEvent(messageId: messageId);
      yield TextMessageContentEvent(
        messageId: messageId,
        delta:
            'salesSkill handled "$actionName" on "$surfaceId". '
            'Applying region=${region ?? 'unknown'}.',
      );
      yield const TextMessageEndEvent(messageId: messageId);
      yield RunFinishedEvent(
        threadId: input.threadId,
        runId: input.runId,
        outcome: const RunFinishedSuccessOutcome(),
      );
      return;
    }

    const toolCallId = 'render-a2ui-call-1';
    yield const ToolCallStartEvent(
      toolCallId: toolCallId,
      toolCallName: renderA2UIToolName,
      parentMessageId: 'assistant-sales-skill',
    );
    yield ToolCallArgsEvent(
      toolCallId: toolCallId,
      delta: jsonEncode({
        'surfaceId': 'sales-dashboard',
        'catalogId': _salesCatalogId,
        'components': [
          {
            'id': 'root',
            'component': 'Column',
            'children': ['title', 'revenue'],
          },
          {
            'id': 'title',
            'component': 'Text',
            'text': 'Sales Overview',
          },
          {
            'id': 'revenue',
            'component': 'MetricCard',
            'label': 'Revenue',
            'value': r'$18,234',
          },
        ],
        'data': {
          'region': 'APAC',
        },
      }),
    );
    yield const ToolCallEndEvent(toolCallId: toolCallId);
    yield RunFinishedEvent(
      threadId: input.threadId,
      runId: input.runId,
      outcome: const RunFinishedSuccessOutcome(),
    );
  }

  A2UIUserAction? _extractForwardedAction(List<Message> messages) {
    for (final message in messages.reversed) {
      if (message is! AssistantMessage || message.toolCalls == null) {
        continue;
      }

      for (final toolCall in message.toolCalls!) {
        if (toolCall.function.name != logA2UIEventToolName) {
          continue;
        }

        final decoded = jsonDecode(toolCall.function.arguments);
        if (decoded is Map<String, dynamic>) {
          return A2UIUserAction.fromJson(decoded);
        }
        if (decoded is Map) {
          return A2UIUserAction.fromJson(Map<String, dynamic>.from(decoded));
        }
      }
    }

    return null;
  }
}

RunAgentInput createRunAgentInput({
  List<Message> messages = const [],
  List<Tool> tools = const [],
  List<Context> context = const [],
  Object? forwardedProps = const <String, dynamic>{},
}) {
  return RunAgentInput(
    threadId: 'thread-1',
    runId: 'run-1',
    state: const <String, dynamic>{},
    messages: messages,
    tools: tools,
    context: context,
    forwardedProps: forwardedProps,
  );
}

void main() {
  group('A2UIMiddleware', () {
    test('injects render tool and schema context', () async {
      final middleware = A2UIMiddleware(
        const A2UIMiddlewareConfig(
          injectA2UITool: true,
          schema: A2UIInlineCatalogSchema(
            catalogId: 'catalog-1',
            components: {
              'Text': {
                'type': 'object',
              },
            },
          ),
        ),
      );
      final agent = CapturingAgent(
        eventsToEmit: const [
          RunStartedEvent(threadId: 'thread-1', runId: 'run-1'),
          RunFinishedEvent(threadId: 'thread-1', runId: 'run-1'),
        ],
      );

      await middleware.run(createRunAgentInput(), agent).drain<void>();

      expect(agent.receivedInput, isNotNull);
      expect(
        agent.receivedInput!.tools.any((tool) => tool.name == renderA2UIToolName),
        isTrue,
      );
      expect(
        agent.receivedInput!.context.any(
          (item) => item.description == a2uiSchemaContextDescription,
        ),
        isTrue,
      );
    });

    test('converts forwarded A2UI action into synthetic messages', () async {
      final middleware = A2UIMiddleware();
      final agent = CapturingAgent(
        eventsToEmit: const [
          RunStartedEvent(threadId: 'thread-1', runId: 'run-1'),
          RunFinishedEvent(threadId: 'thread-1', runId: 'run-1'),
        ],
      );

      await middleware
          .run(
            createRunAgentInput(
              forwardedProps: {
                'a2uiAction': {
                  'userAction': {
                    'name': 'submit_form',
                    'surfaceId': 'contact-form',
                    'sourceComponentId': 'submit-btn',
                    'context': {'email': 'alice@example.com'},
                  },
                },
              },
            ),
            agent,
          )
          .drain<void>();

      final messages = agent.receivedInput!.messages;
      expect(messages, hasLength(2));
      expect(messages.first, isA<AssistantMessage>());
      expect(messages.last, isA<ToolMessage>());

      final assistant = messages.first as AssistantMessage;
      expect(assistant.toolCalls, hasLength(1));
      expect(assistant.toolCalls!.single.function.name, logA2UIEventToolName);

      final tool = messages.last as ToolMessage;
      expect(tool.content, contains('submit_form'));
      expect(tool.content, contains('contact-form'));
    });

    test('emits activity snapshot when tool result contains a2ui operations', () async {
      final middleware = A2UIMiddleware();
      final agent = CapturingAgent(
        eventsToEmit: [
          const RunStartedEvent(threadId: 'thread-1', runId: 'run-1'),
          const ToolCallResultEvent(
            messageId: 'tool-result-1',
            toolCallId: 'tool-call-1',
            content: '''
{"a2ui_operations":[
  {"version":"v0.9","createSurface":{"surfaceId":"surface-1","catalogId":"basic"}},
  {"version":"v0.9","updateComponents":{"surfaceId":"surface-1","components":[{"id":"root","component":"Text","text":"Hello"}]}}
]}''',
          ),
          const RunFinishedEvent(threadId: 'thread-1', runId: 'run-1'),
        ],
      );

      final events = await middleware.run(createRunAgentInput(), agent).toList();

      final activityEvents = events.whereType<ActivitySnapshotEvent>().toList();
      expect(activityEvents, hasLength(1));
      expect(activityEvents.single.activityType, a2uiActivityType);
      expect(
        activityEvents.single.content[a2uiOperationsKey],
        isA<List<dynamic>>(),
      );
    });

    test('runAgent stores generated activity message', () async {
      final agent = CapturingAgent(
        eventsToEmit: [
          const RunStartedEvent(threadId: 'thread-1', runId: 'run-1'),
          const ToolCallResultEvent(
            messageId: 'tool-result-1',
            toolCallId: 'tool-call-1',
            content: '''
{"a2ui_operations":[
  {"version":"v0.9","createSurface":{"surfaceId":"surface-1","catalogId":"basic"}},
  {"version":"v0.9","updateComponents":{"surfaceId":"surface-1","components":[{"id":"root","component":"Text","text":"Hello"}]}}
]}''',
          ),
          const RunFinishedEvent(threadId: 'thread-1', runId: 'run-1'),
        ],
      )..use(A2UIMiddleware());

      final result = await agent.runAgent(const RunAgentParameters(runId: 'run-1'));

      expect(result.newMessages.whereType<ToolMessage>(), hasLength(1));
      final activityMessages = result.newMessages.whereType<ActivityMessage>().toList();
      expect(activityMessages, hasLength(1));
      expect(activityMessages.single.activityType, a2uiActivityType);
      expect(
        activityMessages.single.content[a2uiOperationsKey],
        isA<List<dynamic>>(),
      );
    });

    test('emits activity snapshot while render_a2ui args stream in', () async {
      final middleware = A2UIMiddleware();
      const toolCallId = 'tool-call-streaming';
      const args = '''
{"surfaceId":"surface-stream","catalogId":"basic","components":[{"id":"root","component":"Text","text":"Hello"}],"data":{"form":{"name":"Alice"}}}''';
      final agent = CapturingAgent(
        eventsToEmit: [
          const RunStartedEvent(threadId: 'thread-1', runId: 'run-1'),
          const ToolCallStartEvent(
            toolCallId: toolCallId,
            toolCallName: renderA2UIToolName,
            parentMessageId: 'assistant-1',
          ),
          ToolCallArgsEvent(
            toolCallId: toolCallId,
            delta: args.substring(0, 70),
          ),
          ToolCallArgsEvent(
            toolCallId: toolCallId,
            delta: args.substring(70),
          ),
          const ToolCallEndEvent(toolCallId: toolCallId),
          const RunFinishedEvent(threadId: 'thread-1', runId: 'run-1'),
        ],
      );

      final events = await middleware.run(createRunAgentInput(), agent).toList();

      final activityEvents = events.whereType<ActivitySnapshotEvent>().toList();
      expect(activityEvents, isNotEmpty);
      expect(activityEvents.first.activityType, a2uiActivityType);
      final operations =
          activityEvents.last.content[a2uiOperationsKey] as List<dynamic>;
      expect(operations.length, greaterThanOrEqualTo(2));

      final toolResults = events.whereType<ToolCallResultEvent>().toList();
      expect(toolResults, hasLength(1));
      expect(toolResults.single.toolCallId, toolCallId);
      expect(toolResults.single.content, contains('rendered'));
    });

    test('runAgent stores streamed render tool result and activity message', () async {
      const toolCallId = 'tool-call-streaming';
      final agent = CapturingAgent(
        eventsToEmit: [
          const RunStartedEvent(threadId: 'thread-1', runId: 'run-1'),
          const ToolCallStartEvent(
            toolCallId: toolCallId,
            toolCallName: renderA2UIToolName,
            parentMessageId: 'assistant-1',
          ),
          const ToolCallArgsEvent(
            toolCallId: toolCallId,
            delta:
                '{"surfaceId":"surface-stream","components":[{"id":"root","component":"Text","text":"Hello"}]}',
          ),
          const ToolCallEndEvent(toolCallId: toolCallId),
          const RunFinishedEvent(threadId: 'thread-1', runId: 'run-1'),
        ],
      )..use(A2UIMiddleware());

      final result = await agent.runAgent(const RunAgentParameters(runId: 'run-1'));

      expect(result.newMessages.whereType<AssistantMessage>(), hasLength(1));
      expect(result.newMessages.whereType<ToolMessage>(), hasLength(1));
      expect(result.newMessages.whereType<ActivityMessage>(), hasLength(1));
    });

    test('supports custom catalog and skill follow-up via forwarded a2uiAction', () async {
      final agent = SalesSkillTestAgent()
        ..use(
          A2UIMiddleware(
            const A2UIMiddlewareConfig(
              injectA2UITool: true,
              schema: A2UIInlineCatalogSchema(
                catalogId: _salesCatalogId,
                components: {
                  'Column': {'type': 'object'},
                  'Text': {'type': 'object'},
                  'MetricCard': {
                    'type': 'object',
                    'properties': {
                      'label': {'type': 'string'},
                      'value': {'type': 'string'},
                    },
                  },
                },
              ),
            ),
          ),
        );

      final renderResult = await agent.runAgent(
        const RunAgentParameters(
          context: [
            Context(
              description: 'Skill routing hint',
              value: 'Use salesSkill for sales analytics.',
            ),
          ],
        ),
      );

      expect(agent.receivedInput, isNotNull);
      expect(
        agent.receivedInput!.context.any(
          (item) =>
              item.description == a2uiSchemaContextDescription &&
              item.value.contains(_salesCatalogId),
        ),
        isTrue,
      );

      final renderActivity =
          renderResult.newMessages.whereType<ActivityMessage>().single;
      final operations =
          renderActivity.content[a2uiOperationsKey] as List<dynamic>;
      expect(
        operations.any(
          (operation) =>
              operation is Map &&
              operation['createSurface'] is Map &&
              (operation['createSurface'] as Map)['surfaceId'] ==
                  'sales-dashboard' &&
              (operation['createSurface'] as Map)['catalogId'] ==
                  _salesCatalogId,
        ),
        isTrue,
      );
      expect(
        operations.any(
          (operation) =>
              operation is Map &&
              operation['updateComponents'] is Map &&
              ((operation['updateComponents'] as Map)['components'] as List)
                  .any(
                    (component) =>
                        component is Map &&
                        component['component'] == 'MetricCard',
                  ),
        ),
        isTrue,
      );

      final actionResult = await agent.runAgent(
        const RunAgentParameters(
          forwardedProps: {
            'a2uiAction': {
              'userAction': {
                'name': 'submit_filter',
                'surfaceId': 'sales-dashboard',
                'sourceComponentId': 'region-filter',
                'context': {
                  'region': 'EMEA',
                },
              },
            },
          },
        ),
      );

      final assistantMessages =
          actionResult.newMessages.whereType<AssistantMessage>().toList();
      expect(assistantMessages, hasLength(1));
      expect(assistantMessages.single.content, contains('salesSkill handled'));
      expect(assistantMessages.single.content, contains('region=EMEA'));
    });
  });
}
