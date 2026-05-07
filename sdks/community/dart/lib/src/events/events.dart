library;

import '../types/base.dart';
import '../types/context.dart';
import '../types/message.dart';
import 'event_type.dart';

export 'event_type.dart';

enum TextMessageRole {
  developer('developer'),
  system('system'),
  assistant('assistant'),
  user('user');

  final String value;
  const TextMessageRole(this.value);

  static TextMessageRole fromString(String value) {
    return TextMessageRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => TextMessageRole.assistant,
    );
  }
}

enum ReasoningEncryptedValueSubtype {
  toolCall('tool-call'),
  message('message');

  final String value;
  const ReasoningEncryptedValueSubtype(this.value);

  static ReasoningEncryptedValueSubtype fromString(String value) {
    return ReasoningEncryptedValueSubtype.values.firstWhere(
      (item) => item.value == value,
      orElse: () => throw AGUIValidationError(
        message: 'Invalid reasoning encrypted value subtype: $value',
        field: 'subtype',
        value: value,
      ),
    );
  }
}

sealed class BaseEvent extends AGUIModel with TypeDiscriminator {
  final EventType eventType;
  final int? timestamp;
  final Object? rawEvent;

  const BaseEvent({
    required this.eventType,
    this.timestamp,
    this.rawEvent,
  });

  @override
  String get type => eventType.value;

  factory BaseEvent.fromJson(Map<String, dynamic> json) {
    final eventType = EventType.fromString(JsonDecoder.requireField<String>(json, 'type'));
    switch (eventType) {
      case EventType.textMessageStart:
        return TextMessageStartEvent.fromJson(json);
      case EventType.textMessageContent:
        return TextMessageContentEvent.fromJson(json);
      case EventType.textMessageEnd:
        return TextMessageEndEvent.fromJson(json);
      case EventType.textMessageChunk:
        return TextMessageChunkEvent.fromJson(json);
      case EventType.toolCallStart:
        return ToolCallStartEvent.fromJson(json);
      case EventType.toolCallArgs:
        return ToolCallArgsEvent.fromJson(json);
      case EventType.toolCallEnd:
        return ToolCallEndEvent.fromJson(json);
      case EventType.toolCallChunk:
        return ToolCallChunkEvent.fromJson(json);
      case EventType.toolCallResult:
        return ToolCallResultEvent.fromJson(json);
      case EventType.thinkingStart:
        return ThinkingStartEvent.fromJson(json);
      case EventType.thinkingContent:
        return ThinkingContentEvent.fromJson(json);
      case EventType.thinkingEnd:
        return ThinkingEndEvent.fromJson(json);
      case EventType.thinkingTextMessageStart:
        return ThinkingTextMessageStartEvent.fromJson(json);
      case EventType.thinkingTextMessageContent:
        return ThinkingTextMessageContentEvent.fromJson(json);
      case EventType.thinkingTextMessageEnd:
        return ThinkingTextMessageEndEvent.fromJson(json);
      case EventType.stateSnapshot:
        return StateSnapshotEvent.fromJson(json);
      case EventType.stateDelta:
        return StateDeltaEvent.fromJson(json);
      case EventType.messagesSnapshot:
        return MessagesSnapshotEvent.fromJson(json);
      case EventType.activitySnapshot:
        return ActivitySnapshotEvent.fromJson(json);
      case EventType.activityDelta:
        return ActivityDeltaEvent.fromJson(json);
      case EventType.raw:
        return RawEvent.fromJson(json);
      case EventType.custom:
        return CustomEvent.fromJson(json);
      case EventType.runStarted:
        return RunStartedEvent.fromJson(json);
      case EventType.runFinished:
        return RunFinishedEvent.fromJson(json);
      case EventType.runError:
        return RunErrorEvent.fromJson(json);
      case EventType.stepStarted:
        return StepStartedEvent.fromJson(json);
      case EventType.stepFinished:
        return StepFinishedEvent.fromJson(json);
      case EventType.reasoningStart:
        return ReasoningStartEvent.fromJson(json);
      case EventType.reasoningMessageStart:
        return ReasoningMessageStartEvent.fromJson(json);
      case EventType.reasoningMessageContent:
        return ReasoningMessageContentEvent.fromJson(json);
      case EventType.reasoningMessageEnd:
        return ReasoningMessageEndEvent.fromJson(json);
      case EventType.reasoningMessageChunk:
        return ReasoningMessageChunkEvent.fromJson(json);
      case EventType.reasoningEnd:
        return ReasoningEndEvent.fromJson(json);
      case EventType.reasoningEncryptedValue:
        return ReasoningEncryptedValueEvent.fromJson(json);
    }
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': eventType.value,
    if (timestamp != null) 'timestamp': timestamp,
    if (rawEvent != null) 'rawEvent': rawEvent,
  };
}

