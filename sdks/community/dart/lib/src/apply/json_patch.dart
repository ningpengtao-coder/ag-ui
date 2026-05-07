library;

import 'dart:convert';

Object? cloneJsonValue(Object? value) {
  if (value == null) return null;
  return jsonDecode(jsonEncode(value));
}

List<String> _decodePointer(String pointer) {
  if (pointer.isEmpty) return const [];
  if (!pointer.startsWith('/')) {
    throw ArgumentError('JSON Pointer must start with "/"');
  }
  return pointer
      .substring(1)
      .split('/')
      .map((segment) => segment.replaceAll('~1', '/').replaceAll('~0', '~'))
      .toList();
}

Object? applyJsonPatch(Object? document, List<dynamic> operations) {
  Object? working = cloneJsonValue(document);

  for (final rawOperation in operations) {
    if (rawOperation is! Map) {
      throw ArgumentError('Patch operation must be an object.');
    }

    final operation = Map<String, dynamic>.from(rawOperation as Map);
    final op = operation['op'] as String?;
    final path = operation['path'] as String?;
    if (op == null || path == null) {
      throw ArgumentError('Patch operation must include "op" and "path".');
    }

    switch (op) {
      case 'add':
        working = _applyAdd(working, path, operation['value']);
      case 'replace':
        working = _applyReplace(working, path, operation['value']);
      case 'remove':
        working = _applyRemove(working, path);
      default:
        throw UnsupportedError('Unsupported JSON Patch operation: $op');
    }
  }

  return working;
}

Object? _applyAdd(Object? document, String path, Object? value) {
  final segments = _decodePointer(path);
  if (segments.isEmpty) {
    return cloneJsonValue(value);
  }

  final clonedValue = cloneJsonValue(value);
  final parent = _resolveParent(document, segments);
  final last = segments.last;

  if (parent is Map<String, dynamic>) {
    parent[last] = clonedValue;
    return document;
  }

  if (parent is List) {
    if (last == '-') {
      parent.add(clonedValue);
      return document;
    }
    final index = int.parse(last);
    if (index < 0 || index > parent.length) {
      throw RangeError.index(index, parent, last);
    }
    parent.insert(index, clonedValue);
    return document;
  }

  throw ArgumentError('Cannot apply add operation at path "$path".');
}

Object? _applyReplace(Object? document, String path, Object? value) {
  final segments = _decodePointer(path);
  if (segments.isEmpty) {
    return cloneJsonValue(value);
  }

  final clonedValue = cloneJsonValue(value);
  final parent = _resolveParent(document, segments);
  final last = segments.last;

  if (parent is Map<String, dynamic>) {
    if (!parent.containsKey(last)) {
      throw ArgumentError('Path "$path" does not exist for replace.');
    }
    parent[last] = clonedValue;
    return document;
  }

  if (parent is List) {
    final index = int.parse(last);
    parent[index] = clonedValue;
    return document;
  }

  throw ArgumentError('Cannot apply replace operation at path "$path".');
}

Object? _applyRemove(Object? document, String path) {
  final segments = _decodePointer(path);
  if (segments.isEmpty) {
    return null;
  }

  final parent = _resolveParent(document, segments);
  final last = segments.last;

  if (parent is Map<String, dynamic>) {
    if (!parent.containsKey(last)) {
      throw ArgumentError('Path "$path" does not exist for remove.');
    }
    parent.remove(last);
    return document;
  }

  if (parent is List) {
    final index = int.parse(last);
    parent.removeAt(index);
    return document;
  }

  throw ArgumentError('Cannot apply remove operation at path "$path".');
}

Object? _resolveParent(Object? document, List<String> segments) {
  if (segments.length == 1) {
    return document;
  }

  Object? current = document;
  for (final segment in segments.take(segments.length - 1)) {
    if (current is Map<String, dynamic>) {
      if (!current.containsKey(segment)) {
        throw ArgumentError('Path segment "$segment" does not exist.');
      }
      current = current[segment];
    } else if (current is List) {
      final index = int.parse(segment);
      current = current[index];
    } else {
      throw ArgumentError('Cannot traverse path through non-container value.');
    }
  }

  return current;
}
