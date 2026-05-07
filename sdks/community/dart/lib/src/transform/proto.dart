library;

import 'dart:async';
import 'dart:typed_data';

import '../events/events.dart';
import '../proto/proto.dart';
import '../run/http_request.dart';

Stream<BaseEvent> parseProtoStream(Stream<HttpEvent> source) {
  final controller = StreamController<BaseEvent>();
  var buffer = Uint8List(0);

  void processBuffer() {
    while (buffer.length >= 4) {
      final frameLength = ByteData.sublistView(buffer, 0, 4).getUint32(0, Endian.big);
      final totalLength = 4 + frameLength;
      if (buffer.length < totalLength) {
        return;
      }

      final frame = Uint8List.sublistView(buffer, 0, totalLength);
      controller.add(decodeProtoFrame(frame));
      buffer = Uint8List.sublistView(buffer, totalLength);
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

      final nextBuffer = Uint8List(buffer.length + event.data!.length);
      nextBuffer.setRange(0, buffer.length, buffer);
      nextBuffer.setRange(buffer.length, nextBuffer.length, event.data!);
      buffer = nextBuffer;
      processBuffer();
    },
    onError: controller.addError,
    onDone: () {
      if (buffer.isNotEmpty) {
        try {
          processBuffer();
        } catch (_) {
          // Leave any incomplete trailing frame un-emitted to match the TS parser.
        }
      }
      controller.close();
    },
    cancelOnError: false,
  );

  return controller.stream;
}
