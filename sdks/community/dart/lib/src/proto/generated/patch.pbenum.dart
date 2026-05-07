// This is a generated file - do not edit.
//
// Generated from patch.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class JsonPatchOperationType extends $pb.ProtobufEnum {
  static const JsonPatchOperationType ADD =
      JsonPatchOperationType._(0, _omitEnumNames ? '' : 'ADD');
  static const JsonPatchOperationType REMOVE =
      JsonPatchOperationType._(1, _omitEnumNames ? '' : 'REMOVE');
  static const JsonPatchOperationType REPLACE =
      JsonPatchOperationType._(2, _omitEnumNames ? '' : 'REPLACE');
  static const JsonPatchOperationType MOVE =
      JsonPatchOperationType._(3, _omitEnumNames ? '' : 'MOVE');
  static const JsonPatchOperationType COPY =
      JsonPatchOperationType._(4, _omitEnumNames ? '' : 'COPY');
  static const JsonPatchOperationType TEST =
      JsonPatchOperationType._(5, _omitEnumNames ? '' : 'TEST');

  static const $core.List<JsonPatchOperationType> values =
      <JsonPatchOperationType>[
    ADD,
    REMOVE,
    REPLACE,
    MOVE,
    COPY,
    TEST,
  ];

  static final $core.List<JsonPatchOperationType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static JsonPatchOperationType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const JsonPatchOperationType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
