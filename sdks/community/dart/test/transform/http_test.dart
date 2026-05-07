import 'dart:convert';
import 'dart:typed_data';

import 'package:ag_ui/ag_ui.dart';
import 'package:test/test.dart';

void main() {
  group('transform streams', () {
    test('parseSSEStream parses JSON SSE payloads across chunks', () async {
      final events = parseSSEStream(
        Stream<HttpEvent>.fromIterable([
          const HttpHeadersEvent(status: 200, headers: {'content-type': 'text/event-stream'}),
          HttpDataEvent(
            data: Uint8List.fromList(
              utf8.encode('data: {"type":"TEXT_MESSAGE_START","messageId":"m1"}\n'),
            ),
          ),
          HttpDataEvent(data: Uint8List.fromList(utf8.encode('\n'))),
        ]),
      );

      final parsed = await events.single as Map<String, dynamic>;
      expect(parsed['type'], 'TEXT_MESSAGE_START');
      expect(parsed['messageId'], 'm1');
    });

    test('parseProtoStream decodes framed events split across data chunks', () async {
      final frame = encodeProtoFrame(
        const TextMessageEndEvent(messageId: 'm2'),
      );

      final events = parseProtoStream(
        Stream<HttpEvent>.fromIterable([
          const HttpHeadersEvent(status: 200, headers: {'content-type': agUiMediaType}),
          HttpDataEvent(data: Uint8List.fromList(frame.sublist(0, 3))),
          HttpDataEvent(data: Uint8List.fromList(frame.sublist(3))),
        ]),
      );

      final parsed = await events.single;
      expect(parsed, isA<TextMessageEndEvent>());
      expect((parsed as TextMessageEndEvent).messageId, 'm2');
    });

    test('transformHttpEventStream chooses SSE parser from content type', () async {
      final events = transformHttpEventStream(
        Stream<HttpEvent>.fromIterable([
          const HttpHeadersEvent(status: 200, headers: {'content-type': 'text/event-stream'}),
          HttpDataEvent(
            data: Uint8List.fromList(
              utf8.encode('data: {"type":"RUN_STARTED","threadId":"t1","runId":"r1"}\n\n'),
            ),
          ),
        ]),
      );

      final parsed = await events.single;
      expect(parsed, isA<RunStartedEvent>());
      expect((parsed as RunStartedEvent).threadId, 't1');
    });

    test('transformHttpEventStream chooses proto parser from content type', () async {
      final frame = encodeProtoFrame(
        const RunFinishedEvent(threadId: 't1', runId: 'r1'),
      );

      final events = transformHttpEventStream(
        Stream<HttpEvent>.fromIterable([
          const HttpHeadersEvent(status: 200, headers: {'content-type': agUiMediaType}),
          HttpDataEvent(data: frame),
        ]),
      );

      final parsed = await events.single;
      expect(parsed, isA<RunFinishedEvent>());
      expect((parsed as RunFinishedEvent).runId, 'r1');
    });
  });
}
