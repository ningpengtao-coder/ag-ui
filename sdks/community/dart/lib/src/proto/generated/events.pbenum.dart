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

import 'package:protobuf/protobuf.dart' as $pb;

/// The discriminator carried by every event.
class EventType extends $pb.ProtobufEnum {
  static const EventType TEXT_MESSAGE_START =
      EventType._(0, _omitEnumNames ? '' : 'TEXT_MESSAGE_START');
  static const EventType TEXT_MESSAGE_CONTENT =
      EventType._(1, _omitEnumNames ? '' : 'TEXT_MESSAGE_CONTENT');
  static const EventType TEXT_MESSAGE_END =
      EventType._(2, _omitEnumNames ? '' : 'TEXT_MESSAGE_END');
  static const EventType TOOL_CALL_START =
      EventType._(3, _omitEnumNames ? '' : 'TOOL_CALL_START');
  static const EventType TOOL_CALL_ARGS =
      EventType._(4, _omitEnumNames ? '' : 'TOOL_CALL_ARGS');
  static const EventType TOOL_CALL_END =
      EventType._(5, _omitEnumNames ? '' : 'TOOL_CALL_END');
  static const EventType STATE_SNAPSHOT =
      EventType._(6, _omitEnumNames ? '' : 'STATE_SNAPSHOT');
  static const EventType STATE_DELTA =
      EventType._(7, _omitEnumNames ? '' : 'STATE_DELTA');
  static const EventType MESSAGES_SNAPSHOT =
      EventType._(8, _omitEnumNames ? '' : 'MESSAGES_SNAPSHOT');
  static const EventType RAW = EventType._(9, _omitEnumNames ? '' : 'RAW');
  static const EventType CUSTOM =
      EventType._(10, _omitEnumNames ? '' : 'CUSTOM');
  static const EventType RUN_STARTED =
      EventType._(11, _omitEnumNames ? '' : 'RUN_STARTED');
  static const EventType RUN_FINISHED =
      EventType._(12, _omitEnumNames ? '' : 'RUN_FINISHED');
  static const EventType RUN_ERROR =
      EventType._(13, _omitEnumNames ? '' : 'RUN_ERROR');
  static const EventType STEP_STARTED =
      EventType._(14, _omitEnumNames ? '' : 'STEP_STARTED');
  static const EventType STEP_FINISHED =
      EventType._(15, _omitEnumNames ? '' : 'STEP_FINISHED');
  static const EventType SUBAGENT_STARTED =
      EventType._(16, _omitEnumNames ? '' : 'SUBAGENT_STARTED');
  static const EventType SUBAGENT_FINISHED =
      EventType._(17, _omitEnumNames ? '' : 'SUBAGENT_FINISHED');
  static const EventType SUBAGENT_ERROR =
      EventType._(18, _omitEnumNames ? '' : 'SUBAGENT_ERROR');
  static const EventType TEXT_MESSAGE_CHUNK =
      EventType._(19, _omitEnumNames ? '' : 'TEXT_MESSAGE_CHUNK');
  static const EventType TOOL_CALL_CHUNK =
      EventType._(20, _omitEnumNames ? '' : 'TOOL_CALL_CHUNK');
  static const EventType TOOL_CALL_RESULT =
      EventType._(21, _omitEnumNames ? '' : 'TOOL_CALL_RESULT');
  static const EventType ACTIVITY_SNAPSHOT =
      EventType._(22, _omitEnumNames ? '' : 'ACTIVITY_SNAPSHOT');
  static const EventType ACTIVITY_DELTA =
      EventType._(23, _omitEnumNames ? '' : 'ACTIVITY_DELTA');
  static const EventType REASONING_START =
      EventType._(24, _omitEnumNames ? '' : 'REASONING_START');
  static const EventType REASONING_MESSAGE_START =
      EventType._(25, _omitEnumNames ? '' : 'REASONING_MESSAGE_START');
  static const EventType REASONING_MESSAGE_CONTENT =
      EventType._(26, _omitEnumNames ? '' : 'REASONING_MESSAGE_CONTENT');
  static const EventType REASONING_MESSAGE_END =
      EventType._(27, _omitEnumNames ? '' : 'REASONING_MESSAGE_END');
  static const EventType REASONING_MESSAGE_CHUNK =
      EventType._(28, _omitEnumNames ? '' : 'REASONING_MESSAGE_CHUNK');
  static const EventType REASONING_END =
      EventType._(29, _omitEnumNames ? '' : 'REASONING_END');
  static const EventType REASONING_ENCRYPTED_VALUE =
      EventType._(30, _omitEnumNames ? '' : 'REASONING_ENCRYPTED_VALUE');

  static const $core.List<EventType> values = <EventType>[
    TEXT_MESSAGE_START,
    TEXT_MESSAGE_CONTENT,
    TEXT_MESSAGE_END,
    TOOL_CALL_START,
    TOOL_CALL_ARGS,
    TOOL_CALL_END,
    STATE_SNAPSHOT,
    STATE_DELTA,
    MESSAGES_SNAPSHOT,
    RAW,
    CUSTOM,
    RUN_STARTED,
    RUN_FINISHED,
    RUN_ERROR,
    STEP_STARTED,
    STEP_FINISHED,
    SUBAGENT_STARTED,
    SUBAGENT_FINISHED,
    SUBAGENT_ERROR,
    TEXT_MESSAGE_CHUNK,
    TOOL_CALL_CHUNK,
    TOOL_CALL_RESULT,
    ACTIVITY_SNAPSHOT,
    ACTIVITY_DELTA,
    REASONING_START,
    REASONING_MESSAGE_START,
    REASONING_MESSAGE_CONTENT,
    REASONING_MESSAGE_END,
    REASONING_MESSAGE_CHUNK,
    REASONING_END,
    REASONING_ENCRYPTED_VALUE,
  ];

  static final $core.List<EventType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 30);
  static EventType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EventType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
