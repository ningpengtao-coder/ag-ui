library;

import '../agent/agent.dart';
import '../events/events.dart';
import '../types/types.dart';
import 'middleware.dart';

class BackwardCompatibility_0_0_47 extends Middleware {
  @override
  Stream<BaseEvent> run(RunAgentInput input, AbstractAgent next) {
    final upgradedInput = RunAgentInput(
      threadId: input.threadId,
      runId: input.runId,
      parentRunId: input.parentRunId,
      state: input.state,
      messages: input.messages.map(_upgradeMessageContent).toList(),
      tools: input.tools,
      context: input.context,
      forwardedProps: input.forwardedProps,
      resume: input.resume,
    );

    return runNext(upgradedInput, next);
  }
}

Message _upgradeMessageContent(Message message) {
  final content = message.content;
  if (content is! List) {
    return message;
  }

  final upgraded = content.map((part) {
    if (part is BinaryInputContent) {
      return _convertBinaryToNewFormat(part);
    }
    return part;
  }).toList();

  return _copyMessageWithContent(message, upgraded);
}

Object _convertBinaryToNewFormat(BinaryInputContent binary) {
  final contentType = _mimeTypeToContentType(binary.mimeType);
  final metadata = binary.filename == null ? null : {'filename': binary.filename};

  if (binary.data != null) {
    final source = InputContentDataSource(value: binary.data!, mimeType: binary.mimeType);
    return switch (contentType) {
      'image' => ImageInputContent(source: source, metadata: metadata),
      'audio' => AudioInputContent(source: source, metadata: metadata),
      'video' => VideoInputContent(source: source, metadata: metadata),
      _ => DocumentInputContent(source: source, metadata: metadata),
    };
  }

  if (binary.url != null) {
    final source = InputContentUrlSource(value: binary.url!, mimeType: binary.mimeType);
    return switch (contentType) {
      'image' => ImageInputContent(source: source, metadata: metadata),
      'audio' => AudioInputContent(source: source, metadata: metadata),
      'video' => VideoInputContent(source: source, metadata: metadata),
      _ => DocumentInputContent(source: source, metadata: metadata),
    };
  }

  return binary;
}

String _mimeTypeToContentType(String mimeType) {
  if (mimeType.startsWith('image/')) {
    return 'image';
  }
  if (mimeType.startsWith('audio/')) {
    return 'audio';
  }
  if (mimeType.startsWith('video/')) {
    return 'video';
  }
  return 'document';
}

Message _copyMessageWithContent(Message message, List<Object?> content) {
  return switch (message) {
    UserMessage() => message.copyWith(content: content),
    _ => message,
  };
}
