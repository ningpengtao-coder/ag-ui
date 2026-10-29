library;

import '../types/base.dart';
import '../types/context.dart';
import '../types/message.dart';
import '../types/token_usage.dart';
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
      orElse: () => throw AGUIValidationError(
        message: 'Invalid text message role: $value',
        field: 'role',
        value: value,
      ),
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

  /// The original wire-format payload, preserved verbatim for proxy scenarios.
  final Object? rawEvent;

  /// Free-form metadata carried alongside the event (1.0 `BaseEvent.metadata`).
  final Map<String, dynamic>? metadata;

  /// The subagent a multi-agent producer attributes this event to
  /// (1.0 `Attributable.subagentRunId`).
  ///
  /// `null` means "the run the event arrived on"; it is not an absence of
  /// attribution to distinguish from an anonymous one.
  final String? subagentRunId;

  const BaseEvent({
    required this.eventType,
    this.timestamp,
    this.rawEvent,
    this.metadata,
    this.subagentRunId,
  });

  @override
  String get type => eventType.value;

  /// Whether the event's `type` is one the 1.0 protocol describes.
  ///
  /// Legacy `THINKING_*` translations and events from a newer producer are
  /// not; the enforcement stage drops them unless a middleware translated
  /// them first.
  bool get isProtocolEvent => EventType.protocolTypes.contains(eventType.value);

  factory BaseEvent.fromJson(Map<String, dynamic> json) {
    final event = _createFromJson(json);
    _wirePayloads[event] = json;
    return event;
  }

  static BaseEvent _createFromJson(Map<String, dynamic> json) {
    final rawType = JsonDecoder.requireField<String>(json, 'type');
    final eventType = EventType.values.firstWhere(
      (item) => item.value == rawType,
      orElse: () => EventType.unknown,
    );
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
      case EventType.subagentStarted:
        return SubagentStartedEvent.fromJson(json);
      case EventType.subagentFinished:
        return SubagentFinishedEvent.fromJson(json);
      case EventType.subagentError:
        return SubagentErrorEvent.fromJson(json);
      case EventType.unknown:
        return UnknownEvent(
          rawType: rawType,
          attributes: json,
          timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
          metadata:
              JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
          subagentRunId:
              JsonDecoder.optionalField<String>(json, 'subagentRunId'),
        );
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': eventType.value,
        if (timestamp != null) 'timestamp': timestamp,
        if (rawEvent != null) 'rawEvent': rawEvent,
        if (metadata != null) 'metadata': metadata,
        if (subagentRunId != null) 'subagentRunId': subagentRunId,
      };
}

/// An event whose `type` the protocol does not describe.
///
/// The decoder keeps these instead of rejecting the stream: an era shim may
/// still translate one, and whatever nothing handles is dropped — with a
/// warning — at the enforcement stage, so application code never sees it.
final class UnknownEvent extends BaseEvent {
  /// The wire `type` verbatim.
  final String rawType;

  /// The wire payload verbatim, so a translator can read fields the typed
  /// model does not know about.
  final Map<String, dynamic> attributes;

  UnknownEvent({
    required this.rawType,
    required Map<String, dynamic> attributes,
    super.timestamp,
    super.rawEvent,
    super.metadata,
    super.subagentRunId,
  })  : attributes = Map<String, dynamic>.unmodifiable(attributes),
        super(eventType: EventType.unknown);

  @override
  String get type => rawType;

  @override
  Map<String, dynamic> toJson() => Map<String, dynamic>.from(attributes);

  @override
  UnknownEvent copyWith({
    String? rawType,
    Map<String, dynamic>? attributes,
    int? timestamp,
    Object? rawEvent,
    Map<String, dynamic>? metadata,
    String? subagentRunId,
  }) {
    return UnknownEvent(
      rawType: rawType ?? this.rawType,
      attributes: attributes ?? this.attributes,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
      metadata: metadata ?? this.metadata,
      subagentRunId: subagentRunId ?? this.subagentRunId,
    );
  }
}

/// The wire payload an event was decoded from.
///
/// Enforcement needs the original map to tell an undescribed property apart
/// from a field the typed model never had; the typed model has already
/// dropped everything it does not know. Events built in memory (by an era shim
/// or application code) have no wire payload, so their `toJson` is the
/// closest equivalent.
final Expando<Map<String, dynamic>> _wirePayloads =
    Expando<Map<String, dynamic>>('ag-ui.wirePayload');

