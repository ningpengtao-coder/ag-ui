import 'package:ag_ui/ag_ui.dart';
import 'package:test/test.dart';

class RecordingClient extends AgUiClient {
  final Stream<BaseEvent> Function(
    String endpoint,
    SimpleRunAgentInput input,
    CancelToken? cancelToken,
  )
  handler;

  String? lastEndpoint;
  SimpleRunAgentInput? lastInput;
  CancelToken? lastCancelToken;

  RecordingClient({required this.handler})
    : super(config: AgUiClientConfig(baseUrl: 'https://api.example.com'));

  @override
  Stream<BaseEvent> runAgent(
    String endpoint,
    SimpleRunAgentInput input, {
    CancelToken? cancelToken,
  }) {
    lastEndpoint = endpoint;
    lastInput = input;
    lastCancelToken = cancelToken;
    return handler(endpoint, input, cancelToken);
  }
}

void main() {
  group('HttpAgent', () {
    test('runAgent forwards endpoint, input, and active cancel token', () async {
      final client = RecordingClient(
        handler: (endpoint, input, cancelToken) => Stream<BaseEvent>.fromIterable([
          RunStartedEvent(threadId: input.threadId!, runId: input.runId!),
          RunFinishedEvent(threadId: input.threadId!, runId: input.runId!, result: 'ok'),
        ]),
      );
      final agent = HttpAgent(
        HttpAgentConfig(
          client: client,
          endpoint: 'agents/demo',
          threadId: 'thread-http',
          initialMessages: const [
            UserMessage(id: 'msg-user', content: 'hello'),
          ],
        ),
      );

      final result = await agent.runAgent(const RunAgentParameters(runId: 'run-http'));

      expect(result.result, 'ok');
      expect(client.lastEndpoint, 'agents/demo');
      expect(client.lastInput, isNotNull);
      expect(client.lastInput!.threadId, 'thread-http');
      expect(client.lastInput!.runId, 'run-http');
      expect(client.lastInput!.messages?.map((message) => message.id), ['msg-user']);
      expect(client.lastCancelToken, same(agent.cancelToken));
      expect(client.lastCancelToken?.isCancelled, isFalse);
    });

    test('abortRun cancels the current token and the next run gets a fresh token', () async {
      final client = RecordingClient(
        handler: (endpoint, input, cancelToken) => Stream<BaseEvent>.fromIterable([
          RunStartedEvent(threadId: input.threadId!, runId: input.runId!),
          RunFinishedEvent(threadId: input.threadId!, runId: input.runId!),
        ]),
      );
      final agent = HttpAgent(
        HttpAgentConfig(
          client: client,
          endpoint: 'agents/demo',
          threadId: 'thread-http',
        ),
      );

      await agent.runAgent(const RunAgentParameters(runId: 'run-1'));
      final firstToken = agent.cancelToken;

      agent.abortRun();

      expect(firstToken, isNotNull);
      expect(firstToken!.isCancelled, isTrue);

      await agent.runAgent(const RunAgentParameters(runId: 'run-2'));

      expect(agent.cancelToken, isNot(same(firstToken)));
      expect(agent.cancelToken?.isCancelled, isFalse);
      expect(client.lastCancelToken, same(agent.cancelToken));
    });

    test('clone preserves cancelled token state without sharing the same token instance', () async {
      final client = RecordingClient(
        handler: (endpoint, input, cancelToken) => const Stream<BaseEvent>.empty(),
      );
      final agent = HttpAgent(
        HttpAgentConfig(
          client: client,
          endpoint: 'agents/demo',
          threadId: 'thread-http',
        ),
      );
      agent.cancelToken = CancelToken()..cancel();

      final cloned = agent.clone();

      expect(cloned, isA<HttpAgent>());
      expect((cloned as HttpAgent).cancelToken, isNot(same(agent.cancelToken)));
      expect(cloned.cancelToken?.isCancelled, isTrue);
    });
  });
}
