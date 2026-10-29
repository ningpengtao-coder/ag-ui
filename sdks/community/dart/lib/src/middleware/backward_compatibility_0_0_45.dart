/// Downgrade for agents pinned at or below 0.0.45.
///
/// Maps the retired `THINKING_*` events onto the `REASONING_*` events that
/// replaced them:
///
/// - `THINKING_START` -> `REASONING_START`
/// - `THINKING_TEXT_MESSAGE_START` -> `REASONING_MESSAGE_START`
/// - `THINKING_TEXT_MESSAGE_CONTENT` -> `REASONING_MESSAGE_CONTENT`
/// - `THINKING_TEXT_MESSAGE_END` -> `REASONING_MESSAGE_END`
/// - `THINKING_END` -> `REASONING_END`
///
/// The always-on compatibility boundary translates the same shapes and runs
/// innermost, so in the shipped pipeline it sees them first and this shim
/// usually finds nothing to do.
library;

import '../agent/agent.dart';
import '../diagnostics.dart';
import '../events/events.dart';
import '../types/types.dart';
import 'middleware.dart';

class BackwardCompatibility_0_0_45 extends Middleware {
  CompatIdMinter _ids = CompatIdMinter('');
  String? _currentReasoningId;
  String? _currentMessageId;

  @override
  Stream<BaseEvent> run(RunAgentInput input, AbstractAgent next) async* {
    // Reset state for each run.
    _ids = CompatIdMinter(input.runId);
    _currentReasoningId = null;
    _currentMessageId = null;

    await for (final event in runNext(input, next)) {
      yield _transformEvent(event);
    }
  }

  BaseEvent _transformEvent(BaseEvent event) {
    switch (event) {
      case ThinkingStartEvent():
        _currentReasoningId = _ids.next('reasoning');
        _warnAboutTransformation('THINKING_START', 'REASONING_START');
        final title = event.title;
        if (title != null) {
          // REASONING_START has no title field; the span's label is lost.
          AgUiDiagnostics.warn(
            'Dropping THINKING_START.title "$title": REASONING_START has no '
            "title field, so the span's label cannot be carried.",
          );
        }
        return ReasoningStartEvent(
          messageId: _currentReasoningId!,
          timestamp: event.timestamp,
          rawEvent: event.rawEvent,
          metadata: event.metadata,
          subagentRunId: event.subagentRunId,
        );

      case ThinkingTextMessageStartEvent():
        _currentMessageId = _ids.next('reasoning-message');
        _warnAboutTransformation(
          'THINKING_TEXT_MESSAGE_START',
          'REASONING_MESSAGE_START',
        );
        return ReasoningMessageStartEvent(
          messageId: _currentMessageId!,
          // The event's default `role` is "reasoning", which is what the
          // schema pins; the translation used to say "assistant".
          timestamp: event.timestamp,
          rawEvent: event.rawEvent,
          metadata: event.metadata,
          subagentRunId: event.subagentRunId,
        );

      case ThinkingTextMessageContentEvent():
        _warnAboutTransformation(
          'THINKING_TEXT_MESSAGE_CONTENT',
          'REASONING_MESSAGE_CONTENT',
        );
        return ReasoningMessageContentEvent(
          messageId: _currentMessageId ?? _ids.next('reasoning-message'),
          delta: event.delta,
          timestamp: event.timestamp,
          rawEvent: event.rawEvent,
          metadata: event.metadata,
          subagentRunId: event.subagentRunId,
        );

      case ThinkingContentEvent():
        _warnAboutTransformation(
            'THINKING_CONTENT', 'REASONING_MESSAGE_CONTENT');
        return ReasoningMessageContentEvent(
          messageId: _currentMessageId ?? _ids.next('reasoning-message'),
          delta: event.delta,
          timestamp: event.timestamp,
          rawEvent: event.rawEvent,
          metadata: event.metadata,
          subagentRunId: event.subagentRunId,
        );

      case ThinkingTextMessageEndEvent():
        final messageId = _currentMessageId ?? _ids.next('reasoning-message');
        _warnAboutTransformation(
          'THINKING_TEXT_MESSAGE_END',
          'REASONING_MESSAGE_END',
        );
        return ReasoningMessageEndEvent(
          messageId: messageId,
          timestamp: event.timestamp,
          rawEvent: event.rawEvent,
          metadata: event.metadata,
          subagentRunId: event.subagentRunId,
        );

      case ThinkingEndEvent():
        final messageId = _currentReasoningId ?? _ids.next('reasoning');
        _warnAboutTransformation('THINKING_END', 'REASONING_END');
        return ReasoningEndEvent(
          messageId: messageId,
          timestamp: event.timestamp,
          rawEvent: event.rawEvent,
          metadata: event.metadata,
          subagentRunId: event.subagentRunId,
        );

      default:
        return event;
    }
  }

  void _warnAboutTransformation(String from, String to) {
    AgUiDiagnostics.warn(
      'AG-UI is converting $from to $to. To remove this warning, upgrade your '
      'AG-UI integration package.',
    );
  }
}