Map<String, dynamic> wireJsonOf(BaseEvent event) =>
    _wirePayloads[event] ?? event.toJson();

/// `REASONING_MESSAGE_START.role` is a required literal.
///
/// The quoted literal is spelled the way the reference implementation's
/// validator renders it — JSON-escaped, backslashes included — because the
/// shared conformance corpus matches that exact text.
String _requireReasoningRole(Map<String, dynamic> json) {
  final role = JsonDecoder.requireField<String>(json, 'role');
  if (role != 'reasoning') {
    throw AGUIValidationError(
      message: 'Field \'role\' expected \\"reasoning\\", received \\"$role\\"',
      field: 'role',
      value: role,
      json: json,
    );
  }
  return role;
}

/// `TOOL_CALL_RESULT.role`, when present, is the literal `tool`.
String? _requireToolResultRole(Map<String, dynamic> json) {
  final role = JsonDecoder.optionalField<String>(json, 'role');
  if (role != null && role != 'tool') {
    throw AGUIValidationError(
      message: 'Field \'role\' expected "tool", received "$role"',
      field: 'role',
      value: role,
      json: json,
    );
  }
  return role;
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
    super.metadata,
    super.subagentRunId,
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
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
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
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.textMessageContent);

  factory TextMessageContentEvent.fromJson(Map<String, dynamic> json) {
    return TextMessageContentEvent(
      messageId: JsonDecoder.requireField<String>(json, 'messageId'),
      delta: JsonDecoder.requireField<String>(json, 'delta'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
    );
  }
}

final class TextMessageEndEvent extends BaseEvent {
  final String messageId;

