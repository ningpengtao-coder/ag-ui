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

    test('attributes a message created by a subagent tool call', () async {
      final input = RunAgentInput(
        threadId: 'thread-1',
        runId: 'run-1',
        messages: const [],
        tools: const [],
        context: const [],
      );

      final events = Stream<BaseEvent>.fromIterable([
        const ToolCallStartEvent(
          toolCallId: 'call-1',
          toolCallName: 'find',
          subagentRunId: 'sub-1',
        ),
      ]);

      final updates = await defaultApplyEvents(input, events).toList();
      final assistant = updates.last.messages.single as AssistantMessage;

      // Nothing else on that message can supply the attribution, so the call
      // that created it does.
      expect(assistant.subagentRunId, 'sub-1');
      expect(assistant.toolCalls!.single.id, 'call-1');
    });

    test('a snapshot without a declaration keeps local activities', () async {
      final input = _inputWithActivity();
      final events = Stream<BaseEvent>.fromIterable([
        const MessagesSnapshotEvent(messages: []),
      ]);

      final updates = await defaultApplyEvents(input, events).toList();

      expect(updates.last.messages.single.id, 'activity-1');
    });

    test('a declared scope drops the local activities it owns', () async {
      final input = _inputWithActivity();
      final events = Stream<BaseEvent>.fromIterable([
        const MessagesSnapshotEvent(
          messages: [],
          metadata: {
            agUiClientMetadataKey: {
              'authoritativeActivityTypes': ['map'],
            },
          },
        ),
      ]);

      final updates = await defaultApplyEvents(input, events).toList();

      expect(updates.last.messages, isEmpty);
    });

    test('a declared scope keeps local activities it does not own', () async {
      final input = _inputWithActivity();
      final events = Stream<BaseEvent>.fromIterable([
        const MessagesSnapshotEvent(
          messages: [],
          metadata: {
            agUiClientMetadataKey: {
              'authoritativeActivityTypes': ['chart'],
            },
          },
        ),
      ]);

      final updates = await defaultApplyEvents(input, events).toList();

      expect(updates.last.messages.single.id, 'activity-1');
    });

    test('an explicit null scope owns every activity type', () async {
      final input = _inputWithActivity();
      final events = Stream<BaseEvent>.fromIterable([
        const MessagesSnapshotEvent(
          messages: [],
          metadata: {
            agUiClientMetadataKey: {'authoritativeActivityTypes': null},
          },
        ),
      ]);

      final updates = await defaultApplyEvents(input, events).toList();

      expect(updates.last.messages, isEmpty);
    });

    test('leaves an existing message attribution alone', () async {
      final input = RunAgentInput(
        threadId: 'thread-1',
        runId: 'run-1',
        messages: [
          AssistantMessage(
            id: 'assistant-1',
            subagentRunId: 'sub-parent',
            toolCalls: const [],
          ),
        ],
        tools: const [],
        context: const [],
      );

      final events = Stream<BaseEvent>.fromIterable([
        const ToolCallStartEvent(
          toolCallId: 'call-1',
          toolCallName: 'find',
          parentMessageId: 'assistant-1',
          subagentRunId: 'sub-1',
        ),
      ]);

      final updates = await defaultApplyEvents(input, events).toList();
      final assistant = updates.last.messages.single as AssistantMessage;

      expect(assistant.subagentRunId, 'sub-parent');
    });
  });

  group('activity history convention', () {
    test('an absent declaration is the legacy inference', () {
      const event = MessagesSnapshotEvent(messages: []);

      expect(authoritativeActivityTypes(event).declared, isFalse);
      expect(authoritativeActivityTypes(event).types, isNull);
    });

    test('an explicit null owns every type', () {
      const event = MessagesSnapshotEvent(
        messages: [],
        metadata: {
          agUiClientMetadataKey: {'authoritativeActivityTypes': null},
        },
      );

      final scope = authoritativeActivityTypes(event);
      expect(scope.declared, isTrue);
      expect(scope.types, isNull);
    });

    test('a list owns exactly those types', () {
      const event = MessagesSnapshotEvent(
        messages: [],
        metadata: {
          agUiClientMetadataKey: {
            'authoritativeActivityTypes': ['chart'],
          },
        },
      );

      expect(authoritativeActivityTypes(event).types, ['chart']);
    });

    test('a declaration of the wrong shape owns no types', () {
      const event = MessagesSnapshotEvent(
        messages: [],
        metadata: {
          agUiClientMetadataKey: {'authoritativeActivityTypes': 'chart'},
        },
      );

      final scope = authoritativeActivityTypes(event);
      expect(scope.declared, isTrue);
      expect(scope.types, isEmpty);
    });

    test('adds a projector scope while preserving full authority', () {
      const owned = MessagesSnapshotEvent(
        messages: [],
        metadata: {
          agUiClientMetadataKey: {'authoritativeActivityTypes': null},
        },
      );
      const scoped = MessagesSnapshotEvent(
        messages: [],
        metadata: {
          agUiClientMetadataKey: {
            'authoritativeActivityTypes': ['chart'],
          },
        },
      );

      expect(
        authoritativeActivityTypes(
          withAuthoritativeActivityTypes(owned, ['chart']),
        ).types,
        isNull,
      );
      expect(
        authoritativeActivityTypes(
          withAuthoritativeActivityTypes(scoped, ['map']),
        ).types,
        ['chart', 'map'],
      );
    });
  });
}

RunAgentInput _inputWithActivity() {
  return RunAgentInput(
    threadId: 'thread-1',
    runId: 'run-1',
    messages: const [
      ActivityMessage(
        id: 'activity-1',
        activityType: 'map',
        content: {'zoom': 1},
      ),
    ],
    tools: const [],
    context: const [],
  );
}
