// This is a generated file - do not edit.
//
// Generated from types.proto.

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

@$core.Deprecated('Use toolCallDescriptor instead')
const ToolCall$json = {
  '1': 'ToolCall',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'type', '3': 2, '4': 1, '5': 9, '10': 'type'},
    {
      '1': 'function',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.ToolCall.Function',
      '10': 'function'
    },
  ],
  '3': [ToolCall_Function$json],
};

@$core.Deprecated('Use toolCallDescriptor instead')
const ToolCall_Function$json = {
  '1': 'Function',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'arguments', '3': 2, '4': 1, '5': 9, '10': 'arguments'},
  ],
};

/// Descriptor for `ToolCall`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolCallDescriptor = $convert.base64Decode(
    'CghUb29sQ2FsbBIOCgJpZBgBIAEoCVICaWQSEgoEdHlwZRgCIAEoCVIEdHlwZRI0CghmdW5jdG'
    'lvbhgDIAEoCzIYLmFnX3VpLlRvb2xDYWxsLkZ1bmN0aW9uUghmdW5jdGlvbho8CghGdW5jdGlv'
    'bhISCgRuYW1lGAEgASgJUgRuYW1lEhwKCWFyZ3VtZW50cxgCIAEoCVIJYXJndW1lbnRz');

@$core.Deprecated('Use inputContentDataSourceDescriptor instead')
const InputContentDataSource$json = {
  '1': 'InputContentDataSource',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 9, '10': 'value'},
    {'1': 'mime_type', '3': 2, '4': 1, '5': 9, '10': 'mimeType'},
  ],
};

/// Descriptor for `InputContentDataSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inputContentDataSourceDescriptor =
    $convert.base64Decode(
        'ChZJbnB1dENvbnRlbnREYXRhU291cmNlEhQKBXZhbHVlGAEgASgJUgV2YWx1ZRIbCgltaW1lX3'
        'R5cGUYAiABKAlSCG1pbWVUeXBl');

@$core.Deprecated('Use inputContentUrlSourceDescriptor instead')
const InputContentUrlSource$json = {
  '1': 'InputContentUrlSource',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 9, '10': 'value'},
    {
      '1': 'mime_type',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'mimeType',
      '17': true
    },
  ],
  '8': [
    {'1': '_mime_type'},
  ],
};

/// Descriptor for `InputContentUrlSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inputContentUrlSourceDescriptor = $convert.base64Decode(
    'ChVJbnB1dENvbnRlbnRVcmxTb3VyY2USFAoFdmFsdWUYASABKAlSBXZhbHVlEiAKCW1pbWVfdH'
    'lwZRgCIAEoCUgAUghtaW1lVHlwZYgBAUIMCgpfbWltZV90eXBl');

@$core.Deprecated('Use inputContentSourceDescriptor instead')
const InputContentSource$json = {
  '1': 'InputContentSource',
  '2': [
    {
      '1': 'data',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.InputContentDataSource',
      '9': 0,
      '10': 'data'
    },
    {
      '1': 'url',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.InputContentUrlSource',
      '9': 0,
      '10': 'url'
    },
  ],
  '8': [
    {'1': 'source'},
  ],
};

/// Descriptor for `InputContentSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inputContentSourceDescriptor = $convert.base64Decode(
    'ChJJbnB1dENvbnRlbnRTb3VyY2USMwoEZGF0YRgBIAEoCzIdLmFnX3VpLklucHV0Q29udGVudE'
    'RhdGFTb3VyY2VIAFIEZGF0YRIwCgN1cmwYAiABKAsyHC5hZ191aS5JbnB1dENvbnRlbnRVcmxT'
    'b3VyY2VIAFIDdXJsQggKBnNvdXJjZQ==');

@$core.Deprecated('Use textInputPartDescriptor instead')
const TextInputPart$json = {
  '1': 'TextInputPart',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
  ],
};

/// Descriptor for `TextInputPart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textInputPartDescriptor =
    $convert.base64Decode('Cg1UZXh0SW5wdXRQYXJ0EhIKBHRleHQYASABKAlSBHRleHQ=');

@$core.Deprecated('Use imageInputPartDescriptor instead')
const ImageInputPart$json = {
  '1': 'ImageInputPart',
  '2': [
    {
      '1': 'source',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.InputContentSource',
      '10': 'source'
    },
    {
      '1': 'metadata',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Value',
      '9': 0,
      '10': 'metadata',
      '17': true
    },
  ],
  '8': [
    {'1': '_metadata'},
  ],
};

