library;

import 'dart:math';

import '../agent/agent.dart';
import '../events/events.dart';
import '../types/types.dart';
import 'middleware.dart';

class BackwardCompatibility_0_0_45 extends Middleware {
  String? _currentReasoningId;
  String? _currentMessageId;

  @override
  Stream<BaseEvent> run(RunAgentInput input, AbstractAgent next) async* {
    _currentReasoningId = null;
    _currentMessageId = null;

    await for (final event in runNext(input, next)) {
      yield _transformEvent(event);
    }
  }

  BaseEvent _transformEvent(BaseEvent event) {
    switch (event) {
      case ThinkingStartEvent():
        _currentReasoningId = _currentReasoningId ?? _randomId();
        return ReasoningStartEvent(
          messageId: _currentReasoningId!,
          timestamp: event.timestamp,
          rawEvent: event.rawEvent,
        );
      case ThinkingTextMessageStartEvent():
        _currentMessageId = _currentMessageId ?? _randomId();
        return ReasoningMessageStartEvent(
          messageId: _currentMessageId!,
          role: 'assistant',
          timestamp: event.timestamp,
          rawEvent: event.rawEvent,
        );
      case ThinkingTextMessageContentEvent():
        _currentMessageId = _currentMessageId ?? _randomId();
        return ReasoningMessageContentEvent(
          messageId: _currentMessageId!,
          delta: event.delta,
          timestamp: event.timestamp,
          rawEvent: event.rawEvent,
        );
      case ThinkingTextMessageEndEvent():
        _currentMessageId = _currentMessageId ?? _randomId();
        return ReasoningMessageEndEvent(
          messageId: _currentMessageId!,
          timestamp: event.timestamp,
          rawEvent: event.rawEvent,
        );
      case ThinkingEndEvent():
        _currentReasoningId = _currentReasoningId ?? _randomId();
        return ReasoningEndEvent(
          messageId: _currentReasoningId!,
          timestamp: event.timestamp,
          rawEvent: event.rawEvent,
        );
      default:
        return event;
    }
  }

  static String _randomId() {
    final random = Random().nextInt(1 << 32);
    return 'compat-${DateTime.now().microsecondsSinceEpoch}-$random';
  }
}
