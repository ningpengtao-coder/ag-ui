library;

import 'dart:convert';

import '../types/base.dart';
import '../types/message.dart';

Object? normalizeJsonValue(Object? value) {
  if (value == null || value is String || value is num || value is bool) {
    return value;
  }
  if (value is UserMessageContent) {
    return normalizeJsonValue(value.toJsonValue());
  }
  if (value is AGUIModel) {
    return normalizeJsonValue(value.toJson());
  }
  if (value is Map) {
    return value.map(
      (key, item) => MapEntry(key.toString(), normalizeJsonValue(item)),
    );
  }
  if (value is Iterable) {
    return value.map(normalizeJsonValue).toList();
  }
  return value;
}

Object? cloneJsonValue(Object? value) {
  if (value == null) return null;
  return jsonDecode(jsonEncode(normalizeJsonValue(value)));
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

    final operation = Map<String, dynamic>.from(rawOperation);
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
      case 'move':
        working = _applyMove(working, path, operation['from']);
      case 'copy':
        working = _applyCopy(working, path, operation['from']);
      case 'test':
        working = _applyTest(working, path, operation['value']);
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

Object? _applyMove(Object? document, String path, Object? from) {
  if (from is! String) {
    throw ArgumentError('A move operation must include "from".');
  }
  final value = _resolveValue(document, from);
  return _applyAdd(_applyRemove(document, from), path, value);
}

Object? _applyCopy(Object? document, String path, Object? from) {
  if (from is! String) {
    throw ArgumentError('A copy operation must include "from".');
  }
  return _applyAdd(document, path, _resolveValue(document, from));
}

Object? _applyTest(Object? document, String path, Object? expected) {
  if (!_jsonEquals(_resolveValue(document, path), expected)) {
    throw ArgumentError('Test operation failed at path "$path".');
  }
  return document;
}

/// Resolves the value a JSON Pointer addresses.
Object? _resolveValue(Object? document, String pointer) {
  var current = document;
  for (final segment in _decodePointer(pointer)) {
    if (current is Map<String, dynamic>) {
      if (!current.containsKey(segment)) {
        throw ArgumentError('Path segment "$segment" does not exist.');
      }
      current = current[segment];
    } else if (current is List<Object?>) {
      current = current[int.parse(segment)];
    } else {
      throw ArgumentError('Cannot traverse path through non-container value.');
    }
  }
  return current;
}

bool _jsonEquals(Object? a, Object? b) {
  if (a is Map<Object?, Object?> && b is Map<Object?, Object?>) {
    if (a.length != b.length) {
      return false;
    }
    for (final key in a.keys) {
      if (!b.containsKey(key) || !_jsonEquals(a[key], b[key])) {
        return false;
      }
    }
    return true;
  }
  if (a is List<Object?> && b is List<Object?>) {
    if (a.length != b.length) {
      return false;
    }
    for (var index = 0; index < a.length; index++) {
      if (!_jsonEquals(a[index], b[index])) {
        return false;
      }
    }
    return true;
  }
  return a == b;
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
