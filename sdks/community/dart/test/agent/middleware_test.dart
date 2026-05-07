import 'package:ag_ui/ag_ui.dart';
import 'package:test/test.dart';

class MiddlewareTestAgent extends AbstractAgent {
  final List<BaseEvent> eventsToEmit;

  MiddlewareTestAgent({
    this.eventsToEmit = const [],
  }) : super(
         config: const AgentConfig(
           threadId: 'thread-1',
           initialState: {'value': 0},
         ),
       );

  @override
  AbstractAgent createClone() => MiddlewareTestAgent();

  @override
  Stream<BaseEvent> run(RunAgentInput input) => Stream<BaseEvent>.fromIterable(eventsToEmit);
}

class TrackingMiddleware extends Middleware {
  final List<Object?> seenStates = [];

  @override
  Stream<BaseEvent> run(RunAgentInput input, AbstractAgent next) async* {
    await for (final item in runNextWithState(input, next)) {
      seenStates.add(item.state);
      yield item.event;
    }
  }
}

class StateCapturingMiddleware extends Middleware {
  List<Message> capturedMessages = const [];
  Object? capturedState;
  final List<EventWithState> seen = [];

  @override
  Stream<BaseEvent> run(RunAgentInput input, AbstractAgent next) async* {
    await for (final item in runNextWithState(input, next)) {
      seen.add(item);
      if (item.event is RunFinishedEvent) {
        capturedMessages = item.messages;
        capturedState = item.state;
      }
      yield item.event;
    }
  }
}

class PassThroughMiddleware extends Middleware {
  bool invoked = false;

  @override
  Stream<BaseEvent> run(RunAgentInput input, AbstractAgent next) {
    invoked = true;
    return runNext(input, next);
  }
}

class EventInjectingMiddleware extends Middleware {
  @override
  Stream<BaseEvent> run(RunAgentInput input, AbstractAgent next) async* {
    await for (final event in runNext(input, next)) {
      yield event;
      if (event is RunStartedEvent) {
        yield const StateSnapshotEvent(snapshot: {'injected': true});
      }
    }
  }
}

class ToolCallingAgent extends AbstractAgent {
  ToolCallingAgent() : super(config: const AgentConfig(threadId: 'thread-1'));

  @override
  AbstractAgent createClone() => ToolCallingAgent();

  @override
  Stream<BaseEvent> run(RunAgentInput input) => Stream<BaseEvent>.fromIterable(const [
    RunStartedEvent(threadId: 'thread-1', runId: 'run-1'),
    ToolCallStartEvent(
      toolCallId: 'tool-call-1',
      toolCallName: 'calculator',
      parentMessageId: 'message-1',
    ),
    ToolCallArgsEvent(
      toolCallId: 'tool-call-1',
      delta: '{"operation":"add"}',
    ),
    ToolCallEndEvent(toolCallId: 'tool-call-1'),
    ToolCallResultEvent(
      messageId: 'tool-message-1',
      toolCallId: 'tool-call-1',
      content: '8',
    ),
    ToolCallStartEvent(
      toolCallId: 'tool-call-2',
      toolCallName: 'weather',
      parentMessageId: 'message-2',
    ),
    ToolCallArgsEvent(
      toolCallId: 'tool-call-2',
      delta: '{"city":"New York"}',
    ),
    ToolCallEndEvent(toolCallId: 'tool-call-2'),
    ToolCallResultEvent(
      messageId: 'tool-message-2',
      toolCallId: 'tool-call-2',
      content: 'Sunny',
    ),
    RunFinishedEvent(threadId: 'thread-1', runId: 'run-1'),
  ]);
}

class CapturingAgent extends AbstractAgent {
  final List<BaseEvent> eventsToEmit;
  RunAgentInput? receivedInput;

  CapturingAgent({
    this.eventsToEmit = const [],
  }) : super(config: const AgentConfig(threadId: 'thread-1'));

  @override
  AbstractAgent createClone() => CapturingAgent(eventsToEmit: eventsToEmit);

  @override
  Stream<BaseEvent> run(RunAgentInput input) {
    receivedInput = input;
    return Stream<BaseEvent>.fromIterable(eventsToEmit);
  }
}