String _requireNonEmptyString(Map<String, dynamic> json, String field) {
  final value = JsonDecoder.requireField<String>(json, field);
  if (value.isEmpty) {
    throw AGUIValidationError(
      message: '$field must not be an empty string',
      field: field,
      value: value,
      json: json,
    );
  }
  return value;
}

final class TextMessageStartEvent extends BaseEvent {
  final String messageId;
  final TextMessageRole role;
  final String? name;

  const TextMessageStartEvent({
    required this.messageId,
    this.role = TextMessageRole.assistant,
    this.name,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.textMessageStart);

  factory TextMessageStartEvent.fromJson(Map<String, dynamic> json) {
    return TextMessageStartEvent(
      messageId: JsonDecoder.requireField<String>(json, 'messageId'),
      role: TextMessageRole.fromString(
        JsonDecoder.optionalField<String>(json, 'role') ?? 'assistant',
      ),
      name: JsonDecoder.optionalField<String>(json, 'name'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'messageId': messageId,
    'role': role.value,
    if (name != null) 'name': name,
  };

  @override
  TextMessageStartEvent copyWith({
    String? messageId,
    TextMessageRole? role,
    String? name,
    int? timestamp,
    Object? rawEvent,
  }) {
    return TextMessageStartEvent(
      messageId: messageId ?? this.messageId,
      role: role ?? this.role,
      name: name ?? this.name,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class TextMessageContentEvent extends BaseEvent {
  final String messageId;
  final String delta;

  const TextMessageContentEvent({
    required this.messageId,
    required this.delta,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.textMessageContent);

  factory TextMessageContentEvent.fromJson(Map<String, dynamic> json) {
    return TextMessageContentEvent(
      messageId: JsonDecoder.requireField<String>(json, 'messageId'),
      delta: _requireNonEmptyString(json, 'delta'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'messageId': messageId,
    'delta': delta,
  };

  @override
  TextMessageContentEvent copyWith({
    String? messageId,
    String? delta,
    int? timestamp,
    Object? rawEvent,
  }) {
    return TextMessageContentEvent(
      messageId: messageId ?? this.messageId,
      delta: delta ?? this.delta,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class TextMessageEndEvent extends BaseEvent {
  final String messageId;

  const TextMessageEndEvent({
    required this.messageId,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.textMessageEnd);

  factory TextMessageEndEvent.fromJson(Map<String, dynamic> json) {
    return TextMessageEndEvent(
      messageId: JsonDecoder.requireField<String>(json, 'messageId'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'messageId': messageId,
  };

  @override
  TextMessageEndEvent copyWith({
    String? messageId,
    int? timestamp,
    Object? rawEvent,
  }) {
    return TextMessageEndEvent(
      messageId: messageId ?? this.messageId,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class TextMessageChunkEvent extends BaseEvent {
  final String? messageId;
  final TextMessageRole? role;
  final String? delta;
  final String? name;

  const TextMessageChunkEvent({
    this.messageId,
    this.role,
    this.delta,
    this.name,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.textMessageChunk);

  factory TextMessageChunkEvent.fromJson(Map<String, dynamic> json) {
    final role = JsonDecoder.optionalField<String>(json, 'role');
    return TextMessageChunkEvent(
      messageId: JsonDecoder.optionalField<String>(json, 'messageId'),
      role: role == null ? null : TextMessageRole.fromString(role),
      delta: JsonDecoder.optionalField<String>(json, 'delta'),
      name: JsonDecoder.optionalField<String>(json, 'name'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    if (messageId != null) 'messageId': messageId,
    if (role != null) 'role': role!.value,
    if (delta != null) 'delta': delta,
    if (name != null) 'name': name,
  };

  @override
  TextMessageChunkEvent copyWith({
    String? messageId,
    TextMessageRole? role,
    String? delta,
    String? name,
    int? timestamp,
    Object? rawEvent,
  }) {
    return TextMessageChunkEvent(
      messageId: messageId ?? this.messageId,
      role: role ?? this.role,
      delta: delta ?? this.delta,
      name: name ?? this.name,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class ThinkingStartEvent extends BaseEvent {
  final String? title;

  const ThinkingStartEvent({
    this.title,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.thinkingStart);

  factory ThinkingStartEvent.fromJson(Map<String, dynamic> json) {
    return ThinkingStartEvent(
      title: JsonDecoder.optionalField<String>(json, 'title'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    if (title != null) 'title': title,
  };

  @override
  ThinkingStartEvent copyWith({
    String? title,
    int? timestamp,
    Object? rawEvent,
  }) {
    return ThinkingStartEvent(
      title: title ?? this.title,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

/// Legacy compatibility event kept for the previous Dart wire format.
final class ThinkingContentEvent extends BaseEvent {
  final String delta;

  const ThinkingContentEvent({
    required this.delta,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.thinkingContent);

  factory ThinkingContentEvent.fromJson(Map<String, dynamic> json) {
    return ThinkingContentEvent(
      delta: _requireNonEmptyString(json, 'delta'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'delta': delta,
  };

  @override
  ThinkingContentEvent copyWith({
    String? delta,
    int? timestamp,
    Object? rawEvent,
  }) {
    return ThinkingContentEvent(
      delta: delta ?? this.delta,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class ThinkingEndEvent extends BaseEvent {
  const ThinkingEndEvent({
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.thinkingEnd);

  factory ThinkingEndEvent.fromJson(Map<String, dynamic> json) {
    return ThinkingEndEvent(
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  ThinkingEndEvent copyWith({
    int? timestamp,
    Object? rawEvent,
  }) {
    return ThinkingEndEvent(
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class ThinkingTextMessageStartEvent extends BaseEvent {
  const ThinkingTextMessageStartEvent({
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.thinkingTextMessageStart);

  factory ThinkingTextMessageStartEvent.fromJson(Map<String, dynamic> json) {
    return ThinkingTextMessageStartEvent(
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  ThinkingTextMessageStartEvent copyWith({
    int? timestamp,
    Object? rawEvent,
  }) {
    return ThinkingTextMessageStartEvent(
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class ThinkingTextMessageContentEvent extends BaseEvent {
  final String delta;

  const ThinkingTextMessageContentEvent({
    required this.delta,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.thinkingTextMessageContent);

  factory ThinkingTextMessageContentEvent.fromJson(Map<String, dynamic> json) {
    return ThinkingTextMessageContentEvent(
      delta: _requireNonEmptyString(json, 'delta'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'delta': delta,
  };

  @override
  ThinkingTextMessageContentEvent copyWith({
    String? delta,
    int? timestamp,
    Object? rawEvent,
  }) {
    return ThinkingTextMessageContentEvent(
      delta: delta ?? this.delta,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class ThinkingTextMessageEndEvent extends BaseEvent {
  const ThinkingTextMessageEndEvent({
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.thinkingTextMessageEnd);

  factory ThinkingTextMessageEndEvent.fromJson(Map<String, dynamic> json) {
    return ThinkingTextMessageEndEvent(
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  ThinkingTextMessageEndEvent copyWith({
    int? timestamp,
    Object? rawEvent,
  }) {
    return ThinkingTextMessageEndEvent(
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class ToolCallStartEvent extends BaseEvent {
  final String toolCallId;
  final String toolCallName;
  final String? parentMessageId;

  const ToolCallStartEvent({
    required this.toolCallId,
    required this.toolCallName,
    this.parentMessageId,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.toolCallStart);

  factory ToolCallStartEvent.fromJson(Map<String, dynamic> json) {
    return ToolCallStartEvent(
      toolCallId: JsonDecoder.requireField<String>(json, 'toolCallId'),
      toolCallName: JsonDecoder.requireField<String>(json, 'toolCallName'),
      parentMessageId: JsonDecoder.optionalField<String>(json, 'parentMessageId'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'toolCallId': toolCallId,
    'toolCallName': toolCallName,
    if (parentMessageId != null) 'parentMessageId': parentMessageId,
  };

  @override
  ToolCallStartEvent copyWith({
    String? toolCallId,
    String? toolCallName,
    String? parentMessageId,
    int? timestamp,
    Object? rawEvent,
  }) {
    return ToolCallStartEvent(
      toolCallId: toolCallId ?? this.toolCallId,
      toolCallName: toolCallName ?? this.toolCallName,
      parentMessageId: parentMessageId ?? this.parentMessageId,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class ToolCallArgsEvent extends BaseEvent {
  final String toolCallId;
  final String delta;

  const ToolCallArgsEvent({
    required this.toolCallId,
    required this.delta,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.toolCallArgs);

  factory ToolCallArgsEvent.fromJson(Map<String, dynamic> json) {
    return ToolCallArgsEvent(
      toolCallId: JsonDecoder.requireField<String>(json, 'toolCallId'),
      delta: JsonDecoder.requireField<String>(json, 'delta'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'toolCallId': toolCallId,
    'delta': delta,
  };

  @override
  ToolCallArgsEvent copyWith({
    String? toolCallId,
    String? delta,
    int? timestamp,
    Object? rawEvent,
  }) {
    return ToolCallArgsEvent(
      toolCallId: toolCallId ?? this.toolCallId,
      delta: delta ?? this.delta,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class ToolCallEndEvent extends BaseEvent {
  final String toolCallId;

  const ToolCallEndEvent({
    required this.toolCallId,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.toolCallEnd);

  factory ToolCallEndEvent.fromJson(Map<String, dynamic> json) {
    return ToolCallEndEvent(
      toolCallId: JsonDecoder.requireField<String>(json, 'toolCallId'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'toolCallId': toolCallId,
  };

  @override
  ToolCallEndEvent copyWith({
    String? toolCallId,
    int? timestamp,
    Object? rawEvent,
  }) {
    return ToolCallEndEvent(
      toolCallId: toolCallId ?? this.toolCallId,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class ToolCallChunkEvent extends BaseEvent {
  final String? toolCallId;
  final String? toolCallName;
  final String? parentMessageId;
  final String? delta;

  const ToolCallChunkEvent({
    this.toolCallId,
    this.toolCallName,
    this.parentMessageId,
    this.delta,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.toolCallChunk);

  factory ToolCallChunkEvent.fromJson(Map<String, dynamic> json) {
    return ToolCallChunkEvent(
      toolCallId: JsonDecoder.optionalField<String>(json, 'toolCallId'),
      toolCallName: JsonDecoder.optionalField<String>(json, 'toolCallName'),
      parentMessageId: JsonDecoder.optionalField<String>(json, 'parentMessageId'),
      delta: JsonDecoder.optionalField<String>(json, 'delta'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    if (toolCallId != null) 'toolCallId': toolCallId,
    if (toolCallName != null) 'toolCallName': toolCallName,
    if (parentMessageId != null) 'parentMessageId': parentMessageId,
    if (delta != null) 'delta': delta,
  };

  @override
  ToolCallChunkEvent copyWith({
    String? toolCallId,
    String? toolCallName,
    String? parentMessageId,
    String? delta,
    int? timestamp,
    Object? rawEvent,
  }) {
    return ToolCallChunkEvent(
      toolCallId: toolCallId ?? this.toolCallId,
      toolCallName: toolCallName ?? this.toolCallName,
      parentMessageId: parentMessageId ?? this.parentMessageId,
      delta: delta ?? this.delta,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class ToolCallResultEvent extends BaseEvent {
  final String messageId;
  final String toolCallId;
  final String content;
  final String? role;

  const ToolCallResultEvent({
    required this.messageId,
    required this.toolCallId,
    required this.content,
    this.role,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.toolCallResult);

  factory ToolCallResultEvent.fromJson(Map<String, dynamic> json) {
    return ToolCallResultEvent(
      messageId: JsonDecoder.requireField<String>(json, 'messageId'),
      toolCallId: JsonDecoder.requireField<String>(json, 'toolCallId'),
      content: JsonDecoder.requireField<String>(json, 'content'),
      role: JsonDecoder.optionalField<String>(json, 'role'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'messageId': messageId,
    'toolCallId': toolCallId,
    'content': content,
    if (role != null) 'role': role,
  };

  @override
  ToolCallResultEvent copyWith({
    String? messageId,
    String? toolCallId,
    String? content,
    String? role,
    int? timestamp,
    Object? rawEvent,
  }) {
    return ToolCallResultEvent(
      messageId: messageId ?? this.messageId,
      toolCallId: toolCallId ?? this.toolCallId,
      content: content ?? this.content,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class StateSnapshotEvent extends BaseEvent {
  final State snapshot;

  const StateSnapshotEvent({
    required this.snapshot,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.stateSnapshot);

  factory StateSnapshotEvent.fromJson(Map<String, dynamic> json) {
    return StateSnapshotEvent(
      snapshot: json['snapshot'],
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'snapshot': snapshot,
  };

  @override
  StateSnapshotEvent copyWith({
    State? snapshot,
    int? timestamp,
    Object? rawEvent,
  }) {
    return StateSnapshotEvent(
      snapshot: snapshot ?? this.snapshot,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class StateDeltaEvent extends BaseEvent {
  final List<dynamic> delta;

  const StateDeltaEvent({
    required this.delta,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.stateDelta);

  factory StateDeltaEvent.fromJson(Map<String, dynamic> json) {
    return StateDeltaEvent(
      delta: JsonDecoder.requireField<List<dynamic>>(json, 'delta'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'delta': delta,
  };

  @override
  StateDeltaEvent copyWith({
    List<dynamic>? delta,
    int? timestamp,
    Object? rawEvent,
  }) {
    return StateDeltaEvent(
      delta: delta ?? this.delta,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class MessagesSnapshotEvent extends BaseEvent {
  final List<Message> messages;

  const MessagesSnapshotEvent({
    required this.messages,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.messagesSnapshot);

  factory MessagesSnapshotEvent.fromJson(Map<String, dynamic> json) {
    return MessagesSnapshotEvent(
      messages: JsonDecoder.requireListField<Map<String, dynamic>>(json, 'messages')
          .map((item) => Message.fromJson(item))
          .toList(),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'messages': messages.map((message) => message.toJson()).toList(),
  };

  @override
  MessagesSnapshotEvent copyWith({
    List<Message>? messages,
    int? timestamp,
    Object? rawEvent,
  }) {
    return MessagesSnapshotEvent(
      messages: messages ?? this.messages,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class ActivitySnapshotEvent extends BaseEvent {
  final String messageId;
  final String activityType;
  final Map<String, dynamic> content;
  final bool replace;

  const ActivitySnapshotEvent({
    required this.messageId,
    required this.activityType,
    required this.content,
    this.replace = true,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.activitySnapshot);

  factory ActivitySnapshotEvent.fromJson(Map<String, dynamic> json) {
    return ActivitySnapshotEvent(
      messageId: JsonDecoder.requireField<String>(json, 'messageId'),
      activityType: JsonDecoder.requireField<String>(json, 'activityType'),
      content: Map<String, dynamic>.from(
        JsonDecoder.requireField<Map<String, dynamic>>(json, 'content'),
      ),
      replace: JsonDecoder.optionalField<bool>(json, 'replace') ?? true,
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'messageId': messageId,
    'activityType': activityType,
    'content': content,
    'replace': replace,
  };

  @override
  ActivitySnapshotEvent copyWith({
    String? messageId,
    String? activityType,
    Map<String, dynamic>? content,
    bool? replace,
    int? timestamp,
    Object? rawEvent,
  }) {
    return ActivitySnapshotEvent(
      messageId: messageId ?? this.messageId,
      activityType: activityType ?? this.activityType,
      content: content ?? this.content,
      replace: replace ?? this.replace,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class ActivityDeltaEvent extends BaseEvent {
  final String messageId;
  final String activityType;
  final List<dynamic> patch;

  const ActivityDeltaEvent({
    required this.messageId,
    required this.activityType,
    required this.patch,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.activityDelta);

  factory ActivityDeltaEvent.fromJson(Map<String, dynamic> json) {
    return ActivityDeltaEvent(
      messageId: JsonDecoder.requireField<String>(json, 'messageId'),
      activityType: JsonDecoder.requireField<String>(json, 'activityType'),
      patch: JsonDecoder.requireField<List<dynamic>>(json, 'patch'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'messageId': messageId,
    'activityType': activityType,
    'patch': patch,
  };

  @override
  ActivityDeltaEvent copyWith({
    String? messageId,
    String? activityType,
    List<dynamic>? patch,
    int? timestamp,
    Object? rawEvent,
  }) {
    return ActivityDeltaEvent(
      messageId: messageId ?? this.messageId,
      activityType: activityType ?? this.activityType,
      patch: patch ?? this.patch,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class RawEvent extends BaseEvent {
  final Object? event;
  final String? source;

  const RawEvent({
    required this.event,
    this.source,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.raw);

  factory RawEvent.fromJson(Map<String, dynamic> json) {
    return RawEvent(
      event: json['event'],
      source: JsonDecoder.optionalField<String>(json, 'source'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'event': event,
    if (source != null) 'source': source,
  };

  @override
  RawEvent copyWith({
    Object? event,
    String? source,
    int? timestamp,
    Object? rawEvent,
  }) {
    return RawEvent(
      event: event ?? this.event,
      source: source ?? this.source,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class CustomEvent extends BaseEvent {
  final String name;
  final Object? value;

  const CustomEvent({
    required this.name,
    required this.value,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.custom);

  factory CustomEvent.fromJson(Map<String, dynamic> json) {
    return CustomEvent(
      name: JsonDecoder.requireField<String>(json, 'name'),
      value: json['value'],
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'name': name,
    'value': value,
  };

  @override
  CustomEvent copyWith({
    String? name,
    Object? value,
    int? timestamp,
    Object? rawEvent,
  }) {
    return CustomEvent(
      name: name ?? this.name,
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

sealed class RunFinishedOutcome extends AGUIModel with TypeDiscriminator {
  const RunFinishedOutcome();

  factory RunFinishedOutcome.fromJson(Map<String, dynamic> json) {
    final type = JsonDecoder.requireField<String>(json, 'type');
    switch (type) {
      case 'success':
        return RunFinishedSuccessOutcome.fromJson(json);
      case 'interrupt':
        return RunFinishedInterruptOutcome.fromJson(json);
      default:
        throw AGUIValidationError(
          message: 'Invalid run finished outcome type: $type',
          field: 'type',
          value: type,
          json: json,
        );
    }
  }
}

final class RunFinishedSuccessOutcome extends RunFinishedOutcome {
  const RunFinishedSuccessOutcome();

  factory RunFinishedSuccessOutcome.fromJson(Map<String, dynamic> json) {
    JsonDecoder.requireField<String>(json, 'type');
    return const RunFinishedSuccessOutcome();
  }

  @override
  String get type => 'success';

  @override
  Map<String, dynamic> toJson() => {'type': type};

  @override
  RunFinishedSuccessOutcome copyWith() => const RunFinishedSuccessOutcome();
}

final class RunFinishedInterruptOutcome extends RunFinishedOutcome {
  final List<Interrupt> interrupts;

  const RunFinishedInterruptOutcome({
    required this.interrupts,
  });

  factory RunFinishedInterruptOutcome.fromJson(Map<String, dynamic> json) {
    return RunFinishedInterruptOutcome(
      interrupts: JsonDecoder.requireListField<Map<String, dynamic>>(json, 'interrupts')
          .map((item) => Interrupt.fromJson(item))
          .toList(),
    );
  }

  @override
  String get type => 'interrupt';

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'interrupts': interrupts.map((item) => item.toJson()).toList(),
  };

  @override
  RunFinishedInterruptOutcome copyWith({
    List<Interrupt>? interrupts,
  }) {
    return RunFinishedInterruptOutcome(
      interrupts: interrupts ?? this.interrupts,
    );
  }
}

final class RunStartedEvent extends BaseEvent {
  final String threadId;
  final String runId;
  final String? parentRunId;
  final RunAgentInput? input;

  const RunStartedEvent({
    required this.threadId,
    required this.runId,
    this.parentRunId,
    this.input,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.runStarted);

  factory RunStartedEvent.fromJson(Map<String, dynamic> json) {
    final threadId = JsonDecoder.optionalField<String>(json, 'threadId') ??
        JsonDecoder.requireField<String>(json, 'thread_id');
    final runId = JsonDecoder.optionalField<String>(json, 'runId') ??
        JsonDecoder.requireField<String>(json, 'run_id');
    final inputJson = JsonDecoder.optionalField<Map<String, dynamic>>(json, 'input');

    return RunStartedEvent(
      threadId: threadId,
      runId: runId,
      parentRunId: JsonDecoder.optionalField<String>(json, 'parentRunId') ??
          JsonDecoder.optionalField<String>(json, 'parent_run_id'),
      input: inputJson == null ? null : RunAgentInput.fromJson(inputJson),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'threadId': threadId,
    'runId': runId,
    if (parentRunId != null) 'parentRunId': parentRunId,
    if (input != null) 'input': input!.toJson(),
  };

  @override
  RunStartedEvent copyWith({
    String? threadId,
    String? runId,
    String? parentRunId,
    RunAgentInput? input,
    int? timestamp,
    Object? rawEvent,
  }) {
    return RunStartedEvent(
      threadId: threadId ?? this.threadId,
      runId: runId ?? this.runId,
      parentRunId: parentRunId ?? this.parentRunId,
      input: input ?? this.input,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class RunFinishedEvent extends BaseEvent {
  final String threadId;
  final String runId;
  final Object? result;
  final RunFinishedOutcome? outcome;

  const RunFinishedEvent({
    required this.threadId,
    required this.runId,
    this.result,
    this.outcome,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.runFinished);

  factory RunFinishedEvent.fromJson(Map<String, dynamic> json) {
    final threadId = JsonDecoder.optionalField<String>(json, 'threadId') ??
        JsonDecoder.requireField<String>(json, 'thread_id');
    final runId = JsonDecoder.optionalField<String>(json, 'runId') ??
        JsonDecoder.requireField<String>(json, 'run_id');
    final outcomeJson = json['outcome'];

    return RunFinishedEvent(
      threadId: threadId,
      runId: runId,
      result: json['result'],
      outcome: outcomeJson is Map<String, dynamic>
          ? RunFinishedOutcome.fromJson(outcomeJson)
          : null,
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'threadId': threadId,
    'runId': runId,
    if (result != null) 'result': result,
    if (outcome != null) 'outcome': outcome!.toJson(),
  };

  @override
  RunFinishedEvent copyWith({
    String? threadId,
    String? runId,
    Object? result,
    RunFinishedOutcome? outcome,
    int? timestamp,
    Object? rawEvent,
  }) {
    return RunFinishedEvent(
      threadId: threadId ?? this.threadId,
      runId: runId ?? this.runId,
      result: result ?? this.result,
      outcome: outcome ?? this.outcome,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class RunErrorEvent extends BaseEvent {
  final String message;
  final String? code;

  const RunErrorEvent({
    required this.message,
    this.code,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.runError);

  factory RunErrorEvent.fromJson(Map<String, dynamic> json) {
    return RunErrorEvent(
      message: JsonDecoder.requireField<String>(json, 'message'),
      code: JsonDecoder.optionalField<String>(json, 'code'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'message': message,
    if (code != null) 'code': code,
  };

  @override
  RunErrorEvent copyWith({
    String? message,
    String? code,
    int? timestamp,
    Object? rawEvent,
  }) {
    return RunErrorEvent(
      message: message ?? this.message,
      code: code ?? this.code,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class StepStartedEvent extends BaseEvent {
  final String stepName;

  const StepStartedEvent({
    required this.stepName,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.stepStarted);

  factory StepStartedEvent.fromJson(Map<String, dynamic> json) {
    return StepStartedEvent(
      stepName: JsonDecoder.optionalField<String>(json, 'stepName') ??
          JsonDecoder.requireField<String>(json, 'step_name'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'stepName': stepName,
  };

  @override
  StepStartedEvent copyWith({
    String? stepName,
    int? timestamp,
    Object? rawEvent,
  }) {
    return StepStartedEvent(
      stepName: stepName ?? this.stepName,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class StepFinishedEvent extends BaseEvent {
  final String stepName;

  const StepFinishedEvent({
    required this.stepName,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.stepFinished);

  factory StepFinishedEvent.fromJson(Map<String, dynamic> json) {
    return StepFinishedEvent(
      stepName: JsonDecoder.optionalField<String>(json, 'stepName') ??
          JsonDecoder.requireField<String>(json, 'step_name'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'stepName': stepName,
  };

  @override
  StepFinishedEvent copyWith({
    String? stepName,
    int? timestamp,
    Object? rawEvent,
  }) {
    return StepFinishedEvent(
      stepName: stepName ?? this.stepName,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class ReasoningStartEvent extends BaseEvent {
  final String messageId;

  const ReasoningStartEvent({
    required this.messageId,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.reasoningStart);

  factory ReasoningStartEvent.fromJson(Map<String, dynamic> json) {
    return ReasoningStartEvent(
      messageId: JsonDecoder.requireField<String>(json, 'messageId'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'messageId': messageId,
  };

  @override
  ReasoningStartEvent copyWith({
    String? messageId,
    int? timestamp,
    Object? rawEvent,
  }) {
    return ReasoningStartEvent(
      messageId: messageId ?? this.messageId,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class ReasoningMessageStartEvent extends BaseEvent {
  final String messageId;
  final String role;

  const ReasoningMessageStartEvent({
    required this.messageId,
    this.role = 'reasoning',
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.reasoningMessageStart);

  factory ReasoningMessageStartEvent.fromJson(Map<String, dynamic> json) {
    return ReasoningMessageStartEvent(
      messageId: JsonDecoder.requireField<String>(json, 'messageId'),
      role: JsonDecoder.optionalField<String>(json, 'role') ?? 'reasoning',
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'messageId': messageId,
    'role': role,
  };

  @override
  ReasoningMessageStartEvent copyWith({
    String? messageId,
    String? role,
    int? timestamp,
    Object? rawEvent,
  }) {
    return ReasoningMessageStartEvent(
      messageId: messageId ?? this.messageId,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class ReasoningMessageContentEvent extends BaseEvent {
  final String messageId;
  final String delta;

  const ReasoningMessageContentEvent({
    required this.messageId,
    required this.delta,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.reasoningMessageContent);

  factory ReasoningMessageContentEvent.fromJson(Map<String, dynamic> json) {
    return ReasoningMessageContentEvent(
      messageId: JsonDecoder.requireField<String>(json, 'messageId'),
      delta: _requireNonEmptyString(json, 'delta'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'messageId': messageId,
    'delta': delta,
  };

  @override
  ReasoningMessageContentEvent copyWith({
    String? messageId,
    String? delta,
    int? timestamp,
    Object? rawEvent,
  }) {
    return ReasoningMessageContentEvent(
      messageId: messageId ?? this.messageId,
      delta: delta ?? this.delta,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class ReasoningMessageEndEvent extends BaseEvent {
  final String messageId;

  const ReasoningMessageEndEvent({
    required this.messageId,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.reasoningMessageEnd);

  factory ReasoningMessageEndEvent.fromJson(Map<String, dynamic> json) {
    return ReasoningMessageEndEvent(
      messageId: JsonDecoder.requireField<String>(json, 'messageId'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'messageId': messageId,
  };

  @override
  ReasoningMessageEndEvent copyWith({
    String? messageId,
    int? timestamp,
    Object? rawEvent,
  }) {
    return ReasoningMessageEndEvent(
      messageId: messageId ?? this.messageId,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class ReasoningMessageChunkEvent extends BaseEvent {
  final String? messageId;
  final String? delta;

  const ReasoningMessageChunkEvent({
    this.messageId,
    this.delta,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.reasoningMessageChunk);

  factory ReasoningMessageChunkEvent.fromJson(Map<String, dynamic> json) {
    return ReasoningMessageChunkEvent(
      messageId: JsonDecoder.optionalField<String>(json, 'messageId'),
      delta: JsonDecoder.optionalField<String>(json, 'delta'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    if (messageId != null) 'messageId': messageId,
    if (delta != null) 'delta': delta,
  };

  @override
  ReasoningMessageChunkEvent copyWith({
    String? messageId,
    String? delta,
    int? timestamp,
    Object? rawEvent,
  }) {
    return ReasoningMessageChunkEvent(
      messageId: messageId ?? this.messageId,
      delta: delta ?? this.delta,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class ReasoningEndEvent extends BaseEvent {
  final String messageId;

  const ReasoningEndEvent({
    required this.messageId,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.reasoningEnd);

  factory ReasoningEndEvent.fromJson(Map<String, dynamic> json) {
    return ReasoningEndEvent(
      messageId: JsonDecoder.requireField<String>(json, 'messageId'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'messageId': messageId,
  };

  @override
  ReasoningEndEvent copyWith({
    String? messageId,
    int? timestamp,
    Object? rawEvent,
  }) {
    return ReasoningEndEvent(
      messageId: messageId ?? this.messageId,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}

final class ReasoningEncryptedValueEvent extends BaseEvent {
  final ReasoningEncryptedValueSubtype subtype;
  final String entityId;
  final String encryptedValue;

  const ReasoningEncryptedValueEvent({
    required this.subtype,
    required this.entityId,
    required this.encryptedValue,
    super.timestamp,
    super.rawEvent,
  }) : super(eventType: EventType.reasoningEncryptedValue);

  factory ReasoningEncryptedValueEvent.fromJson(Map<String, dynamic> json) {
    return ReasoningEncryptedValueEvent(
      subtype: ReasoningEncryptedValueSubtype.fromString(
        JsonDecoder.requireField<String>(json, 'subtype'),
      ),
      entityId: JsonDecoder.requireField<String>(json, 'entityId'),
      encryptedValue: JsonDecoder.requireField<String>(json, 'encryptedValue'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'subtype': subtype.value,
    'entityId': entityId,
    'encryptedValue': encryptedValue,
  };

  @override
  ReasoningEncryptedValueEvent copyWith({
    ReasoningEncryptedValueSubtype? subtype,
    String? entityId,
    String? encryptedValue,
    int? timestamp,
    Object? rawEvent,
  }) {
    return ReasoningEncryptedValueEvent(
      subtype: subtype ?? this.subtype,
      entityId: entityId ?? this.entityId,
      encryptedValue: encryptedValue ?? this.encryptedValue,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
    );
  }
}
