library;

import 'dart:convert';

import '../types/base.dart';

/// Container key used to wrap A2UI operations.
const String a2uiOperationsKey = 'a2ui_operations';

class A2UIParseResult extends AGUIModel {
  final List<Map<String, dynamic>> operations;

  const A2UIParseResult({
    required this.operations,
  });

  @override
  Map<String, dynamic> toJson() => {
    a2uiOperationsKey: operations,
  };

  @override
  A2UIParseResult copyWith({
    List<Map<String, dynamic>>? operations,
  }) {
    return A2UIParseResult(
      operations: operations ?? this.operations,
    );
  }
}

/// Try to parse text as an A2UI operations container.
A2UIParseResult? tryParseA2UIOperations(String text) {
  final parsed = _parseJsonValue(text);
  final result = _extractOperations(parsed);
  if (result != null) {
    return result;
  }

  if (parsed is String) {
    return _extractOperations(_parseJsonValue(parsed));
  }

  return null;
}

String? getOperationSurfaceId(Map<String, dynamic> operation) {
  final createSurface = operation['createSurface'];
  if (createSurface is Map && createSurface['surfaceId'] is String) {
    return createSurface['surfaceId'] as String;
  }

  final updateComponents = operation['updateComponents'];
  if (updateComponents is Map && updateComponents['surfaceId'] is String) {
    return updateComponents['surfaceId'] as String;
  }

  final updateDataModel = operation['updateDataModel'];
  if (updateDataModel is Map && updateDataModel['surfaceId'] is String) {
    return updateDataModel['surfaceId'] as String;
  }

  final deleteSurface = operation['deleteSurface'];
  if (deleteSurface is Map && deleteSurface['surfaceId'] is String) {
    return deleteSurface['surfaceId'] as String;
  }

  return null;
}

List<String> extractSurfaceIds(List<Map<String, dynamic>> operations) {
  final surfaceIds = <String>{};
  for (final operation in operations) {
    final surfaceId = getOperationSurfaceId(operation);
    if (surfaceId != null) {
      surfaceIds.add(surfaceId);
    }
  }
  return surfaceIds.toList();
}

Object? _parseJsonValue(String text) {
  try {
    return jsonDecode(text);
  } on FormatException {
    return null;
  }
}

A2UIParseResult? _extractOperations(Object? value) {
  if (value is! Map) {
    return null;
  }

  final operations = value[a2uiOperationsKey];
  if (operations is! List) {
    return null;
  }

  final normalized = <Map<String, dynamic>>[];
  for (final operation in operations) {
    if (operation is! Map) {
      return null;
    }
    normalized.add(Map<String, dynamic>.from(operation));
  }

  return A2UIParseResult(operations: normalized);
}
