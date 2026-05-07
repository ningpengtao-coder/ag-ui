import 'dart:async';

import 'package:ag_ui/ag_ui.dart';
import 'package:test/test.dart';

class TestAgent extends AbstractAgent {
  final List<BaseEvent> eventsToEmit;

  TestAgent({
    AgentConfig config = const AgentConfig(),
    this.eventsToEmit = const [],
  }) : super(config: config);

  @override
  AbstractAgent createClone() => TestAgent();

  @override
  Stream<BaseEvent> run(RunAgentInput input) => Stream<BaseEvent>.fromIterable(eventsToEmit);
}

class StreamingTestAgent extends AbstractAgent {
  StreamController<BaseEvent>? controller;

  StreamingTestAgent({
    AgentConfig config = const AgentConfig(),
  }) : super(config: config);

  @override
  AbstractAgent createClone() => StreamingTestAgent();

  @override
  Stream<BaseEvent> run(RunAgentInput input) {
    final activeController = controller;
    if (activeController == null) {
      throw StateError('controller must be set before run');
    }
    return activeController.stream;
  }
}

class ConnectTestAgent extends TestAgent {
  final List<BaseEvent> connectEventsToEmit;

  ConnectTestAgent({
    AgentConfig config = const AgentConfig(),
    List<BaseEvent> runEventsToEmit = const [],
    this.connectEventsToEmit = const [],
  }) : super(config: config, eventsToEmit: runEventsToEmit);

  @override
  AbstractAgent createClone() => ConnectTestAgent();

  @override
  Stream<BaseEvent> connect(RunAgentInput input) {
    return Stream<BaseEvent>.fromIterable(connectEventsToEmit);
  }
}

class ErrorTestAgent extends AbstractAgent {
  ErrorTestAgent({
    AgentConfig config = const AgentConfig(),
  }) : super(config: config);

  @override
  AbstractAgent createClone() => ErrorTestAgent();

  @override
  Stream<BaseEvent> run(RunAgentInput input) async* {
    throw StateError('Something went wrong');
  }
}

class RunThenErrorAgent extends AbstractAgent {
  RunThenErrorAgent({
    AgentConfig config = const AgentConfig(),
  }) : super(config: config);

  @override
  AbstractAgent createClone() => RunThenErrorAgent();

  @override
  Stream<BaseEvent> run(RunAgentInput input) async* {
    yield RunStartedEvent(threadId: input.threadId, runId: input.runId);
    throw StateError('Run exploded');
  }
}