/// Descriptor for `ImageInputPart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageInputPartDescriptor = $convert.base64Decode(
    'Cg5JbWFnZUlucHV0UGFydBIxCgZzb3VyY2UYASABKAsyGS5hZ191aS5JbnB1dENvbnRlbnRTb3'
    'VyY2VSBnNvdXJjZRI3CghtZXRhZGF0YRgCIAEoCzIWLmdvb2dsZS5wcm90b2J1Zi5WYWx1ZUgA'
    'UghtZXRhZGF0YYgBAUILCglfbWV0YWRhdGE=');

@$core.Deprecated('Use audioInputPartDescriptor instead')
const AudioInputPart$json = {
  '1': 'AudioInputPart',
  '2': [
    {
      '1': 'source',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.InputContentSource',
      '10': 'source'
    },
    {
      '1': 'metadata',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Value',
      '9': 0,
      '10': 'metadata',
      '17': true
    },
  ],
  '8': [
    {'1': '_metadata'},
  ],
};

/// Descriptor for `AudioInputPart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioInputPartDescriptor = $convert.base64Decode(
    'Cg5BdWRpb0lucHV0UGFydBIxCgZzb3VyY2UYASABKAsyGS5hZ191aS5JbnB1dENvbnRlbnRTb3'
    'VyY2VSBnNvdXJjZRI3CghtZXRhZGF0YRgCIAEoCzIWLmdvb2dsZS5wcm90b2J1Zi5WYWx1ZUgA'
    'UghtZXRhZGF0YYgBAUILCglfbWV0YWRhdGE=');

@$core.Deprecated('Use videoInputPartDescriptor instead')
const VideoInputPart$json = {
  '1': 'VideoInputPart',
  '2': [
    {
      '1': 'source',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.InputContentSource',
      '10': 'source'
    },
    {
      '1': 'metadata',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Value',
      '9': 0,
      '10': 'metadata',
      '17': true
    },
  ],
  '8': [
    {'1': '_metadata'},
  ],
};

/// Descriptor for `VideoInputPart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoInputPartDescriptor = $convert.base64Decode(
    'Cg5WaWRlb0lucHV0UGFydBIxCgZzb3VyY2UYASABKAsyGS5hZ191aS5JbnB1dENvbnRlbnRTb3'
    'VyY2VSBnNvdXJjZRI3CghtZXRhZGF0YRgCIAEoCzIWLmdvb2dsZS5wcm90b2J1Zi5WYWx1ZUgA'
    'UghtZXRhZGF0YYgBAUILCglfbWV0YWRhdGE=');

@$core.Deprecated('Use documentInputPartDescriptor instead')
const DocumentInputPart$json = {
  '1': 'DocumentInputPart',
  '2': [
    {
      '1': 'source',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.InputContentSource',
      '10': 'source'
    },
    {
      '1': 'metadata',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Value',
      '9': 0,
      '10': 'metadata',
      '17': true
    },
  ],
  '8': [
    {'1': '_metadata'},
  ],
};

/// Descriptor for `DocumentInputPart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List documentInputPartDescriptor = $convert.base64Decode(
    'ChFEb2N1bWVudElucHV0UGFydBIxCgZzb3VyY2UYASABKAsyGS5hZ191aS5JbnB1dENvbnRlbn'
    'RTb3VyY2VSBnNvdXJjZRI3CghtZXRhZGF0YRgCIAEoCzIWLmdvb2dsZS5wcm90b2J1Zi5WYWx1'
    'ZUgAUghtZXRhZGF0YYgBAUILCglfbWV0YWRhdGE=');

@$core.Deprecated('Use inputContentDescriptor instead')
const InputContent$json = {
  '1': 'InputContent',
  '2': [
    {
      '1': 'text',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.TextInputPart',
      '9': 0,
      '10': 'text'
    },
    {
      '1': 'image',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.ImageInputPart',
      '9': 0,
      '10': 'image'
    },
    {
      '1': 'audio',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.AudioInputPart',
      '9': 0,
      '10': 'audio'
    },
    {
      '1': 'video',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.VideoInputPart',
      '9': 0,
      '10': 'video'
    },
    {
      '1': 'document',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.DocumentInputPart',
      '9': 0,
      '10': 'document'
    },
  ],
  '8': [
    {'1': 'part'},
  ],
};

