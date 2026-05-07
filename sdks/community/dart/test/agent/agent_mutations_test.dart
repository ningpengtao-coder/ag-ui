import 'dart:async';

import 'package:ag_ui/ag_ui.dart';
import 'package:test/test.dart';

class MutationTestAgent extends AbstractAgent {
  MutationTestAgent({
    AgentConfig config = const AgentConfig(),
  }) : super(config: config);

  @override
  AbstractAgent createClone() => MutationTestAgent();

  @override
  Stream<BaseEvent> run(RunAgentInput input) => const Stream<BaseEvent>.empty();
}

Future<void> pumpAsyncNotifications() async {
  for (var i = 0; i < 4; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('AbstractAgent mutation helpers', () {
    late MutationTestAgent agent;
    late List<String> callOrder;
    late List<ToolCall> seenToolCalls;
    var newMessageCount = 0;
    var messagesChangedCount = 0;
    var stateChangedCount = 0;

    setUp(() {
      callOrder = <String>[];
      seenToolCalls = <ToolCall>[];
      newMessageCount = 0;
      messagesChangedCount = 0;
      stateChangedCount = 0;

      agent = MutationTestAgent(
        config: const AgentConfig(
          threadId: 'thread-mutations',
          initialMessages: [
            UserMessage(id: 'initial-msg', content: 'Initial message'),
          ],
          initialState: {'counter': 0},
        ),
      );

      agent.subscribe(
        AgentSubscriber(
          onNewMessage: (context) {
            newMessageCount++;
            callOrder.add('newMessage:${context.message.id}');
          },
          onMessagesChanged: (context) {
            messagesChangedCount++;
            callOrder.add('messagesChanged');
          },
          onStateChanged: (context) {
            stateChangedCount++;
            callOrder.add('stateChanged');
          },
          onNewToolCall: (context) {
            seenToolCalls.add(context.toolCall);
            callOrder.add('toolCall:${context.toolCall.id}');
          },
        ),
      );
    });

    test('addMessage notifies new message and messages changed for user message', () async {
      agent.addMessage(
        const UserMessage(id: 'user-msg-1', content: 'Hello world'),
      );

      expect(agent.messages, hasLength(2));
      expect(agent.messages.last.id, 'user-msg-1');

      await pumpAsyncNotifications();

      expect(newMessageCount, 1);
      expect(messagesChangedCount, 1);
      expect(stateChangedCount, 0);
      expect(seenToolCalls, isEmpty);
      expect(callOrder, ['newMessage:user-msg-1', 'messagesChanged']);
    });

    test('addMessage notifies each tool call before messages changed', () async {
      agent.addMessage(
        const AssistantMessage(
          id: 'assistant-msg-1',
          content: 'Let me help',
          toolCalls: [
            ToolCall(
              id: 'call-1',
              type: 'function',
              function: FunctionCall(
                name: 'get_weather',
                arguments: '{"location":"New York"}',
              ),
            ),
            ToolCall(
              id: 'call-2',
              type: 'function',
              function: FunctionCall(
                name: 'search_web',
                arguments: '{"query":"latest news"}',
              ),
            ),
          ],
        ),
      );

      await pumpAsyncNotifications();

      expect(newMessageCount, 1);
      expect(messagesChangedCount, 1);
      expect(seenToolCalls.map((toolCall) => toolCall.id), ['call-1', 'call-2']);
      expect(
        callOrder,
        [
          'newMessage:assistant-msg-1',
          'toolCall:call-1',
          'toolCall:call-2',
          'messagesChanged',
        ],
      );
    });

    test('addMessages emits one messages changed callback and handles empty list', () async {
      agent.addMessages(
        const [
          UserMessage(id: 'msg-1', content: 'First'),
          AssistantMessage(
            id: 'msg-2',
            content: 'Second',
            toolCalls: [
              ToolCall(
                id: 'call-1',
                type: 'function',
                function: FunctionCall(
                  name: 'test_tool',
                  arguments: '{"param":"value"}',
                ),
              ),
            ],
          ),
          UserMessage(id: 'msg-3', content: 'Third'),
        ],
      );

      await pumpAsyncNotifications();

      expect(newMessageCount, 3);
      expect(messagesChangedCount, 1);
      expect(seenToolCalls.map((toolCall) => toolCall.id), ['call-1']);

      callOrder.clear();
      seenToolCalls.clear();
      newMessageCount = 0;
      messagesChangedCount = 0;

      agent.addMessages(const []);
      await pumpAsyncNotifications();

      expect(newMessageCount, 0);
      expect(messagesChangedCount, 1);
      expect(seenToolCalls, isEmpty);
      expect(callOrder, ['messagesChanged']);
    });

    test('setMessages only emits messages changed', () async {
      agent.setMessages(
        const [
          UserMessage(id: 'new-msg-1', content: 'New conversation start'),
          AssistantMessage(id: 'new-msg-2', content: 'Assistant response'),
        ],
      );

      await pumpAsyncNotifications();

      expect(agent.messages.map((message) => message.id), ['new-msg-1', 'new-msg-2']);
      expect(newMessageCount, 0);
      expect(messagesChangedCount, 1);
      expect(stateChangedCount, 0);
      expect(seenToolCalls, isEmpty);
      expect(callOrder, ['messagesChanged']);
    });

    test('setState clones state and only emits state changed', () async {
      final nextState = {
        'counter': 100,
        'isActive': true,
      };

      agent.setState(nextState);

      await pumpAsyncNotifications();

      expect(agent.state, nextState);
      expect(identical(agent.state, nextState), isFalse);
      expect(newMessageCount, 0);
      expect(messagesChangedCount, 0);
      expect(stateChangedCount, 1);
      expect(callOrder, ['stateChanged']);
    });

    test('notifies subscribers in registration order for addMessage', () async {
      final orderedAgent = MutationTestAgent();
      final orderedCalls = <String>[];

      orderedAgent.subscribe(
        AgentSubscriber(
          onNewMessage: (context) => orderedCalls.add('first-newMessage'),
          onMessagesChanged: (context) => orderedCalls.add('first-messagesChanged'),
        ),
      );
      orderedAgent.subscribe(
        AgentSubscriber(
          onNewMessage: (context) => orderedCalls.add('second-newMessage'),
          onMessagesChanged: (context) => orderedCalls.add('second-messagesChanged'),
        ),
      );

      orderedAgent.addMessage(
        const UserMessage(id: 'test-msg', content: 'Test message'),
      );

      var attempts = 0;
      while (orderedCalls.length < 4 && attempts < 20) {
        attempts++;
        await pumpAsyncNotifications();
      }

      expect(
        orderedCalls,
        [
          'first-newMessage',
          'second-newMessage',
          'first-messagesChanged',
          'second-messagesChanged',
        ],
      );
    });
  });
}