void main() {
  group('AbstractAgent', () {
    test('clone preserves base fields and keeps state independent', () {
      final agent = TestAgent(
        config: const AgentConfig(
          agentId: 'agent-1',
          description: 'test agent',
          threadId: 'thread-1',
          initialMessages: [
            UserMessage(id: 'msg-1', content: 'hello'),
          ],
          initialState: {'count': 1},
        ),
      );
      agent.pendingInterrupts = const [
        Interrupt(id: 'int-1', reason: 'tool_call'),
      ];

      final cloned = agent.clone();

      expect(cloned, isA<TestAgent>());
      expect(cloned, isNot(same(agent)));
      expect(cloned.messages, isNot(same(agent.messages)));
      expect(cloned.messages.single.id, 'msg-1');
      expect(cloned.pendingInterrupts, isNot(same(agent.pendingInterrupts)));
      expect(cloned.pendingInterrupts.single.id, 'int-1');

      (cloned.state as Map<String, dynamic>)['count'] = 2;
      expect((agent.state as Map<String, dynamic>)['count'], 1);
    });

    test('chains subscriber mutations during initialization', () async {
      final order = <String>[];
      final agent = TestAgent(
        config: const AgentConfig(
          initialState: {'counter': 0},
        ),
        eventsToEmit: const [
          RunStartedEvent(threadId: 'thread-1', runId: 'run-1'),
        ],
      );

      agent.subscribe(
        AgentSubscriber(
          onRunInitialized: (context) {
            order.add('first');
            return const AgentStateMutation(state: {'step': 1});
          },
        ),
      );
      agent.subscribe(
        AgentSubscriber(
          onRunInitialized: (context) {
            order.add('second');
            expect(context.state, {'step': 1});
            return const AgentStateMutation(state: {'step': 2});
          },
        ),
      );

      await agent.runAgent(
        const RunAgentParameters(runId: 'run-1'),
      );

      expect(order, ['first', 'second']);
      expect(agent.state, {'step': 2});
    });

    test('subscribe handle removes only the targeted subscriber', () {
      final agent = TestAgent();
      final first = AgentSubscriber(onEvent: (_) => null);
      final second = AgentSubscriber(onEvent: (_) => null);

      final firstHandle = agent.subscribe(first);
      final secondHandle = agent.subscribe(second);

      expect(agent.subscribers, [first, second]);

      firstHandle.unsubscribe();
      expect(agent.subscribers, [second]);

      secondHandle.unsubscribe();
      expect(agent.subscribers, isEmpty);
    });

    test('temporary subscriber is combined with permanent subscribers', () async {
      final permanentCalls = <String>[];
      final temporaryCalls = <String>[];
      final agent = TestAgent(
        config: const AgentConfig(threadId: 'thread-1'),
        eventsToEmit: const [
          RunStartedEvent(threadId: 'thread-1', runId: 'run-1'),
          RunFinishedEvent(threadId: 'thread-1', runId: 'run-1'),
        ],
      );

      agent.subscribe(
        AgentSubscriber(
          onRunStartedEvent: (context) {
            permanentCalls.add(context.event.runId);
            return null;
          },
        ),
      );

      final temporary = AgentSubscriber(
        onRunStartedEvent: (context) {
          temporaryCalls.add(context.event.runId);
          return null;
        },
      );

      await agent.runAgent(const RunAgentParameters(runId: 'run-1'), temporary);

      expect(permanentCalls, ['run-1']);
      expect(temporaryCalls, ['run-1']);
    });

    test('notifies changed callbacks when subscriber returns new references with same content', () async {
      var messagesChangedCount = 0;
      var stateChangedCount = 0;
      final agent = TestAgent(
        config: const AgentConfig(
          initialMessages: [
            UserMessage(id: 'msg-1', content: 'hello'),
          ],
          initialState: {'count': 1},
        ),
        eventsToEmit: const [
          RunStartedEvent(threadId: 'thread-1', runId: 'run-1'),
        ],
      );

      agent.subscribe(
        AgentSubscriber(
          onRunInitialized: (context) => AgentStateMutation(
            messages: List<Message>.from(context.messages),
            state: Map<String, dynamic>.from(context.state! as Map),
          ),
          onMessagesChanged: (context) {
            messagesChangedCount++;
            return null;
          },
          onStateChanged: (context) {
            stateChangedCount++;
            return null;
          },
        ),
      );

      await agent.runAgent(const RunAgentParameters(runId: 'run-1'));

      expect(messagesChangedCount, 1);
      expect(stateChangedCount, 1);
      expect(agent.messages.single.id, 'msg-1');
      expect(agent.state, {'count': 1});
    });

    test('calls generic onEvent for every event', () async {
      final seen = <String>[];
      final agent = TestAgent(
        config: const AgentConfig(threadId: 'thread-1'),
        eventsToEmit: const [
          RunStartedEvent(threadId: 'thread-1', runId: 'run-1'),
          StateSnapshotEvent(snapshot: {'ready': true}),
          RunFinishedEvent(threadId: 'thread-1', runId: 'run-1'),
        ],
      );

      agent.subscribe(
        AgentSubscriber(
          onEvent: (context) {
            seen.add(context.event.type);
            return null;
          },
        ),
      );

      await agent.runAgent(const RunAgentParameters(runId: 'run-1'));

      expect(seen, ['RUN_STARTED', 'STATE_SNAPSHOT', 'RUN_FINISHED']);
    });

    test('returns result and new messages while exposing text buffers to subscribers', () async {
      final buffers = <String>[];
      final agent = TestAgent(
        config: const AgentConfig(threadId: 'thread-1'),
        eventsToEmit: const [
          RunStartedEvent(threadId: 'thread-1', runId: 'run-1'),
          TextMessageStartEvent(messageId: 'm1', role: TextMessageRole.assistant),
          TextMessageContentEvent(messageId: 'm1', delta: 'Hello'),
          TextMessageContentEvent(messageId: 'm1', delta: ' world'),
          TextMessageEndEvent(messageId: 'm1'),
          RunFinishedEvent(threadId: 'thread-1', runId: 'run-1', result: 'done'),
        ],
      );

      final subscriber = AgentSubscriber(
        onTextMessageContentEvent: (context) {
          buffers.add(context.textMessageBuffer ?? '');
          return null;
        },
      );

      final result = await agent.runAgent(
        const RunAgentParameters(runId: 'run-1'),
        subscriber,
      );

      expect(buffers, ['', 'Hello']);
      expect(result.result, 'done');
      expect(result.newMessages, hasLength(1));
      expect(result.newMessages.single.id, 'm1');
      expect(result.newMessages.single.content, 'Hello world');
    });

    test('exposes tool-call buffers and parsed args to subscribers', () async {
      final buffers = <String>[];
      final partialArgs = <Object?>[];
      final finalArgs = <Object?>[];
      final agent = TestAgent(
        config: const AgentConfig(threadId: 'thread-1'),
        eventsToEmit: const [
          RunStartedEvent(threadId: 'thread-1', runId: 'run-1'),
          ToolCallStartEvent(
            toolCallId: 'call-1',
            toolCallName: 'search',
            parentMessageId: 'msg-1',
          ),
          ToolCallArgsEvent(toolCallId: 'call-1', delta: '{"query":"te'),
          ToolCallArgsEvent(toolCallId: 'call-1', delta: 'st"}'),
          ToolCallEndEvent(toolCallId: 'call-1'),
          RunFinishedEvent(threadId: 'thread-1', runId: 'run-1'),
        ],
      );

      agent.subscribe(
        AgentSubscriber(
          onToolCallArgsEvent: (context) {
            buffers.add(context.toolCallBuffer ?? '');
            partialArgs.add(context.partialToolCallArgs);
            return null;
          },
          onToolCallEndEvent: (context) {
            finalArgs.add(context.toolCallArgs);
            return null;
          },
        ),
      );

      await agent.runAgent(const RunAgentParameters(runId: 'run-1'));

      expect(buffers, ['', '{"query":"te']);
      expect(partialArgs[0], '');
      expect(partialArgs[1], '{"query":"te');
      expect(finalArgs.single, {'query': 'test'});
    });

    test('connectAgent uses connect pipeline and ignores missing connect support', () async {
      final connected = ConnectTestAgent(
        config: const AgentConfig(threadId: 'thread-connect'),
        connectEventsToEmit: const [
          RunStartedEvent(threadId: 'thread-connect', runId: 'run-connect'),
          TextMessageStartEvent(messageId: 'm-connect', role: TextMessageRole.assistant),
          TextMessageContentEvent(messageId: 'm-connect', delta: 'connected'),
          TextMessageEndEvent(messageId: 'm-connect'),
          RunFinishedEvent(
            threadId: 'thread-connect',
            runId: 'run-connect',
            result: 'connected-result',
          ),
        ],
      );

      final connectedResult = await connected.connectAgent(
        const RunAgentParameters(runId: 'run-connect'),
      );

      expect(connectedResult.result, 'connected-result');
      expect(connectedResult.newMessages.map((message) => message.id), ['m-connect']);

      final notImplemented = TestAgent(
        config: const AgentConfig(threadId: 'thread-connect'),
      );
      final fallbackResult = await notImplemented.connectAgent(
        const RunAgentParameters(runId: 'run-connect-missing'),
      );

      expect(fallbackResult.result, isNull);
      expect(fallbackResult.newMessages, isEmpty);
    });

    test('accumulates messages across multiple sequential runs', () async {
      var agent = TestAgent(
        config: const AgentConfig(threadId: 'test-thread'),
        eventsToEmit: const [
          RunStartedEvent(threadId: 'test-thread', runId: 'run-1'),
          TextMessageStartEvent(messageId: 'msg-1', role: TextMessageRole.assistant),
          TextMessageContentEvent(messageId: 'msg-1', delta: 'Hello from run 1'),
          TextMessageEndEvent(messageId: 'msg-1'),
          RunFinishedEvent(threadId: 'test-thread', runId: 'run-1'),
        ],
      );

      final result1 = await agent.runAgent(const RunAgentParameters(runId: 'run-1'));
      expect(result1.newMessages.single.content, 'Hello from run 1');
      expect(agent.messages, hasLength(1));

      agent = TestAgent(
        config: AgentConfig(
          threadId: 'test-thread',
          initialMessages: List<Message>.from(agent.messages),
        ),
        eventsToEmit: const [
          RunStartedEvent(threadId: 'test-thread', runId: 'run-2'),
          TextMessageStartEvent(messageId: 'msg-2', role: TextMessageRole.assistant),
          TextMessageContentEvent(messageId: 'msg-2', delta: 'Hello from run 2'),
          TextMessageEndEvent(messageId: 'msg-2'),
          RunFinishedEvent(threadId: 'test-thread', runId: 'run-2'),
        ],
      );

      final result2 = await agent.runAgent(const RunAgentParameters(runId: 'run-2'));
      expect(result2.newMessages.single.content, 'Hello from run 2');
      expect(agent.messages.map((message) => message.id).toList(), ['msg-1', 'msg-2']);
    });

    test('handles concurrent text messages through full agent pipeline', () async {
      final agent = TestAgent(
        config: const AgentConfig(threadId: 'test'),
        eventsToEmit: const [
          RunStartedEvent(threadId: 'test', runId: 'test'),
          TextMessageStartEvent(messageId: 'msg1', role: TextMessageRole.assistant),
          TextMessageStartEvent(messageId: 'msg2', role: TextMessageRole.assistant),
          TextMessageContentEvent(messageId: 'msg1', delta: 'First message '),
          TextMessageContentEvent(messageId: 'msg2', delta: 'Second message '),
          TextMessageContentEvent(messageId: 'msg1', delta: 'content'),
          TextMessageContentEvent(messageId: 'msg2', delta: 'content'),
          TextMessageEndEvent(messageId: 'msg2'),
          TextMessageEndEvent(messageId: 'msg1'),
          RunFinishedEvent(threadId: 'test', runId: 'test'),
        ],
      );

      final result = await agent.runAgent();

      expect(result.newMessages, hasLength(2));
      final msg1 = result.newMessages.where((message) => message.id == 'msg1').single;
      final msg2 = result.newMessages.where((message) => message.id == 'msg2').single;
      expect(msg1.content, 'First message content');
      expect(msg2.content, 'Second message content');
    });

    test('handles concurrent tool calls through full agent pipeline', () async {
      final agent = TestAgent(
        config: const AgentConfig(threadId: 'test'),
        eventsToEmit: const [
          RunStartedEvent(threadId: 'test', runId: 'test'),
          ToolCallStartEvent(
            toolCallId: 'tool1',
            toolCallName: 'search',
            parentMessageId: 'msg1',
          ),
          ToolCallStartEvent(
            toolCallId: 'tool2',
            toolCallName: 'calculate',
            parentMessageId: 'msg2',
          ),
          ToolCallArgsEvent(toolCallId: 'tool1', delta: '{"query":'),
          ToolCallArgsEvent(toolCallId: 'tool2', delta: '{"expr":'),
          ToolCallArgsEvent(toolCallId: 'tool1', delta: '"test"}'),
          ToolCallArgsEvent(toolCallId: 'tool2', delta: '"1+1"}'),
          ToolCallEndEvent(toolCallId: 'tool1'),
          ToolCallEndEvent(toolCallId: 'tool2'),
          RunFinishedEvent(threadId: 'test', runId: 'test'),
        ],
      );

      final result = await agent.runAgent();

      expect(result.newMessages, hasLength(2));
      final msg1 = result.newMessages
          .whereType<AssistantMessage>()
          .where((message) => message.id == 'msg1')
          .single;
      final msg2 = result.newMessages
          .whereType<AssistantMessage>()
          .where((message) => message.id == 'msg2')
          .single;
      expect(msg1.toolCalls!.single.function.arguments, '{"query":"test"}');
      expect(msg2.toolCalls!.single.function.arguments, '{"expr":"1+1"}');
    });

    test('detachActiveRun finalizes before resolving and ignores later events', () async {
      final controller = StreamController<BaseEvent>();
      final order = <String>[];
      var messagesChangedCount = 0;
      final agent = StreamingTestAgent(
        config: const AgentConfig(threadId: 'thread-detach'),
      )..controller = controller;

      final runFuture = agent.runAgent(
        const RunAgentParameters(runId: 'run-detach'),
        AgentSubscriber(
          onMessagesChanged: (context) {
            messagesChangedCount++;
            return null;
          },
          onRunFinalized: (context) async {
            order.add('finalized');
            return null;
          },
        ),
      );

      await Future<void>.delayed(Duration.zero);
      controller.add(
        const RunStartedEvent(threadId: 'thread-detach', runId: 'run-detach'),
      );
      await Future<void>.delayed(Duration.zero);

      final detachFuture = agent.detachActiveRun().then((_) => order.add('awaited'));

      controller.add(
        const TextMessageStartEvent(
          messageId: 'msg-after-detach',
          role: TextMessageRole.assistant,
        ),
      );
      controller.add(
        const TextMessageContentEvent(
          messageId: 'msg-after-detach',
          delta: 'ignored',
        ),
      );
      controller.add(const TextMessageEndEvent(messageId: 'msg-after-detach'));
      await controller.close();

      await Future.wait([runFuture, detachFuture]);

      expect(order, ['finalized', 'awaited']);
      expect(messagesChangedCount, 0);
      expect(agent.messages.where((message) => message.id == 'msg-after-detach'), isEmpty);
    });

    test('continues processing later subscribers when one subscriber throws', () async {
      var recovered = false;
      final agent = TestAgent(
        config: const AgentConfig(threadId: 'thread-1'),
        eventsToEmit: const [
          RunStartedEvent(threadId: 'thread-1', runId: 'run-1'),
          TextMessageStartEvent(messageId: 'msg-1', role: TextMessageRole.assistant),
        ],
      );

      agent.subscribe(
        AgentSubscriber(
          onTextMessageStartEvent: (_) => throw StateError('subscriber failed'),
        ),
      );
      agent.subscribe(
        AgentSubscriber(
          onTextMessageStartEvent: (_) {
            recovered = true;
            return null;
          },
        ),
      );

      await agent.runAgent(const RunAgentParameters(runId: 'run-1'));

      expect(recovered, isTrue);
    });

    test('onRunFailed can stop propagation and still finalizes the run', () async {
      final calls = <String>[];
      final agent = RunThenErrorAgent(
        config: const AgentConfig(threadId: 'thread-err'),
      );

      agent.subscribe(
        AgentSubscriber(
          onRunFailed: (context) {
            calls.add('failed:${context.error}');
            return const AgentStateMutation(stopPropagation: true);
          },
          onRunFinalized: (context) {
            calls.add('finalized');
            return null;
          },
        ),
      );

      final result = await agent.runAgent(const RunAgentParameters(runId: 'run-err'));

      expect(result.result, isNull);
      expect(result.newMessages, isEmpty);
      expect(calls.length, 2);
      expect(calls.first, startsWith('failed:'));
      expect(calls.last, 'finalized');
    });

    test('debug config can be resolved at construction and toggled later', () {
      final agent = TestAgent(config: const AgentConfig(debug: true));
      expect(agent.debugLogger, isA<DebugLogger>());
      expect(
        agent.debug,
        const ResolvedAgentDebugConfig(
          enabled: true,
          events: true,
          lifecycle: true,
          verbose: true,
        ),
      );

      agent.debug = false;
      expect(agent.debugLogger, isNull);
      expect(
        agent.debug,
        const ResolvedAgentDebugConfig(
          enabled: false,
          events: false,
          lifecycle: false,
          verbose: false,
        ),
      );
    });

    test('runAgent emits lifecycle and pipeline debug logs when enabled', () async {
      final lines = <String>[];
      final agent = TestAgent(
        config: const AgentConfig(
          agentId: 'test-agent',
          threadId: 'thread-1',
          debug: true,
        ),
        eventsToEmit: const [
          RunStartedEvent(threadId: 'thread-1', runId: 'run-1'),
          TextMessageStartEvent(messageId: 'msg-1', role: TextMessageRole.assistant),
          TextMessageContentEvent(messageId: 'msg-1', delta: 'Hello'),
          TextMessageEndEvent(messageId: 'msg-1'),
          RunFinishedEvent(threadId: 'thread-1', runId: 'run-1'),
        ],
      );

      await runZoned(
        () => agent.runAgent(),
        zoneSpecification: ZoneSpecification(
          print: (_, __, ___, line) => lines.add(line),
        ),
      );

      expect(lines.any((line) => line.startsWith('[LIFECYCLE] Run started:')), isTrue);
      expect(lines.any((line) => line.startsWith('[LIFECYCLE] Run finished:')), isTrue);
      expect(lines.any((line) => line.startsWith('[VERIFY] Event:')), isTrue);
      expect(lines.any((line) => line.startsWith('[APPLY] Event applied:')), isTrue);
    });

    test('runAgent logs errors when lifecycle debugging is enabled', () async {
      final lines = <String>[];
      final agent = ErrorTestAgent(
        config: const AgentConfig(
          agentId: 'error-agent',
          threadId: 'thread-1',
          debug: true,
        ),
      );

      await expectLater(
        () => runZoned(
          () => agent.runAgent(),
          zoneSpecification: ZoneSpecification(
            print: (_, __, ___, line) => lines.add(line),
          ),
        ),
        throwsA(isA<StateError>()),
      );

      expect(lines.any((line) => line.startsWith('[LIFECYCLE] Run errored:')), isTrue);
    });
  });
}
