library;

import 'dart:async';
import 'dart:convert';

import '../debug_logger.dart';
import '../run/http_request.dart';

Stream<Object?> parseSSEStream(
  Stream<HttpEvent> source, {
  Object? debugLogger,
}) {
  final log = resolveDebugLogger(debugLogger);
  final controller = StreamController<Object?>();
  final decoder = const Utf8Decoder(allowMalformed: true);
  var buffer = '';

  void processEvent(String eventText) {
    final lines = eventText.split('\n');
    final dataLines = <String>[];

    for (final line in lines) {
      if (line.startsWith('data:')) {
        dataLines.add(line.substring(5).replaceFirst(RegExp(r'^ '), ''));
      }
    }

    if (dataLines.isEmpty) {
      return;
    }

    try {
      final jsonString = dataLines.join('\n');
      final decoded = json.decode(jsonString);
      if (decoded is Map<String, dynamic> && decoded['type'] != null) {
        log?.event('SSE', 'Event received:', decoded, {'type': decoded['type']});
      }
      controller.add(decoded);
    } catch (error, stackTrace) {
      controller.addError(error, stackTrace);
    }
  }

  source.listen(
    (event) {
      if (event is HttpHeadersEvent) {
        return;
      }
      if (event is! HttpDataEvent || event.data == null) {
        return;
      }

      buffer += decoder.convert(event.data!);
      final chunks = buffer.split(RegExp(r'\n\n'));
      buffer = chunks.removeLast();
      for (final chunk in chunks) {
        processEvent(chunk);
      }
    },
    onError: controller.addError,
    onDone: () {
      if (buffer.isNotEmpty) {
        processEvent(buffer);
      }
      controller.close();
    },
    cancelOnError: false,
  );

  return controller.stream;
}
