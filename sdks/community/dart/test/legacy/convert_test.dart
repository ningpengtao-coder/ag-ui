import 'dart:convert';

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

    test('carries the message list in a messages snapshot', () async {
      final events = await convertToLegacyEvents(
        'thread',
        'run',
        'agent',
      )(
        Stream<BaseEvent>.fromIterable([
          MessagesSnapshotEvent(
            messages: [UserMessage(id: 'm1', content: 'hello')],
          ),
        ]),
      ).toList();

      final state = _stateOf(events.single);
      final messages = (state['messages'] as List).cast<Map<String, dynamic>>();
      expect(messages.single['id'], 'm1');
      expect(messages.single['role'], 'user');
      expect(messages.single['content'], 'hello');
    });

    test('carries the legacy-shaped messages in the finished state', () async {
      final events = await convertToLegacyEvents(
        'thread',
        'run',
        'agent',
      )(
        Stream<BaseEvent>.fromIterable([
          MessagesSnapshotEvent(
            messages: [
              AssistantMessage(
                id: 'a1',
                content: 'hi',
                toolCalls: const [
                  ToolCall(
                    id: 'c1',
                    function: FunctionCall(name: 'find', arguments: '{"x":1}'),
                  ),
                ],
              ),
            ],
          ),
          const RunFinishedEvent(threadId: 'thread', runId: 'run'),
        ]),
      ).toList();

      final stateEvents = events
          .where((event) => event['type'] == 'AgentStateMessage')
          .toList();
      expect(stateEvents, hasLength(2));

      // The snapshot carries the raw AG-UI messages, tool calls included.
      final snapshotMessages =
          (_stateOf(stateEvents.first)['messages'] as List)
              .cast<Map<String, dynamic>>();
      expect(snapshotMessages.single.containsKey('toolCalls'), isTrue);

      // The finished event carries the legacy shape: one entry per message and
      // one per tool call, with the arguments parsed.
      final finalMessages =
          (_stateOf(stateEvents.last)['messages'] as List)
              .cast<Map<String, dynamic>>();
      expect(finalMessages, hasLength(2));
      expect(finalMessages.last, {
        'id': 'c1',
        'name': 'find',
        'arguments': {'x': 1},
        'parentMessageId': 'a1',
      });
    });

    test('survives a state patch that cannot be applied', () async {
      final events = await convertToLegacyEvents(
        'thread',
        'run',
        'agent',
      )(
        Stream<BaseEvent>.fromIterable([
          const StateSnapshotEvent(snapshot: {'a': 1}),
          const StateDeltaEvent(
            delta: [
              {'op': 'replace', 'path': '/missing', 'value': 2},
            ],
          ),
          const CustomEvent(name: 'StillRunning', value: null),
        ]),
      ).toList();

      expect(events.map((event) => event['type']).toList(), [
        'AgentStateMessage',
        'MetaEvent',
      ]);
    });

    test('reports a run error when a tool call holds unparseable arguments',
        () async {
      final events = await convertToLegacyEvents(
        'thread',
        'run',
        'agent',
      )(
        Stream<BaseEvent>.fromIterable([
          MessagesSnapshotEvent(
            messages: [
              AssistantMessage(
                id: 'a1',
                toolCalls: const [
                  ToolCall(
                    id: 'c1',
                    function: FunctionCall(name: 'find', arguments: 'not json'),
                  ),
                ],
              ),
            ],
          ),
          const RunFinishedEvent(threadId: 'thread', runId: 'run'),
        ]),
      ).toList();

      expect(events.last['type'], 'RunError');
    });

    test('flattens tool result parts to text', () async {
      final events = await convertToLegacyEvents(
        'thread',
        'run',
        'agent',
      )(
        Stream<BaseEvent>.fromIterable([
          const ToolCallStartEvent(toolCallId: 'c1', toolCallName: 'find'),
          const ToolCallResultEvent(
            messageId: 'm1',
            toolCallId: 'c1',
            content: [
              TextInputContent(text: 'he'),
              TextInputContent(text: 'llo'),
              ImageInputContent(
                source: InputContentUrlSource(value: 'https://example.com/a.png'),
              ),
            ],
          ),
        ]),
      ).toList();

      expect(events.last['type'], 'ActionExecutionResult');
      expect(events.last['result'], 'hello');
    });
  });
}

Map<String, dynamic> _stateOf(Map<String, dynamic> event) {
  return jsonDecode(event['state'] as String) as Map<String, dynamic>;
}
