import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:ag_ui/ag_ui.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  group('runHttpRequest', () {
    test('emits headers first and then data chunks', () async {
      final client = _FakeClient((request) async {
        return http.StreamedResponse(
          Stream<List<int>>.fromIterable([
            utf8.encode('hello'),
            utf8.encode('world'),
          ]),
          200,
          headers: {'content-type': 'text/plain'},
        );
      });

      final request = http.Request('GET', Uri.parse('https://example.com/test'));
      final events = await runHttpRequest(
        'https://example.com/test',
        request,
        client: client,
      ).toList();

      expect(events.first, isA<HttpHeadersEvent>());
      expect((events.first as HttpHeadersEvent).status, 200);
      expect(events.skip(1).whereType<HttpDataEvent>().map((e) => utf8.decode(e.data!)).toList(), [
        'hello',
        'world',
      ]);
    });

    test('throws TransportError on non-ok responses', () async {
      final client = _FakeClient((request) async {
        return http.StreamedResponse(
          Stream<List<int>>.value(utf8.encode(json.encode({'error': 'nope'}))),
          500,
          headers: {'content-type': 'application/json'},
        );
      });

      final request = http.Request('GET', Uri.parse('https://example.com/test'));

      expect(
        () => runHttpRequest('https://example.com/test', request, client: client).toList(),
        throwsA(isA<TransportError>()),
      );
    });
  });
}

class _FakeClient extends http.BaseClient {
  final Future<http.StreamedResponse> Function(http.BaseRequest request) handler;

  _FakeClient(this.handler);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) => handler(request);
}
