import 'package:ag_ui/ag_ui.dart';
import 'package:test/test.dart';

void main() {
  group('event factories', () {
    test('creates text message start with default assistant role', () {
      final event = createTextMessageStartEvent(messageId: 'msg-1');
      expect(event.type, EventType.textMessageStart.value);
      expect(event.role, TextMessageRole.assistant);
    });

    test('creates tool call lifecycle events', () {
      final start = createToolCallStartEvent(
        toolCallId: 'tc-1',
        toolCallName: 'search',
        parentMessageId: 'msg-parent',
      );
      final args = createToolCallArgsEvent(toolCallId: 'tc-1', delta: '{"q":"hi"}');
      final end = createToolCallEndEvent(toolCallId: 'tc-1');

      expect(start.parentMessageId, 'msg-parent');
      expect(args.delta, contains('q'));
      expect(end.type, EventType.toolCallEnd.value);
    });

    test('creates run finished success and interrupt variants', () {
      final success = createRunFinishedSuccessEvent(
        threadId: 't-1',
        runId: 'r-1',
        result: {'ok': true},
      );
      final interrupt = createRunFinishedInterruptEvent(
        threadId: 't-1',
        runId: 'r-1',
        interrupts: const [Interrupt(id: 'int-1', reason: 'tool_call')],
      );

      expect(success.outcome, isA<RunFinishedSuccessOutcome>());
      expect(interrupt.outcome, isA<RunFinishedInterruptOutcome>());
    });

    test('rejects empty interrupts array for interrupt outcome factory', () {
      expect(
        () => createRunFinishedInterruptEvent(
          threadId: 't-1',
          runId: 'r-1',
          interrupts: const [],
        ),
        throwsArgumentError,
      );
    });
  });
}
