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
import 'patch.pb.dart' as $1;
import 'types.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'events.pbenum.dart';

class BaseEvent extends $pb.GeneratedMessage {
  factory BaseEvent({
    EventType? type,
    $fixnum.Int64? timestamp,
    $0.Value? rawEvent,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (timestamp != null) result.timestamp = timestamp;
    if (rawEvent != null) result.rawEvent = rawEvent;
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

  @$pb.TagNumber(1)
  EventType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(EventType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get timestamp => $_getI64(1);
  @$pb.TagNumber(2)
  set timestamp($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => $_clearField(2);

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
}

class TextMessageStartEvent extends $pb.GeneratedMessage {
  factory TextMessageStartEvent({
    BaseEvent? baseEvent,
    $core.String? messageId,
    $core.String? role,
    $core.String? name,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (messageId != null) result.messageId = messageId;
    if (role != null) result.role = role;
    if (name != null) result.name = name;
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

  @$pb.TagNumber(2)
  $core.String get messageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set messageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get role => $_getSZ(2);
  @$pb.TagNumber(3)
  set role($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);
}

class TextMessageContentEvent extends $pb.GeneratedMessage {
  factory TextMessageContentEvent({
    BaseEvent? baseEvent,
    $core.String? messageId,
    $core.String? delta,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (messageId != null) result.messageId = messageId;
    if (delta != null) result.delta = delta;
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

  @$pb.TagNumber(2)
  $core.String get messageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set messageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get delta => $_getSZ(2);
  @$pb.TagNumber(3)
  set delta($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDelta() => $_has(2);
  @$pb.TagNumber(3)
  void clearDelta() => $_clearField(3);
}

class TextMessageEndEvent extends $pb.GeneratedMessage {
  factory TextMessageEndEvent({
    BaseEvent? baseEvent,
    $core.String? messageId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (messageId != null) result.messageId = messageId;
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

  @$pb.TagNumber(2)
  $core.String get messageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set messageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageId() => $_clearField(2);
}

class ToolCallStartEvent extends $pb.GeneratedMessage {
  factory ToolCallStartEvent({
    BaseEvent? baseEvent,
    $core.String? toolCallId,
    $core.String? toolCallName,
    $core.String? parentMessageId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (toolCallId != null) result.toolCallId = toolCallId;
    if (toolCallName != null) result.toolCallName = toolCallName;
    if (parentMessageId != null) result.parentMessageId = parentMessageId;
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

  @$pb.TagNumber(2)
  $core.String get toolCallId => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolCallId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolCallId() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolCallId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get toolCallName => $_getSZ(2);
  @$pb.TagNumber(3)
  set toolCallName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToolCallName() => $_has(2);
  @$pb.TagNumber(3)
  void clearToolCallName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get parentMessageId => $_getSZ(3);
  @$pb.TagNumber(4)
  set parentMessageId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParentMessageId() => $_has(3);
  @$pb.TagNumber(4)
  void clearParentMessageId() => $_clearField(4);
}

class ToolCallArgsEvent extends $pb.GeneratedMessage {
  factory ToolCallArgsEvent({
    BaseEvent? baseEvent,
    $core.String? toolCallId,
    $core.String? delta,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (toolCallId != null) result.toolCallId = toolCallId;
    if (delta != null) result.delta = delta;
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

  @$pb.TagNumber(2)
  $core.String get toolCallId => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolCallId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolCallId() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolCallId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get delta => $_getSZ(2);
  @$pb.TagNumber(3)
  set delta($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDelta() => $_has(2);
  @$pb.TagNumber(3)
  void clearDelta() => $_clearField(3);
}

class ToolCallEndEvent extends $pb.GeneratedMessage {
  factory ToolCallEndEvent({
    BaseEvent? baseEvent,
    $core.String? toolCallId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (toolCallId != null) result.toolCallId = toolCallId;
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

  @$pb.TagNumber(2)
  $core.String get toolCallId => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolCallId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolCallId() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolCallId() => $_clearField(2);
}

class StateSnapshotEvent extends $pb.GeneratedMessage {
  factory StateSnapshotEvent({
    BaseEvent? baseEvent,
    $0.Value? snapshot,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (snapshot != null) result.snapshot = snapshot;
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
}

class StateDeltaEvent extends $pb.GeneratedMessage {
  factory StateDeltaEvent({
    BaseEvent? baseEvent,
    $core.Iterable<$1.JsonPatchOperation>? delta,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (delta != null) result.delta.addAll(delta);
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
    ..pPM<$1.JsonPatchOperation>(2, _omitFieldNames ? '' : 'delta',
        subBuilder: $1.JsonPatchOperation.create)
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

  @$pb.TagNumber(2)
  $pb.PbList<$1.JsonPatchOperation> get delta => $_getList(1);
}

class MessagesSnapshotEvent extends $pb.GeneratedMessage {
  factory MessagesSnapshotEvent({
    BaseEvent? baseEvent,
    $core.Iterable<$2.Message>? messages,
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
    ..pPM<$2.Message>(2, _omitFieldNames ? '' : 'messages',
        subBuilder: $2.Message.create)
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

  @$pb.TagNumber(2)
  $pb.PbList<$2.Message> get messages => $_getList(1);
}

class RawEvent extends $pb.GeneratedMessage {
  factory RawEvent({
    BaseEvent? baseEvent,
    $0.Value? event,
    $core.String? source,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (event != null) result.event = event;
    if (source != null) result.source = source;
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

  @$pb.TagNumber(3)
  $core.String get source => $_getSZ(2);
  @$pb.TagNumber(3)
  set source($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSource() => $_has(2);
  @$pb.TagNumber(3)
  void clearSource() => $_clearField(3);
}

class CustomEvent extends $pb.GeneratedMessage {
  factory CustomEvent({
    BaseEvent? baseEvent,
    $core.String? name,
    $0.Value? value,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (name != null) result.name = name;
    if (value != null) result.value = value;
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

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

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
}

class RunStartedEvent extends $pb.GeneratedMessage {
  factory RunStartedEvent({
    BaseEvent? baseEvent,
    $core.String? threadId,
    $core.String? runId,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (threadId != null) result.threadId = threadId;
    if (runId != null) result.runId = runId;
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

  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get runId => $_getSZ(2);
  @$pb.TagNumber(3)
  set runId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRunId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRunId() => $_clearField(3);
}

class RunFinishedEvent extends $pb.GeneratedMessage {
  factory RunFinishedEvent({
    BaseEvent? baseEvent,
    $core.String? threadId,
    $core.String? runId,
    $0.Value? result,
    $core.String? outcome,
    $core.Iterable<$2.Interrupt>? interrupts,
  }) {
    final result$ = create();
    if (baseEvent != null) result$.baseEvent = baseEvent;
    if (threadId != null) result$.threadId = threadId;
    if (runId != null) result$.runId = runId;
    if (result != null) result$.result = result;
    if (outcome != null) result$.outcome = outcome;
    if (interrupts != null) result$.interrupts.addAll(interrupts);
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
    ..pPM<$2.Interrupt>(6, _omitFieldNames ? '' : 'interrupts',
        subBuilder: $2.Interrupt.create)
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

  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get runId => $_getSZ(2);
  @$pb.TagNumber(3)
  set runId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRunId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRunId() => $_clearField(3);

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

  @$pb.TagNumber(5)
  $core.String get outcome => $_getSZ(4);
  @$pb.TagNumber(5)
  set outcome($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOutcome() => $_has(4);
  @$pb.TagNumber(5)
  void clearOutcome() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$2.Interrupt> get interrupts => $_getList(5);
}

class RunErrorEvent extends $pb.GeneratedMessage {
  factory RunErrorEvent({
    BaseEvent? baseEvent,
    $core.String? code,
    $core.String? message,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (code != null) result.code = code;
    if (message != null) result.message = message;
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

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);
}

class StepStartedEvent extends $pb.GeneratedMessage {
  factory StepStartedEvent({
    BaseEvent? baseEvent,
    $core.String? stepName,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (stepName != null) result.stepName = stepName;
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

  @$pb.TagNumber(2)
  $core.String get stepName => $_getSZ(1);
  @$pb.TagNumber(2)
  set stepName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStepName() => $_has(1);
  @$pb.TagNumber(2)
  void clearStepName() => $_clearField(2);
}

class StepFinishedEvent extends $pb.GeneratedMessage {
  factory StepFinishedEvent({
    BaseEvent? baseEvent,
    $core.String? stepName,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (stepName != null) result.stepName = stepName;
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

  @$pb.TagNumber(2)
  $core.String get stepName => $_getSZ(1);
  @$pb.TagNumber(2)
  set stepName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStepName() => $_has(1);
  @$pb.TagNumber(2)
  void clearStepName() => $_clearField(2);
}

class TextMessageChunkEvent extends $pb.GeneratedMessage {
  factory TextMessageChunkEvent({
    BaseEvent? baseEvent,
    $core.String? messageId,
    $core.String? role,
    $core.String? delta,
    $core.String? name,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (messageId != null) result.messageId = messageId;
    if (role != null) result.role = role;
    if (delta != null) result.delta = delta;
    if (name != null) result.name = name;
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

  @$pb.TagNumber(2)
  $core.String get messageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set messageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get role => $_getSZ(2);
  @$pb.TagNumber(3)
  set role($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get delta => $_getSZ(3);
  @$pb.TagNumber(4)
  set delta($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDelta() => $_has(3);
  @$pb.TagNumber(4)
  void clearDelta() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get name => $_getSZ(4);
  @$pb.TagNumber(5)
  set name($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasName() => $_has(4);
  @$pb.TagNumber(5)
  void clearName() => $_clearField(5);
}

class ToolCallChunkEvent extends $pb.GeneratedMessage {
  factory ToolCallChunkEvent({
    BaseEvent? baseEvent,
    $core.String? toolCallId,
    $core.String? toolCallName,
    $core.String? parentMessageId,
    $core.String? delta,
  }) {
    final result = create();
    if (baseEvent != null) result.baseEvent = baseEvent;
    if (toolCallId != null) result.toolCallId = toolCallId;
    if (toolCallName != null) result.toolCallName = toolCallName;
    if (parentMessageId != null) result.parentMessageId = parentMessageId;
    if (delta != null) result.delta = delta;
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

  @$pb.TagNumber(2)
  $core.String get toolCallId => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolCallId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToolCallId() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolCallId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get toolCallName => $_getSZ(2);
  @$pb.TagNumber(3)
  set toolCallName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToolCallName() => $_has(2);
  @$pb.TagNumber(3)
  void clearToolCallName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get parentMessageId => $_getSZ(3);
  @$pb.TagNumber(4)
  set parentMessageId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParentMessageId() => $_has(3);
  @$pb.TagNumber(4)
  void clearParentMessageId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get delta => $_getSZ(4);
  @$pb.TagNumber(5)
  set delta($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDelta() => $_has(4);
  @$pb.TagNumber(5)
  void clearDelta() => $_clearField(5);
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
  notSet
}

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
    0: Event_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Event',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18])
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
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