/// Descriptor for `InputContent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inputContentDescriptor = $convert.base64Decode(
    'CgxJbnB1dENvbnRlbnQSKgoEdGV4dBgBIAEoCzIULmFnX3VpLlRleHRJbnB1dFBhcnRIAFIEdG'
    'V4dBItCgVpbWFnZRgCIAEoCzIVLmFnX3VpLkltYWdlSW5wdXRQYXJ0SABSBWltYWdlEi0KBWF1'
    'ZGlvGAMgASgLMhUuYWdfdWkuQXVkaW9JbnB1dFBhcnRIAFIFYXVkaW8SLQoFdmlkZW8YBCABKA'
    'syFS5hZ191aS5WaWRlb0lucHV0UGFydEgAUgV2aWRlbxI2Cghkb2N1bWVudBgFIAEoCzIYLmFn'
    'X3VpLkRvY3VtZW50SW5wdXRQYXJ0SABSCGRvY3VtZW50QgYKBHBhcnQ=');

@$core.Deprecated('Use messageDescriptor instead')
const Message$json = {
  '1': 'Message',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'role', '3': 2, '4': 1, '5': 9, '10': 'role'},
    {
      '1': 'content',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'content',
      '17': true
    },
    {'1': 'name', '3': 4, '4': 1, '5': 9, '9': 1, '10': 'name', '17': true},
    {
      '1': 'tool_calls',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.ag_ui.ToolCall',
      '10': 'toolCalls'
    },
    {
      '1': 'tool_call_id',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'toolCallId',
      '17': true
    },
    {'1': 'error', '3': 7, '4': 1, '5': 9, '9': 3, '10': 'error', '17': true},
    {
      '1': 'content_parts',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.ag_ui.InputContent',
      '10': 'contentParts'
    },
  ],
  '8': [
    {'1': '_content'},
    {'1': '_name'},
    {'1': '_tool_call_id'},
    {'1': '_error'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode(
    'CgdNZXNzYWdlEg4KAmlkGAEgASgJUgJpZBISCgRyb2xlGAIgASgJUgRyb2xlEh0KB2NvbnRlbn'
    'QYAyABKAlIAFIHY29udGVudIgBARIXCgRuYW1lGAQgASgJSAFSBG5hbWWIAQESLgoKdG9vbF9j'
    'YWxscxgFIAMoCzIPLmFnX3VpLlRvb2xDYWxsUgl0b29sQ2FsbHMSJQoMdG9vbF9jYWxsX2lkGA'
    'YgASgJSAJSCnRvb2xDYWxsSWSIAQESGQoFZXJyb3IYByABKAlIA1IFZXJyb3KIAQESOAoNY29u'
    'dGVudF9wYXJ0cxgIIAMoCzITLmFnX3VpLklucHV0Q29udGVudFIMY29udGVudFBhcnRzQgoKCF'
    '9jb250ZW50QgcKBV9uYW1lQg8KDV90b29sX2NhbGxfaWRCCAoGX2Vycm9y');

@$core.Deprecated('Use interruptDescriptor instead')
const Interrupt$json = {
  '1': 'Interrupt',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'message',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'message',
      '17': true
    },
    {
      '1': 'tool_call_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'toolCallId',
      '17': true
    },
    {
      '1': 'response_schema',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Value',
      '9': 2,
      '10': 'responseSchema',
      '17': true
    },
    {
      '1': 'expires_at',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'expiresAt',
      '17': true
    },
    {
      '1': 'metadata',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Value',
      '9': 4,
      '10': 'metadata',
      '17': true
    },
  ],
  '8': [
    {'1': '_message'},
    {'1': '_tool_call_id'},
    {'1': '_response_schema'},
    {'1': '_expires_at'},
    {'1': '_metadata'},
  ],
};

/// Descriptor for `Interrupt`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List interruptDescriptor = $convert.base64Decode(
    'CglJbnRlcnJ1cHQSDgoCaWQYASABKAlSAmlkEhYKBnJlYXNvbhgCIAEoCVIGcmVhc29uEh0KB2'
    '1lc3NhZ2UYAyABKAlIAFIHbWVzc2FnZYgBARIlCgx0b29sX2NhbGxfaWQYBCABKAlIAVIKdG9v'
    'bENhbGxJZIgBARJECg9yZXNwb25zZV9zY2hlbWEYBSABKAsyFi5nb29nbGUucHJvdG9idWYuVm'
    'FsdWVIAlIOcmVzcG9uc2VTY2hlbWGIAQESIgoKZXhwaXJlc19hdBgGIAEoCUgDUglleHBpcmVz'
    'QXSIAQESNwoIbWV0YWRhdGEYByABKAsyFi5nb29nbGUucHJvdG9idWYuVmFsdWVIBFIIbWV0YW'
    'RhdGGIAQFCCgoIX21lc3NhZ2VCDwoNX3Rvb2xfY2FsbF9pZEISChBfcmVzcG9uc2Vfc2NoZW1h'
    'Qg0KC19leHBpcmVzX2F0QgsKCV9tZXRhZGF0YQ==');
