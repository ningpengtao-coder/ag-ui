import 'package:ag_ui/ag_ui.dart';
import 'package:test/test.dart';

void main() {
  group('extractCompleteItems', () {
    test('returns complete objects from a partially streamed array', () {
      const partial = '{"components": [{"id":"1","text":"A"}, {"id":"2"';

      final items = extractCompleteItems(partial, 'components');

      expect(items, hasLength(1));
      expect(items!.single, {
        'id': '1',
        'text': 'A',
      });
    });

    test('returns all items and closed status when array is complete', () {
      const partial = '{"components": [{"id":"1"}, {"id":"2"}]}';

      final result = extractCompleteItemsWithStatus(partial, 'components');

      expect(result, isNotNull);
      expect(result!.arrayClosed, isTrue);
      expect(result.items, hasLength(2));
    });

    test('returns null when key is missing', () {
      expect(extractCompleteItems('{"other": []}', 'components'), isNull);
    });

    test('supports nested objects inside items', () {
      const partial =
          '{"components": [{"id":"1","props":{"value":"A"}}, {"id":"2"';

      final items = extractCompleteItems(partial, 'components');

      expect(items, hasLength(1));
      expect(items!.single, {
        'id': '1',
        'props': {'value': 'A'},
      });
    });
  });

  group('extractCompleteObject', () {
    test('extracts a complete object value', () {
      const partial =
          '{"surfaceId":"s1","data":{"form":{"name":"Alice"}},"components":[]}';

      final data = extractCompleteObject(partial, 'data');

      expect(data, {
        'form': {'name': 'Alice'},
      });
    });

    test('returns null when object is not fully closed', () {
      const partial = '{"surfaceId":"s1","data":{"form":{"name":"Ali';

      expect(extractCompleteObject(partial, 'data'), isNull);
    });

    test('supports nested arrays and braces inside strings', () {
      const partial =
          '{"data":{"items":[1,2],"message":"hello {world}"},"done":true}';

      final data = extractCompleteObject(partial, 'data');

      expect(data, {
        'items': [1, 2],
        'message': 'hello {world}',
      });
    });
  });

  group('extractStringField', () {
    test('extracts a complete string field', () {
      const partial = '{"surfaceId":"name-form","components":[]}';

      expect(extractStringField(partial, 'surfaceId'), 'name-form');
    });

    test('returns null for incomplete string values', () {
      const partial = '{"surfaceId":"name-fo';

      expect(extractStringField(partial, 'surfaceId'), isNull);
    });

    test('handles escaped characters', () {
      const partial = r'{"path":"a\\b\nc"}';

      expect(extractStringField(partial, 'path'), 'a\\b\nc');
    });
  });
}
