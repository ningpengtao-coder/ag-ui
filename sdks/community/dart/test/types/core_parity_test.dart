import 'package:ag_ui/ag_ui.dart';
import 'package:test/test.dart';

void main() {
  group('RunFinishedEvent compatibility', () {
    test('parses legacy event with no outcome', () {
      final parsed = BaseEvent.fromJson({
        'type': EventType.runFinished.value,
        'threadId': 't-1',
        'runId': 'r-1',
      }) as RunFinishedEvent;

      expect(parsed.outcome, isNull);
    });

    test('parses explicit success outcome', () {
      final parsed = BaseEvent.fromJson({
        'type': EventType.runFinished.value,
        'threadId': 't-1',
        'runId': 'r-1',
        'outcome': {'type': 'success'},
      }) as RunFinishedEvent;

      expect(parsed.outcome, isA<RunFinishedSuccessOutcome>());
    });

    test('parses interrupt outcome', () {
      final parsed = BaseEvent.fromJson({
        'type': EventType.runFinished.value,
        'threadId': 't-1',
        'runId': 'r-1',
        'outcome': {
          'type': 'interrupt',
          'interrupts': [
            {'id': 'int-1', 'reason': 'tool_call'},
          ],
        },
      }) as RunFinishedEvent;

      expect(parsed.outcome, isA<RunFinishedInterruptOutcome>());
      expect((parsed.outcome as RunFinishedInterruptOutcome).interrupts, hasLength(1));
    });
  });

  group('Multimodal messages', () {
    test('parses user message with content array', () {
      final parsed = Message.fromJson({
        'id': 'user_multimodal',
        'role': 'user',
        'content': [
          {'type': 'text', 'text': 'Check this out'},
          {
            'type': 'image',
            'source': {
              'type': 'url',
              'value': 'https://example.com/image.png',
              'mimeType': 'image/png',
            },
          },
        ],
      }) as UserMessage;

      expect(parsed.content, isA<List>());
      final content = parsed.content as List;
      expect((content[0] as TextInputContent).text, 'Check this out');
      expect((content[1] as ImageInputContent).source, isA<InputContentUrlSource>());
    });

    test('requires a payload source for binary input content', () {
      expect(
        () => BinaryInputContent.fromJson({
          'type': 'binary',
          'mimeType': 'image/png',
        }),
        throwsA(isA<AGUIValidationError>()),
      );
    });
  });

  group('Event role defaults', () {
    test('defaults TextMessageStartEvent role to assistant', () {
      final parsed = BaseEvent.fromJson({
        'type': EventType.textMessageStart.value,
        'messageId': 'test-msg',
      }) as TextMessageStartEvent;

      expect(parsed.role, TextMessageRole.assistant);
    });

    test('keeps role optional in TextMessageChunkEvent', () {
      final parsed = BaseEvent.fromJson({
        'type': EventType.textMessageChunk.value,
        'messageId': 'test-msg',
        'delta': 'test content',
      }) as TextMessageChunkEvent;

      expect(parsed.role, isNull);
    });

    test('supports name field on text message events', () {
      final start = BaseEvent.fromJson({
        'type': EventType.textMessageStart.value,
        'messageId': 'test-msg',
        'name': 'research-agent',
      }) as TextMessageStartEvent;
      final chunk = BaseEvent.fromJson({
        'type': EventType.textMessageChunk.value,
        'messageId': 'test-msg',
        'delta': 'Hello',
        'name': 'research-agent',
      }) as TextMessageChunkEvent;

      expect(start.name, 'research-agent');
      expect(chunk.name, 'research-agent');
    });
  });
}