class LegacyInputAgent extends AbstractAgent {
  RunAgentInput? receivedInput;

  LegacyInputAgent({
    required List<Message> initialMessages,
  }) : super(
         config: AgentConfig(
           threadId: 'thread-1',
           initialMessages: initialMessages,
         ),
       );

  @override
  String get maxVersion => '0.0.39';

  @override
  AbstractAgent createClone() => LegacyInputAgent(initialMessages: const []);

  @override
  Stream<BaseEvent> run(RunAgentInput input) {
    receivedInput = input;
    return Stream<BaseEvent>.fromIterable([
      RunStartedEvent(threadId: input.threadId, runId: input.runId),
    ]);
  }

  @override
  RunAgentInput prepareRunAgentInput(RunAgentParameters parameters) {
    final prepared = super.prepareRunAgentInput(parameters);
    return RunAgentInput(
      threadId: prepared.threadId,
      runId: prepared.runId,
      parentRunId: 'legacy-parent',
      state: prepared.state,
      messages: prepared.messages,
      tools: prepared.tools,
      context: prepared.context,
      forwardedProps: prepared.forwardedProps,
      resume: prepared.resume,
    );
  }
}

class LegacyThinkingAgent extends AbstractAgent {
  LegacyThinkingAgent() : super(config: const AgentConfig(threadId: 'thread-1'));

  @override
  String get maxVersion => '0.0.45';

  @override
  AbstractAgent createClone() => LegacyThinkingAgent();

  @override
  Stream<BaseEvent> run(RunAgentInput input) => Stream<BaseEvent>.fromIterable([
    RunStartedEvent(threadId: input.threadId, runId: input.runId),
    const ThinkingStartEvent(),
    const ThinkingTextMessageStartEvent(),
    const ThinkingTextMessageContentEvent(delta: 'thinking'),
    const ThinkingTextMessageEndEvent(),
    const ThinkingEndEvent(),
    RunFinishedEvent(threadId: input.threadId, runId: input.runId),
  ]);
}

class LegacyBinaryAgent extends AbstractAgent {
  RunAgentInput? receivedInput;

  LegacyBinaryAgent({
    required List<Message> initialMessages,
  }) : super(
         config: AgentConfig(
           threadId: 'thread-1',
           initialMessages: initialMessages,
         ),
       );

  @override
  String get maxVersion => '0.0.47';

  @override
  AbstractAgent createClone() => LegacyBinaryAgent(initialMessages: const []);

  @override
  Stream<BaseEvent> run(RunAgentInput input) {
    receivedInput = input;
    return Stream<BaseEvent>.fromIterable([
      RunStartedEvent(threadId: input.threadId, runId: input.runId),
    ]);
  }
}

class TextChunkAgent extends AbstractAgent {
  TextChunkAgent({
    AgentConfig config = const AgentConfig(threadId: 'thread-1'),
  }) : super(config: config);

  @override
  AbstractAgent createClone() => TextChunkAgent();

  @override
  Stream<BaseEvent> run(RunAgentInput input) => Stream<BaseEvent>.fromIterable([
    RunStartedEvent(threadId: input.threadId, runId: input.runId),
    const TextMessageChunkEvent(
      messageId: 'msg-1',
      role: TextMessageRole.assistant,
      delta: 'Hello from agent',
    ),
    RunFinishedEvent(threadId: input.threadId, runId: input.runId),
  ]);
}

class ToolCallChunkAgent extends AbstractAgent {
  ToolCallChunkAgent({
    AgentConfig config = const AgentConfig(threadId: 'thread-1'),
  }) : super(config: config);

  @override
  AbstractAgent createClone() => ToolCallChunkAgent();

  @override
  Stream<BaseEvent> run(RunAgentInput input) => Stream<BaseEvent>.fromIterable([
    RunStartedEvent(threadId: input.threadId, runId: input.runId),
    const ToolCallChunkEvent(
      toolCallId: 'tc-1',
      toolCallName: 'get_weather',
      parentMessageId: 'msg-1',
      delta: '{"city":"NYC"}',
    ),
    const ToolCallResultEvent(
      messageId: 'tool-result-1',
      toolCallId: 'tc-1',
      content: '72F',
    ),
    RunFinishedEvent(threadId: input.threadId, runId: input.runId),
  ]);
}

