library;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../client/errors.dart';

enum HttpEventType {
  headers,
  data,
}

sealed class HttpEvent {
  final HttpEventType type;

  const HttpEvent(this.type);
}

class HttpHeadersEvent extends HttpEvent {
  final int status;
  final Map<String, String> headers;

  const HttpHeadersEvent({
    required this.status,
    required this.headers,
  }) : super(HttpEventType.headers);
}

class HttpDataEvent extends HttpEvent {
  final Uint8List? data;

  const HttpDataEvent({this.data}) : super(HttpEventType.data);
}

Stream<HttpEvent> runHttpRequest(
  String url,
  http.BaseRequest request, {
  http.Client? client,
}) async* {
  final httpClient = client ?? http.Client();
  final ownsClient = client == null;

  try {
    final response = await httpClient.send(request);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final text = await response.stream.bytesToString();
      Object payload = text;
      final contentType = response.headers['content-type'] ?? '';
      if (contentType.contains('application/json')) {
        try {
          payload = json.decode(text);
        } catch (_) {
          payload = text;
        }
      }
      throw TransportError(
        'HTTP ${response.statusCode}: ${payload is String ? payload : json.encode(payload)}',
        statusCode: response.statusCode,
        endpoint: url,
        responseBody: text,
      );
    }

    yield HttpHeadersEvent(
      status: response.statusCode,
      headers: response.headers,
    );

    await for (final chunk in response.stream) {
      yield HttpDataEvent(data: Uint8List.fromList(chunk));
    }
  } finally {
    if (ownsClient) {
      httpClient.close();
    }
  }
}
