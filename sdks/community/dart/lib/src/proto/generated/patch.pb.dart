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
import 'package:protobuf/well_known_types/google/protobuf/struct.pb.dart' as $0;

import 'patch.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'patch.pbenum.dart';

class JsonPatchOperation extends $pb.GeneratedMessage {
  factory JsonPatchOperation({
    JsonPatchOperationType? op,
    $core.String? path,
    $core.String? from,
    $0.Value? value,
  }) {
    final result = create();
    if (op != null) result.op = op;
    if (path != null) result.path = path;
    if (from != null) result.from = from;
    if (value != null) result.value = value;
    return result;
  }

  JsonPatchOperation._();

  factory JsonPatchOperation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory JsonPatchOperation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JsonPatchOperation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aE<JsonPatchOperationType>(1, _omitFieldNames ? '' : 'op',
        enumValues: JsonPatchOperationType.values)
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..aOS(3, _omitFieldNames ? '' : 'from')
    ..aOM<$0.Value>(4, _omitFieldNames ? '' : 'value',
        subBuilder: $0.Value.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JsonPatchOperation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JsonPatchOperation copyWith(void Function(JsonPatchOperation) updates) =>
      super.copyWith((message) => updates(message as JsonPatchOperation))
          as JsonPatchOperation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JsonPatchOperation create() => JsonPatchOperation._();
  @$core.override
  JsonPatchOperation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static JsonPatchOperation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JsonPatchOperation>(create);
  static JsonPatchOperation? _defaultInstance;

  @$pb.TagNumber(1)
  JsonPatchOperationType get op => $_getN(0);
  @$pb.TagNumber(1)
  set op(JsonPatchOperationType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOp() => $_has(0);
  @$pb.TagNumber(1)
  void clearOp() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get from => $_getSZ(2);
  @$pb.TagNumber(3)
  set from($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFrom() => $_has(2);
  @$pb.TagNumber(3)
  void clearFrom() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Value get value => $_getN(3);
  @$pb.TagNumber(4)
  set value($0.Value value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearValue() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Value ensureValue() => $_ensure(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
