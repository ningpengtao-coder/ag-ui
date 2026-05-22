import 'dart:convert';

import 'package:ag_ui/ag_ui.dart';

const _salesCatalogId = 'myapp://sales-catalog';

class SalesSkillAgent extends AbstractAgent {
  SalesSkillAgent() : super(config: const AgentConfig(threadId: 'demo-thread'));

  @override
  AbstractAgent createClone() => SalesSkillAgent();

  @override
  Stream<BaseEvent> run(RunAgentInput input) async* {
    yield RunStartedEvent(threadId: input.threadId, runId: input.runId);

    switch (_routeSkill(input)) {
      case 'sales':
        final forwardedAction = _extractForwardedAction(input.messages);
        if (forwardedAction != null) {
          yield* _handleSalesAction(input, forwardedAction);
          return;
        }

        yield* _renderSalesDashboard(input);
      default:
        yield* _emitDefaultReply(input);
    }
  }

  String _routeSkill(RunAgentInput input) {
    if (_extractForwardedAction(input.messages) != null) {
      return 'sales';
    }

    return 'sales';
  }

  Stream<BaseEvent> _renderSalesDashboard(RunAgentInput input) async* {
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
            'children': ['title', 'filters', 'revenue'],
          },
          {
            'id': 'title',
            'component': 'Text',
            'text': 'Sales Overview',
          },
          {
            'id': 'filters',
            'component': 'FilterBar',
            'options': ['APAC', 'EMEA', 'NA'],
            'selected': 'APAC',
          },
          {
            'id': 'revenue',
            'component': 'MetricCard',
            'label': 'Revenue',
            'value': r'$18,234',
            'trend': '+18% WoW',
          },
        ],
        'data': {
          'revenue': 18234,
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

  Stream<BaseEvent> _handleSalesAction(
    RunAgentInput input,
    A2UIUserAction forwardedAction,
  ) async* {
    const messageId = 'assistant-msg-a2ui-action';
    final actionName = forwardedAction.name ?? 'unknown_action';
    final surfaceId = forwardedAction.surfaceId ?? 'unknown_surface';
    final region = forwardedAction.context?['region'];
    final quarter = forwardedAction.context?['quarter'];

    yield const TextMessageStartEvent(
      messageId: messageId,
    );
    yield TextMessageContentEvent(
      messageId: messageId,
      delta:
          'salesSkill handled "$actionName" on "$surfaceId". '
          'Applying region=${region ?? 'unknown'}'
          '${quarter == null ? '' : ', quarter=$quarter'}.',
    );
    yield const TextMessageEndEvent(messageId: messageId);
    yield RunFinishedEvent(
      threadId: input.threadId,
      runId: input.runId,
      outcome: const RunFinishedSuccessOutcome(),
    );
  }

  Stream<BaseEvent> _emitDefaultReply(RunAgentInput input) async* {
    const messageId = 'assistant-msg-default-skill';
    yield const TextMessageStartEvent(messageId: messageId);
    yield const TextMessageContentEvent(
      messageId: messageId,
      delta: 'No skill matched the current request.',
    );
    yield const TextMessageEndEvent(messageId: messageId);
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

Future<void> main() async {
  final agent = SalesSkillAgent()
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
                  'trend': {'type': 'string'},
                },
              },
              'FilterBar': {
                'type': 'object',
                'properties': {
                  'options': {'type': 'array'},
                  'selected': {'type': 'string'},
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
          value:
              'Use salesSkill for sales analytics and prefer a compact dashboard.',
        ),
      ],
    ),
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
              'region': 'APAC',
              'quarter': 'Q2',
            },
          },
        },
      },
    ),
  );

  // ignore: avoid_print
  print('salesSkill render run messages:');
  _printMessages(renderResult.newMessages);

  // ignore: avoid_print
  print('');
  // ignore: avoid_print
  print('salesSkill action follow-up messages:');
  _printMessages(actionResult.newMessages);
}

void _printMessages(List<Message> messages) {
  for (final message in messages) {
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
