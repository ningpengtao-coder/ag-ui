library;

import '../client/client.dart';
import '../events/events.dart';
import '../types/types.dart';
import 'agent.dart';
import 'subscriber.dart';
import 'types.dart';

class HttpAgentConfig extends AgentConfig {
  final AgUiClient client;
  final String endpoint;

  const HttpAgentConfig({
    required this.client,
    required this.endpoint,
    super.agentId,
    super.description,
    super.threadId,
    super.initialMessages,
    super.initialState,
  });
}

class HttpAgent extends AbstractAgent {
  final AgUiClient client;
  final String endpoint;
  CancelToken? cancelToken;

  HttpAgent(HttpAgentConfig config)
    : client = config.client,
      endpoint = config.endpoint,
      super(config: config);

  @override
  HttpAgent createClone() {
    CancelToken? clonedToken;
    if (cancelToken != null && cancelToken!.isCancelled) {
      clonedToken = CancelToken();
      clonedToken.cancel();
    }
    final cloned = HttpAgent(
      HttpAgentConfig(
        client: client,
        endpoint: endpoint,
        agentId: agentId,
        description: description,
        threadId: threadId,
      ),
    );
    cloned.cancelToken = clonedToken;
    return cloned;
  }

  @override
  Stream<BaseEvent> run(RunAgentInput input) {
    cancelToken ??= CancelToken();
    return client.runAgent(
      endpoint,
      SimpleRunAgentInput.fromRunAgentInput(input),
      cancelToken: cancelToken,
    );
  }

  @override
  Future<RunAgentResult> runAgent([
    RunAgentParameters parameters = const RunAgentParameters(),
    AgentSubscriber? subscriber,
  ]) {
    if (cancelToken == null || cancelToken!.isCancelled) {
      cancelToken = CancelToken();
    }
    return super.runAgent(parameters, subscriber);
  }

  @override
  void abortRun() {
    cancelToken?.cancel();
    super.abortRun();
  }
}
