import 'package:ag_ui/ag_ui.dart';
import 'package:test/test.dart';

void main() {
  group('transformChunks', () {
    test('expands text message chunks into start and content events', () async {
      final events = Stream<BaseEvent>.fromIterable([
        const TextMessageChunkEvent(
          messageId: 'm1',
          role: TextMessageRole.assistant,
          delta: 'Hello',
        ),
      ]);

      final transformed = await transformChunks(events).toList();

      // The stream ends while the message is still open: chunk expansion does
      // not synthesise an END after the source has terminated, exactly like
      // the reference implementation's finalize stage.
      expect(transformed, hasLength(2));
      expect(transformed[0], isA<TextMessageStartEvent>());
      expect(transformed[1], isA<TextMessageContentEvent>());
    });

    test('closes previous chunk stream before switching message ids', () async {
      final events = Stream<BaseEvent>.fromIterable([
        const TextMessageChunkEvent(messageId: 'm1', delta: 'A'),
        const TextMessageChunkEvent(messageId: 'm2', delta: 'B'),
      ]);

      final transformed = await transformChunks(events).toList();

      expect(
        transformed.map((event) => event.eventType),
        [
          EventType.textMessageStart,
          EventType.textMessageContent,
          EventType.textMessageEnd,
          EventType.textMessageStart,
          EventType.textMessageContent,
        ],
      );
    });
  });
}