  const TextMessageEndEvent({
    required this.messageId,
    super.timestamp,
    super.rawEvent,
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.textMessageEnd);

  factory TextMessageEndEvent.fromJson(Map<String, dynamic> json) {
    return TextMessageEndEvent(
      messageId: JsonDecoder.requireField<String>(json, 'messageId'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
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
    super.metadata,
    super.subagentRunId,
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
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
    );
  }
}

final class ThinkingStartEvent extends BaseEvent {
  final String? title;

  const ThinkingStartEvent({
    this.title,
    super.timestamp,
    super.rawEvent,
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.thinkingStart);

  factory ThinkingStartEvent.fromJson(Map<String, dynamic> json) {
    return ThinkingStartEvent(
      title: JsonDecoder.optionalField<String>(json, 'title'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
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
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.thinkingContent);

  factory ThinkingContentEvent.fromJson(Map<String, dynamic> json) {
    return ThinkingContentEvent(
      delta: JsonDecoder.requireField<String>(json, 'delta'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
    );
  }
}

final class ThinkingEndEvent extends BaseEvent {
  const ThinkingEndEvent({
    super.timestamp,
    super.rawEvent,
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.thinkingEnd);

  factory ThinkingEndEvent.fromJson(Map<String, dynamic> json) {
    return ThinkingEndEvent(
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
    );
  }
}

final class ThinkingTextMessageStartEvent extends BaseEvent {
  const ThinkingTextMessageStartEvent({
    super.timestamp,
    super.rawEvent,
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.thinkingTextMessageStart);

  factory ThinkingTextMessageStartEvent.fromJson(Map<String, dynamic> json) {
    return ThinkingTextMessageStartEvent(
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
    );
  }
}

final class ThinkingTextMessageContentEvent extends BaseEvent {
  final String delta;

  const ThinkingTextMessageContentEvent({
    required this.delta,
    super.timestamp,
    super.rawEvent,
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.thinkingTextMessageContent);

  factory ThinkingTextMessageContentEvent.fromJson(Map<String, dynamic> json) {
    return ThinkingTextMessageContentEvent(
      delta: JsonDecoder.requireField<String>(json, 'delta'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
    );
  }
}

final class ThinkingTextMessageEndEvent extends BaseEvent {
  const ThinkingTextMessageEndEvent({
    super.timestamp,
    super.rawEvent,
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.thinkingTextMessageEnd);

  factory ThinkingTextMessageEndEvent.fromJson(Map<String, dynamic> json) {
    return ThinkingTextMessageEndEvent(
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
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
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.toolCallStart);

  factory ToolCallStartEvent.fromJson(Map<String, dynamic> json) {
    return ToolCallStartEvent(
      toolCallId: JsonDecoder.requireField<String>(json, 'toolCallId'),
      toolCallName: JsonDecoder.requireField<String>(json, 'toolCallName'),
      parentMessageId:
          JsonDecoder.optionalField<String>(json, 'parentMessageId'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
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
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.toolCallArgs);

  factory ToolCallArgsEvent.fromJson(Map<String, dynamic> json) {
    return ToolCallArgsEvent(
      toolCallId: JsonDecoder.requireField<String>(json, 'toolCallId'),
      delta: JsonDecoder.requireField<String>(json, 'delta'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
    );
  }
}

final class ToolCallEndEvent extends BaseEvent {
  final String toolCallId;

  const ToolCallEndEvent({
    required this.toolCallId,
    super.timestamp,
    super.rawEvent,
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.toolCallEnd);

  factory ToolCallEndEvent.fromJson(Map<String, dynamic> json) {
    return ToolCallEndEvent(
      toolCallId: JsonDecoder.requireField<String>(json, 'toolCallId'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
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
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.toolCallChunk);

  factory ToolCallChunkEvent.fromJson(Map<String, dynamic> json) {
    return ToolCallChunkEvent(
      toolCallId: JsonDecoder.optionalField<String>(json, 'toolCallId'),
      toolCallName: JsonDecoder.optionalField<String>(json, 'toolCallName'),
      parentMessageId:
          JsonDecoder.optionalField<String>(json, 'parentMessageId'),
      delta: JsonDecoder.optionalField<String>(json, 'delta'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
    );
  }
}

final class ToolCallResultEvent extends BaseEvent {
  final String messageId;
  final String toolCallId;

  /// The tool result: either text or a list of [ContentPart]s (1.0 union).
  final Object content;
  final String? role;

  const ToolCallResultEvent({
    required this.messageId,
    required this.toolCallId,
    required this.content,
    this.role,
    super.timestamp,
    super.rawEvent,
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.toolCallResult);

  factory ToolCallResultEvent.fromJson(Map<String, dynamic> json) {
    return ToolCallResultEvent(
      messageId: JsonDecoder.requireField<String>(json, 'messageId'),
      toolCallId: JsonDecoder.requireField<String>(json, 'toolCallId'),
      content: parseContentValue(json, 'content'),
      role: _requireToolResultRole(json),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'messageId': messageId,
        'toolCallId': toolCallId,
        'content': _serializeContentValue(content),
        if (role != null) 'role': role,
      };

  @override
  ToolCallResultEvent copyWith({
    String? messageId,
    String? toolCallId,
    Object? content,
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
    );
  }
}

Object _serializeContentValue(Object content) {
  if (content is List<InputContent>) {
    return content.map((item) => item.toJson()).toList();
  }
  return content;
}

final class StateSnapshotEvent extends BaseEvent {
  final State snapshot;

  const StateSnapshotEvent({
    required this.snapshot,
    super.timestamp,
    super.rawEvent,
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.stateSnapshot);

  factory StateSnapshotEvent.fromJson(Map<String, dynamic> json) {
    return StateSnapshotEvent(
      snapshot: json['snapshot'],
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
    );
  }
}

final class StateDeltaEvent extends BaseEvent {
  final List<dynamic> delta;

  const StateDeltaEvent({
    required this.delta,
    super.timestamp,
    super.rawEvent,
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.stateDelta);

  factory StateDeltaEvent.fromJson(Map<String, dynamic> json) {
    return StateDeltaEvent(
      delta: JsonDecoder.requireField<List<dynamic>>(json, 'delta'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
    );
  }
}

final class MessagesSnapshotEvent extends BaseEvent {
  final List<Message> messages;

  const MessagesSnapshotEvent({
    required this.messages,
    super.timestamp,
    super.rawEvent,
    super.metadata,
  }) : super(eventType: EventType.messagesSnapshot);

  factory MessagesSnapshotEvent.fromJson(Map<String, dynamic> json) {
    return MessagesSnapshotEvent(
      messages:
          JsonDecoder.requireListField<Map<String, dynamic>>(json, 'messages')
              .map((item) => Message.fromJson(item))
              .toList(),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
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
      metadata: this.metadata,
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
    super.metadata,
    super.subagentRunId,
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
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
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
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.activityDelta);

  factory ActivityDeltaEvent.fromJson(Map<String, dynamic> json) {
    return ActivityDeltaEvent(
      messageId: JsonDecoder.requireField<String>(json, 'messageId'),
      activityType: JsonDecoder.requireField<String>(json, 'activityType'),
      patch: JsonDecoder.requireField<List<dynamic>>(json, 'patch'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
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
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.raw);

  factory RawEvent.fromJson(Map<String, dynamic> json) {
    return RawEvent(
      event: json['event'],
      source: JsonDecoder.optionalField<String>(json, 'source'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
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
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.custom);

  factory CustomEvent.fromJson(Map<String, dynamic> json) {
    return CustomEvent(
      name: JsonDecoder.requireField<String>(json, 'name'),
      value: json['value'],
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
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
      case 'cancelled':
        return const RunFinishedCancelledOutcome();
      default:
        // Lenient on purpose: an outcome a newer producer invented is
        // stripped, with a warning, at the enforcement stage. Rejecting the
        // whole event here would turn "unknown member" into "fatal", which
        // the specification reserves for malformed values.
        return UnknownRunFinishedOutcome(raw: json);
    }
  }
}

final class RunFinishedSuccessOutcome extends RunFinishedOutcome {
  final List<String> pendingToolCallIds;

  const RunFinishedSuccessOutcome({this.pendingToolCallIds = const []});

  factory RunFinishedSuccessOutcome.fromJson(Map<String, dynamic> json) {
    JsonDecoder.requireField<String>(json, 'type');
    return RunFinishedSuccessOutcome(
      pendingToolCallIds:
          JsonDecoder.optionalListField<String>(json, 'pendingToolCallIds') ??
              const [],
    );
  }

  @override
  String get type => 'success';

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        if (pendingToolCallIds.isNotEmpty)
          'pendingToolCallIds': pendingToolCallIds,
      };

  @override
  RunFinishedSuccessOutcome copyWith({
    List<String>? pendingToolCallIds,
  }) {
    return RunFinishedSuccessOutcome(
      pendingToolCallIds: pendingToolCallIds ?? this.pendingToolCallIds,
    );
  }
}

final class RunFinishedInterruptOutcome extends RunFinishedOutcome {
  final List<Interrupt> interrupts;

  const RunFinishedInterruptOutcome({
    required this.interrupts,
  });

  factory RunFinishedInterruptOutcome.fromJson(Map<String, dynamic> json) {
    final interrupts =
        JsonDecoder.requireListField<Map<String, dynamic>>(json, 'interrupts')
            .map((item) => Interrupt.fromJson(item))
            .toList();
    // At least one: an interrupt outcome with nothing to answer would leave a
    // consumer with nothing to do, so the schema pins `minItems: 1` and an
    // empty list is a malformed known value rather than an unknown member.
    if (interrupts.isEmpty) {
      throw AGUIValidationError(
        message: "Field 'interrupts' must contain at least one interrupt",
        field: 'interrupts',
        value: json['interrupts'],
        json: json,
      );
    }
    return RunFinishedInterruptOutcome(interrupts: interrupts);
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

final class RunFinishedCancelledOutcome extends RunFinishedOutcome {
  const RunFinishedCancelledOutcome();

  @override
  String get type => 'cancelled';

  @override
  Map<String, dynamic> toJson() => {'type': type};

  @override
  RunFinishedCancelledOutcome copyWith() => const RunFinishedCancelledOutcome();
}

/// An outcome whose `type` the 1.0 protocol does not describe.
///
/// Kept so the enforcement stage can strip it and warn instead of the decoder
/// rejecting the stream.
final class UnknownRunFinishedOutcome extends RunFinishedOutcome {
  final Map<String, dynamic> raw;

  UnknownRunFinishedOutcome({required Map<String, dynamic> raw})
      : raw = Map<String, dynamic>.unmodifiable(raw);

  @override
  String get type => (raw['type'] as String?) ?? 'unknown';

  @override
  Map<String, dynamic> toJson() => Map<String, dynamic>.from(raw);

  @override
  UnknownRunFinishedOutcome copyWith({Map<String, dynamic>? raw}) {
    return UnknownRunFinishedOutcome(raw: raw ?? this.raw);
  }
}

final class RunStartedEvent extends BaseEvent {
  final String threadId;
  final String runId;
  final String? parentRunId;
  final RunAgentInput? input;

  /// The protocol version the producer speaks, if it declares one.
  ///
  /// A peer that pins a maximum version uses this to decide whether any era
  /// shim is needed; its absence is the pre-1.0 convention.
  final String? protocolVersion;

  const RunStartedEvent({
    required this.threadId,
    required this.runId,
    this.parentRunId,
    this.input,
    this.protocolVersion,
    super.timestamp,
    super.rawEvent,
    super.metadata,
  }) : super(eventType: EventType.runStarted);

  factory RunStartedEvent.fromJson(Map<String, dynamic> json) {
    final threadId = JsonDecoder.optionalField<String>(json, 'threadId') ??
        JsonDecoder.requireField<String>(json, 'thread_id');
    final runId = JsonDecoder.optionalField<String>(json, 'runId') ??
        JsonDecoder.requireField<String>(json, 'run_id');
    final inputJson =
        JsonDecoder.optionalField<Map<String, dynamic>>(json, 'input');

    return RunStartedEvent(
      threadId: threadId,
      runId: runId,
      parentRunId: JsonDecoder.optionalField<String>(json, 'parentRunId') ??
          JsonDecoder.optionalField<String>(json, 'parent_run_id'),
      input: inputJson == null ? null : RunAgentInput.fromJson(inputJson),
      protocolVersion:
          JsonDecoder.optionalField<String>(json, 'protocolVersion'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'threadId': threadId,
        'runId': runId,
        if (parentRunId != null) 'parentRunId': parentRunId,
        if (input != null) 'input': input!.toJson(),
        if (protocolVersion != null) 'protocolVersion': protocolVersion,
      };

  @override
  RunStartedEvent copyWith({
    String? threadId,
    String? runId,
    String? parentRunId,
    RunAgentInput? input,
    String? protocolVersion,
    int? timestamp,
    Object? rawEvent,
  }) {
    return RunStartedEvent(
      threadId: threadId ?? this.threadId,
      runId: runId ?? this.runId,
      parentRunId: parentRunId ?? this.parentRunId,
      input: input ?? this.input,
      protocolVersion: protocolVersion ?? this.protocolVersion,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
      metadata: this.metadata,
    );
  }
}

final class RunFinishedEvent extends BaseEvent {
  final String threadId;
  final String runId;
  final Object? result;
  final RunFinishedOutcome? outcome;

  /// Token accounting for the run, when the producer reports it.
  final List<TokenUsage> usage;

  const RunFinishedEvent({
    required this.threadId,
    required this.runId,
    this.result,
    this.outcome,
    this.usage = const [],
    super.timestamp,
    super.rawEvent,
    super.metadata,
  }) : super(eventType: EventType.runFinished);

  factory RunFinishedEvent.fromJson(Map<String, dynamic> json) {
    final threadId = JsonDecoder.optionalField<String>(json, 'threadId') ??
        JsonDecoder.requireField<String>(json, 'thread_id');
    final runId = JsonDecoder.optionalField<String>(json, 'runId') ??
        JsonDecoder.requireField<String>(json, 'run_id');
    final outcomeJson = json['outcome'];
    if (outcomeJson != null && outcomeJson is! Map) {
      final received =
          outcomeJson is List ? 'array' : outcomeJson.runtimeType.toString();
      throw AGUIValidationError(
        message: "Field 'outcome' expected object, received $received",
        field: 'outcome',
        value: outcomeJson,
        json: json,
      );
    }

    return RunFinishedEvent(
      threadId: threadId,
      runId: runId,
      result: json['result'],
      outcome: outcomeJson is Map<String, dynamic>
          ? RunFinishedOutcome.fromJson(outcomeJson)
          : null,
      usage: _parseUsage(json),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'threadId': threadId,
        'runId': runId,
        if (result != null) 'result': result,
        if (outcome != null) 'outcome': outcome!.toJson(),
        if (usage.isNotEmpty)
          'usage': usage.map((item) => item.toJson()).toList(),
      };

  @override
  RunFinishedEvent copyWith({
    String? threadId,
    String? runId,
    Object? result,
    RunFinishedOutcome? outcome,
    List<TokenUsage>? usage,
    int? timestamp,
    Object? rawEvent,
  }) {
    return RunFinishedEvent(
      threadId: threadId ?? this.threadId,
      runId: runId ?? this.runId,
      result: result ?? this.result,
      outcome: outcome ?? this.outcome,
      usage: usage ?? this.usage,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
      metadata: this.metadata,
    );
  }
}

final class RunErrorEvent extends BaseEvent {
  final String message;
  final String? code;

  /// Token accounting for the failed run, when the producer reports it.
  final List<TokenUsage> usage;

  const RunErrorEvent({
    required this.message,
    this.code,
    this.usage = const [],
    super.timestamp,
    super.rawEvent,
    super.metadata,
  }) : super(eventType: EventType.runError);

  factory RunErrorEvent.fromJson(Map<String, dynamic> json) {
    return RunErrorEvent(
      message: JsonDecoder.requireField<String>(json, 'message'),
      code: JsonDecoder.optionalField<String>(json, 'code'),
      usage: _parseUsage(json),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'message': message,
        if (code != null) 'code': code,
        if (usage.isNotEmpty)
          'usage': usage.map((item) => item.toJson()).toList(),
      };

  @override
  RunErrorEvent copyWith({
    String? message,
    String? code,
    List<TokenUsage>? usage,
    int? timestamp,
    Object? rawEvent,
  }) {
    return RunErrorEvent(
      message: message ?? this.message,
      code: code ?? this.code,
      usage: usage ?? this.usage,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
      metadata: this.metadata,
    );
  }
}

List<TokenUsage> _parseUsage(Map<String, dynamic> json) {
  final raw = json['usage'];
  if (raw is! List) return const [];
  return raw
      .whereType<Map>()
      .map((item) => TokenUsage.fromJson(Map<String, dynamic>.from(item)))
      .toList();
}

final class StepStartedEvent extends BaseEvent {
  final String stepName;

  const StepStartedEvent({
    required this.stepName,
    super.timestamp,
    super.rawEvent,
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.stepStarted);

  factory StepStartedEvent.fromJson(Map<String, dynamic> json) {
    return StepStartedEvent(
      stepName: JsonDecoder.optionalField<String>(json, 'stepName') ??
          JsonDecoder.requireField<String>(json, 'step_name'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
    );
  }
}

final class StepFinishedEvent extends BaseEvent {
  final String stepName;

  const StepFinishedEvent({
    required this.stepName,
    super.timestamp,
    super.rawEvent,
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.stepFinished);

  factory StepFinishedEvent.fromJson(Map<String, dynamic> json) {
    return StepFinishedEvent(
      stepName: JsonDecoder.optionalField<String>(json, 'stepName') ??
          JsonDecoder.requireField<String>(json, 'step_name'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
    );
  }
}

final class ReasoningStartEvent extends BaseEvent {
  final String messageId;

  const ReasoningStartEvent({
    required this.messageId,
    super.timestamp,
    super.rawEvent,
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.reasoningStart);

  factory ReasoningStartEvent.fromJson(Map<String, dynamic> json) {
    return ReasoningStartEvent(
      messageId: JsonDecoder.requireField<String>(json, 'messageId'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
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
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.reasoningMessageStart);

  factory ReasoningMessageStartEvent.fromJson(Map<String, dynamic> json) {
    return ReasoningMessageStartEvent(
      messageId: JsonDecoder.requireField<String>(json, 'messageId'),
      role: _requireReasoningRole(json),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
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
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.reasoningMessageContent);

  factory ReasoningMessageContentEvent.fromJson(Map<String, dynamic> json) {
    return ReasoningMessageContentEvent(
      messageId: JsonDecoder.requireField<String>(json, 'messageId'),
      delta: JsonDecoder.requireField<String>(json, 'delta'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
    );
  }
}

final class ReasoningMessageEndEvent extends BaseEvent {
  final String messageId;

  const ReasoningMessageEndEvent({
    required this.messageId,
    super.timestamp,
    super.rawEvent,
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.reasoningMessageEnd);

  factory ReasoningMessageEndEvent.fromJson(Map<String, dynamic> json) {
    return ReasoningMessageEndEvent(
      messageId: JsonDecoder.requireField<String>(json, 'messageId'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
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
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.reasoningMessageChunk);

  factory ReasoningMessageChunkEvent.fromJson(Map<String, dynamic> json) {
    return ReasoningMessageChunkEvent(
      messageId: JsonDecoder.optionalField<String>(json, 'messageId'),
      delta: JsonDecoder.optionalField<String>(json, 'delta'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
    );
  }
}

final class ReasoningEndEvent extends BaseEvent {
  final String messageId;

  const ReasoningEndEvent({
    required this.messageId,
    super.timestamp,
    super.rawEvent,
    super.metadata,
    super.subagentRunId,
  }) : super(eventType: EventType.reasoningEnd);

  factory ReasoningEndEvent.fromJson(Map<String, dynamic> json) {
    return ReasoningEndEvent(
      messageId: JsonDecoder.requireField<String>(json, 'messageId'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
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
    super.metadata,
    super.subagentRunId,
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
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      subagentRunId: JsonDecoder.optionalField<String>(json, 'subagentRunId'),
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
      metadata: this.metadata,
      subagentRunId: this.subagentRunId,
    );
  }
}

/// A multi-agent producer announced a nested run.
///
/// `subagentRunId` is required on this event: unlike [Attributable], it names
/// the subagent being started rather than attributing the event to a parent.
final class SubagentStartedEvent extends BaseEvent {
  final String name;
  final String? description;
  final String? parentSubagentRunId;
  final String? parentToolCallId;
  final String? parentMessageId;

  const SubagentStartedEvent({
    required super.subagentRunId,
    required this.name,
    this.description,
    this.parentSubagentRunId,
    this.parentToolCallId,
    this.parentMessageId,
    super.timestamp,
    super.rawEvent,
    super.metadata,
  }) : super(eventType: EventType.subagentStarted);

  factory SubagentStartedEvent.fromJson(Map<String, dynamic> json) {
    return SubagentStartedEvent(
      subagentRunId: JsonDecoder.requireField<String>(json, 'subagentRunId'),
      name: JsonDecoder.requireField<String>(json, 'name'),
      description: JsonDecoder.optionalField<String>(json, 'description'),
      parentSubagentRunId:
          JsonDecoder.optionalField<String>(json, 'parentSubagentRunId'),
      parentToolCallId:
          JsonDecoder.optionalField<String>(json, 'parentToolCallId'),
      parentMessageId:
          JsonDecoder.optionalField<String>(json, 'parentMessageId'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'name': name,
        if (description != null) 'description': description,
        if (parentSubagentRunId != null)
          'parentSubagentRunId': parentSubagentRunId,
        if (parentToolCallId != null) 'parentToolCallId': parentToolCallId,
        if (parentMessageId != null) 'parentMessageId': parentMessageId,
      };

  @override
  SubagentStartedEvent copyWith({
    String? subagentRunId,
    String? name,
    String? description,
    String? parentSubagentRunId,
    String? parentToolCallId,
    String? parentMessageId,
    int? timestamp,
    Object? rawEvent,
  }) {
    return SubagentStartedEvent(
      subagentRunId: subagentRunId ?? this.subagentRunId,
      name: name ?? this.name,
      description: description ?? this.description,
      parentSubagentRunId: parentSubagentRunId ?? this.parentSubagentRunId,
      parentToolCallId: parentToolCallId ?? this.parentToolCallId,
      parentMessageId: parentMessageId ?? this.parentMessageId,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
      metadata: this.metadata,
    );
  }
}

sealed class SubagentFinishedOutcome extends AGUIModel with TypeDiscriminator {
  const SubagentFinishedOutcome();

  factory SubagentFinishedOutcome.fromJson(Map<String, dynamic> json) {
    final type = JsonDecoder.requireField<String>(json, 'type');
    switch (type) {
      case 'success':
        return const SubagentFinishedSuccessOutcome();
      case 'suspended':
        return SubagentFinishedSuspendedOutcome.fromJson(json);
      default:
        return UnknownSubagentFinishedOutcome(raw: json);
    }
  }
}

final class SubagentFinishedSuccessOutcome extends SubagentFinishedOutcome {
  const SubagentFinishedSuccessOutcome();

  @override
  String get type => 'success';

  @override
  Map<String, dynamic> toJson() => {'type': type};

  @override
  SubagentFinishedSuccessOutcome copyWith() =>
      const SubagentFinishedSuccessOutcome();
}

final class SubagentFinishedSuspendedOutcome extends SubagentFinishedOutcome {
  final List<String> interruptIds;

  const SubagentFinishedSuspendedOutcome({this.interruptIds = const []});

  factory SubagentFinishedSuspendedOutcome.fromJson(Map<String, dynamic> json) {
    return SubagentFinishedSuspendedOutcome(
      interruptIds:
          JsonDecoder.optionalListField<String>(json, 'interruptIds') ??
              const [],
    );
  }

  @override
  String get type => 'suspended';

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        if (interruptIds.isNotEmpty) 'interruptIds': interruptIds,
      };

  @override
  SubagentFinishedSuspendedOutcome copyWith({List<String>? interruptIds}) {
    return SubagentFinishedSuspendedOutcome(
      interruptIds: interruptIds ?? this.interruptIds,
    );
  }
}

final class UnknownSubagentFinishedOutcome extends SubagentFinishedOutcome {
  final Map<String, dynamic> raw;

  UnknownSubagentFinishedOutcome({required Map<String, dynamic> raw})
      : raw = Map<String, dynamic>.unmodifiable(raw);

  @override
  String get type => (raw['type'] as String?) ?? 'unknown';

  @override
  Map<String, dynamic> toJson() => Map<String, dynamic>.from(raw);

  @override
  UnknownSubagentFinishedOutcome copyWith({Map<String, dynamic>? raw}) {
    return UnknownSubagentFinishedOutcome(raw: raw ?? this.raw);
  }
}

final class SubagentFinishedEvent extends BaseEvent {
  final Object? result;
  final SubagentFinishedOutcome? outcome;

  const SubagentFinishedEvent({
    required super.subagentRunId,
    this.result,
    this.outcome,
    super.timestamp,
    super.rawEvent,
    super.metadata,
  }) : super(eventType: EventType.subagentFinished);

  factory SubagentFinishedEvent.fromJson(Map<String, dynamic> json) {
    final outcomeJson = json['outcome'];
    return SubagentFinishedEvent(
      subagentRunId: JsonDecoder.requireField<String>(json, 'subagentRunId'),
      result: json['result'],
      outcome: outcomeJson is Map<String, dynamic>
          ? SubagentFinishedOutcome.fromJson(outcomeJson)
          : null,
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        if (result != null) 'result': result,
        if (outcome != null) 'outcome': outcome!.toJson(),
      };

  @override
  SubagentFinishedEvent copyWith({
    String? subagentRunId,
    Object? result,
    SubagentFinishedOutcome? outcome,
    int? timestamp,
    Object? rawEvent,
  }) {
    return SubagentFinishedEvent(
      subagentRunId: subagentRunId ?? this.subagentRunId,
      result: result ?? this.result,
      outcome: outcome ?? this.outcome,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
      metadata: this.metadata,
    );
  }
}

final class SubagentErrorEvent extends BaseEvent {
  final String message;
  final String? code;

  const SubagentErrorEvent({
    required super.subagentRunId,
    required this.message,
    this.code,
    super.timestamp,
    super.rawEvent,
    super.metadata,
  }) : super(eventType: EventType.subagentError);

  factory SubagentErrorEvent.fromJson(Map<String, dynamic> json) {
    return SubagentErrorEvent(
      subagentRunId: JsonDecoder.requireField<String>(json, 'subagentRunId'),
      message: JsonDecoder.requireField<String>(json, 'message'),
      code: JsonDecoder.optionalField<String>(json, 'code'),
      timestamp: JsonDecoder.optionalField<int>(json, 'timestamp'),
      rawEvent: json['rawEvent'],
      metadata:
          JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'message': message,
        if (code != null) 'code': code,
      };

  @override
  SubagentErrorEvent copyWith({
    String? subagentRunId,
    String? message,
    String? code,
    int? timestamp,
    Object? rawEvent,
  }) {
    return SubagentErrorEvent(
      subagentRunId: subagentRunId ?? this.subagentRunId,
      message: message ?? this.message,
      code: code ?? this.code,
      timestamp: timestamp ?? this.timestamp,
      rawEvent: rawEvent ?? this.rawEvent,
      metadata: this.metadata,
    );
  }
}
