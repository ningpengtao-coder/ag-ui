import 'package:ag_ui/ag_ui.dart';
import 'package:test/test.dart';

void main() {
  group('convertToLegacyEvents', () {
    test('handles basic tool call lifecycle', () async {
      final events = await convertToLegacyEvents(
        'test-thread',
        'test-run',
        'test-agent',
      )(
        Stream<BaseEvent>.fromIterable(const [
          ToolCallStartEvent(toolCallId: 'call-1', toolCallName: 'test_tool'),
          ToolCallArgsEvent(toolCallId: 'call-1', delta: '{"key":"value"}'),
          ToolCallEndEvent(toolCallId: 'call-1'),
        ]),
      ).toList();

      expect(events.map((event) => event['type']).toList(), [
        'ActionExecutionStart',
        'ActionExecutionArgs',
        'ActionExecutionEnd',
      ]);
    });

    test('handles predictive state updates from partial args', () async {
      final events = await convertToLegacyEvents(
        'test-thread',
        'test-run',
        'test-agent',
      )(
        Stream<BaseEvent>.fromIterable(const [
          CustomEvent(
            name: 'PredictState',
            value: [
              {
                'state_key': 'greeting',
                'tool': 'make_greeting',
                'tool_argument': 'message',
              },
            ],
          ),
          ToolCallStartEvent(toolCallId: 'greeting-1', toolCallName: 'make_greeting'),
          ToolCallArgsEvent(toolCallId: 'greeting-1', delta: '{"message": "Hello'),
          ToolCallArgsEvent(toolCallId: 'greeting-1', delta: ' world!"}'),
          ToolCallEndEvent(toolCallId: 'greeting-1'),
        ]),
      ).toList();

      final stateEvents = events.where((event) => event['type'] == 'AgentStateMessage').toList();
      expect(stateEvents, hasLength(2));
      expect(stateEvents.first['state'], '{"greeting":"Hello"}');
      expect(stateEvents.last['state'], '{"greeting":"Hello world!"}');
    });

    test('handles concurrent text and tool events in order', () async {
      final events = await convertToLegacyEvents(
        'test-thread',
        'test-run',
        'test-agent',
      )(
        Stream<BaseEvent>.fromIterable(const [
          TextMessageStartEvent(messageId: 'thinking_msg', role: TextMessageRole.assistant),
          ToolCallStartEvent(
            toolCallId: 'search_tool',
            toolCallName: 'web_search',
            parentMessageId: 'tool_msg',
          ),
          TextMessageContentEvent(messageId: 'thinking_msg', delta: 'Let me search for that...'),
          ToolCallArgsEvent(toolCallId: 'search_tool', delta: '{"query":"concurrent events"}'),
          TextMessageEndEvent(messageId: 'thinking_msg'),
          ToolCallEndEvent(toolCallId: 'search_tool'),
        ]),
      ).toList();

      expect(events.map((event) => event['type']).toList(), [
        'TextMessageStart',
        'ActionExecutionStart',
        'TextMessageContent',
        'ActionExecutionArgs',
        'TextMessageEnd',
        'ActionExecutionEnd',
      ]);
    });
  });
}
