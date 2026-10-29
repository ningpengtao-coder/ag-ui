import 'package:ag_ui/ag_ui.dart';
import 'package:test/test.dart';

void main() {
  group('compactEvents', () {
    test('compacts multiple text content events into one', () {
      final compacted = compactEvents([
        const TextMessageStartEvent(messageId: 'msg1', role: TextMessageRole.user),
        const TextMessageContentEvent(messageId: 'msg1', delta: 'Hello'),
        const TextMessageContentEvent(messageId: 'msg1', delta: ' '),
        const TextMessageContentEvent(messageId: 'msg1', delta: 'world'),
        const TextMessageEndEvent(messageId: 'msg1'),
      ]);

      expect(compacted, hasLength(3));
      expect(compacted[1], isA<TextMessageContentEvent>());
      expect((compacted[1] as TextMessageContentEvent).delta, 'Hello world');
    });

    test('moves interleaved events after text message lifecycle', () {
      final compacted = compactEvents([
        const TextMessageStartEvent(messageId: 'msg1'),
        const TextMessageContentEvent(messageId: 'msg1', delta: 'Processing'),
        const CustomEvent(name: 'thinking', value: null),
        const TextMessageContentEvent(messageId: 'msg1', delta: '...'),
        const CustomEvent(name: 'done-thinking', value: null),
        const TextMessageEndEvent(messageId: 'msg1'),
      ]);

      expect(compacted.map((event) => event.type), [
        EventType.textMessageStart.value,
        EventType.textMessageContent.value,
        EventType.textMessageEnd.value,
        EventType.custom.value,
        EventType.custom.value,
      ]);
    });

    test('compacts multiple tool call args events into one', () {
      final compacted = compactEvents([
        const ToolCallStartEvent(
          toolCallId: 'tool1',
          toolCallName: 'search',
          parentMessageId: 'msg1',
        ),
        const ToolCallArgsEvent(toolCallId: 'tool1', delta: '{"query": "'),
        const ToolCallArgsEvent(toolCallId: 'tool1', delta: 'weather'),
        const ToolCallArgsEvent(toolCallId: 'tool1', delta: ' today"}'),
        const ToolCallEndEvent(toolCallId: 'tool1'),
      ]);

      expect(compacted, hasLength(3));
      expect((compacted[1] as ToolCallArgsEvent).delta, '{"query": "weather today"}');
    });

    test('compacts state snapshots and deltas into one snapshot', () {
      final compacted = compactEvents([
        const RunStartedEvent(threadId: 't1', runId: 'r1'),
        const StateSnapshotEvent(snapshot: {'count': 0, 'name': 'test'}),
        const StateDeltaEvent(
          delta: [
            {'op': 'replace', 'path': '/count', 'value': 1},
          ],
        ),
        const StateDeltaEvent(
          delta: [
            {'op': 'replace', 'path': '/count', 'value': 2},
          ],
        ),
        const RunFinishedEvent(threadId: 't1', runId: 'r1'),
      ]);

      expect(compacted, hasLength(3));
      expect((compacted[1] as StateSnapshotEvent).snapshot, {
        'count': 2,
        'name': 'test',
      });
    });

    test('flushes state events outside of runs', () {
      final compacted = compactEvents([
        const StateSnapshotEvent(snapshot: {'x': 1}),
        const StateDeltaEvent(
          delta: [
            {'op': 'replace', 'path': '/x', 'value': 2},
          ],
        ),
      ]);

      expect(compacted, hasLength(1));
      expect((compacted.first as StateSnapshotEvent).snapshot, {'x': 2});
    });

    test('flushes an unclosed stream before the terminal event', () {
      final compacted = compactEvents([
        const RunStartedEvent(threadId: 't1', runId: 'r1'),
        const TextMessageStartEvent(messageId: 'msg1'),
        const TextMessageContentEvent(messageId: 'msg1', delta: 'half'),
        const RunFinishedEvent(threadId: 't1', runId: 'r1'),
      ]);

      // Everything the run produced precedes its terminal event, otherwise a
      // replay sees a message opened after the run that carried it ended.
      expect(compacted.map((event) => event.type), [
        EventType.runStarted.value,
        EventType.textMessageStart.value,
        EventType.textMessageContent.value,
        EventType.runFinished.value,
      ]);
    });

    test('keeps the metadata of the deltas it collapses', () {
      final compacted = compactEvents([
        const TextMessageStartEvent(messageId: 'msg1'),
        const TextMessageContentEvent(
          messageId: 'msg1',
          delta: 'a',
          metadata: {'provider': 'openai'},
        ),
        const TextMessageContentEvent(
          messageId: 'msg1',
          delta: 'b',
          metadata: {'finishReason': 'stop'},
        ),
        const TextMessageEndEvent(messageId: 'msg1'),
      ]);

      final content = compacted[1] as TextMessageContentEvent;
      expect(content.delta, 'ab');
      expect(content.metadata, {
        'provider': 'openai',
        'finishReason': 'stop',
      });
    });

    test('passes a state window with no snapshot through unchanged', () {
      const delta = StateDeltaEvent(
        delta: [
          {'op': 'replace', 'path': '/x', 'value': 1},
        ],
      );

      final compacted = compactEvents([delta, delta]);

      // Collapsing these would need a snapshot built from `{}`, which on replay
      // would wipe state the consumer already holds from before the window.
      expect(compacted, hasLength(2));
      expect(compacted.every((event) => event is StateDeltaEvent), isTrue);
    });

    test('folds state from the last snapshot and keeps its metadata', () {
      final compacted = compactEvents([
        // Unresolvable against `{}` on its own; unobservable behind the
        // snapshot that follows it.
        const StateDeltaEvent(
          delta: [
            {'op': 'replace', 'path': '/missing', 'value': 0},
          ],
        ),
        const StateSnapshotEvent(
          snapshot: {'count': 1},
          metadata: {'provider': 'openai'},
        ),
        const StateDeltaEvent(
          delta: [
            {'op': 'replace', 'path': '/count', 'value': 2},
          ],
          metadata: {'finishReason': 'stop'},
        ),
      ]);

      expect(compacted, hasLength(1));
      final snapshot = compacted.single as StateSnapshotEvent;
      expect(snapshot.snapshot, {'count': 2});
      expect(snapshot.metadata, {
        'provider': 'openai',
        'finishReason': 'stop',
      });
    });
  });
}
