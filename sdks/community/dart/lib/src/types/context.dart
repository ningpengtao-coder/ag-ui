/// Context and run types for AG-UI protocol.
library;

import 'base.dart';
import 'message.dart';
import 'tool.dart';

/// Additional context for the agent
class Context extends AGUIModel {
  final String description;
  final String value;

  const Context({
    required this.description,
    required this.value,
  });

  factory Context.fromJson(Map<String, dynamic> json) {
    return Context(
      description: JsonDecoder.requireField<String>(json, 'description'),
      value: JsonDecoder.requireField<String>(json, 'value'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'description': description,
    'value': value,
  };

  @override
  Context copyWith({
    String? description,
    String? value,
  }) {
    return Context(
      description: description ?? this.description,
      value: value ?? this.value,
    );
  }
}

class Interrupt extends AGUIModel {
  final String id;
  final String reason;
  final String? message;
  final String? toolCallId;
  final Map<String, dynamic>? responseSchema;
  final String? expiresAt;
  final Map<String, dynamic>? metadata;

  const Interrupt({
    required this.id,
    required this.reason,
    this.message,
    this.toolCallId,
    this.responseSchema,
    this.expiresAt,
    this.metadata,
  });

  factory Interrupt.fromJson(Map<String, dynamic> json) {
    return Interrupt(
      id: JsonDecoder.requireField<String>(json, 'id'),
      reason: JsonDecoder.requireField<String>(json, 'reason'),
      message: JsonDecoder.optionalField<String>(json, 'message'),
      toolCallId: JsonDecoder.optionalField<String>(json, 'toolCallId') ??
          JsonDecoder.optionalField<String>(json, 'tool_call_id'),
      responseSchema: JsonDecoder.optionalField<Map<String, dynamic>>(json, 'responseSchema'),
      expiresAt: JsonDecoder.optionalField<String>(json, 'expiresAt'),
      metadata: JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'reason': reason,
    if (message != null) 'message': message,
    if (toolCallId != null) 'toolCallId': toolCallId,
    if (responseSchema != null) 'responseSchema': responseSchema,
    if (expiresAt != null) 'expiresAt': expiresAt,
    if (metadata != null) 'metadata': metadata,
  };

  @override
  Interrupt copyWith({
    String? id,
    String? reason,
    String? message,
    String? toolCallId,
    Map<String, dynamic>? responseSchema,
    String? expiresAt,
    Map<String, dynamic>? metadata,
  }) {
    return Interrupt(
      id: id ?? this.id,
      reason: reason ?? this.reason,
      message: message ?? this.message,
      toolCallId: toolCallId ?? this.toolCallId,
      responseSchema: responseSchema ?? this.responseSchema,
      expiresAt: expiresAt ?? this.expiresAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

enum ResumeStatus {
  resolved('resolved'),
  cancelled('cancelled');

  final String value;
  const ResumeStatus(this.value);

  static ResumeStatus fromString(String value) {
    return ResumeStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => throw AGUIValidationError(
        message: 'Invalid resume status: $value',
        field: 'status',
        value: value,
      ),
    );
  }
}

class ResumeEntry extends AGUIModel {
  final String interruptId;
  final ResumeStatus status;
  final Object? payload;

  const ResumeEntry({
    required this.interruptId,
    required this.status,
    this.payload,
  });

  factory ResumeEntry.fromJson(Map<String, dynamic> json) {
    return ResumeEntry(
      interruptId: JsonDecoder.requireField<String>(json, 'interruptId'),
      status: ResumeStatus.fromString(JsonDecoder.requireField<String>(json, 'status')),
      payload: json['payload'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'interruptId': interruptId,
    'status': status.value,
    if (payload != null) 'payload': payload,
  };

  @override
  ResumeEntry copyWith({
    String? interruptId,
    ResumeStatus? status,
    Object? payload,
  }) {
    return ResumeEntry(
      interruptId: interruptId ?? this.interruptId,
      status: status ?? this.status,
      payload: payload ?? this.payload,
    );
  }
}

class RunAgentInput extends AGUIModel {
  final String threadId;
  final String runId;
  final String? parentRunId;
  final Object? state;
  final List<Message> messages;
  final List<Tool> tools;
  final List<Context> context;
  final Object? forwardedProps;
  final List<ResumeEntry>? resume;

  const RunAgentInput({
    required this.threadId,
    required this.runId,
    this.parentRunId,
    this.state,
    required this.messages,
    required this.tools,
    required this.context,
    this.forwardedProps,
    this.resume,
  });

  factory RunAgentInput.fromJson(Map<String, dynamic> json) {
    final threadId = JsonDecoder.optionalField<String>(json, 'threadId') ??
        JsonDecoder.optionalField<String>(json, 'thread_id');
    final runId = JsonDecoder.optionalField<String>(json, 'runId') ??
        JsonDecoder.optionalField<String>(json, 'run_id');

    if (threadId == null) {
      throw AGUIValidationError(
        message: 'Missing required field: threadId or thread_id',
        field: 'threadId',
        json: json,
      );
    }
    if (runId == null) {
      throw AGUIValidationError(
        message: 'Missing required field: runId or run_id',
        field: 'runId',
        json: json,
      );
    }
    
    return RunAgentInput(
      threadId: threadId,
      runId: runId,
      parentRunId: JsonDecoder.optionalField<String>(json, 'parentRunId') ??
          JsonDecoder.optionalField<String>(json, 'parent_run_id'),
      state: json['state'],
      messages: JsonDecoder.requireListField<Map<String, dynamic>>(
        json,
        'messages',
      ).map((item) => Message.fromJson(item)).toList(),
      tools: JsonDecoder.requireListField<Map<String, dynamic>>(
        json,
        'tools',
      ).map((item) => Tool.fromJson(item)).toList(),
      context: JsonDecoder.requireListField<Map<String, dynamic>>(
        json,
        'context',
      ).map((item) => Context.fromJson(item)).toList(),
      forwardedProps: json['forwardedProps'] ?? json['forwarded_props'],
      resume: JsonDecoder.optionalListField<Map<String, dynamic>>(json, 'resume')
          ?.map((item) => ResumeEntry.fromJson(item))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'threadId': threadId,
    'runId': runId,
    if (parentRunId != null) 'parentRunId': parentRunId,
    if (state != null) 'state': state,
    'messages': messages.map((m) => m.toJson()).toList(),
    'tools': tools.map((t) => t.toJson()).toList(),
    'context': context.map((c) => c.toJson()).toList(),
    if (forwardedProps != null) 'forwardedProps': forwardedProps,
    if (resume != null) 'resume': resume!.map((item) => item.toJson()).toList(),
  };

  @override
  RunAgentInput copyWith({
    String? threadId,
    String? runId,
    String? parentRunId,
    Object? state,
    List<Message>? messages,
    List<Tool>? tools,
    List<Context>? context,
    Object? forwardedProps,
    List<ResumeEntry>? resume,
  }) {
    return RunAgentInput(
      threadId: threadId ?? this.threadId,
      runId: runId ?? this.runId,
      parentRunId: parentRunId ?? this.parentRunId,
      state: state ?? this.state,
      messages: messages ?? this.messages,
      tools: tools ?? this.tools,
      context: context ?? this.context,
      forwardedProps: forwardedProps ?? this.forwardedProps,
      resume: resume ?? this.resume,
    );
  }
}

/// Represents a run in the AG-UI protocol
class Run extends AGUIModel {
  final String threadId;
  final String runId;
  final dynamic result;

  const Run({
    required this.threadId,
    required this.runId,
    this.result,
  });

  factory Run.fromJson(Map<String, dynamic> json) {
    // Handle both camelCase and snake_case field names
    final threadId = JsonDecoder.optionalField<String>(json, 'threadId') ??
        JsonDecoder.optionalField<String>(json, 'thread_id');
    final runId = JsonDecoder.optionalField<String>(json, 'runId') ??
        JsonDecoder.optionalField<String>(json, 'run_id');
    
    if (threadId == null) {
      throw AGUIValidationError(
        message: 'Missing required field: threadId or thread_id',
        field: 'threadId',
        json: json,
      );
    }
    if (runId == null) {
      throw AGUIValidationError(
        message: 'Missing required field: runId or run_id',
        field: 'runId',
        json: json,
      );
    }
    
    return Run(
      threadId: threadId,
      runId: runId,
      result: json['result'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'threadId': threadId,
    'runId': runId,
    if (result != null) 'result': result,
  };

  @override
  Run copyWith({
    String? threadId,
    String? runId,
    dynamic result,
  }) {
    return Run(
      threadId: threadId ?? this.threadId,
      runId: runId ?? this.runId,
      result: result ?? this.result,
    );
  }
}

/// Type alias for state (can be any type)
typedef State = dynamic;
