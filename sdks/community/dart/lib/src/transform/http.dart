library;

import 'dart:async';

import '../debug_logger.dart';
import '../events/events.dart';
import '../proto/proto.dart';
import '../run/http_request.dart';
import 'proto.dart';
import 'sse.dart';

Stream<BaseEvent> transformHttpEventStream(
  Stream<HttpEvent> source, {
  Object? debugLogger,
}) async* {
  final log = resolveDebugLogger(debugLogger);
  final iterator = StreamIterator<HttpEvent>(source);

  if (!await iterator.moveNext()) {
    return;
  }

  final first = iterator.current;
  if (first is! HttpHeadersEvent) {
    throw StateError('No headers event received before data events');
  }

  final contentType = first.headers['content-type'];
  final isProto = contentType == agUiMediaType;
  log?.lifecycle('HTTP', 'Stream format detected:', {
    'contentType': contentType,
    'parser': isProto ? 'protobuf' : 'sse',
  });

  Stream<HttpEvent> replayed() async* {
    yield first;
    while (await iterator.moveNext()) {
      yield iterator.current;
    }
  }

  if (isProto) {
    yield* parseProtoStream(replayed());
    return;
  }

  await for (final json in parseSSEStream(replayed(), debugLogger: log)) {
    if (json is! Map<String, dynamic>) {
      throw StateError('Invalid SSE payload');
    }
    log?.event('HTTP', 'Event validated:', json, {
      'type': json['type'],
      'valid': true,
    });
    yield BaseEvent.fromJson(json);
  }
}
