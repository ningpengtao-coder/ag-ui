import 'package:ag_ui/ag_ui.dart';
import 'package:test/test.dart';

void main() {
  group('getRunOutcome', () {
    test('returns null when outcome is omitted', () {
      const event = RunFinishedEvent(threadId: 't-1', runId: 'r-1');
      expect(getRunOutcome(event), isNull);
    });

    test('returns success outcome', () {
      const event = RunFinishedEvent(
        threadId: 't-1',
        runId: 'r-1',
        outcome: RunFinishedSuccessOutcome(),
      );
      expect(getRunOutcome(event), const RunFinishedSuccessOutcome());
    });

    test('returns interrupt outcome', () {
      const interrupts = [Interrupt(id: 'int-1', reason: 'tool_call')];
      const event = RunFinishedEvent(
        threadId: 't-1',
        runId: 'r-1',
        outcome: RunFinishedInterruptOutcome(interrupts: interrupts),
      );
      final outcome = getRunOutcome(event);
      expect(outcome, isA<RunFinishedInterruptOutcome>());
      expect((outcome as RunFinishedInterruptOutcome).interrupts, interrupts);
    });
  });

  group('isInterruptExpired', () {
    test('returns false when expiresAt is unset', () {
      const interrupt = Interrupt(id: 'int-1', reason: 'tool_call');
      expect(isInterruptExpired(interrupt), isFalse);
    });

    test('honors injected now', () {
      const interrupt = Interrupt(
        id: 'int-1',
        reason: 'tool_call',
        expiresAt: '2026-04-22T12:00:00Z',
      );
      expect(
        isInterruptExpired(interrupt, DateTime.parse('2026-04-22T11:59:00Z')),
        isFalse,
      );
      expect(
        isInterruptExpired(interrupt, DateTime.parse('2026-04-22T12:00:01Z')),
        isTrue,
      );
    });
  });

  group('buildResumeArray', () {
    const interrupts = [
      Interrupt(id: 'int-1', reason: 'tool_call'),
      Interrupt(id: 'int-2', reason: 'tool_call'),
    ];

    test('builds an array addressing every interrupt', () {
      final resume = buildResumeArray(interrupts, {
        'int-1': const ResumeResponse.resolved({'approved': true}),
        'int-2': const ResumeResponse.cancelled(),
      });

      expect(resume, hasLength(2));
      expect(resume[0].interruptId, 'int-1');
      expect(resume[0].status, ResumeStatus.resolved);
      expect(resume[0].payload, {'approved': true});
      expect(resume[1].status, ResumeStatus.cancelled);
      expect(resume[1].payload, isNull);
    });

    test('throws when a response is missing', () {
      expect(
        () => buildResumeArray(interrupts, {
          'int-1': const ResumeResponse.resolved({'approved': true}),
        }),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws when responses reference an unknown interrupt id', () {
      expect(
        () => buildResumeArray(interrupts, {
          'int-1': const ResumeResponse.resolved(),
          'int-2': const ResumeResponse.cancelled(),
          'int-3': const ResumeResponse.cancelled(),
        }),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
