library;

import 'dart:convert';

class ExtractedItemsWithStatus {
  final List<Object?> items;
  final bool arrayClosed;

  const ExtractedItemsWithStatus({
    required this.items,
    required this.arrayClosed,
  });
}

List<Object?>? extractCompleteItems(String partial, String dataKey) {
  return extractCompleteItemsWithStatus(partial, dataKey)?.items;
}

ExtractedItemsWithStatus? extractCompleteItemsWithStatus(
  String partial,
  String dataKey,
) {
  final valueStart = _findValueStart(partial, dataKey);
  if (valueStart == null || partial[valueStart] != '[') {
    return null;
  }

  final items = <Object?>[];
  var index = valueStart + 1;
  var arrayClosed = false;

  while (index < partial.length) {
    index = _skipWhitespace(partial, index);
    if (index >= partial.length) {
      break;
    }

    final char = partial[index];
    if (char == ']') {
      arrayClosed = true;
      index++;
      break;
    }
    if (char == ',') {
      index++;
      continue;
    }

    final end = _findJsonValueEnd(partial, index);
    if (end == null) {
      break;
    }

    try {
      items.add(jsonDecode(partial.substring(index, end)));
    } on FormatException {
      break;
    }

    index = _skipWhitespace(partial, end);
    if (index < partial.length && partial[index] == ',') {
      index++;
      continue;
    }
    if (index < partial.length && partial[index] == ']') {
      arrayClosed = true;
      index++;
      break;
    }
  }

  if (items.isEmpty) {
    return null;
  }

  return ExtractedItemsWithStatus(items: items, arrayClosed: arrayClosed);
}

Map<String, dynamic>? extractCompleteObject(String partial, String dataKey) {
  final valueStart = _findValueStart(partial, dataKey);
  if (valueStart == null || partial[valueStart] != '{') {
    return null;
  }

  final end = _findBalancedEnd(partial, valueStart, '{', '}');
  if (end == null) {
    return null;
  }

  try {
    final value = jsonDecode(partial.substring(valueStart, end));
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
  } on FormatException {
    return null;
  }

  return null;
}

String? extractStringField(String partial, String key) {
  final valueStart = _findValueStart(partial, key);
  if (valueStart == null || partial[valueStart] != '"') {
    return null;
  }

  final end = _findStringEnd(partial, valueStart);
  if (end == null) {
    return null;
  }

  try {
    final value = jsonDecode(partial.substring(valueStart, end));
    return value is String ? value : null;
  } on FormatException {
    return null;
  }
}

int? _findValueStart(String partial, String key) {
  final keyPattern = '"$key"';
  final keyIndex = partial.indexOf(keyPattern);
  if (keyIndex == -1) {
    return null;
  }

  final colonIndex = partial.indexOf(':', keyIndex + keyPattern.length);
  if (colonIndex == -1) {
    return null;
  }

  final start = _skipWhitespace(partial, colonIndex + 1);
  return start < partial.length ? start : null;
}

int _skipWhitespace(String input, int start) {
  var index = start;
  while (index < input.length) {
    final char = input[index];
    if (char != ' ' && char != '\n' && char != '\r' && char != '\t') {
      break;
    }
    index++;
  }
  return index;
}

int? _findJsonValueEnd(String input, int start) {
  final char = input[start];
  if (char == '{') {
    return _findBalancedEnd(input, start, '{', '}');
  }
  if (char == '[') {
    return _findBalancedEnd(input, start, '[', ']');
  }
  if (char == '"') {
    return _findStringEnd(input, start);
  }
  return _findPrimitiveEnd(input, start);
}

int? _findBalancedEnd(
  String input,
  int start,
  String openChar,
  String closeChar,
) {
  var depth = 0;
  var inString = false;
  var escaping = false;

  for (var i = start; i < input.length; i++) {
    final char = input[i];
    if (inString) {
      if (escaping) {
        escaping = false;
      } else if (char == r'\') {
        escaping = true;
      } else if (char == '"') {
        inString = false;
      }
      continue;
    }

    if (char == '"') {
      inString = true;
      continue;
    }
    if (char == openChar) {
      depth++;
      continue;
    }
    if (char == closeChar) {
      depth--;
      if (depth == 0) {
        return i + 1;
      }
    }
  }

  return null;
}

int? _findStringEnd(String input, int start) {
  var escaping = false;
  for (var i = start + 1; i < input.length; i++) {
    final char = input[i];
    if (escaping) {
      escaping = false;
      continue;
    }
    if (char == r'\') {
      escaping = true;
      continue;
    }
    if (char == '"') {
      return i + 1;
    }
  }
  return null;
}

int? _findPrimitiveEnd(String input, int start) {
  var index = start;
  while (index < input.length) {
    final char = input[index];
    if (char == ',' || char == ']' || char == '}' || char == '\n' || char == '\r') {
      break;
    }
    index++;
  }

  if (index == start) {
    return null;
  }

  final candidate = input.substring(start, index).trimRight();
  if (candidate.isEmpty) {
    return null;
  }

  try {
    jsonDecode(candidate);
    return start + candidate.length;
  } on FormatException {
    return null;
  }
}