class TextAndStateAgent extends AbstractAgent {
  TextAndStateAgent({
    AgentConfig config = const AgentConfig(threadId: 'thread-1'),
  }) : super(config: config);

  @override
  AbstractAgent createClone() => TextAndStateAgent();

  @override
  Stream<BaseEvent> run(RunAgentInput input) => Stream<BaseEvent>.fromIterable([
    RunStartedEvent(threadId: input.threadId, runId: input.runId),
    const StateSnapshotEvent(snapshot: {'temperature': 72}),
    const TextMessageChunkEvent(
      messageId: 'msg-1',
      role: TextMessageRole.assistant,
      delta: 'Weather is nice',
    ),
    const StateDeltaEvent(
      delta: [
        {'op': 'replace', 'path': '/temperature', 'value': 75},
      ],
    ),
    RunFinishedEvent(threadId: input.threadId, runId: input.runId),
  ]);
}

class MessagesSnapshotAgent extends AbstractAgent {
  MessagesSnapshotAgent({
    AgentConfig config = const AgentConfig(threadId: 'thread-1'),
  }) : super(config: config);

  @override
  AbstractAgent createClone() => MessagesSnapshotAgent();

  @override
  Stream<BaseEvent> run(RunAgentInput input) => Stream<BaseEvent>.fromIterable([
    RunStartedEvent(threadId: input.threadId, runId: input.runId),
    const TextMessageStartEvent(
      messageId: 'msg-1',
      role: TextMessageRole.assistant,
    ),
    const TextMessageContentEvent(messageId: 'msg-1', delta: 'original'),
    const TextMessageEndEvent(messageId: 'msg-1'),
    const MessagesSnapshotEvent(
      messages: [
        UserMessage(id: 'snap-1', content: 'question'),
        AssistantMessage(id: 'snap-2', content: 'answer'),
      ],
    ),
    RunFinishedEvent(threadId: input.threadId, runId: input.runId),
  ]);
}

