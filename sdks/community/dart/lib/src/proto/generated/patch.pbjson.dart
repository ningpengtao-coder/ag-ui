// This is a generated file - do not edit.
//
// Generated from patch.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use jsonPatchOperationTypeDescriptor instead')
const JsonPatchOperationType$json = {
  '1': 'JsonPatchOperationType',
  '2': [
    {'1': 'ADD', '2': 0},
    {'1': 'REMOVE', '2': 1},
    {'1': 'REPLACE', '2': 2},
    {'1': 'MOVE', '2': 3},
    {'1': 'COPY', '2': 4},
    {'1': 'TEST', '2': 5},
  ],
};

/// Descriptor for `JsonPatchOperationType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List jsonPatchOperationTypeDescriptor =
    $convert.base64Decode(
        'ChZKc29uUGF0Y2hPcGVyYXRpb25UeXBlEgcKA0FERBAAEgoKBlJFTU9WRRABEgsKB1JFUExBQ0'
        'UQAhIICgRNT1ZFEAMSCAoEQ09QWRAEEggKBFRFU1QQBQ==');

@$core.Deprecated('Use jsonPatchOperationDescriptor instead')
const JsonPatchOperation$json = {
  '1': 'JsonPatchOperation',
  '2': [
    {
      '1': 'op',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.ag_ui.JsonPatchOperationType',
      '10': 'op'
    },
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {'1': 'from', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'from', '17': true},
    {
      '1': 'value',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Value',
      '9': 1,
      '10': 'value',
      '17': true
    },
  ],
  '8': [
    {'1': '_from'},
    {'1': '_value'},
  ],
};

/// Descriptor for `JsonPatchOperation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List jsonPatchOperationDescriptor = $convert.base64Decode(
    'ChJKc29uUGF0Y2hPcGVyYXRpb24SLQoCb3AYASABKA4yHS5hZ191aS5Kc29uUGF0Y2hPcGVyYX'
    'Rpb25UeXBlUgJvcBISCgRwYXRoGAIgASgJUgRwYXRoEhcKBGZyb20YAyABKAlIAFIEZnJvbYgB'
    'ARIxCgV2YWx1ZRgEIAEoCzIWLmdvb2dsZS5wcm90b2J1Zi5WYWx1ZUgBUgV2YWx1ZYgBAUIHCg'
    'VfZnJvbUIICgZfdmFsdWU=');
