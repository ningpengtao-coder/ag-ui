import 'dart:convert';

import 'package:ag_ui/ag_ui.dart';

const _customCatalogId = 'myapp://custom-dashboard-catalog';

class CustomCatalogAgent extends AbstractAgent {
  CustomCatalogAgent() : super(config: const AgentConfig(threadId: 'demo-thread'));

  @override
  AbstractAgent createClone() => CustomCatalogAgent();

  @override
  Stream<BaseEvent> run(RunAgentInput input) async* {
    yield RunStartedEvent(threadId: input.threadId, runId: input.runId);

    const toolCallId = 'render-custom-catalog';
    yield const ToolCallStartEvent(
      toolCallId: toolCallId,
      toolCallName: renderA2UIToolName,
      parentMessageId: 'assistant-custom-catalog',
    );

    yield ToolCallArgsEvent(
      toolCallId: toolCallId,
      delta: jsonEncode({
        'surfaceId': 'custom-dashboard',
        'catalogId': _customCatalogId,
        'components': [
          {
            'id': 'root',
            'component': 'Column',
            'children': ['title', 'status', 'metric'],
          },
          {
            'id': 'title',
            'component': 'Text',
            'text': 'Custom Catalog Demo',
          },
          {
            'id': 'status',
            'component': 'StatusBadge',
            'label': 'Healthy',
            'tone': 'success',
          },
          {
            'id': 'metric',
            'component': 'MetricCard',
            'label': 'Weekly Active Users',
            'value': '12,480',
          },
        ],
        'data': {
          'wau': 12480,
          'health': 'healthy',
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
}

Future<void> main() async {
  final agent = CustomCatalogAgent()
    ..use(
      A2UIMiddleware(
        const A2UIMiddlewareConfig(
          injectA2UITool: true,
          schema: A2UIInlineCatalogSchema(
            catalogId: _customCatalogId,
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
              'StatusBadge': {
                'type': 'object',
                'properties': {
                  'label': {'type': 'string'},
                  'tone': {'type': 'string'},
                },
              },
            },
          ),
        ),
      ),
    );

  final result = await agent.runAgent(
    const RunAgentParameters(
      context: [
        Context(
          description: 'Catalog brief',
          value:
              'Render a compact dashboard using only the custom catalog components.',
        ),
      ],
    ),
  );

  // ignore: avoid_print
  print('custom catalog run messages:');
  for (final message in result.newMessages) {
    switch (message) {
      case ActivityMessage():
        // ignore: avoid_print
        print('ACTIVITY ${message.activityType}');
        // ignore: avoid_print
        print(const JsonEncoder.withIndent('  ').convert(message.content));
      case ToolMessage():
        // ignore: avoid_print
        print('TOOL RESULT ${message.toolCallId}: ${message.content}');
      case AssistantMessage():
        // ignore: avoid_print
        print('ASSISTANT ${message.id}');
      default:
        // ignore: avoid_print
        print('${message.role.value}: ${message.id}');
    }
  }
}
