/// Tool-related types for AG-UI protocol.
library;

import 'base.dart';

class FunctionCall extends AGUIModel {
  final String name;
  final String arguments;

  const FunctionCall({
    required this.name,
    required this.arguments,
  });

  factory FunctionCall.fromJson(Map<String, dynamic> json) {
    return FunctionCall(
      name: JsonDecoder.requireField<String>(json, 'name'),
      arguments: JsonDecoder.requireField<String>(json, 'arguments'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
    'arguments': arguments,
  };

  @override
  FunctionCall copyWith({
    String? name,
    String? arguments,
  }) {
    return FunctionCall(
      name: name ?? this.name,
      arguments: arguments ?? this.arguments,
    );
  }
}

class ToolCall extends AGUIModel {
  final String id;
  final String type;
  final FunctionCall function;
  final String? encryptedValue;

  const ToolCall({
    required this.id,
    this.type = 'function',
    required this.function,
    this.encryptedValue,
  });

  factory ToolCall.fromJson(Map<String, dynamic> json) {
    return ToolCall(
      id: JsonDecoder.requireField<String>(json, 'id'),
      type: JsonDecoder.optionalField<String>(json, 'type') ?? 'function',
      function: FunctionCall.fromJson(
        JsonDecoder.requireField<Map<String, dynamic>>(json, 'function'),
      ),
      encryptedValue: JsonDecoder.optionalField<String>(json, 'encryptedValue'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'function': function.toJson(),
    if (encryptedValue != null) 'encryptedValue': encryptedValue,
  };

  @override
  ToolCall copyWith({
    String? id,
    String? type,
    FunctionCall? function,
    String? encryptedValue,
  }) {
    return ToolCall(
      id: id ?? this.id,
      type: type ?? this.type,
      function: function ?? this.function,
      encryptedValue: encryptedValue ?? this.encryptedValue,
    );
  }
}

class Tool extends AGUIModel {
  final String name;
  final String description;
  final Object? parameters;
  final Map<String, dynamic>? metadata;

  const Tool({
    required this.name,
    required this.description,
    this.parameters,
    this.metadata,
  });

  factory Tool.fromJson(Map<String, dynamic> json) {
    return Tool(
      name: JsonDecoder.requireField<String>(json, 'name'),
      description: JsonDecoder.requireField<String>(json, 'description'),
      parameters: json['parameters'],
      metadata: JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    if (parameters != null) 'parameters': parameters,
    if (metadata != null) 'metadata': metadata,
  };

  @override
  Tool copyWith({
    String? name,
    String? description,
    Object? parameters,
    Map<String, dynamic>? metadata,
  }) {
    return Tool(
      name: name ?? this.name,
      description: description ?? this.description,
      parameters: parameters ?? this.parameters,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Convenience model for tool execution results in client-side workflows.
class ToolResult extends AGUIModel {
  final String toolCallId;
  final String content;
  final String? error;
  final Map<String, dynamic>? metadata;

  const ToolResult({
    required this.toolCallId,
    required this.content,
    this.error,
    this.metadata,
  });

  factory ToolResult.fromJson(Map<String, dynamic> json) {
    final toolCallId = JsonDecoder.optionalField<String>(json, 'toolCallId') ??
        JsonDecoder.optionalField<String>(json, 'tool_call_id');
    
    if (toolCallId == null) {
      throw AGUIValidationError(
        message: 'Missing required field: toolCallId or tool_call_id',
        field: 'toolCallId',
        json: json,
      );
    }
    
    return ToolResult(
      toolCallId: toolCallId,
      content: JsonDecoder.requireField<String>(json, 'content'),
      error: JsonDecoder.optionalField<String>(json, 'error'),
      metadata: JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'toolCallId': toolCallId,
    'content': content,
    if (error != null) 'error': error,
    if (metadata != null) 'metadata': metadata,
  };

  @override
  ToolResult copyWith({
    String? toolCallId,
    String? content,
    String? error,
    Map<String, dynamic>? metadata,
  }) {
    return ToolResult(
      toolCallId: toolCallId ?? this.toolCallId,
      content: content ?? this.content,
      error: error ?? this.error,
      metadata: metadata ?? this.metadata,
    );
  }
}
