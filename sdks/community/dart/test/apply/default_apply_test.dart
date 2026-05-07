import 'package:ag_ui/ag_ui.dart';
import 'package:test/test.dart';

void main() {
  group('defaultApplyEvents', () {
    test('applies state delta patches', () async {
      final input = RunAgentInput(
        threadId: 'thread-1',
        runId: 'run-1',
        messages: const [],
        tools: const [],
        context: const [],
        state: {
          'count': 0,
          'items': ['a'],
        },
      );

      final events = Stream<BaseEvent>.fromIterable([
        const StateDeltaEvent(
          delta: [
            {'op': 'replace', 'path': '/count', 'value': 2},
            {'op': 'add', 'path': '/items/-', 'value': 'b'},
          ],
        ),
      ]);

      final updates = await defaultApplyEvents(input, events).toList();

      expect(updates, hasLength(1));
      expect(updates.single.state, {
        'count': 2,
        'items': ['a', 'b'],
      });
    });

    test('creates and updates reasoning messages', () async {
      final input = RunAgentInput(
        threadId: 'thread-1',
        runId: 'run-1',
        messages: const [],
        tools: const [],
        context: const [],
      );

      final events = Stream<BaseEvent>.fromIterable([
        const ReasoningMessageStartEvent(messageId: 'r1'),
        const ReasoningMessageContentEvent(messageId: 'r1', delta: 'Hello'),
        const ReasoningMessageContentEvent(messageId: 'r1', delta: ' world'),
      ]);

      final updates = await defaultApplyEvents(input, events).toList();

      expect(updates, hasLength(3));
      final finalMessage = updates.last.messages.single as ReasoningMessage;
      expect(finalMessage.id, 'r1');
      expect(finalMessage.content, 'Hello world');
    });

    test('updates encrypted values on tool calls and messages', () async {
      final input = RunAgentInput(
        threadId: 'thread-1',
        runId: 'run-1',
        messages: [
          AssistantMessage(
            id: 'assistant-1',
            toolCalls: const [
              ToolCall(
                id: 'tc-1',
                function: FunctionCall(name: 'lookup', arguments: '{}'),
              ),
            ],
          ),
        ],
        tools: const [],
        context: const [],
      );

      final events = Stream<BaseEvent>.fromIterable([
        const ReasoningEncryptedValueEvent(
          subtype: ReasoningEncryptedValueSubtype.toolCall,
          entityId: 'tc-1',
          encryptedValue: 'enc-tool',
        ),
        const ReasoningEncryptedValueEvent(
          subtype: ReasoningEncryptedValueSubtype.message,
          entityId: 'assistant-1',
          encryptedValue: 'enc-msg',
        ),
      ]);

      final updates = await defaultApplyEvents(input, events).toList();
      final assistant = updates.last.messages.single as AssistantMessage;
      expect(assistant.encryptedValue, 'enc-msg');
      expect(assistant.toolCalls!.single.encryptedValue, 'enc-tool');
    });
  });
}