void main() {
  group('Middleware', () {
    test('runNextWithState observes post-apply state', () async {
      final middleware = TrackingMiddleware();
      final agent = MiddlewareTestAgent(
        eventsToEmit: const [
          RunStartedEvent(threadId: 'thread-1', runId: 'run-1'),
          StateSnapshotEvent(snapshot: {'value': 5}),
          RunFinishedEvent(threadId: 'thread-1', runId: 'run-1'),
        ],
      )..use(middleware);

      await agent.runAgent(const RunAgentParameters(runId: 'run-1'));

      expect(middleware.seenStates, hasLength(3));
      expect(middleware.seenStates[0], {'value': 0});
      expect(middleware.seenStates[1], {'value': 5});
      expect(middleware.seenStates[2], {'value': 5});
    });

    test('FilterToolCallsMiddleware filters disallowed tools', () async {
      final agent = ToolCallingAgent();
      final middleware = FilterToolCallsMiddleware(
        disallowedToolCalls: const ['calculator'],
      );

      final events = await middleware
          .run(
            RunAgentInput(
              threadId: 'thread-1',
              runId: 'run-1',
              state: const {},
              messages: const [],
              tools: const [],
              context: const [],
              forwardedProps: const {},
            ),
            agent,
          )
          .toList();

      final toolStarts = events.whereType<ToolCallStartEvent>().toList();
      expect(toolStarts, hasLength(1));
      expect(toolStarts.single.toolCallName, 'weather');
    });

    test('FilterToolCallsMiddleware keeps only allowed tools', () async {
      final agent = ToolCallingAgent();
      final middleware = FilterToolCallsMiddleware(
        allowedToolCalls: const ['calculator'],
      );

      final events = await middleware
          .run(
            RunAgentInput(
              threadId: 'thread-1',
              runId: 'run-1',
              state: const {},
              messages: const [],
              tools: const [],
              context: const [],
              forwardedProps: const {},
            ),
            agent,
          )
          .toList();

      final toolStarts = events.whereType<ToolCallStartEvent>().toList();
      expect(toolStarts, hasLength(1));
      expect(toolStarts.single.toolCallName, 'calculator');
      expect(events.first, isA<RunStartedEvent>());
      expect(events.last, isA<RunFinishedEvent>());
    });

    test('auto inserts 0.0.39 compatibility middleware', () async {
      final agent = LegacyInputAgent(
        initialMessages: [
          UserMessage(
            id: 'msg-1',
            content: const [
              TextInputContent(text: 'Hello '),
              TextInputContent(text: 'world!'),
              BinaryInputContent(mimeType: 'text/plain', data: 'ignored'),
            ],
          ),
          const AssistantMessage(id: 'msg-2'),
        ],
      );

      await agent.runAgent(const RunAgentParameters(runId: 'run-1'));

      expect(agent.receivedInput, isNotNull);
      expect(agent.receivedInput!.parentRunId, isNull);
      expect(agent.receivedInput!.messages[0].content, 'Hello world!');
      expect(agent.receivedInput!.messages[1].content, '');
    });

    test('auto inserts 0.0.45 compatibility middleware', () async {
      final agent = LegacyThinkingAgent();

      final result = await agent.runAgent(const RunAgentParameters(runId: 'run-1'));

      expect(result.newMessages.whereType<ReasoningMessage>(), hasLength(1));
      expect(result.newMessages.whereType<ReasoningMessage>().single.content, 'thinking');
    });

    test('BackwardCompatibility_0_0_45 transforms a complete thinking flow', () async {
      final middleware = BackwardCompatibility_0_0_45();
      final agent = CapturingAgent(
        eventsToEmit: const [
          RunStartedEvent(threadId: 'thread-1', runId: 'run-1'),
          ThinkingStartEvent(title: 'Analyzing'),
          ThinkingTextMessageStartEvent(),
          ThinkingTextMessageContentEvent(delta: 'step 1'),
          ThinkingTextMessageContentEvent(delta: 'step 2'),
          ThinkingTextMessageEndEvent(),
          ThinkingEndEvent(),
          RunFinishedEvent(threadId: 'thread-1', runId: 'run-1'),
        ],
      );

      final events = await middleware
          .run(
            RunAgentInput(
              threadId: 'thread-1',
              runId: 'run-1',
              state: const {},
              messages: const [],
              tools: const [],
              context: const [],
              forwardedProps: const {},
            ),
            agent,
          )
          .toList();

      expect(events.map((event) => event.type), [
        'RUN_STARTED',
        'REASONING_START',
        'REASONING_MESSAGE_START',
        'REASONING_MESSAGE_CONTENT',
        'REASONING_MESSAGE_CONTENT',
        'REASONING_MESSAGE_END',
        'REASONING_END',
        'RUN_FINISHED',
      ]);

      final reasoningStart = events[1] as ReasoningStartEvent;
      final reasoningMessageStart = events[2] as ReasoningMessageStartEvent;
      expect(reasoningStart.messageId, isNotEmpty);
      expect((events[6] as ReasoningEndEvent).messageId, reasoningStart.messageId);
      expect(reasoningMessageStart.role, 'assistant');
      expect((events[3] as ReasoningMessageContentEvent).messageId, reasoningMessageStart.messageId);
      expect((events[4] as ReasoningMessageContentEvent).messageId, reasoningMessageStart.messageId);
      expect((events[5] as ReasoningMessageEndEvent).messageId, reasoningMessageStart.messageId);
    });

    test('BackwardCompatibility_0_0_45 passes through non-thinking events unchanged', () async {
      final middleware = BackwardCompatibility_0_0_45();
      final agent = CapturingAgent(
        eventsToEmit: const [
          TextMessageStartEvent(messageId: 'msg-1', role: TextMessageRole.assistant),
          TextMessageContentEvent(messageId: 'msg-1', delta: 'Hello'),
          TextMessageEndEvent(messageId: 'msg-1'),
        ],
      );

      final events = await middleware
          .run(
            RunAgentInput(
              threadId: 'thread-1',
              runId: 'run-1',
              state: const {},
              messages: const [],
              tools: const [],
              context: const [],
              forwardedProps: const {},
            ),
            agent,
          )
          .toList();

      expect(events, hasLength(3));
      expect(events[0], isA<TextMessageStartEvent>());
      expect(events[1], isA<TextMessageContentEvent>());
      expect(events[2], isA<TextMessageEndEvent>());
    });

    test('auto inserts 0.0.47 compatibility middleware', () async {
      final agent = LegacyBinaryAgent(
        initialMessages: [
          UserMessage(
            id: 'msg-1',
            content: const [
              BinaryInputContent(
                mimeType: 'image/png',
                data: 'iVBORw0KGgo=',
              ),
            ],
          ),
        ],
      );

      await agent.runAgent(const RunAgentParameters(runId: 'run-1'));

      final content = agent.receivedInput!.messages.single.content as List;
      expect(content.single, isA<ImageInputContent>());
      expect((content.single as ImageInputContent).source, isA<InputContentDataSource>());
    });

    test('BackwardCompatibility_0_0_47 passes through plain string content unchanged', () async {
      final middleware = BackwardCompatibility_0_0_47();
      final agent = CapturingAgent();

      await middleware
          .run(
            RunAgentInput(
              threadId: 'thread-1',
              runId: 'run-1',
              state: const {},
              messages: const [
                UserMessage(id: 'msg-1', content: 'hello world'),
              ],
              tools: const [],
              context: const [],
              forwardedProps: const {},
            ),
            agent,
          )
          .drain<void>();

      expect(agent.receivedInput!.messages.single.content, 'hello world');
    });

    test('BackwardCompatibility_0_0_47 passes through text content parts unchanged', () async {
      final middleware = BackwardCompatibility_0_0_47();
      final agent = CapturingAgent();

      await middleware
          .run(
            RunAgentInput(
              threadId: 'thread-1',
              runId: 'run-1',
              state: const {},
              messages: const [
                UserMessage(
                  id: 'msg-1',
                  content: [TextInputContent(text: 'hello')],
                ),
              ],
              tools: const [],
              context: const [],
              forwardedProps: const {},
            ),
            agent,
          )
          .drain<void>();

      final content = agent.receivedInput!.messages.single.content as List;
      expect(content.single, const TextInputContent(text: 'hello'));
    });

    test('BackwardCompatibility_0_0_47 upgrades binary url audio content', () async {
      final middleware = BackwardCompatibility_0_0_47();
      final agent = CapturingAgent();

      await middleware
          .run(
            RunAgentInput(
              threadId: 'thread-1',
              runId: 'run-1',
              state: const {},
              messages: const [
                UserMessage(
                  id: 'msg-1',
                  content: [
                    BinaryInputContent(
                      mimeType: 'audio/mp3',
                      url: 'https://example.com/audio.mp3',
                    ),
                  ],
                ),
              ],
              tools: const [],
              context: const [],
              forwardedProps: const {},
            ),
            agent,
          )
          .drain<void>();

      final content = agent.receivedInput!.messages.single.content as List;
      expect(content.single, isA<AudioInputContent>());
      final source = (content.single as AudioInputContent).source as InputContentUrlSource;
      expect(source.value, 'https://example.com/audio.mp3');
      expect(source.mimeType, 'audio/mp3');
    });

    test('BackwardCompatibility_0_0_47 upgrades video and document binary content', () async {
      final middleware = BackwardCompatibility_0_0_47();
      final agent = CapturingAgent();

      await middleware
          .run(
            RunAgentInput(
              threadId: 'thread-1',
              runId: 'run-1',
              state: const {},
              messages: const [
                UserMessage(
                  id: 'msg-1',
                  content: [
                    BinaryInputContent(mimeType: 'video/mp4', data: 'AAAA'),
                    BinaryInputContent(
                      mimeType: 'application/pdf',
                      url: 'https://example.com/doc.pdf',
                    ),
                  ],
                ),
              ],
              tools: const [],
              context: const [],
              forwardedProps: const {},
            ),
            agent,
          )
          .drain<void>();

      final content = agent.receivedInput!.messages.single.content as List;
      expect(content[0], isA<VideoInputContent>());
      expect(content[1], isA<DocumentInputContent>());
    });

    test('BackwardCompatibility_0_0_47 preserves filename metadata and prefers data over url', () async {
      final middleware = BackwardCompatibility_0_0_47();
      final agent = CapturingAgent();

      await middleware
          .run(
            RunAgentInput(
              threadId: 'thread-1',
              runId: 'run-1',
              state: const {},
              messages: const [
                UserMessage(
                  id: 'msg-1',
                  content: [
                    BinaryInputContent(
                      mimeType: 'image/jpeg',
                      data: 'base64data',
                      url: 'https://example.com/photo.jpg',
                      filename: 'photo.jpg',
                    ),
                  ],
                ),
              ],
              tools: const [],
              context: const [],
              forwardedProps: const {},
            ),
            agent,
          )
          .drain<void>();

      final content = agent.receivedInput!.messages.single.content as List;
      final image = content.single as ImageInputContent;
      expect(image.metadata, {'filename': 'photo.jpg'});
      expect(image.source, isA<InputContentDataSource>());
      expect((image.source as InputContentDataSource).value, 'base64data');
    });

    test('BackwardCompatibility_0_0_47 leaves id-only binary content unchanged', () async {
      final middleware = BackwardCompatibility_0_0_47();
      final agent = CapturingAgent();

      await middleware
          .run(
            RunAgentInput(
              threadId: 'thread-1',
              runId: 'run-1',
              state: const {},
              messages: const [
                UserMessage(
                  id: 'msg-1',
                  content: [
                    BinaryInputContent(
                      mimeType: 'image/png',
                      id: 'file-123',
                    ),
                  ],
                ),
              ],
              tools: const [],
              context: const [],
              forwardedProps: const {},
            ),
            agent,
          )
          .drain<void>();

      final content = agent.receivedInput!.messages.single.content as List;
      expect(content.single, isA<BinaryInputContent>());
      expect((content.single as BinaryInputContent).id, 'file-123');
    });

    test('BackwardCompatibility_0_0_47 upgrades only legacy binary parts in mixed user content', () async {
      final middleware = BackwardCompatibility_0_0_47();
      final agent = CapturingAgent();

      await middleware
          .run(
            RunAgentInput(
              threadId: 'thread-1',
              runId: 'run-1',
              state: const {},
              messages: const [
                UserMessage(
                  id: 'msg-1',
                  content: [
                    TextInputContent(text: 'Look at this:'),
                    BinaryInputContent(mimeType: 'image/png', data: 'imgdata'),
                    ImageInputContent(
                      source: InputContentUrlSource(value: 'https://example.com/img.png'),
                    ),
                  ],
                ),
              ],
              tools: const [],
              context: const [],
              forwardedProps: const {},
            ),
            agent,
          )
          .drain<void>();

      final content = agent.receivedInput!.messages.single.content as List;
      expect(content, hasLength(3));
      expect(content[0], const TextInputContent(text: 'Look at this:'));
      expect(content[1], isA<ImageInputContent>());
      expect(content[2], isA<ImageInputContent>());
      expect(((content[1] as ImageInputContent).source as InputContentDataSource).value, 'imgdata');
      expect(((content[2] as ImageInputContent).source as InputContentUrlSource).value, 'https://example.com/img.png');
    });

    test('BackwardCompatibility_0_0_47 does not modify non-user messages', () async {
      final middleware = BackwardCompatibility_0_0_47();
      final agent = CapturingAgent();

      const assistant = AssistantMessage(id: 'msg-1', content: 'hi');
      const system = SystemMessage(id: 'msg-2', content: 'You are helpful');

      await middleware
          .run(
            RunAgentInput(
              threadId: 'thread-1',
              runId: 'run-1',
              state: const {},
              messages: const [assistant, system],
              tools: const [],
              context: const [],
              forwardedProps: const {},
            ),
            agent,
          )
          .drain<void>();

      expect(agent.receivedInput!.messages[0], same(assistant));
      expect(agent.receivedInput!.messages[1], same(system));
    });

    test('chained middlewares track text messages through runAgent', () async {
      final outer = StateCapturingMiddleware();
      final inner = StateCapturingMiddleware();
      final agent = TextChunkAgent()
        ..use(outer)
        ..use(inner);

      final result = await agent.runAgent(const RunAgentParameters(runId: 'run-1'));

      expect(result.newMessages, hasLength(1));
      expect(result.newMessages.single, isA<AssistantMessage>());
      expect(result.newMessages.single.content, 'Hello from agent');

      for (final middleware in [outer, inner]) {
        expect(middleware.capturedMessages, hasLength(1));
        expect(middleware.capturedMessages.single, isA<AssistantMessage>());
        expect(middleware.capturedMessages.single.content, 'Hello from agent');
      }
    });

    test('chained middlewares track tool-call chunk expansion and tool result', () async {
      final outer = StateCapturingMiddleware();
      final inner = StateCapturingMiddleware();
      final agent = ToolCallChunkAgent()
        ..use(outer)
        ..use(inner);

      await agent.runAgent(const RunAgentParameters(runId: 'run-1'));

      for (final middleware in [outer, inner]) {
        expect(middleware.capturedMessages, hasLength(2));
        final assistant = middleware.capturedMessages.first as AssistantMessage;
        expect(assistant.toolCalls, hasLength(1));
        expect(assistant.toolCalls!.single.id, 'tc-1');
        expect(assistant.toolCalls!.single.function.name, 'get_weather');
        expect(assistant.toolCalls!.single.function.arguments, '{"city":"NYC"}');

        final tool = middleware.capturedMessages.last as ToolMessage;
        expect(tool.content, '72F');
        expect(tool.toolCallId, 'tc-1');
      }
    });

    test('chained middlewares propagate state snapshot and state delta', () async {
      final outer = StateCapturingMiddleware();
      final inner = StateCapturingMiddleware();
      final agent = TextAndStateAgent()
        ..use(outer)
        ..use(inner);

      await agent.runAgent(const RunAgentParameters(runId: 'run-1'));

      expect(inner.capturedState, {'temperature': 75});
      expect(outer.capturedState, {'temperature': 75});
      expect(inner.capturedMessages.single.content, 'Weather is nice');
      expect(outer.capturedMessages.single.content, 'Weather is nice');

      final snapshotSeen = inner.seen.where((item) => item.event is StateSnapshotEvent).single;
      final deltaSeen = inner.seen.where((item) => item.event is StateDeltaEvent).single;
      expect(snapshotSeen.state, {'temperature': 72});
      expect(deltaSeen.state, {'temperature': 75});
    });

    test('chained middlewares observe messages snapshot replacement', () async {
      final outer = StateCapturingMiddleware();
      final inner = StateCapturingMiddleware();
      final agent = MessagesSnapshotAgent()
        ..use(outer)
        ..use(inner);

      await agent.runAgent(const RunAgentParameters(runId: 'run-1'));

      for (final middleware in [outer, inner]) {
        expect(middleware.capturedMessages, hasLength(2));
        expect(middleware.capturedMessages[0].id, 'snap-1');
        expect(middleware.capturedMessages[0].content, 'question');
        expect(middleware.capturedMessages[1].id, 'snap-2');
        expect(middleware.capturedMessages[1].content, 'answer');
      }
    });

    test('mixed middleware chains preserve injected state', () async {
      final capturing = StateCapturingMiddleware();
      final passThrough = PassThroughMiddleware();
      final injecting = EventInjectingMiddleware();
      final agent = TextChunkAgent()
        ..use(capturing)
        ..use(passThrough)
        ..use(injecting);

      await agent.runAgent(const RunAgentParameters(runId: 'run-1'));

      expect(passThrough.invoked, isTrue);
      expect(capturing.capturedMessages.single.content, 'Hello from agent');
      expect(capturing.capturedState, {'injected': true});
    });

    test('function middleware intercepts events when used through agent', () async {
      final seenFinished = <RunFinishedEvent>[];
      final agent = TextChunkAgent()
        ..use((RunAgentInput input, AbstractAgent next) async* {
          await for (final event in next.run(input)) {
            if (event is RunFinishedEvent) {
              final updated = event.copyWith(result: const {'success': true});
              seenFinished.add(updated);
              yield updated;
            } else {
              yield event;
            }
          }
        });

      final result = await agent.runAgent(const RunAgentParameters(runId: 'run-1'));

      expect(result.newMessages.single.content, 'Hello from agent');
      expect(seenFinished, hasLength(1));
      expect(seenFinished.single.result, {'success': true});
    });
  });
}
