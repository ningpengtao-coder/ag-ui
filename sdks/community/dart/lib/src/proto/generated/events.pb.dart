// This is a generated file - do not edit.
//
// Generated from events.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/struct.pb.dart' as $0;

import 'events.pbenum.dart';
import 'patch.pb.dart' as $2;
import 'types.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'events.pbenum.dart';

/// The fields every event carries, whatever its type. Composed into each event
/// definition rather than repeated, so a change here reaches every event at once.
class BaseEvent extends $pb.GeneratedMessage {
  factory BaseEvent({
    EventType? type,
    $fixnum.Int64? timestamp,
    $0.Value? rawEvent,
    $0.Struct? metadata,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (timestamp != null) result.timestamp = timestamp;
    if (rawEvent != null) result.rawEvent = rawEvent;
    if (metadata != null) result.metadata = metadata;
    return result;
  }

  BaseEvent._();

  factory BaseEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BaseEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BaseEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aE<EventType>(1, _omitFieldNames ? '' : 'type',
        enumValues: EventType.values)
    ..aInt64(2, _omitFieldNames ? '' : 'timestamp')
    ..aOM<$0.Value>(3, _omitFieldNames ? '' : 'rawEvent',
        subBuilder: $0.Value.create)
    ..aOM<$0.Struct>(4, _omitFieldNames ? '' : 'metadata',
        subBuilder: $0.Struct.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BaseEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BaseEvent copyWith(void Function(BaseEvent) updates) =>
      super.copyWith((message) => updates(message as BaseEvent)) as BaseEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BaseEvent create() => BaseEvent._();
  @$core.override
  BaseEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BaseEvent getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BaseEvent>(create);
  static BaseEvent? _defaultInstance;

  /// Which event this is. Each event definition narrows this to a single value.
  @$pb.TagNumber(1)
  EventType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(EventType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  /// When the event was created. Bounded to the range JSON numbers survive a
  /// round trip in, so the value a consumer reads is the value the producer
  /// wrote. Deliberately not a float. The unit is not constrained here, because
  /// it never has been stated normatively; every SDK that sets it in practice
  /// uses milliseconds since the Unix epoch, and a producer choosing another unit
  /// will be misread by consumers even though it validates. Nothing in the
  /// protocol computes with this value.
  @$pb.TagNumber(2)
  $fixnum.Int64 get timestamp => $_getI64(1);
  @$pb.TagNumber(2)
  set timestamp($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => $_clearField(2);

  /// The provider-native event this one was translated from, carried verbatim for
  /// debugging and for consumers that need detail the protocol does not model.
  /// Any JSON value.
  @$pb.TagNumber(3)
  $0.Value get rawEvent => $_getN(2);
  @$pb.TagNumber(3)
  set rawEvent($0.Value value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRawEvent() => $_has(2);
  @$pb.TagNumber(3)
  void clearRawEvent() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Value ensureRawEvent() => $_ensure(2);

  /// Extra information attached to this event.
  @$pb.TagNumber(4)
  $0.Struct get metadata => $_getN(3);
  @$pb.TagNumber(4)
  set metadata($0.Struct value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMetadata() => $_has(3);
  @$pb.TagNumber(4)
  void clearMetadata() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Struct ensureMetadata() => $_ensure(3);
}

/// Opens a streamed text message. The content arrives as TEXT_MESSAGE_CONTENT
/// events and the message closes with TEXT_MESSAGE_END.
class TextMessageStartEvent extends $pb.GeneratedMessage {
  factory TextMessageStartEvent({
    BaseEvent? baseEvent,
    $core.String? messageId,
    $core.String? role,
    $core.String? name,
    $core.String? subagentRunId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (messageId != null) result.messageId = messageId;
    if (role != null) result.role = role;
    if (name != null) result.name = name;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    return result;
  }

  TextMessageStartEvent._();

  factory TextMessageStartEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TextMessageStartEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TextMessageStartEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'messageId')
    ..aOS(3, _omitFieldNames ? '' : 'role')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOS(5, _omitFieldNames ? '' : 'subagentRunId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextMessageStartEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextMessageStartEvent copyWith(
          void Function(TextMessageStartEvent) updates) =>
      super.copyWith((message) => updates(message as TextMessageStartEvent))
          as TextMessageStartEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TextMessageStartEvent create() => TextMessageStartEvent._();
  @$core.override
  TextMessageStartEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TextMessageStartEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TextMessageStartEvent>(create);
  static TextMessageStartEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// Identifies the message this stream builds, and ties the later content and
  /// end events to it.
  @$pb.TagNumber(2)
  $core.String get messageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set messageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageId() => $_clearField(2);

  /// Who the message is from. An absent role means assistant; that meaning is
  /// normative and stated in the prose, because a validator treats a default as
  /// documentation rather than as behaviour.
  @$pb.TagNumber(3)
  $core.String get role => $_getSZ(2);
  @$pb.TagNumber(3)
  set role($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => $_clearField(3);

  /// An optional display name for the author, for providers that distinguish
  /// several participants in one role.
  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(5)
  $core.String get subagentRunId => $_getSZ(4);
  @$pb.TagNumber(5)
  set subagentRunId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSubagentRunId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSubagentRunId() => $_clearField(5);
}

/// Appends a fragment to a streamed text message.
class TextMessageContentEvent extends $pb.GeneratedMessage {
  factory TextMessageContentEvent({
    BaseEvent? baseEvent,
    $core.String? messageId,
    $core.String? delta,
    $core.String? subagentRunId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (messageId != null) result.messageId = messageId;
    if (delta != null) result.delta = delta;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    return result;
  }

  TextMessageContentEvent._();

  factory TextMessageContentEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TextMessageContentEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TextMessageContentEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'messageId')
    ..aOS(3, _omitFieldNames ? '' : 'delta')
    ..aOS(4, _omitFieldNames ? '' : 'subagentRunId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextMessageContentEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextMessageContentEvent copyWith(
          void Function(TextMessageContentEvent) updates) =>
      super.copyWith((message) => updates(message as TextMessageContentEvent))
          as TextMessageContentEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TextMessageContentEvent create() => TextMessageContentEvent._();
  @$core.override
  TextMessageContentEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TextMessageContentEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TextMessageContentEvent>(create);
  static TextMessageContentEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The message this fragment belongs to.
  @$pb.TagNumber(2)
  $core.String get messageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set messageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageId() => $_clearField(2);

  /// The fragment to append. May be the empty string: providers emit empty deltas
  /// as keep-alives and while a tool call is being decided, and rejecting them
  /// would kill runs that are working correctly.
  @$pb.TagNumber(3)
  $core.String get delta => $_getSZ(2);
  @$pb.TagNumber(3)
  set delta($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDelta() => $_has(2);
  @$pb.TagNumber(3)
  void clearDelta() => $_clearField(3);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(4)
  $core.String get subagentRunId => $_getSZ(3);
  @$pb.TagNumber(4)
  set subagentRunId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSubagentRunId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubagentRunId() => $_clearField(4);
}

/// Closes a streamed text message.
class TextMessageEndEvent extends $pb.GeneratedMessage {
  factory TextMessageEndEvent({
    BaseEvent? baseEvent,
    $core.String? messageId,
    $core.String? subagentRunId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (messageId != null) result.messageId = messageId;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    return result;
  }

  TextMessageEndEvent._();

  factory TextMessageEndEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TextMessageEndEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TextMessageEndEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'messageId')
    ..aOS(3, _omitFieldNames ? '' : 'subagentRunId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextMessageEndEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextMessageEndEvent copyWith(void Function(TextMessageEndEvent) updates) =>
      super.copyWith((message) => updates(message as TextMessageEndEvent))
          as TextMessageEndEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TextMessageEndEvent create() => TextMessageEndEvent._();
  @$core.override
  TextMessageEndEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TextMessageEndEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TextMessageEndEvent>(create);
  static TextMessageEndEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The message being closed.
  @$pb.TagNumber(2)
  $core.String get messageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set messageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageId() => $_clearField(2);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(3)
  $core.String get subagentRunId => $_getSZ(2);
  @$pb.TagNumber(3)
  set subagentRunId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubagentRunId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubagentRunId() => $_clearField(3);
}

/// A shorthand that stands in for a start, content and end sequence, for
/// producers that cannot know in advance where a message begins. Every field is
/// optional because a continuation chunk omits what has not changed; which
/// message a field-less chunk continues is a sequence question the prose
/// specification answers.
class TextMessageChunkEvent extends $pb.GeneratedMessage {
  factory TextMessageChunkEvent({
    BaseEvent? baseEvent,
    $core.String? messageId,
    $core.String? role,
    $core.String? delta,
    $core.String? name,
    $core.String? subagentRunId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (messageId != null) result.messageId = messageId;
    if (role != null) result.role = role;
    if (delta != null) result.delta = delta;
    if (name != null) result.name = name;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    return result;
  }

  TextMessageChunkEvent._();

  factory TextMessageChunkEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TextMessageChunkEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TextMessageChunkEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'messageId')
    ..aOS(3, _omitFieldNames ? '' : 'role')
    ..aOS(4, _omitFieldNames ? '' : 'delta')
    ..aOS(5, _omitFieldNames ? '' : 'name')
    ..aOS(6, _omitFieldNames ? '' : 'subagentRunId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextMessageChunkEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextMessageChunkEvent copyWith(
          void Function(TextMessageChunkEvent) updates) =>
      super.copyWith((message) => updates(message as TextMessageChunkEvent))
          as TextMessageChunkEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TextMessageChunkEvent create() => TextMessageChunkEvent._();
  @$core.override
  TextMessageChunkEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TextMessageChunkEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TextMessageChunkEvent>(create);
  static TextMessageChunkEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The message this chunk belongs to. Absent continues the message already
  /// open.
  @$pb.TagNumber(2)
  $core.String get messageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set messageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageId() => $_clearField(2);

  /// Who the message is from, on the chunk that opens it.
  @$pb.TagNumber(3)
  $core.String get role => $_getSZ(2);
  @$pb.TagNumber(3)
  set role($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => $_clearField(3);

  /// The fragment to append. May be the empty string.
  @$pb.TagNumber(4)
  $core.String get delta => $_getSZ(3);
  @$pb.TagNumber(4)
  set delta($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDelta() => $_has(3);
  @$pb.TagNumber(4)
  void clearDelta() => $_clearField(4);

  /// An optional display name for the author.
  @$pb.TagNumber(5)
  $core.String get name => $_getSZ(4);
  @$pb.TagNumber(5)
  set name($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasName() => $_has(4);
  @$pb.TagNumber(5)
  void clearName() => $_clearField(5);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(6)
  $core.String get subagentRunId => $_getSZ(5);
  @$pb.TagNumber(6)
  set subagentRunId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSubagentRunId() => $_has(5);
  @$pb.TagNumber(6)
  void clearSubagentRunId() => $_clearField(6);
}

/// Opens a tool call. The arguments arrive as TOOL_CALL_ARGS events and the call
/// closes with TOOL_CALL_END.
class ToolCallStartEvent extends $pb.GeneratedMessage {
  factory ToolCallStartEvent({
    BaseEvent? baseEvent,
    $core.String? toolCallId,
    $core.String? toolCallName,
    $core.String? parentMessageId,
    $core.String? subagentRunId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (toolCallId != null) result.toolCallId = toolCallId;
    if (toolCallName != null) result.toolCallName = toolCallName;
    if (parentMessageId != null) result.parentMessageId = parentMessageId;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    return result;
  }

  ToolCallStartEvent._();

  factory ToolCallStartEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToolCallStartEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToolCallStartEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'toolCallId')
    ..aOS(3, _omitFieldNames ? '' : 'toolCallName')
    ..aOS(4, _omitFieldNames ? '' : 'parentMessageId')
    ..aOS(5, _omitFieldNames ? '' : 'subagentRunId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolCallStartEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolCallStartEvent copyWith(void Function(ToolCallStartEvent) updates) =>
      super.copyWith((message) => updates(message as ToolCallStartEvent))
          as ToolCallStartEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToolCallStartEvent create() => ToolCallStartEvent._();
  @$core.override
  ToolCallStartEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ToolCallStartEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToolCallStartEvent>(create);
  static ToolCallStartEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// Identifies the call, and ties the later args, end and result events to it.
  @$pb.TagNumber(2)
  $core.String get toolCallId => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolCallId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolCallId() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolCallId() => $_clearField(2);

  /// Which tool is being called.
  @$pb.TagNumber(3)
  $core.String get toolCallName => $_getSZ(2);
  @$pb.TagNumber(3)
  set toolCallName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToolCallName() => $_has(2);
  @$pb.TagNumber(3)
  void clearToolCallName() => $_clearField(3);

  /// The assistant message that holds this call. Absent means the producer did
  /// not attribute it to one.
  @$pb.TagNumber(4)
  $core.String get parentMessageId => $_getSZ(3);
  @$pb.TagNumber(4)
  set parentMessageId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParentMessageId() => $_has(3);
  @$pb.TagNumber(4)
  void clearParentMessageId() => $_clearField(4);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(5)
  $core.String get subagentRunId => $_getSZ(4);
  @$pb.TagNumber(5)
  set subagentRunId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSubagentRunId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSubagentRunId() => $_clearField(5);
}

/// Appends a fragment of a tool call's arguments.
class ToolCallArgsEvent extends $pb.GeneratedMessage {
  factory ToolCallArgsEvent({
    BaseEvent? baseEvent,
    $core.String? toolCallId,
    $core.String? delta,
    $core.String? subagentRunId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (toolCallId != null) result.toolCallId = toolCallId;
    if (delta != null) result.delta = delta;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    return result;
  }

  ToolCallArgsEvent._();

  factory ToolCallArgsEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToolCallArgsEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToolCallArgsEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'toolCallId')
    ..aOS(3, _omitFieldNames ? '' : 'delta')
    ..aOS(4, _omitFieldNames ? '' : 'subagentRunId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolCallArgsEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolCallArgsEvent copyWith(void Function(ToolCallArgsEvent) updates) =>
      super.copyWith((message) => updates(message as ToolCallArgsEvent))
          as ToolCallArgsEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToolCallArgsEvent create() => ToolCallArgsEvent._();
  @$core.override
  ToolCallArgsEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ToolCallArgsEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToolCallArgsEvent>(create);
  static ToolCallArgsEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The call these arguments belong to.
  @$pb.TagNumber(2)
  $core.String get toolCallId => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolCallId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolCallId() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolCallId() => $_clearField(2);

  /// A fragment of the arguments, which concatenate into the call's argument text
  /// — conventionally a JSON document, though the protocol does not validate it
  /// (see FunctionCall.arguments). Deliberately a string rather than parsed JSON:
  /// a fragment is not itself a document. May be the empty string.
  @$pb.TagNumber(3)
  $core.String get delta => $_getSZ(2);
  @$pb.TagNumber(3)
  set delta($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDelta() => $_has(2);
  @$pb.TagNumber(3)
  void clearDelta() => $_clearField(3);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(4)
  $core.String get subagentRunId => $_getSZ(3);
  @$pb.TagNumber(4)
  set subagentRunId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSubagentRunId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubagentRunId() => $_clearField(4);
}

/// Closes a tool call, meaning its arguments are complete.
class ToolCallEndEvent extends $pb.GeneratedMessage {
  factory ToolCallEndEvent({
    BaseEvent? baseEvent,
    $core.String? toolCallId,
    $core.String? subagentRunId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (toolCallId != null) result.toolCallId = toolCallId;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    return result;
  }

  ToolCallEndEvent._();

  factory ToolCallEndEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToolCallEndEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToolCallEndEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'toolCallId')
    ..aOS(3, _omitFieldNames ? '' : 'subagentRunId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolCallEndEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolCallEndEvent copyWith(void Function(ToolCallEndEvent) updates) =>
      super.copyWith((message) => updates(message as ToolCallEndEvent))
          as ToolCallEndEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToolCallEndEvent create() => ToolCallEndEvent._();
  @$core.override
  ToolCallEndEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ToolCallEndEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToolCallEndEvent>(create);
  static ToolCallEndEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The call being closed.
  @$pb.TagNumber(2)
  $core.String get toolCallId => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolCallId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolCallId() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolCallId() => $_clearField(2);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(3)
  $core.String get subagentRunId => $_getSZ(2);
  @$pb.TagNumber(3)
  set subagentRunId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubagentRunId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubagentRunId() => $_clearField(3);
}

/// A shorthand that stands in for a tool call's start, args and end sequence.
/// Every field is optional for the same reason as TEXT_MESSAGE_CHUNK.
class ToolCallChunkEvent extends $pb.GeneratedMessage {
  factory ToolCallChunkEvent({
    BaseEvent? baseEvent,
    $core.String? toolCallId,
    $core.String? toolCallName,
    $core.String? parentMessageId,
    $core.String? delta,
    $core.String? subagentRunId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (toolCallId != null) result.toolCallId = toolCallId;
    if (toolCallName != null) result.toolCallName = toolCallName;
    if (parentMessageId != null) result.parentMessageId = parentMessageId;
    if (delta != null) result.delta = delta;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    return result;
  }

  ToolCallChunkEvent._();

  factory ToolCallChunkEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToolCallChunkEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToolCallChunkEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'toolCallId')
    ..aOS(3, _omitFieldNames ? '' : 'toolCallName')
    ..aOS(4, _omitFieldNames ? '' : 'parentMessageId')
    ..aOS(5, _omitFieldNames ? '' : 'delta')
    ..aOS(6, _omitFieldNames ? '' : 'subagentRunId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolCallChunkEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolCallChunkEvent copyWith(void Function(ToolCallChunkEvent) updates) =>
      super.copyWith((message) => updates(message as ToolCallChunkEvent))
          as ToolCallChunkEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToolCallChunkEvent create() => ToolCallChunkEvent._();
  @$core.override
  ToolCallChunkEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ToolCallChunkEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToolCallChunkEvent>(create);
  static ToolCallChunkEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The call this chunk belongs to. Absent continues the call already open.
  @$pb.TagNumber(2)
  $core.String get toolCallId => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolCallId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolCallId() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolCallId() => $_clearField(2);

  /// Which tool is being called, on the chunk that opens it.
  @$pb.TagNumber(3)
  $core.String get toolCallName => $_getSZ(2);
  @$pb.TagNumber(3)
  set toolCallName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToolCallName() => $_has(2);
  @$pb.TagNumber(3)
  void clearToolCallName() => $_clearField(3);

  /// The assistant message that holds this call.
  @$pb.TagNumber(4)
  $core.String get parentMessageId => $_getSZ(3);
  @$pb.TagNumber(4)
  set parentMessageId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParentMessageId() => $_has(3);
  @$pb.TagNumber(4)
  void clearParentMessageId() => $_clearField(4);

  /// A fragment of the arguments. May be the empty string.
  @$pb.TagNumber(5)
  $core.String get delta => $_getSZ(4);
  @$pb.TagNumber(5)
  set delta($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDelta() => $_has(4);
  @$pb.TagNumber(5)
  void clearDelta() => $_clearField(5);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(6)
  $core.String get subagentRunId => $_getSZ(5);
  @$pb.TagNumber(6)
  set subagentRunId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSubagentRunId() => $_has(5);
  @$pb.TagNumber(6)
  void clearSubagentRunId() => $_clearField(6);
}

/// Carries what a tool returned. Mints a tool message rather than appending to an
/// existing one, which is why it has its own messageId.
class ToolCallResultEvent extends $pb.GeneratedMessage {
  factory ToolCallResultEvent({
    BaseEvent? baseEvent,
    $core.String? subagentRunId,
    $core.String? messageId,
    $core.String? toolCallId,
    $core.String? content,
    $core.String? role,
    $core.Iterable<$1.InputContent>? contentParts,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    if (messageId != null) result.messageId = messageId;
    if (toolCallId != null) result.toolCallId = toolCallId;
    if (content != null) result.content = content;
    if (role != null) result.role = role;
    if (contentParts != null) result.contentParts.addAll(contentParts);
    return result;
  }

  ToolCallResultEvent._();

  factory ToolCallResultEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToolCallResultEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToolCallResultEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'subagentRunId')
    ..aOS(3, _omitFieldNames ? '' : 'messageId')
    ..aOS(4, _omitFieldNames ? '' : 'toolCallId')
    ..aOS(5, _omitFieldNames ? '' : 'content')
    ..aOS(6, _omitFieldNames ? '' : 'role')
    ..pPM<$1.InputContent>(7, _omitFieldNames ? '' : 'contentParts',
        subBuilder: $1.InputContent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolCallResultEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolCallResultEvent copyWith(void Function(ToolCallResultEvent) updates) =>
      super.copyWith((message) => updates(message as ToolCallResultEvent))
          as ToolCallResultEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToolCallResultEvent create() => ToolCallResultEvent._();
  @$core.override
  ToolCallResultEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ToolCallResultEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToolCallResultEvent>(create);
  static ToolCallResultEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(2)
  $core.String get subagentRunId => $_getSZ(1);
  @$pb.TagNumber(2)
  set subagentRunId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubagentRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubagentRunId() => $_clearField(2);

  /// The tool message this result becomes.
  @$pb.TagNumber(3)
  $core.String get messageId => $_getSZ(2);
  @$pb.TagNumber(3)
  set messageId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessageId() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessageId() => $_clearField(3);

  /// The call being answered.
  @$pb.TagNumber(4)
  $core.String get toolCallId => $_getSZ(3);
  @$pb.TagNumber(4)
  set toolCallId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasToolCallId() => $_has(3);
  @$pb.TagNumber(4)
  void clearToolCallId() => $_clearField(4);

  /// What the tool returned: either plain text, or an ordered list of parts,
  /// exactly as on the tool message this event mints. A tool returning structured
  /// data serialises it into text; media travel as parts of their own.
  @$pb.TagNumber(5)
  $core.String get content => $_getSZ(4);
  @$pb.TagNumber(5)
  set content($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContent() => $_has(4);
  @$pb.TagNumber(5)
  void clearContent() => $_clearField(5);

  /// Present only for symmetry with the message it mints; the value is fixed, so
  /// a producer may leave it out.
  @$pb.TagNumber(6)
  $core.String get role => $_getSZ(5);
  @$pb.TagNumber(6)
  set role($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRole() => $_has(5);
  @$pb.TagNumber(6)
  void clearRole() => $_clearField(6);

  /// What the tool returned: either plain text, or an ordered list of parts,
  /// exactly as on the tool message this event mints. A tool returning structured
  /// data serialises it into text; media travel as parts of their own.
  @$pb.TagNumber(7)
  $pb.PbList<$1.InputContent> get contentParts => $_getList(6);
}

/// Replaces the agent state wholesale. Sent when a delta cannot express the
/// change, or to resynchronise a consumer.
class StateSnapshotEvent extends $pb.GeneratedMessage {
  factory StateSnapshotEvent({
    BaseEvent? baseEvent,
    $0.Value? snapshot,
    $core.String? subagentRunId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (snapshot != null) result.snapshot = snapshot;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    return result;
  }

  StateSnapshotEvent._();

  factory StateSnapshotEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StateSnapshotEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StateSnapshotEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOM<$0.Value>(2, _omitFieldNames ? '' : 'snapshot',
        subBuilder: $0.Value.create)
    ..aOS(3, _omitFieldNames ? '' : 'subagentRunId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StateSnapshotEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StateSnapshotEvent copyWith(void Function(StateSnapshotEvent) updates) =>
      super.copyWith((message) => updates(message as StateSnapshotEvent))
          as StateSnapshotEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StateSnapshotEvent create() => StateSnapshotEvent._();
  @$core.override
  StateSnapshotEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StateSnapshotEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StateSnapshotEvent>(create);
  static StateSnapshotEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The complete new state.
  @$pb.TagNumber(2)
  $0.Value get snapshot => $_getN(1);
  @$pb.TagNumber(2)
  set snapshot($0.Value value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSnapshot() => $_has(1);
  @$pb.TagNumber(2)
  void clearSnapshot() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Value ensureSnapshot() => $_ensure(1);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(3)
  $core.String get subagentRunId => $_getSZ(2);
  @$pb.TagNumber(3)
  set subagentRunId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubagentRunId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubagentRunId() => $_clearField(3);
}

/// Changes the agent state incrementally.
class StateDeltaEvent extends $pb.GeneratedMessage {
  factory StateDeltaEvent({
    BaseEvent? baseEvent,
    $core.Iterable<$2.JsonPatchOperation>? delta,
    $core.String? subagentRunId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (delta != null) result.delta.addAll(delta);
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    return result;
  }

  StateDeltaEvent._();

  factory StateDeltaEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StateDeltaEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StateDeltaEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..pPM<$2.JsonPatchOperation>(2, _omitFieldNames ? '' : 'delta',
        subBuilder: $2.JsonPatchOperation.create)
    ..aOS(3, _omitFieldNames ? '' : 'subagentRunId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StateDeltaEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StateDeltaEvent copyWith(void Function(StateDeltaEvent) updates) =>
      super.copyWith((message) => updates(message as StateDeltaEvent))
          as StateDeltaEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StateDeltaEvent create() => StateDeltaEvent._();
  @$core.override
  StateDeltaEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StateDeltaEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StateDeltaEvent>(create);
  static StateDeltaEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The change, as an RFC 6902 patch against the current state. Structural
  /// validity here does not mean the patch applies: a well-formed operation may
  /// point at a path that does not exist, which RFC 6902 leaves to the applier.
  @$pb.TagNumber(2)
  $pb.PbList<$2.JsonPatchOperation> get delta => $_getList(1);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(3)
  $core.String get subagentRunId => $_getSZ(2);
  @$pb.TagNumber(3)
  set subagentRunId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubagentRunId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubagentRunId() => $_clearField(3);
}

/// The complete set of messages the producer owns, in order. Conversation-wide
/// rather than a plain overwrite: a consumer may keep messages of its own that no
/// producer tracks, so exactly how a snapshot reconciles with those is
/// behavioural and belongs in the prose. Being conversation-wide it cannot belong
/// to a single subagent, so it carries no attribution; it does establish which
/// subagent owns each message it contains, through the messages themselves.
class MessagesSnapshotEvent extends $pb.GeneratedMessage {
  factory MessagesSnapshotEvent({
    BaseEvent? baseEvent,
    $core.Iterable<$1.Message>? messages,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (messages != null) result.messages.addAll(messages);
    return result;
  }

  MessagesSnapshotEvent._();

  factory MessagesSnapshotEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessagesSnapshotEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MessagesSnapshotEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..pPM<$1.Message>(2, _omitFieldNames ? '' : 'messages',
        subBuilder: $1.Message.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessagesSnapshotEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessagesSnapshotEvent copyWith(
          void Function(MessagesSnapshotEvent) updates) =>
      super.copyWith((message) => updates(message as MessagesSnapshotEvent))
          as MessagesSnapshotEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessagesSnapshotEvent create() => MessagesSnapshotEvent._();
  @$core.override
  MessagesSnapshotEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessagesSnapshotEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MessagesSnapshotEvent>(create);
  static MessagesSnapshotEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The messages the producer is declaring, in order.
  @$pb.TagNumber(2)
  $pb.PbList<$1.Message> get messages => $_getList(1);
}

/// Reports structured progress that is not conversation content, such as a step a
/// UI renders as its own widget.
class ActivitySnapshotEvent extends $pb.GeneratedMessage {
  factory ActivitySnapshotEvent({
    BaseEvent? baseEvent,
    $core.String? subagentRunId,
    $core.String? messageId,
    $core.String? activityType,
    $0.Struct? content,
    $core.bool? replace,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    if (messageId != null) result.messageId = messageId;
    if (activityType != null) result.activityType = activityType;
    if (content != null) result.content = content;
    if (replace != null) result.replace = replace;
    return result;
  }

  ActivitySnapshotEvent._();

  factory ActivitySnapshotEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ActivitySnapshotEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActivitySnapshotEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'subagentRunId')
    ..aOS(3, _omitFieldNames ? '' : 'messageId')
    ..aOS(4, _omitFieldNames ? '' : 'activityType')
    ..aOM<$0.Struct>(5, _omitFieldNames ? '' : 'content',
        subBuilder: $0.Struct.create)
    ..aOB(6, _omitFieldNames ? '' : 'replace')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivitySnapshotEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivitySnapshotEvent copyWith(
          void Function(ActivitySnapshotEvent) updates) =>
      super.copyWith((message) => updates(message as ActivitySnapshotEvent))
          as ActivitySnapshotEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ActivitySnapshotEvent create() => ActivitySnapshotEvent._();
  @$core.override
  ActivitySnapshotEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ActivitySnapshotEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ActivitySnapshotEvent>(create);
  static ActivitySnapshotEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(2)
  $core.String get subagentRunId => $_getSZ(1);
  @$pb.TagNumber(2)
  set subagentRunId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubagentRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubagentRunId() => $_clearField(2);

  /// The activity message this describes.
  @$pb.TagNumber(3)
  $core.String get messageId => $_getSZ(2);
  @$pb.TagNumber(3)
  set messageId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessageId() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessageId() => $_clearField(3);

  /// What kind of activity this is. An open string: the set is the producer's,
  /// not the protocol's.
  @$pb.TagNumber(4)
  $core.String get activityType => $_getSZ(3);
  @$pb.TagNumber(4)
  set activityType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActivityType() => $_has(3);
  @$pb.TagNumber(4)
  void clearActivityType() => $_clearField(4);

  /// The activity's payload, open by key.
  @$pb.TagNumber(5)
  $0.Struct get content => $_getN(4);
  @$pb.TagNumber(5)
  set content($0.Struct value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasContent() => $_has(4);
  @$pb.TagNumber(5)
  void clearContent() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Struct ensureContent() => $_ensure(4);

  /// Whether this snapshot overwrites the activity's existing content. Absent
  /// means it does, and that meaning is normative; only an explicit false asks a
  /// consumer to leave what is already there. It does not ask for a merge —
  /// ACTIVITY_DELTA is how content is changed incrementally. What a consumer does
  /// with a non-overwriting snapshot is behavioural and belongs in the prose.
  @$pb.TagNumber(6)
  $core.bool get replace => $_getBF(5);
  @$pb.TagNumber(6)
  set replace($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReplace() => $_has(5);
  @$pb.TagNumber(6)
  void clearReplace() => $_clearField(6);
}

/// Changes an activity message's content incrementally.
class ActivityDeltaEvent extends $pb.GeneratedMessage {
  factory ActivityDeltaEvent({
    BaseEvent? baseEvent,
    $core.String? subagentRunId,
    $core.String? messageId,
    $core.String? activityType,
    $core.Iterable<$2.JsonPatchOperation>? patch,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    if (messageId != null) result.messageId = messageId;
    if (activityType != null) result.activityType = activityType;
    if (patch != null) result.patch.addAll(patch);
    return result;
  }

  ActivityDeltaEvent._();

  factory ActivityDeltaEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ActivityDeltaEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActivityDeltaEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'subagentRunId')
    ..aOS(3, _omitFieldNames ? '' : 'messageId')
    ..aOS(4, _omitFieldNames ? '' : 'activityType')
    ..pPM<$2.JsonPatchOperation>(5, _omitFieldNames ? '' : 'patch',
        subBuilder: $2.JsonPatchOperation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivityDeltaEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivityDeltaEvent copyWith(void Function(ActivityDeltaEvent) updates) =>
      super.copyWith((message) => updates(message as ActivityDeltaEvent))
          as ActivityDeltaEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ActivityDeltaEvent create() => ActivityDeltaEvent._();
  @$core.override
  ActivityDeltaEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ActivityDeltaEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ActivityDeltaEvent>(create);
  static ActivityDeltaEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(2)
  $core.String get subagentRunId => $_getSZ(1);
  @$pb.TagNumber(2)
  set subagentRunId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubagentRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubagentRunId() => $_clearField(2);

  /// The activity message being changed.
  @$pb.TagNumber(3)
  $core.String get messageId => $_getSZ(2);
  @$pb.TagNumber(3)
  set messageId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessageId() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessageId() => $_clearField(3);

  /// What kind of activity this is.
  @$pb.TagNumber(4)
  $core.String get activityType => $_getSZ(3);
  @$pb.TagNumber(4)
  set activityType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActivityType() => $_has(3);
  @$pb.TagNumber(4)
  void clearActivityType() => $_clearField(4);

  /// The change, as an RFC 6902 patch against the activity's content.
  @$pb.TagNumber(5)
  $pb.PbList<$2.JsonPatchOperation> get patch => $_getList(4);
}

/// Passes a provider-native event through untranslated, for consumers that need
/// detail the protocol does not model.
class RawEvent extends $pb.GeneratedMessage {
  factory RawEvent({
    BaseEvent? baseEvent,
    $0.Value? event,
    $core.String? source,
    $core.String? subagentRunId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (event != null) result.event = event;
    if (source != null) result.source = source;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    return result;
  }

  RawEvent._();

  factory RawEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RawEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RawEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOM<$0.Value>(2, _omitFieldNames ? '' : 'event',
        subBuilder: $0.Value.create)
    ..aOS(3, _omitFieldNames ? '' : 'source')
    ..aOS(4, _omitFieldNames ? '' : 'subagentRunId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RawEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RawEvent copyWith(void Function(RawEvent) updates) =>
      super.copyWith((message) => updates(message as RawEvent)) as RawEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RawEvent create() => RawEvent._();
  @$core.override
  RawEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RawEvent getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RawEvent>(create);
  static RawEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The provider's own event. Any JSON value, and required: an event whose only
  /// purpose is to carry this would say nothing without it.
  @$pb.TagNumber(2)
  $0.Value get event => $_getN(1);
  @$pb.TagNumber(2)
  set event($0.Value value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEvent() => $_has(1);
  @$pb.TagNumber(2)
  void clearEvent() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Value ensureEvent() => $_ensure(1);

  /// Which provider or framework the event came from.
  @$pb.TagNumber(3)
  $core.String get source => $_getSZ(2);
  @$pb.TagNumber(3)
  set source($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSource() => $_has(2);
  @$pb.TagNumber(3)
  void clearSource() => $_clearField(3);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(4)
  $core.String get subagentRunId => $_getSZ(3);
  @$pb.TagNumber(4)
  set subagentRunId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSubagentRunId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubagentRunId() => $_clearField(4);
}

/// The protocol's extension point for an application's own events. Anything a
/// consumer does with one is outside the protocol.
class CustomEvent extends $pb.GeneratedMessage {
  factory CustomEvent({
    BaseEvent? baseEvent,
    $core.String? name,
    $0.Value? value,
    $core.String? subagentRunId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (name != null) result.name = name;
    if (value != null) result.value = value;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    return result;
  }

  CustomEvent._();

  factory CustomEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CustomEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CustomEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOM<$0.Value>(3, _omitFieldNames ? '' : 'value',
        subBuilder: $0.Value.create)
    ..aOS(4, _omitFieldNames ? '' : 'subagentRunId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CustomEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CustomEvent copyWith(void Function(CustomEvent) updates) =>
      super.copyWith((message) => updates(message as CustomEvent))
          as CustomEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CustomEvent create() => CustomEvent._();
  @$core.override
  CustomEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CustomEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CustomEvent>(create);
  static CustomEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// What this custom event is. Required: without it a consumer cannot route the
  /// value.
  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  /// The payload. Any JSON value, and required.
  @$pb.TagNumber(3)
  $0.Value get value => $_getN(2);
  @$pb.TagNumber(3)
  set value($0.Value value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearValue() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Value ensureValue() => $_ensure(2);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(4)
  $core.String get subagentRunId => $_getSZ(3);
  @$pb.TagNumber(4)
  set subagentRunId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSubagentRunId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubagentRunId() => $_clearField(4);
}

/// Opens a run. Run-scoped, so it carries no subagent attribution.
class RunStartedEvent extends $pb.GeneratedMessage {
  factory RunStartedEvent({
    BaseEvent? baseEvent,
    $core.String? threadId,
    $core.String? runId,
    $core.String? parentRunId,
    $1.RunAgentInput? input,
    $core.String? protocolVersion,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (threadId != null) result.threadId = threadId;
    if (runId != null) result.runId = runId;
    if (parentRunId != null) result.parentRunId = parentRunId;
    if (input != null) result.input = input;
    if (protocolVersion != null) result.protocolVersion = protocolVersion;
    return result;
  }

  RunStartedEvent._();

  factory RunStartedEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RunStartedEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RunStartedEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'threadId')
    ..aOS(3, _omitFieldNames ? '' : 'runId')
    ..aOS(4, _omitFieldNames ? '' : 'parentRunId')
    ..aOM<$1.RunAgentInput>(5, _omitFieldNames ? '' : 'input',
        subBuilder: $1.RunAgentInput.create)
    ..aOS(6, _omitFieldNames ? '' : 'protocolVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunStartedEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunStartedEvent copyWith(void Function(RunStartedEvent) updates) =>
      super.copyWith((message) => updates(message as RunStartedEvent))
          as RunStartedEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RunStartedEvent create() => RunStartedEvent._();
  @$core.override
  RunStartedEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RunStartedEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RunStartedEvent>(create);
  static RunStartedEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The conversation this run belongs to.
  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);

  /// Identifies this run.
  @$pb.TagNumber(3)
  $core.String get runId => $_getSZ(2);
  @$pb.TagNumber(3)
  set runId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRunId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRunId() => $_clearField(3);

  /// The run that spawned this one, when an agent invokes another agent as a
  /// separate run rather than as a subagent within one.
  @$pb.TagNumber(4)
  $core.String get parentRunId => $_getSZ(3);
  @$pb.TagNumber(4)
  set parentRunId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParentRunId() => $_has(3);
  @$pb.TagNumber(4)
  void clearParentRunId() => $_clearField(4);

  /// The request this run was started from, echoed back so a consumer that did
  /// not make the request can still see what the agent was asked.
  @$pb.TagNumber(5)
  $1.RunAgentInput get input => $_getN(4);
  @$pb.TagNumber(5)
  set input($1.RunAgentInput value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasInput() => $_has(4);
  @$pb.TagNumber(5)
  void clearInput() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.RunAgentInput ensureInput() => $_ensure(4);

  /// The protocol version this producer speaks, such as "1.0" — the producer's
  /// own version, not an echo of the input's, which is what makes the pair a
  /// negotiation: each side declares itself and the consumer sees a downgrade the
  /// moment it happens. Absent means a producer from before the protocol carried
  /// a version.
  @$pb.TagNumber(6)
  $core.String get protocolVersion => $_getSZ(5);
  @$pb.TagNumber(6)
  set protocolVersion($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasProtocolVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearProtocolVersion() => $_clearField(6);
}

/// Closes a run that did not fail. Run-scoped, so it carries no subagent
/// attribution.
class RunFinishedEvent extends $pb.GeneratedMessage {
  factory RunFinishedEvent({
    BaseEvent? baseEvent,
    $core.String? threadId,
    $core.String? runId,
    $0.Value? result,
    $core.String? outcome,
    $core.Iterable<$1.Interrupt>? interrupts,
    $core.Iterable<Usage>? usage,
    $core.Iterable<$core.String>? pendingToolCallIds,
  }) {
    final result$ = create();
    if (baseEvent != null) result$.baseEvent = baseEvent;
    if (threadId != null) result$.threadId = threadId;
    if (runId != null) result$.runId = runId;
    if (result != null) result$.result = result;
    if (outcome != null) result$.outcome = outcome;
    if (interrupts != null) result$.interrupts.addAll(interrupts);
    if (usage != null) result$.usage.addAll(usage);
    if (pendingToolCallIds != null)
      result$.pendingToolCallIds.addAll(pendingToolCallIds);
    return result$;
  }

  RunFinishedEvent._();

  factory RunFinishedEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RunFinishedEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RunFinishedEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'threadId')
    ..aOS(3, _omitFieldNames ? '' : 'runId')
    ..aOM<$0.Value>(4, _omitFieldNames ? '' : 'result',
        subBuilder: $0.Value.create)
    ..aOS(5, _omitFieldNames ? '' : 'outcome')
    ..pPM<$1.Interrupt>(6, _omitFieldNames ? '' : 'interrupts',
        subBuilder: $1.Interrupt.create)
    ..pPM<Usage>(7, _omitFieldNames ? '' : 'usage', subBuilder: Usage.create)
    ..pPS(8, _omitFieldNames ? '' : 'pendingToolCallIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunFinishedEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunFinishedEvent copyWith(void Function(RunFinishedEvent) updates) =>
      super.copyWith((message) => updates(message as RunFinishedEvent))
          as RunFinishedEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RunFinishedEvent create() => RunFinishedEvent._();
  @$core.override
  RunFinishedEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RunFinishedEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RunFinishedEvent>(create);
  static RunFinishedEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The conversation this run belongs to.
  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);

  /// The run being closed.
  @$pb.TagNumber(3)
  $core.String get runId => $_getSZ(2);
  @$pb.TagNumber(3)
  set runId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRunId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRunId() => $_clearField(3);

  /// The run's return value, if it has one. Any JSON value.
  @$pb.TagNumber(4)
  $0.Value get result => $_getN(3);
  @$pb.TagNumber(4)
  set result($0.Value value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasResult() => $_has(3);
  @$pb.TagNumber(4)
  void clearResult() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Value ensureResult() => $_ensure(3);

  /// Why the run ended. Absent means success, so every producer written before
  /// outcomes existed is already conformant.
  @$pb.TagNumber(5)
  $core.String get outcome => $_getSZ(4);
  @$pb.TagNumber(5)
  set outcome($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOutcome() => $_has(4);
  @$pb.TagNumber(5)
  void clearOutcome() => $_clearField(5);

  /// What the run is waiting for. At least one: an interrupt outcome with nothing
  /// to answer would leave a consumer with nothing to do.
  @$pb.TagNumber(6)
  $pb.PbList<$1.Interrupt> get interrupts => $_getList(5);

  /// Token usage for the run, one entry per provider and model, so a run that
  /// invoked several models keeps them separate. A consumer that only wants
  /// totals sums across the entries. The run is the accounting boundary: usage
  /// covers every model call made within the run, calls made by its subagents
  /// included; an agent invoked as a separate run under parentRunId reports its
  /// own usage on its own terminal event; and a run that resumes an interrupted
  /// one reports only the calls it made itself, not the interrupted run's.
  @$pb.TagNumber(7)
  $pb.PbList<Usage> get usage => $_getList(6);

  /// The tool calls this run started and left unanswered — no TOOL_CALL_RESULT in
  /// the run — for the application to answer in the next input's messages, in the
  /// order they were made. Absent or empty means the producer named none, and a
  /// consumer derives the list from the stream; otherwise it is the list, and it
  /// agrees with the stream. On the success outcome rather than the event because
  /// a run that stopped on a frontend tool call is a completed run: whether the
  /// application continues the thread is its own decision, so the producer
  /// reports what it knows and no more.
  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get pendingToolCallIds => $_getList(7);
}

/// Ends a run that failed. Run-scoped, so it carries no subagent attribution; a
/// subagent that fails without ending the run reports SUBAGENT_ERROR instead.
class RunErrorEvent extends $pb.GeneratedMessage {
  factory RunErrorEvent({
    BaseEvent? baseEvent,
    $core.String? code,
    $core.String? message,
    $core.Iterable<Usage>? usage,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    if (usage != null) result.usage.addAll(usage);
    return result;
  }

  RunErrorEvent._();

  factory RunErrorEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RunErrorEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RunErrorEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..pPM<Usage>(4, _omitFieldNames ? '' : 'usage', subBuilder: Usage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunErrorEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunErrorEvent copyWith(void Function(RunErrorEvent) updates) =>
      super.copyWith((message) => updates(message as RunErrorEvent))
          as RunErrorEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RunErrorEvent create() => RunErrorEvent._();
  @$core.override
  RunErrorEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RunErrorEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RunErrorEvent>(create);
  static RunErrorEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// A machine-readable error code. An open string: the protocol defines no
  /// vocabulary.
  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  /// What went wrong, for a person to read.
  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);

  /// Token usage accrued before the failure, for a run that completed one or more
  /// model calls before dying. Scoped as on RUN_FINISHED: the run's own calls,
  /// subagents included.
  @$pb.TagNumber(4)
  $pb.PbList<Usage> get usage => $_getList(3);
}

/// Opens a named step within a run, for producers whose frameworks have a step
/// concept worth surfacing.
class StepStartedEvent extends $pb.GeneratedMessage {
  factory StepStartedEvent({
    BaseEvent? baseEvent,
    $core.String? stepName,
    $core.String? subagentRunId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (stepName != null) result.stepName = stepName;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    return result;
  }

  StepStartedEvent._();

  factory StepStartedEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StepStartedEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StepStartedEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'stepName')
    ..aOS(3, _omitFieldNames ? '' : 'subagentRunId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StepStartedEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StepStartedEvent copyWith(void Function(StepStartedEvent) updates) =>
      super.copyWith((message) => updates(message as StepStartedEvent))
          as StepStartedEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StepStartedEvent create() => StepStartedEvent._();
  @$core.override
  StepStartedEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StepStartedEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StepStartedEvent>(create);
  static StepStartedEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The step's name. Identifies it: the matching STEP_FINISHED carries the same
  /// name.
  @$pb.TagNumber(2)
  $core.String get stepName => $_getSZ(1);
  @$pb.TagNumber(2)
  set stepName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStepName() => $_has(1);
  @$pb.TagNumber(2)
  void clearStepName() => $_clearField(2);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(3)
  $core.String get subagentRunId => $_getSZ(2);
  @$pb.TagNumber(3)
  set subagentRunId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubagentRunId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubagentRunId() => $_clearField(3);
}

/// Closes a named step.
class StepFinishedEvent extends $pb.GeneratedMessage {
  factory StepFinishedEvent({
    BaseEvent? baseEvent,
    $core.String? stepName,
    $core.String? subagentRunId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (stepName != null) result.stepName = stepName;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    return result;
  }

  StepFinishedEvent._();

  factory StepFinishedEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StepFinishedEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StepFinishedEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'stepName')
    ..aOS(3, _omitFieldNames ? '' : 'subagentRunId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StepFinishedEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StepFinishedEvent copyWith(void Function(StepFinishedEvent) updates) =>
      super.copyWith((message) => updates(message as StepFinishedEvent))
          as StepFinishedEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StepFinishedEvent create() => StepFinishedEvent._();
  @$core.override
  StepFinishedEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StepFinishedEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StepFinishedEvent>(create);
  static StepFinishedEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The step being closed.
  @$pb.TagNumber(2)
  $core.String get stepName => $_getSZ(1);
  @$pb.TagNumber(2)
  set stepName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStepName() => $_has(1);
  @$pb.TagNumber(2)
  void clearStepName() => $_clearField(2);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(3)
  $core.String get subagentRunId => $_getSZ(2);
  @$pb.TagNumber(3)
  set subagentRunId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubagentRunId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubagentRunId() => $_clearField(3);
}

/// Opens a span of reasoning. A span may contain several reasoning messages.
class ReasoningStartEvent extends $pb.GeneratedMessage {
  factory ReasoningStartEvent({
    BaseEvent? baseEvent,
    $core.String? subagentRunId,
    $core.String? messageId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    if (messageId != null) result.messageId = messageId;
    return result;
  }

  ReasoningStartEvent._();

  factory ReasoningStartEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReasoningStartEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReasoningStartEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'subagentRunId')
    ..aOS(3, _omitFieldNames ? '' : 'messageId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReasoningStartEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReasoningStartEvent copyWith(void Function(ReasoningStartEvent) updates) =>
      super.copyWith((message) => updates(message as ReasoningStartEvent))
          as ReasoningStartEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReasoningStartEvent create() => ReasoningStartEvent._();
  @$core.override
  ReasoningStartEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReasoningStartEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReasoningStartEvent>(create);
  static ReasoningStartEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(2)
  $core.String get subagentRunId => $_getSZ(1);
  @$pb.TagNumber(2)
  set subagentRunId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubagentRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubagentRunId() => $_clearField(2);

  /// The span being opened.
  @$pb.TagNumber(3)
  $core.String get messageId => $_getSZ(2);
  @$pb.TagNumber(3)
  set messageId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessageId() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessageId() => $_clearField(3);
}

/// Opens a streamed reasoning message.
class ReasoningMessageStartEvent extends $pb.GeneratedMessage {
  factory ReasoningMessageStartEvent({
    BaseEvent? baseEvent,
    $core.String? subagentRunId,
    $core.String? messageId,
    $core.String? role,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    if (messageId != null) result.messageId = messageId;
    if (role != null) result.role = role;
    return result;
  }

  ReasoningMessageStartEvent._();

  factory ReasoningMessageStartEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReasoningMessageStartEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReasoningMessageStartEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'subagentRunId')
    ..aOS(3, _omitFieldNames ? '' : 'messageId')
    ..aOS(4, _omitFieldNames ? '' : 'role')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReasoningMessageStartEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReasoningMessageStartEvent copyWith(
          void Function(ReasoningMessageStartEvent) updates) =>
      super.copyWith(
              (message) => updates(message as ReasoningMessageStartEvent))
          as ReasoningMessageStartEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReasoningMessageStartEvent create() => ReasoningMessageStartEvent._();
  @$core.override
  ReasoningMessageStartEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReasoningMessageStartEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReasoningMessageStartEvent>(create);
  static ReasoningMessageStartEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(2)
  $core.String get subagentRunId => $_getSZ(1);
  @$pb.TagNumber(2)
  set subagentRunId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubagentRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubagentRunId() => $_clearField(2);

  /// The reasoning message this stream builds.
  @$pb.TagNumber(3)
  $core.String get messageId => $_getSZ(2);
  @$pb.TagNumber(3)
  set messageId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessageId() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessageId() => $_clearField(3);

  /// Fixed, and required rather than defaulted. The requirement is inherited from
  /// the SDKs rather than chosen.
  @$pb.TagNumber(4)
  $core.String get role => $_getSZ(3);
  @$pb.TagNumber(4)
  set role($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRole() => $_has(3);
  @$pb.TagNumber(4)
  void clearRole() => $_clearField(4);
}

/// Appends a fragment to a streamed reasoning message.
class ReasoningMessageContentEvent extends $pb.GeneratedMessage {
  factory ReasoningMessageContentEvent({
    BaseEvent? baseEvent,
    $core.String? subagentRunId,
    $core.String? messageId,
    $core.String? delta,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    if (messageId != null) result.messageId = messageId;
    if (delta != null) result.delta = delta;
    return result;
  }

  ReasoningMessageContentEvent._();

  factory ReasoningMessageContentEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReasoningMessageContentEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReasoningMessageContentEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'subagentRunId')
    ..aOS(3, _omitFieldNames ? '' : 'messageId')
    ..aOS(4, _omitFieldNames ? '' : 'delta')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReasoningMessageContentEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReasoningMessageContentEvent copyWith(
          void Function(ReasoningMessageContentEvent) updates) =>
      super.copyWith(
              (message) => updates(message as ReasoningMessageContentEvent))
          as ReasoningMessageContentEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReasoningMessageContentEvent create() =>
      ReasoningMessageContentEvent._();
  @$core.override
  ReasoningMessageContentEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReasoningMessageContentEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReasoningMessageContentEvent>(create);
  static ReasoningMessageContentEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(2)
  $core.String get subagentRunId => $_getSZ(1);
  @$pb.TagNumber(2)
  set subagentRunId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubagentRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubagentRunId() => $_clearField(2);

  /// The reasoning message this fragment belongs to.
  @$pb.TagNumber(3)
  $core.String get messageId => $_getSZ(2);
  @$pb.TagNumber(3)
  set messageId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessageId() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessageId() => $_clearField(3);

  /// The fragment to append. May be the empty string.
  @$pb.TagNumber(4)
  $core.String get delta => $_getSZ(3);
  @$pb.TagNumber(4)
  set delta($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDelta() => $_has(3);
  @$pb.TagNumber(4)
  void clearDelta() => $_clearField(4);
}

/// Closes a streamed reasoning message.
class ReasoningMessageEndEvent extends $pb.GeneratedMessage {
  factory ReasoningMessageEndEvent({
    BaseEvent? baseEvent,
    $core.String? subagentRunId,
    $core.String? messageId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    if (messageId != null) result.messageId = messageId;
    return result;
  }

  ReasoningMessageEndEvent._();

  factory ReasoningMessageEndEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReasoningMessageEndEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReasoningMessageEndEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'subagentRunId')
    ..aOS(3, _omitFieldNames ? '' : 'messageId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReasoningMessageEndEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReasoningMessageEndEvent copyWith(
          void Function(ReasoningMessageEndEvent) updates) =>
      super.copyWith((message) => updates(message as ReasoningMessageEndEvent))
          as ReasoningMessageEndEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReasoningMessageEndEvent create() => ReasoningMessageEndEvent._();
  @$core.override
  ReasoningMessageEndEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReasoningMessageEndEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReasoningMessageEndEvent>(create);
  static ReasoningMessageEndEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(2)
  $core.String get subagentRunId => $_getSZ(1);
  @$pb.TagNumber(2)
  set subagentRunId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubagentRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubagentRunId() => $_clearField(2);

  /// The reasoning message being closed.
  @$pb.TagNumber(3)
  $core.String get messageId => $_getSZ(2);
  @$pb.TagNumber(3)
  set messageId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessageId() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessageId() => $_clearField(3);
}

/// A shorthand that stands in for a reasoning message's start, content and end
/// sequence.
class ReasoningMessageChunkEvent extends $pb.GeneratedMessage {
  factory ReasoningMessageChunkEvent({
    BaseEvent? baseEvent,
    $core.String? subagentRunId,
    $core.String? messageId,
    $core.String? delta,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    if (messageId != null) result.messageId = messageId;
    if (delta != null) result.delta = delta;
    return result;
  }

  ReasoningMessageChunkEvent._();

  factory ReasoningMessageChunkEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReasoningMessageChunkEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReasoningMessageChunkEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'subagentRunId')
    ..aOS(3, _omitFieldNames ? '' : 'messageId')
    ..aOS(4, _omitFieldNames ? '' : 'delta')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReasoningMessageChunkEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReasoningMessageChunkEvent copyWith(
          void Function(ReasoningMessageChunkEvent) updates) =>
      super.copyWith(
              (message) => updates(message as ReasoningMessageChunkEvent))
          as ReasoningMessageChunkEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReasoningMessageChunkEvent create() => ReasoningMessageChunkEvent._();
  @$core.override
  ReasoningMessageChunkEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReasoningMessageChunkEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReasoningMessageChunkEvent>(create);
  static ReasoningMessageChunkEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(2)
  $core.String get subagentRunId => $_getSZ(1);
  @$pb.TagNumber(2)
  set subagentRunId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubagentRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubagentRunId() => $_clearField(2);

  /// The reasoning message this chunk belongs to. Absent continues the one
  /// already open.
  @$pb.TagNumber(3)
  $core.String get messageId => $_getSZ(2);
  @$pb.TagNumber(3)
  set messageId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessageId() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessageId() => $_clearField(3);

  /// The fragment to append. May be the empty string.
  @$pb.TagNumber(4)
  $core.String get delta => $_getSZ(3);
  @$pb.TagNumber(4)
  set delta($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDelta() => $_has(3);
  @$pb.TagNumber(4)
  void clearDelta() => $_clearField(4);
}

/// Closes a span of reasoning.
class ReasoningEndEvent extends $pb.GeneratedMessage {
  factory ReasoningEndEvent({
    BaseEvent? baseEvent,
    $core.String? subagentRunId,
    $core.String? messageId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    if (messageId != null) result.messageId = messageId;
    return result;
  }

  ReasoningEndEvent._();

  factory ReasoningEndEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReasoningEndEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReasoningEndEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'subagentRunId')
    ..aOS(3, _omitFieldNames ? '' : 'messageId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReasoningEndEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReasoningEndEvent copyWith(void Function(ReasoningEndEvent) updates) =>
      super.copyWith((message) => updates(message as ReasoningEndEvent))
          as ReasoningEndEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReasoningEndEvent create() => ReasoningEndEvent._();
  @$core.override
  ReasoningEndEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReasoningEndEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReasoningEndEvent>(create);
  static ReasoningEndEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(2)
  $core.String get subagentRunId => $_getSZ(1);
  @$pb.TagNumber(2)
  set subagentRunId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubagentRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubagentRunId() => $_clearField(2);

  /// The span being closed.
  @$pb.TagNumber(3)
  $core.String get messageId => $_getSZ(2);
  @$pb.TagNumber(3)
  set messageId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessageId() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessageId() => $_clearField(3);
}

/// Carries a provider's opaque, encrypted reasoning artefact, which a consumer
/// stores and returns on a later turn without being able to read it.
class ReasoningEncryptedValueEvent extends $pb.GeneratedMessage {
  factory ReasoningEncryptedValueEvent({
    BaseEvent? baseEvent,
    $core.String? subagentRunId,
    $core.String? subtype,
    $core.String? entityId,
    $core.String? encryptedValue,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    if (subtype != null) result.subtype = subtype;
    if (entityId != null) result.entityId = entityId;
    if (encryptedValue != null) result.encryptedValue = encryptedValue;
    return result;
  }

  ReasoningEncryptedValueEvent._();

  factory ReasoningEncryptedValueEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReasoningEncryptedValueEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReasoningEncryptedValueEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'subagentRunId')
    ..aOS(3, _omitFieldNames ? '' : 'subtype')
    ..aOS(4, _omitFieldNames ? '' : 'entityId')
    ..aOS(5, _omitFieldNames ? '' : 'encryptedValue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReasoningEncryptedValueEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReasoningEncryptedValueEvent copyWith(
          void Function(ReasoningEncryptedValueEvent) updates) =>
      super.copyWith(
              (message) => updates(message as ReasoningEncryptedValueEvent))
          as ReasoningEncryptedValueEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReasoningEncryptedValueEvent create() =>
      ReasoningEncryptedValueEvent._();
  @$core.override
  ReasoningEncryptedValueEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReasoningEncryptedValueEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReasoningEncryptedValueEvent>(create);
  static ReasoningEncryptedValueEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(2)
  $core.String get subagentRunId => $_getSZ(1);
  @$pb.TagNumber(2)
  set subagentRunId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubagentRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubagentRunId() => $_clearField(2);

  /// What kind of thing entityId names, which decides where the value is stored.
  @$pb.TagNumber(3)
  $core.String get subtype => $_getSZ(2);
  @$pb.TagNumber(3)
  set subtype($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubtype() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubtype() => $_clearField(3);

  /// What the value belongs to: a message id or a tool call id, according to
  /// subtype.
  @$pb.TagNumber(4)
  $core.String get entityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set entityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEntityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearEntityId() => $_clearField(4);

  /// The provider's opaque artefact.
  @$pb.TagNumber(5)
  $core.String get encryptedValue => $_getSZ(4);
  @$pb.TagNumber(5)
  set encryptedValue($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEncryptedValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearEncryptedValue() => $_clearField(5);
}

/// Announces that a subagent invocation has begun. Everything the subagent
/// produces afterwards is attributed by carrying its subagentRunId, so a consumer
/// can group the work without replaying the stream. Composed from BaseEvent alone
/// rather than Attributable, because here subagentRunId identifies the subagent
/// rather than attributing the event to one; attribution to an enclosing subagent
/// is parentSubagentRunId.
class SubagentStartedEvent extends $pb.GeneratedMessage {
  factory SubagentStartedEvent({
    BaseEvent? baseEvent,
    $core.String? subagentRunId,
    $core.String? name,
    $core.String? description,
    $core.String? parentSubagentRunId,
    $core.String? parentToolCallId,
    $core.String? parentMessageId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (parentSubagentRunId != null)
      result.parentSubagentRunId = parentSubagentRunId;
    if (parentToolCallId != null) result.parentToolCallId = parentToolCallId;
    if (parentMessageId != null) result.parentMessageId = parentMessageId;
    return result;
  }

  SubagentStartedEvent._();

  factory SubagentStartedEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubagentStartedEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubagentStartedEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'subagentRunId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'parentSubagentRunId')
    ..aOS(6, _omitFieldNames ? '' : 'parentToolCallId')
    ..aOS(7, _omitFieldNames ? '' : 'parentMessageId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentStartedEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentStartedEvent copyWith(void Function(SubagentStartedEvent) updates) =>
      super.copyWith((message) => updates(message as SubagentStartedEvent))
          as SubagentStartedEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubagentStartedEvent create() => SubagentStartedEvent._();
  @$core.override
  SubagentStartedEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubagentStartedEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubagentStartedEvent>(create);
  static SubagentStartedEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The invocation being announced.
  @$pb.TagNumber(2)
  $core.String get subagentRunId => $_getSZ(1);
  @$pb.TagNumber(2)
  set subagentRunId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubagentRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubagentRunId() => $_clearField(2);

  /// The subagent's name, which is reusable across invocations, unlike
  /// subagentRunId.
  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  /// What this subagent is for, for a consumer to display.
  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  /// The subagent invocation that spawned this one, for nested delegation. Absent
  /// means the parent agent spawned it directly.
  @$pb.TagNumber(5)
  $core.String get parentSubagentRunId => $_getSZ(4);
  @$pb.TagNumber(5)
  set parentSubagentRunId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasParentSubagentRunId() => $_has(4);
  @$pb.TagNumber(5)
  void clearParentSubagentRunId() => $_clearField(5);

  /// The tool call that spawned this subagent, for the pattern where agents are
  /// exposed to a model as tools. Lets a consumer tie the subagent to the call
  /// without reading rawEvent.
  @$pb.TagNumber(6)
  $core.String get parentToolCallId => $_getSZ(5);
  @$pb.TagNumber(6)
  set parentToolCallId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasParentToolCallId() => $_has(5);
  @$pb.TagNumber(6)
  void clearParentToolCallId() => $_clearField(6);

  /// The message that held the spawning tool call.
  @$pb.TagNumber(7)
  $core.String get parentMessageId => $_getSZ(6);
  @$pb.TagNumber(7)
  set parentMessageId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasParentMessageId() => $_has(6);
  @$pb.TagNumber(7)
  void clearParentMessageId() => $_clearField(7);
}

/// Ends a subagent invocation's segment of this run, either because the work
/// completed or because it is suspended awaiting outside input.
class SubagentFinishedEvent extends $pb.GeneratedMessage {
  factory SubagentFinishedEvent({
    BaseEvent? baseEvent,
    $core.String? subagentRunId,
    $0.Value? result,
    $core.String? outcome,
    $core.Iterable<$core.String>? interruptIds,
  }) {
    final result$ = create();
    if (baseEvent != null) result$.baseEvent = baseEvent;
    if (subagentRunId != null) result$.subagentRunId = subagentRunId;
    if (result != null) result$.result = result;
    if (outcome != null) result$.outcome = outcome;
    if (interruptIds != null) result$.interruptIds.addAll(interruptIds);
    return result$;
  }

  SubagentFinishedEvent._();

  factory SubagentFinishedEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubagentFinishedEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubagentFinishedEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'subagentRunId')
    ..aOM<$0.Value>(3, _omitFieldNames ? '' : 'result',
        subBuilder: $0.Value.create)
    ..aOS(4, _omitFieldNames ? '' : 'outcome')
    ..pPS(5, _omitFieldNames ? '' : 'interruptIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentFinishedEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentFinishedEvent copyWith(
          void Function(SubagentFinishedEvent) updates) =>
      super.copyWith((message) => updates(message as SubagentFinishedEvent))
          as SubagentFinishedEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubagentFinishedEvent create() => SubagentFinishedEvent._();
  @$core.override
  SubagentFinishedEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubagentFinishedEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubagentFinishedEvent>(create);
  static SubagentFinishedEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The invocation being closed.
  @$pb.TagNumber(2)
  $core.String get subagentRunId => $_getSZ(1);
  @$pb.TagNumber(2)
  set subagentRunId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubagentRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubagentRunId() => $_clearField(2);

  /// The subagent's return value, if it has one. Any JSON value, mirroring
  /// RUN_FINISHED.result.
  @$pb.TagNumber(3)
  $0.Value get result => $_getN(2);
  @$pb.TagNumber(3)
  set result($0.Value value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasResult() => $_has(2);
  @$pb.TagNumber(3)
  void clearResult() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Value ensureResult() => $_ensure(2);

  /// Why the segment ended. Absent means success. A suspended subagent is neither
  /// a success nor a failure, which is why saying so needs its own value rather
  /// than being inferred from a later interrupt.
  @$pb.TagNumber(4)
  $core.String get outcome => $_getSZ(3);
  @$pb.TagNumber(4)
  set outcome($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOutcome() => $_has(3);
  @$pb.TagNumber(4)
  void clearOutcome() => $_clearField(4);

  /// The run-level interrupts this subagent raised itself. May be empty or
  /// absent: a subagent suspended because a descendant interrupted owns no
  /// interrupt of its own.
  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get interruptIds => $_getList(4);
}

/// Reports that a subagent invocation failed. The run may continue: a parent
/// agent is free to handle a failed subagent, which is why this is not RUN_ERROR.
class SubagentErrorEvent extends $pb.GeneratedMessage {
  factory SubagentErrorEvent({
    BaseEvent? baseEvent,
    $core.String? subagentRunId,
    $core.String? message,
    $core.String? code,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    if (message != null) result.message = message;
    if (code != null) result.code = code;
    return result;
  }

  SubagentErrorEvent._();

  factory SubagentErrorEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubagentErrorEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubagentErrorEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<BaseEvent>(1, _omitFieldNames ? '' : 'baseEvent',
        subBuilder: BaseEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'subagentRunId')
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..aOS(4, _omitFieldNames ? '' : 'code')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentErrorEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubagentErrorEvent copyWith(void Function(SubagentErrorEvent) updates) =>
      super.copyWith((message) => updates(message as SubagentErrorEvent))
          as SubagentErrorEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubagentErrorEvent create() => SubagentErrorEvent._();
  @$core.override
  SubagentErrorEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubagentErrorEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubagentErrorEvent>(create);
  static SubagentErrorEvent? _defaultInstance;

  /// The fields every event carries.
  @$pb.TagNumber(1)
  BaseEvent get baseEvent => $_getN(0);
  @$pb.TagNumber(1)
  set baseEvent(BaseEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  BaseEvent ensureBaseEvent() => $_ensure(0);

  /// The invocation that failed.
  @$pb.TagNumber(2)
  $core.String get subagentRunId => $_getSZ(1);
  @$pb.TagNumber(2)
  set subagentRunId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubagentRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubagentRunId() => $_clearField(2);

  /// What went wrong, for a person to read.
  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);

  /// A machine-readable error code. An open string.
  @$pb.TagNumber(4)
  $core.String get code => $_getSZ(3);
  @$pb.TagNumber(4)
  set code($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearCode() => $_clearField(4);
}

enum Event_Event {
  textMessageStart,
  textMessageContent,
  textMessageEnd,
  toolCallStart,
  toolCallArgs,
  toolCallEnd,
  stateSnapshot,
  stateDelta,
  messagesSnapshot,
  raw,
  custom,
  runStarted,
  runFinished,
  runError,
  stepStarted,
  stepFinished,
  textMessageChunk,
  toolCallChunk,
  subagentStarted,
  subagentFinished,
  subagentError,
  toolCallResult,
  activitySnapshot,
  activityDelta,
  reasoningStart,
  reasoningMessageStart,
  reasoningMessageContent,
  reasoningMessageEnd,
  reasoningMessageChunk,
  reasoningEnd,
  reasoningEncryptedValue,
  notSet
}

/// Any AG-UI event. Every member is normative: there is no optional tier and no
/// event a consumer may decline to implement. Discriminated by the type property.
class Event extends $pb.GeneratedMessage {
  factory Event({
    TextMessageStartEvent? textMessageStart,
    TextMessageContentEvent? textMessageContent,
    TextMessageEndEvent? textMessageEnd,
    ToolCallStartEvent? toolCallStart,
    ToolCallArgsEvent? toolCallArgs,
    ToolCallEndEvent? toolCallEnd,
    StateSnapshotEvent? stateSnapshot,
    StateDeltaEvent? stateDelta,
    MessagesSnapshotEvent? messagesSnapshot,
    RawEvent? raw,
    CustomEvent? custom,
    RunStartedEvent? runStarted,
    RunFinishedEvent? runFinished,
    RunErrorEvent? runError,
    StepStartedEvent? stepStarted,
    StepFinishedEvent? stepFinished,
    TextMessageChunkEvent? textMessageChunk,
    ToolCallChunkEvent? toolCallChunk,
    SubagentStartedEvent? subagentStarted,
    SubagentFinishedEvent? subagentFinished,
    SubagentErrorEvent? subagentError,
    ToolCallResultEvent? toolCallResult,
    ActivitySnapshotEvent? activitySnapshot,
    ActivityDeltaEvent? activityDelta,
    ReasoningStartEvent? reasoningStart,
    ReasoningMessageStartEvent? reasoningMessageStart,
    ReasoningMessageContentEvent? reasoningMessageContent,
    ReasoningMessageEndEvent? reasoningMessageEnd,
    ReasoningMessageChunkEvent? reasoningMessageChunk,
    ReasoningEndEvent? reasoningEnd,
    ReasoningEncryptedValueEvent? reasoningEncryptedValue,
  }) {
    final result = create();
    if (textMessageStart != null) result.textMessageStart = textMessageStart;
    if (textMessageContent != null)
      result.textMessageContent = textMessageContent;
    if (textMessageEnd != null) result.textMessageEnd = textMessageEnd;
    if (toolCallStart != null) result.toolCallStart = toolCallStart;
    if (toolCallArgs != null) result.toolCallArgs = toolCallArgs;
    if (toolCallEnd != null) result.toolCallEnd = toolCallEnd;
    if (stateSnapshot != null) result.stateSnapshot = stateSnapshot;
    if (stateDelta != null) result.stateDelta = stateDelta;
    if (messagesSnapshot != null) result.messagesSnapshot = messagesSnapshot;
    if (raw != null) result.raw = raw;
    if (custom != null) result.custom = custom;
    if (runStarted != null) result.runStarted = runStarted;
    if (runFinished != null) result.runFinished = runFinished;
    if (runError != null) result.runError = runError;
    if (stepStarted != null) result.stepStarted = stepStarted;
    if (stepFinished != null) result.stepFinished = stepFinished;
    if (textMessageChunk != null) result.textMessageChunk = textMessageChunk;
    if (toolCallChunk != null) result.toolCallChunk = toolCallChunk;
    if (subagentStarted != null) result.subagentStarted = subagentStarted;
    if (subagentFinished != null) result.subagentFinished = subagentFinished;
    if (subagentError != null) result.subagentError = subagentError;
    if (toolCallResult != null) result.toolCallResult = toolCallResult;
    if (activitySnapshot != null) result.activitySnapshot = activitySnapshot;
    if (activityDelta != null) result.activityDelta = activityDelta;
    if (reasoningStart != null) result.reasoningStart = reasoningStart;
    if (reasoningMessageStart != null)
      result.reasoningMessageStart = reasoningMessageStart;
    if (reasoningMessageContent != null)
      result.reasoningMessageContent = reasoningMessageContent;
    if (reasoningMessageEnd != null)
      result.reasoningMessageEnd = reasoningMessageEnd;
    if (reasoningMessageChunk != null)
      result.reasoningMessageChunk = reasoningMessageChunk;
    if (reasoningEnd != null) result.reasoningEnd = reasoningEnd;
    if (reasoningEncryptedValue != null)
      result.reasoningEncryptedValue = reasoningEncryptedValue;
    return result;
  }

  Event._();

  factory Event.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Event.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Event_Event> _Event_EventByTag = {
    1: Event_Event.textMessageStart,
    2: Event_Event.textMessageContent,
    3: Event_Event.textMessageEnd,
    4: Event_Event.toolCallStart,
    5: Event_Event.toolCallArgs,
    6: Event_Event.toolCallEnd,
    7: Event_Event.stateSnapshot,
    8: Event_Event.stateDelta,
    9: Event_Event.messagesSnapshot,
    10: Event_Event.raw,
    11: Event_Event.custom,
    12: Event_Event.runStarted,
    13: Event_Event.runFinished,
    14: Event_Event.runError,
    15: Event_Event.stepStarted,
    16: Event_Event.stepFinished,
    17: Event_Event.textMessageChunk,
    18: Event_Event.toolCallChunk,
    19: Event_Event.subagentStarted,
    20: Event_Event.subagentFinished,
    21: Event_Event.subagentError,
    22: Event_Event.toolCallResult,
    23: Event_Event.activitySnapshot,
    24: Event_Event.activityDelta,
    25: Event_Event.reasoningStart,
    26: Event_Event.reasoningMessageStart,
    27: Event_Event.reasoningMessageContent,
    28: Event_Event.reasoningMessageEnd,
    29: Event_Event.reasoningMessageChunk,
    30: Event_Event.reasoningEnd,
    31: Event_Event.reasoningEncryptedValue,
    0: Event_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Event',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..oo(0, [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29,
      30,
      31
    ])
    ..aOM<TextMessageStartEvent>(1, _omitFieldNames ? '' : 'textMessageStart',
        subBuilder: TextMessageStartEvent.create)
    ..aOM<TextMessageContentEvent>(
        2, _omitFieldNames ? '' : 'textMessageContent',
        subBuilder: TextMessageContentEvent.create)
    ..aOM<TextMessageEndEvent>(3, _omitFieldNames ? '' : 'textMessageEnd',
        subBuilder: TextMessageEndEvent.create)
    ..aOM<ToolCallStartEvent>(4, _omitFieldNames ? '' : 'toolCallStart',
        subBuilder: ToolCallStartEvent.create)
    ..aOM<ToolCallArgsEvent>(5, _omitFieldNames ? '' : 'toolCallArgs',
        subBuilder: ToolCallArgsEvent.create)
    ..aOM<ToolCallEndEvent>(6, _omitFieldNames ? '' : 'toolCallEnd',
        subBuilder: ToolCallEndEvent.create)
    ..aOM<StateSnapshotEvent>(7, _omitFieldNames ? '' : 'stateSnapshot',
        subBuilder: StateSnapshotEvent.create)
    ..aOM<StateDeltaEvent>(8, _omitFieldNames ? '' : 'stateDelta',
        subBuilder: StateDeltaEvent.create)
    ..aOM<MessagesSnapshotEvent>(9, _omitFieldNames ? '' : 'messagesSnapshot',
        subBuilder: MessagesSnapshotEvent.create)
    ..aOM<RawEvent>(10, _omitFieldNames ? '' : 'raw',
        subBuilder: RawEvent.create)
    ..aOM<CustomEvent>(11, _omitFieldNames ? '' : 'custom',
        subBuilder: CustomEvent.create)
    ..aOM<RunStartedEvent>(12, _omitFieldNames ? '' : 'runStarted',
        subBuilder: RunStartedEvent.create)
    ..aOM<RunFinishedEvent>(13, _omitFieldNames ? '' : 'runFinished',
        subBuilder: RunFinishedEvent.create)
    ..aOM<RunErrorEvent>(14, _omitFieldNames ? '' : 'runError',
        subBuilder: RunErrorEvent.create)
    ..aOM<StepStartedEvent>(15, _omitFieldNames ? '' : 'stepStarted',
        subBuilder: StepStartedEvent.create)
    ..aOM<StepFinishedEvent>(16, _omitFieldNames ? '' : 'stepFinished',
        subBuilder: StepFinishedEvent.create)
    ..aOM<TextMessageChunkEvent>(17, _omitFieldNames ? '' : 'textMessageChunk',
        subBuilder: TextMessageChunkEvent.create)
    ..aOM<ToolCallChunkEvent>(18, _omitFieldNames ? '' : 'toolCallChunk',
        subBuilder: ToolCallChunkEvent.create)
    ..aOM<SubagentStartedEvent>(19, _omitFieldNames ? '' : 'subagentStarted',
        subBuilder: SubagentStartedEvent.create)
    ..aOM<SubagentFinishedEvent>(20, _omitFieldNames ? '' : 'subagentFinished',
        subBuilder: SubagentFinishedEvent.create)
    ..aOM<SubagentErrorEvent>(21, _omitFieldNames ? '' : 'subagentError',
        subBuilder: SubagentErrorEvent.create)
    ..aOM<ToolCallResultEvent>(22, _omitFieldNames ? '' : 'toolCallResult',
        subBuilder: ToolCallResultEvent.create)
    ..aOM<ActivitySnapshotEvent>(23, _omitFieldNames ? '' : 'activitySnapshot',
        subBuilder: ActivitySnapshotEvent.create)
    ..aOM<ActivityDeltaEvent>(24, _omitFieldNames ? '' : 'activityDelta',
        subBuilder: ActivityDeltaEvent.create)
    ..aOM<ReasoningStartEvent>(25, _omitFieldNames ? '' : 'reasoningStart',
        subBuilder: ReasoningStartEvent.create)
    ..aOM<ReasoningMessageStartEvent>(
        26, _omitFieldNames ? '' : 'reasoningMessageStart',
        subBuilder: ReasoningMessageStartEvent.create)
    ..aOM<ReasoningMessageContentEvent>(
        27, _omitFieldNames ? '' : 'reasoningMessageContent',
        subBuilder: ReasoningMessageContentEvent.create)
    ..aOM<ReasoningMessageEndEvent>(
        28, _omitFieldNames ? '' : 'reasoningMessageEnd',
        subBuilder: ReasoningMessageEndEvent.create)
    ..aOM<ReasoningMessageChunkEvent>(
        29, _omitFieldNames ? '' : 'reasoningMessageChunk',
        subBuilder: ReasoningMessageChunkEvent.create)
    ..aOM<ReasoningEndEvent>(30, _omitFieldNames ? '' : 'reasoningEnd',
        subBuilder: ReasoningEndEvent.create)
    ..aOM<ReasoningEncryptedValueEvent>(
        31, _omitFieldNames ? '' : 'reasoningEncryptedValue',
        subBuilder: ReasoningEncryptedValueEvent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Event clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Event copyWith(void Function(Event) updates) =>
      super.copyWith((message) => updates(message as Event)) as Event;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Event create() => Event._();
  @$core.override
  Event createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Event getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Event>(create);
  static Event? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(26)
  @$pb.TagNumber(27)
  @$pb.TagNumber(28)
  @$pb.TagNumber(29)
  @$pb.TagNumber(30)
  @$pb.TagNumber(31)
  Event_Event whichEvent() => _Event_EventByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(26)
  @$pb.TagNumber(27)
  @$pb.TagNumber(28)
  @$pb.TagNumber(29)
  @$pb.TagNumber(30)
  @$pb.TagNumber(31)
  void clearEvent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  TextMessageStartEvent get textMessageStart => $_getN(0);
  @$pb.TagNumber(1)
  set textMessageStart(TextMessageStartEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTextMessageStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearTextMessageStart() => $_clearField(1);
  @$pb.TagNumber(1)
  TextMessageStartEvent ensureTextMessageStart() => $_ensure(0);

  @$pb.TagNumber(2)
  TextMessageContentEvent get textMessageContent => $_getN(1);
  @$pb.TagNumber(2)
  set textMessageContent(TextMessageContentEvent value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTextMessageContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearTextMessageContent() => $_clearField(2);
  @$pb.TagNumber(2)
  TextMessageContentEvent ensureTextMessageContent() => $_ensure(1);

  @$pb.TagNumber(3)
  TextMessageEndEvent get textMessageEnd => $_getN(2);
  @$pb.TagNumber(3)
  set textMessageEnd(TextMessageEndEvent value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTextMessageEnd() => $_has(2);
  @$pb.TagNumber(3)
  void clearTextMessageEnd() => $_clearField(3);
  @$pb.TagNumber(3)
  TextMessageEndEvent ensureTextMessageEnd() => $_ensure(2);

  @$pb.TagNumber(4)
  ToolCallStartEvent get toolCallStart => $_getN(3);
  @$pb.TagNumber(4)
  set toolCallStart(ToolCallStartEvent value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasToolCallStart() => $_has(3);
  @$pb.TagNumber(4)
  void clearToolCallStart() => $_clearField(4);
  @$pb.TagNumber(4)
  ToolCallStartEvent ensureToolCallStart() => $_ensure(3);

  @$pb.TagNumber(5)
  ToolCallArgsEvent get toolCallArgs => $_getN(4);
  @$pb.TagNumber(5)
  set toolCallArgs(ToolCallArgsEvent value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasToolCallArgs() => $_has(4);
  @$pb.TagNumber(5)
  void clearToolCallArgs() => $_clearField(5);
  @$pb.TagNumber(5)
  ToolCallArgsEvent ensureToolCallArgs() => $_ensure(4);

  @$pb.TagNumber(6)
  ToolCallEndEvent get toolCallEnd => $_getN(5);
  @$pb.TagNumber(6)
  set toolCallEnd(ToolCallEndEvent value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasToolCallEnd() => $_has(5);
  @$pb.TagNumber(6)
  void clearToolCallEnd() => $_clearField(6);
  @$pb.TagNumber(6)
  ToolCallEndEvent ensureToolCallEnd() => $_ensure(5);

  @$pb.TagNumber(7)
  StateSnapshotEvent get stateSnapshot => $_getN(6);
  @$pb.TagNumber(7)
  set stateSnapshot(StateSnapshotEvent value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStateSnapshot() => $_has(6);
  @$pb.TagNumber(7)
  void clearStateSnapshot() => $_clearField(7);
  @$pb.TagNumber(7)
  StateSnapshotEvent ensureStateSnapshot() => $_ensure(6);

  @$pb.TagNumber(8)
  StateDeltaEvent get stateDelta => $_getN(7);
  @$pb.TagNumber(8)
  set stateDelta(StateDeltaEvent value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStateDelta() => $_has(7);
  @$pb.TagNumber(8)
  void clearStateDelta() => $_clearField(8);
  @$pb.TagNumber(8)
  StateDeltaEvent ensureStateDelta() => $_ensure(7);

  @$pb.TagNumber(9)
  MessagesSnapshotEvent get messagesSnapshot => $_getN(8);
  @$pb.TagNumber(9)
  set messagesSnapshot(MessagesSnapshotEvent value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasMessagesSnapshot() => $_has(8);
  @$pb.TagNumber(9)
  void clearMessagesSnapshot() => $_clearField(9);
  @$pb.TagNumber(9)
  MessagesSnapshotEvent ensureMessagesSnapshot() => $_ensure(8);

  @$pb.TagNumber(10)
  RawEvent get raw => $_getN(9);
  @$pb.TagNumber(10)
  set raw(RawEvent value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasRaw() => $_has(9);
  @$pb.TagNumber(10)
  void clearRaw() => $_clearField(10);
  @$pb.TagNumber(10)
  RawEvent ensureRaw() => $_ensure(9);

  @$pb.TagNumber(11)
  CustomEvent get custom => $_getN(10);
  @$pb.TagNumber(11)
  set custom(CustomEvent value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasCustom() => $_has(10);
  @$pb.TagNumber(11)
  void clearCustom() => $_clearField(11);
  @$pb.TagNumber(11)
  CustomEvent ensureCustom() => $_ensure(10);

  @$pb.TagNumber(12)
  RunStartedEvent get runStarted => $_getN(11);
  @$pb.TagNumber(12)
  set runStarted(RunStartedEvent value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasRunStarted() => $_has(11);
  @$pb.TagNumber(12)
  void clearRunStarted() => $_clearField(12);
  @$pb.TagNumber(12)
  RunStartedEvent ensureRunStarted() => $_ensure(11);

  @$pb.TagNumber(13)
  RunFinishedEvent get runFinished => $_getN(12);
  @$pb.TagNumber(13)
  set runFinished(RunFinishedEvent value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasRunFinished() => $_has(12);
  @$pb.TagNumber(13)
  void clearRunFinished() => $_clearField(13);
  @$pb.TagNumber(13)
  RunFinishedEvent ensureRunFinished() => $_ensure(12);

  @$pb.TagNumber(14)
  RunErrorEvent get runError => $_getN(13);
  @$pb.TagNumber(14)
  set runError(RunErrorEvent value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasRunError() => $_has(13);
  @$pb.TagNumber(14)
  void clearRunError() => $_clearField(14);
  @$pb.TagNumber(14)
  RunErrorEvent ensureRunError() => $_ensure(13);

  @$pb.TagNumber(15)
  StepStartedEvent get stepStarted => $_getN(14);
  @$pb.TagNumber(15)
  set stepStarted(StepStartedEvent value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasStepStarted() => $_has(14);
  @$pb.TagNumber(15)
  void clearStepStarted() => $_clearField(15);
  @$pb.TagNumber(15)
  StepStartedEvent ensureStepStarted() => $_ensure(14);

  @$pb.TagNumber(16)
  StepFinishedEvent get stepFinished => $_getN(15);
  @$pb.TagNumber(16)
  set stepFinished(StepFinishedEvent value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasStepFinished() => $_has(15);
  @$pb.TagNumber(16)
  void clearStepFinished() => $_clearField(16);
  @$pb.TagNumber(16)
  StepFinishedEvent ensureStepFinished() => $_ensure(15);

  @$pb.TagNumber(17)
  TextMessageChunkEvent get textMessageChunk => $_getN(16);
  @$pb.TagNumber(17)
  set textMessageChunk(TextMessageChunkEvent value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasTextMessageChunk() => $_has(16);
  @$pb.TagNumber(17)
  void clearTextMessageChunk() => $_clearField(17);
  @$pb.TagNumber(17)
  TextMessageChunkEvent ensureTextMessageChunk() => $_ensure(16);

  @$pb.TagNumber(18)
  ToolCallChunkEvent get toolCallChunk => $_getN(17);
  @$pb.TagNumber(18)
  set toolCallChunk(ToolCallChunkEvent value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasToolCallChunk() => $_has(17);
  @$pb.TagNumber(18)
  void clearToolCallChunk() => $_clearField(18);
  @$pb.TagNumber(18)
  ToolCallChunkEvent ensureToolCallChunk() => $_ensure(17);

  @$pb.TagNumber(19)
  SubagentStartedEvent get subagentStarted => $_getN(18);
  @$pb.TagNumber(19)
  set subagentStarted(SubagentStartedEvent value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasSubagentStarted() => $_has(18);
  @$pb.TagNumber(19)
  void clearSubagentStarted() => $_clearField(19);
  @$pb.TagNumber(19)
  SubagentStartedEvent ensureSubagentStarted() => $_ensure(18);

  @$pb.TagNumber(20)
  SubagentFinishedEvent get subagentFinished => $_getN(19);
  @$pb.TagNumber(20)
  set subagentFinished(SubagentFinishedEvent value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasSubagentFinished() => $_has(19);
  @$pb.TagNumber(20)
  void clearSubagentFinished() => $_clearField(20);
  @$pb.TagNumber(20)
  SubagentFinishedEvent ensureSubagentFinished() => $_ensure(19);

  @$pb.TagNumber(21)
  SubagentErrorEvent get subagentError => $_getN(20);
  @$pb.TagNumber(21)
  set subagentError(SubagentErrorEvent value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasSubagentError() => $_has(20);
  @$pb.TagNumber(21)
  void clearSubagentError() => $_clearField(21);
  @$pb.TagNumber(21)
  SubagentErrorEvent ensureSubagentError() => $_ensure(20);

  @$pb.TagNumber(22)
  ToolCallResultEvent get toolCallResult => $_getN(21);
  @$pb.TagNumber(22)
  set toolCallResult(ToolCallResultEvent value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasToolCallResult() => $_has(21);
  @$pb.TagNumber(22)
  void clearToolCallResult() => $_clearField(22);
  @$pb.TagNumber(22)
  ToolCallResultEvent ensureToolCallResult() => $_ensure(21);

  @$pb.TagNumber(23)
  ActivitySnapshotEvent get activitySnapshot => $_getN(22);
  @$pb.TagNumber(23)
  set activitySnapshot(ActivitySnapshotEvent value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasActivitySnapshot() => $_has(22);
  @$pb.TagNumber(23)
  void clearActivitySnapshot() => $_clearField(23);
  @$pb.TagNumber(23)
  ActivitySnapshotEvent ensureActivitySnapshot() => $_ensure(22);

  @$pb.TagNumber(24)
  ActivityDeltaEvent get activityDelta => $_getN(23);
  @$pb.TagNumber(24)
  set activityDelta(ActivityDeltaEvent value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasActivityDelta() => $_has(23);
  @$pb.TagNumber(24)
  void clearActivityDelta() => $_clearField(24);
  @$pb.TagNumber(24)
  ActivityDeltaEvent ensureActivityDelta() => $_ensure(23);

  @$pb.TagNumber(25)
  ReasoningStartEvent get reasoningStart => $_getN(24);
  @$pb.TagNumber(25)
  set reasoningStart(ReasoningStartEvent value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasReasoningStart() => $_has(24);
  @$pb.TagNumber(25)
  void clearReasoningStart() => $_clearField(25);
  @$pb.TagNumber(25)
  ReasoningStartEvent ensureReasoningStart() => $_ensure(24);

  @$pb.TagNumber(26)
  ReasoningMessageStartEvent get reasoningMessageStart => $_getN(25);
  @$pb.TagNumber(26)
  set reasoningMessageStart(ReasoningMessageStartEvent value) =>
      $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasReasoningMessageStart() => $_has(25);
  @$pb.TagNumber(26)
  void clearReasoningMessageStart() => $_clearField(26);
  @$pb.TagNumber(26)
  ReasoningMessageStartEvent ensureReasoningMessageStart() => $_ensure(25);

  @$pb.TagNumber(27)
  ReasoningMessageContentEvent get reasoningMessageContent => $_getN(26);
  @$pb.TagNumber(27)
  set reasoningMessageContent(ReasoningMessageContentEvent value) =>
      $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasReasoningMessageContent() => $_has(26);
  @$pb.TagNumber(27)
  void clearReasoningMessageContent() => $_clearField(27);
  @$pb.TagNumber(27)
  ReasoningMessageContentEvent ensureReasoningMessageContent() => $_ensure(26);

  @$pb.TagNumber(28)
  ReasoningMessageEndEvent get reasoningMessageEnd => $_getN(27);
  @$pb.TagNumber(28)
  set reasoningMessageEnd(ReasoningMessageEndEvent value) =>
      $_setField(28, value);
  @$pb.TagNumber(28)
  $core.bool hasReasoningMessageEnd() => $_has(27);
  @$pb.TagNumber(28)
  void clearReasoningMessageEnd() => $_clearField(28);
  @$pb.TagNumber(28)
  ReasoningMessageEndEvent ensureReasoningMessageEnd() => $_ensure(27);

  @$pb.TagNumber(29)
  ReasoningMessageChunkEvent get reasoningMessageChunk => $_getN(28);
  @$pb.TagNumber(29)
  set reasoningMessageChunk(ReasoningMessageChunkEvent value) =>
      $_setField(29, value);
  @$pb.TagNumber(29)
  $core.bool hasReasoningMessageChunk() => $_has(28);
  @$pb.TagNumber(29)
  void clearReasoningMessageChunk() => $_clearField(29);
  @$pb.TagNumber(29)
  ReasoningMessageChunkEvent ensureReasoningMessageChunk() => $_ensure(28);

  @$pb.TagNumber(30)
  ReasoningEndEvent get reasoningEnd => $_getN(29);
  @$pb.TagNumber(30)
  set reasoningEnd(ReasoningEndEvent value) => $_setField(30, value);
  @$pb.TagNumber(30)
  $core.bool hasReasoningEnd() => $_has(29);
  @$pb.TagNumber(30)
  void clearReasoningEnd() => $_clearField(30);
  @$pb.TagNumber(30)
  ReasoningEndEvent ensureReasoningEnd() => $_ensure(29);

  @$pb.TagNumber(31)
  ReasoningEncryptedValueEvent get reasoningEncryptedValue => $_getN(30);
  @$pb.TagNumber(31)
  set reasoningEncryptedValue(ReasoningEncryptedValueEvent value) =>
      $_setField(31, value);
  @$pb.TagNumber(31)
  $core.bool hasReasoningEncryptedValue() => $_has(30);
  @$pb.TagNumber(31)
  void clearReasoningEncryptedValue() => $_clearField(31);
  @$pb.TagNumber(31)
  ReasoningEncryptedValueEvent ensureReasoningEncryptedValue() => $_ensure(30);
}

/// Token counts for one provider and model, in the protocol's own accounting:
/// every count is either a total or a named part of one, so entries from
/// different providers add up without double-counting. inputTokens and
/// outputTokens are the totals; reasoningTokens, cachedInputTokens and
/// cacheWriteInputTokens are parts of them, never additions to them; totalTokens
/// is the two totals summed. Every field is a label or a number — nothing
/// content-bearing or identifying, no prompts, completions, messages, or thread,
/// run and user identifiers.
class Usage extends $pb.GeneratedMessage {
  factory Usage({
    $core.String? provider,
    $core.String? model,
    $fixnum.Int64? inputTokens,
    $fixnum.Int64? outputTokens,
    $fixnum.Int64? totalTokens,
    $fixnum.Int64? reasoningTokens,
    $fixnum.Int64? cachedInputTokens,
    $fixnum.Int64? cacheWriteInputTokens,
  }) {
    final result = create();
    if (provider != null) result.provider = provider;
    if (model != null) result.model = model;
    if (inputTokens != null) result.inputTokens = inputTokens;
    if (outputTokens != null) result.outputTokens = outputTokens;
    if (totalTokens != null) result.totalTokens = totalTokens;
    if (reasoningTokens != null) result.reasoningTokens = reasoningTokens;
    if (cachedInputTokens != null) result.cachedInputTokens = cachedInputTokens;
    if (cacheWriteInputTokens != null)
      result.cacheWriteInputTokens = cacheWriteInputTokens;
    return result;
  }

  Usage._();

  factory Usage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Usage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Usage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'provider')
    ..aOS(2, _omitFieldNames ? '' : 'model')
    ..aInt64(3, _omitFieldNames ? '' : 'inputTokens')
    ..aInt64(4, _omitFieldNames ? '' : 'outputTokens')
    ..aInt64(5, _omitFieldNames ? '' : 'totalTokens')
    ..aInt64(6, _omitFieldNames ? '' : 'reasoningTokens')
    ..aInt64(7, _omitFieldNames ? '' : 'cachedInputTokens')
    ..aInt64(8, _omitFieldNames ? '' : 'cacheWriteInputTokens')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Usage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Usage copyWith(void Function(Usage) updates) =>
      super.copyWith((message) => updates(message as Usage)) as Usage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Usage create() => Usage._();
  @$core.override
  Usage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Usage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Usage>(create);
  static Usage? _defaultInstance;

  /// Which provider served the request.
  @$pb.TagNumber(1)
  $core.String get provider => $_getSZ(0);
  @$pb.TagNumber(1)
  set provider($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProvider() => $_has(0);
  @$pb.TagNumber(1)
  void clearProvider() => $_clearField(1);

  /// Which model served the request.
  @$pb.TagNumber(2)
  $core.String get model => $_getSZ(1);
  @$pb.TagNumber(2)
  set model($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasModel() => $_has(1);
  @$pb.TagNumber(2)
  void clearModel() => $_clearField(2);

  /// Every prompt token the call was charged for: tokens read from a provider
  /// cache, tokens written to one, and audio or other non-text input all count
  /// here. cachedInputTokens and cacheWriteInputTokens break this number down and
  /// are never added to it — a provider that reports its cache counts beside a
  /// smaller input count has them added in by the producer before the entry
  /// leaves. Bounded like timestamp and for the same reason: a count above the
  /// JSON safe-integer range does not survive a round trip, so a consumer would
  /// silently read a different number than the producer wrote.
  @$pb.TagNumber(3)
  $fixnum.Int64 get inputTokens => $_getI64(2);
  @$pb.TagNumber(3)
  set inputTokens($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInputTokens() => $_has(2);
  @$pb.TagNumber(3)
  void clearInputTokens() => $_clearField(3);

  /// Every generated token, reasoning included where the provider distinguishes
  /// it. reasoningTokens breaks this number down and is never added to it — a
  /// provider that reports reasoning tokens beside a smaller completion count has
  /// them added in by the producer.
  @$pb.TagNumber(4)
  $fixnum.Int64 get outputTokens => $_getI64(3);
  @$pb.TagNumber(4)
  set outputTokens($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOutputTokens() => $_has(3);
  @$pb.TagNumber(4)
  void clearOutputTokens() => $_clearField(4);

  /// inputTokens plus outputTokens, under the accounting above. A producer MAY
  /// compute it rather than copy a provider's total, and copies a provider's
  /// total only when that total counts the same way, so a consumer can read this
  /// field as the sum of the other two.
  @$pb.TagNumber(5)
  $fixnum.Int64 get totalTokens => $_getI64(4);
  @$pb.TagNumber(5)
  set totalTokens($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTotalTokens() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalTokens() => $_clearField(5);

  /// Output tokens spent on reasoning, where the provider distinguishes them.
  /// Part of outputTokens, not in addition to it.
  @$pb.TagNumber(6)
  $fixnum.Int64 get reasoningTokens => $_getI64(5);
  @$pb.TagNumber(6)
  set reasoningTokens($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReasoningTokens() => $_has(5);
  @$pb.TagNumber(6)
  void clearReasoningTokens() => $_clearField(6);

  /// Input tokens read from a provider cache. Part of inputTokens, not in
  /// addition to it, and disjoint from cacheWriteInputTokens.
  @$pb.TagNumber(7)
  $fixnum.Int64 get cachedInputTokens => $_getI64(6);
  @$pb.TagNumber(7)
  set cachedInputTokens($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCachedInputTokens() => $_has(6);
  @$pb.TagNumber(7)
  void clearCachedInputTokens() => $_clearField(7);

  /// Input tokens written to a provider cache on this call, where the provider
  /// distinguishes them. Part of inputTokens, not in addition to it, and disjoint
  /// from cachedInputTokens. Its own field because providers price a cache write
  /// differently from a cache read, so a consumer computing cost cannot do
  /// without it.
  @$pb.TagNumber(8)
  $fixnum.Int64 get cacheWriteInputTokens => $_getI64(7);
  @$pb.TagNumber(8)
  set cacheWriteInputTokens($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCacheWriteInputTokens() => $_has(7);
  @$pb.TagNumber(8)
  void clearCacheWriteInputTokens() => $_clearField(8);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
