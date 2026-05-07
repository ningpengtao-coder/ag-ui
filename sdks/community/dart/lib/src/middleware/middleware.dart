library;

export 'backward_compatibility_0_0_39.dart';
export 'backward_compatibility_0_0_45.dart';
export 'backward_compatibility_0_0_47.dart';
export 'filter_tool_calls.dart';

import '../agent/agent.dart';
import '../apply/default.dart';
import '../events/events.dart';
import '../transform/chunks.dart';
import '../types/types.dart';

typedef MiddlewareFunction = Stream<BaseEvent> Function(
  RunAgentInput input,
  AbstractAgent next,
);

class EventWithState {
  final BaseEvent event;
  final List<Message> messages;
  final Object? state;

  const EventWithState({
    required this.event,
    required this.messages,
    required this.state,
  });
}

abstract class Middleware {
  Stream<BaseEvent> run(RunAgentInput input, AbstractAgent next);

  Stream<BaseEvent> runNext(RunAgentInput input, AbstractAgent next) {
    return transformChunks(next.run(input));
  }

  Stream<EventWithState> runNextWithState(
    RunAgentInput input,
    AbstractAgent next,
  ) async* {
    var currentMessages = List<Message>.from(input.messages);
    var currentState = input.state;

    await for (final event in runNext(input, next)) {
      final applied = await defaultApplyEvents(
        RunAgentInput(
          threadId: input.threadId,
          runId: input.runId,
          parentRunId: input.parentRunId,
          state: currentState,
          messages: currentMessages,
          tools: input.tools,
          context: input.context,
          forwardedProps: input.forwardedProps,
          resume: input.resume,
        ),
        Stream<BaseEvent>.value(event),
      ).toList();

      if (applied.isNotEmpty) {
        currentMessages = applied.last.messages;
        currentState = applied.last.state;
      }

      yield EventWithState(
        event: event,
        messages: List<Message>.from(currentMessages),
        state: currentState,
      );
    }
  }
}

class FunctionMiddleware extends Middleware {
  final MiddlewareFunction _fn;

  FunctionMiddleware(this._fn);

  @override
  Stream<BaseEvent> run(RunAgentInput input, AbstractAgent next) => _fn(input, next);
}
