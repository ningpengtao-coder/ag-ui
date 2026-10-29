library;

import 'dart:async';
import 'dart:typed_data';

import '../events/events.dart';
import '../proto/proto.dart';
import '../run/http_request.dart';

/// The largest frame the framing buffer will accept, judged against the length
/// the frame's own 4-byte prefix declares.
///
/// `processBuffer` waits until the buffer holds the whole message named by that
/// prefix, so a prefix that is never satisfied would grow it without bound.
/// Checking the declared length bounds the buffer to one frame and rejects an
/// unsatisfiable prefix on the read that carries it. Mirrors the TypeScript
/// parser and the C++ SDK's 10 MB cap.
const int maxProtoFrameSize = 10 * 1024 * 1024;

Stream<BaseEvent> parseProtoStream(Stream<HttpEvent> source) {
  final controller = StreamController<BaseEvent>();
  var buffer = Uint8List(0);
  // Once the stream has failed the undecodable frame is still at the head of
  // the buffer; without this every later chunk would re-read it, and the end of
  // the stream would blame the leftovers on truncation instead of the failure
  // that actually happened.
  var failed = false;

  void fail(Object error) {
    if (failed) {
      return;
    }
    failed = true;
    controller.addError(error);
    controller.close();
  }

  void processBuffer() {
    if (failed) {
      return;
    }
    while (buffer.length >= 4) {
      final frameLength =
          ByteData.sublistView(buffer, 0, 4).getUint32(0, Endian.big);
      final totalLength = 4 + frameLength;

      if (totalLength > maxProtoFrameSize) {
        fail(StateError(
          'Protobuf message size exceeded maximum limit of '
          '${maxProtoFrameSize ~/ (1024 * 1024)} MB',
        ));
        return;
      }

      if (buffer.length < totalLength) {
        return;
      }

      final frame = Uint8List.sublistView(buffer, 0, totalLength);
      try {
        controller.add(decodeProtoFrame(frame));
      } on Object catch (error) {
        fail(StateError('Failed to decode protocol buffer message: $error'));
        return;
      }
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
    onError: (Object error, StackTrace stackTrace) {
      if (failed) {
        return;
      }
      failed = true;
      controller.addError(error, stackTrace);
      controller.close();
    },
    onDone: () {
      processBuffer();
      if (failed) {
        return;
      }
      // A short final frame never throws — the framing loop simply waits for
      // bytes that will not come — so only this check can notice it. Losing a
      // message and completing anyway would report success for a stream that was
      // cut in half.
      if (buffer.isNotEmpty) {
        fail(StateError(
          'The binary stream ended mid-frame: ${buffer.length} trailing bytes '
          'could not be read as a complete message.',
        ));
        return;
      }
      controller.close();
    },
    cancelOnError: false,
  );

  return controller.stream;
}
