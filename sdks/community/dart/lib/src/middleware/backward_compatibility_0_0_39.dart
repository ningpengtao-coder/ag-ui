library;

import '../agent/agent.dart';
import '../events/events.dart';
import '../types/types.dart';
import 'middleware.dart';

class BackwardCompatibility_0_0_39 extends Middleware {
  @override
  Stream<BaseEvent> run(RunAgentInput input, AbstractAgent next) {
    final sanitizedInput = RunAgentInput(
      threadId: input.threadId,
      runId: input.runId,
      state: input.state,
      messages: input.messages.map(_sanitizeMessageContent).toList(),
      tools: input.tools,
      context: input.context,
      forwardedProps: input.forwardedProps,
      resume: input.resume,
    );

    return runNext(sanitizedInput, next);
  }
}

Message _sanitizeMessageContent(Message message) {
  final content = message.content;
  if (content is String) {
    return message;
  }

  if (content is List) {
    final flattened = content
        .whereType<TextInputContent>()
        .map((part) => part.text)
        .join();
    return _copyMessageWithContent(message, flattened);
  }

  return _copyMessageWithContent(message, '');
}

Message _copyMessageWithContent(Message message, String content) {
  return switch (message) {
    DeveloperMessage() => message.copyWith(content: content),
    SystemMessage() => message.copyWith(content: content),
    AssistantMessage() => message.copyWith(content: content),
    UserMessage() => message.copyWith(content: content),
    ToolMessage() => message.copyWith(content: content),
    ReasoningMessage() => message.copyWith(content: content),
    ActivityMessage() => message,
  };
}
