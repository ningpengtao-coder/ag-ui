import 'package:ag_ui/ag_ui.dart';
import 'package:test/test.dart';

void main() {
  group('verifyEvents', () {
    test('requires RUN_STARTED as the first event', () async {
      final stream = verifyEvents(
        Stream<BaseEvent>.fromIterable([
          const TextMessageStartEvent(messageId: 'm1'),
        ]),
      );

      expect(
        stream.toList(),
        throwsA(
          isA<AGUIError>().having(
            (error) => error.message,
            'message',
            contains("First event must be 'RUN_STARTED'"),
          ),
        ),
      );
    });

    test('accepts a valid run lifecycle', () async {
      final stream = verifyEvents(
        Stream<BaseEvent>.fromIterable([
          const RunStartedEvent(threadId: 'thread-1', runId: 'run-1'),
          const TextMessageStartEvent(messageId: 'm1'),
          const TextMessageContentEvent(messageId: 'm1', delta: 'hello'),
          const TextMessageEndEvent(messageId: 'm1'),
          const RunFinishedEvent(threadId: 'thread-1', runId: 'run-1'),
        ]),
      );

      final events = await stream.toList();
      expect(events, hasLength(5));
      expect(events.first.eventType, EventType.runStarted);
      expect(events.last.eventType, EventType.runFinished);
    });
  });
}
