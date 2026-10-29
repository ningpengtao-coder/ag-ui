/// Downgrade for agents pinned at or below 0.0.39.
///
/// A 0.0.39 peer accepts `content` as a bare string and nothing else, so a
/// multimodal message has to be flattened before it leaves the client. The
/// flattening is lossy and says so: parts the peer cannot receive are named in
/// a warning. A malformed text part is never repaired on the way past — the
/// message is handed on untouched, so the defect stays visible.
library;

import '../agent/agent.dart';
import '../diagnostics.dart';
import '../events/events.dart';
import '../types/types.dart';
import 'middleware.dart';

class BackwardCompatibility_0_0_39 extends Middleware {
  @override
  Stream<BaseEvent> run(RunAgentInput input, AbstractAgent next) {
    final sanitizedInput = RunAgentInput(
      threadId: input.threadId,
      runId: input.runId,
      // `parentRunId` postdates 0.0.39, and an unknown input member is exactly
      // what a strict old parser could reject.
      protocolVersion: input.protocolVersion,
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

  final parts = _contentPartsOf(message);
  if (parts == null) {
    // Absent content is the one value a downgrade may supply for: the older
    // schema requires the field, so an empty string is permitted reshaping.
    // Anything else held by a known field is a defect, and repairing it would
    // hide a value the modern contract rejects.
    return content == null ? _copyMessageWithText(message, '') : message;
  }

  // Two questions, deliberately separate. "Does this part CLAIM to be text?"
  // decides whether it is media the peer cannot represent; "is it well formed
  // text?" decides whether the message carries a defect.
  final malformed = parts
      .where(
        (part) => part.toJson()['type'] == 'text' && part is! TextInputContent,
      )
      .toList();
  if (malformed.isNotEmpty) {
    // A downgrade MUST NOT repair a malformed value on the way past. Dropping
    // the defective part and flattening the rest would produce acceptable
    // content out of unacceptable input.
    AgUiDiagnostics.warn(
      'Not flattening message content for a <=0.0.39 peer: '
      '${malformed.length} content part(s) claim type "text" but carry a '
      "malformed 'text' value. That is a defect in the message, not media the "
      'peer cannot represent, so the content is passed on unchanged.',
    );
    return message;
  }

  final dropped = parts
      .where((part) => part is! TextInputContent)
      .map((part) => part.type)
      .toList();
  if (dropped.isNotEmpty) {
    // Losing content must never be silent: an image, audio, video, document or
    // binary part cannot survive the flattening a 0.0.39 peer requires.
    AgUiDiagnostics.warn(
      'Flattening message content for a <=0.0.39 peer DROPS non-text parts '
      '(${dropped.join(', ')}). The peer cannot receive them; upgrade it to '
      'keep media content.',
    );
  }

  final flattened =
      parts.whereType<TextInputContent>().map((part) => part.text).join();

  return _copyMessageWithText(message, flattened);
}

List<InputContent>? _contentPartsOf(Message message) {
  return switch (message) {
    UserMessage() => message.content.partsOrNull,
    ToolMessage() => message.contentParts,
    _ => null,
  };
}

Message _copyMessageWithText(Message message, String content) {
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
