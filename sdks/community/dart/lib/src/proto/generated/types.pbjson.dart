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

@$core.Deprecated('Use textInputPartDescriptor instead')
const TextInputPart$json = {
  '1': 'TextInputPart',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'id', '17': true},
    {
      '1': 'metadata',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Value',
      '9': 1,
      '10': 'metadata',
      '17': true
    },
  ],
  '8': [
    {'1': '_id'},
    {'1': '_metadata'},
  ],
};

/// Descriptor for `TextInputPart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textInputPartDescriptor = $convert.base64Decode(
    'Cg1UZXh0SW5wdXRQYXJ0EhIKBHRleHQYASABKAlSBHRleHQSEwoCaWQYAiABKAlIAFICaWSIAQ'
    'ESNwoIbWV0YWRhdGEYAyABKAsyFi5nb29nbGUucHJvdG9idWYuVmFsdWVIAVIIbWV0YWRhdGGI'
    'AQFCBQoDX2lkQgsKCV9tZXRhZGF0YQ==');

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
    {'1': 'id', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'id', '17': true},
  ],
  '8': [
    {'1': '_metadata'},
    {'1': '_id'},
  ],
};

/// Descriptor for `ImageInputPart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageInputPartDescriptor = $convert.base64Decode(
    'Cg5JbWFnZUlucHV0UGFydBIxCgZzb3VyY2UYASABKAsyGS5hZ191aS5JbnB1dENvbnRlbnRTb3'
    'VyY2VSBnNvdXJjZRI3CghtZXRhZGF0YRgCIAEoCzIWLmdvb2dsZS5wcm90b2J1Zi5WYWx1ZUgA'
    'UghtZXRhZGF0YYgBARITCgJpZBgDIAEoCUgBUgJpZIgBAUILCglfbWV0YWRhdGFCBQoDX2lk');

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

@$core.Deprecated('Use inputContentFileSourceDescriptor instead')
const InputContentFileSource$json = {
  '1': 'InputContentFileSource',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 9, '10': 'value'},
    {
      '1': 'provider',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'provider',
      '17': true
    },
    {
      '1': 'mime_type',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'mimeType',
      '17': true
    },
  ],
  '8': [
    {'1': '_provider'},
    {'1': '_mime_type'},
  ],
};

/// Descriptor for `InputContentFileSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inputContentFileSourceDescriptor = $convert.base64Decode(
    'ChZJbnB1dENvbnRlbnRGaWxlU291cmNlEhQKBXZhbHVlGAEgASgJUgV2YWx1ZRIfCghwcm92aW'
    'RlchgCIAEoCUgAUghwcm92aWRlcogBARIgCgltaW1lX3R5cGUYAyABKAlIAVIIbWltZVR5cGWI'
    'AQFCCwoJX3Byb3ZpZGVyQgwKCl9taW1lX3R5cGU=');

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
    {
      '1': 'file',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.InputContentFileSource',
      '9': 0,
      '10': 'file'
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
    'b3VyY2VIAFIDdXJsEjMKBGZpbGUYAyABKAsyHS5hZ191aS5JbnB1dENvbnRlbnRGaWxlU291cm'
    'NlSABSBGZpbGVCCAoGc291cmNl');

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
    {'1': 'id', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'id', '17': true},
  ],
  '8': [
    {'1': '_metadata'},
    {'1': '_id'},
  ],
};

/// Descriptor for `AudioInputPart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioInputPartDescriptor = $convert.base64Decode(
    'Cg5BdWRpb0lucHV0UGFydBIxCgZzb3VyY2UYASABKAsyGS5hZ191aS5JbnB1dENvbnRlbnRTb3'
    'VyY2VSBnNvdXJjZRI3CghtZXRhZGF0YRgCIAEoCzIWLmdvb2dsZS5wcm90b2J1Zi5WYWx1ZUgA'
    'UghtZXRhZGF0YYgBARITCgJpZBgDIAEoCUgBUgJpZIgBAUILCglfbWV0YWRhdGFCBQoDX2lk');

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
    {'1': 'id', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'id', '17': true},
  ],
  '8': [
    {'1': '_metadata'},
    {'1': '_id'},
  ],
};

/// Descriptor for `VideoInputPart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoInputPartDescriptor = $convert.base64Decode(
    'Cg5WaWRlb0lucHV0UGFydBIxCgZzb3VyY2UYASABKAsyGS5hZ191aS5JbnB1dENvbnRlbnRTb3'
    'VyY2VSBnNvdXJjZRI3CghtZXRhZGF0YRgCIAEoCzIWLmdvb2dsZS5wcm90b2J1Zi5WYWx1ZUgA'
    'UghtZXRhZGF0YYgBARITCgJpZBgDIAEoCUgBUgJpZIgBAUILCglfbWV0YWRhdGFCBQoDX2lk');

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
    {'1': 'id', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'id', '17': true},
  ],
  '8': [
    {'1': '_metadata'},
    {'1': '_id'},
  ],
};

/// Descriptor for `DocumentInputPart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List documentInputPartDescriptor = $convert.base64Decode(
    'ChFEb2N1bWVudElucHV0UGFydBIxCgZzb3VyY2UYASABKAsyGS5hZ191aS5JbnB1dENvbnRlbn'
    'RTb3VyY2VSBnNvdXJjZRI3CghtZXRhZGF0YRgCIAEoCzIWLmdvb2dsZS5wcm90b2J1Zi5WYWx1'
    'ZUgAUghtZXRhZGF0YYgBARITCgJpZBgDIAEoCUgBUgJpZIgBAUILCglfbWV0YWRhdGFCBQoDX2'
    'lk');

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
    {
      '1': 'metadata',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Struct',
      '9': 0,
      '10': 'metadata',
      '17': true
    },
    {
      '1': 'encrypted_value',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'encryptedValue',
      '17': true
    },
  ],
  '3': [ToolCall_Function$json],
  '8': [
    {'1': '_metadata'},
    {'1': '_encrypted_value'},
  ],
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
    'lvbhgDIAEoCzIYLmFnX3VpLlRvb2xDYWxsLkZ1bmN0aW9uUghmdW5jdGlvbhI4CghtZXRhZGF0'
    'YRgEIAEoCzIXLmdvb2dsZS5wcm90b2J1Zi5TdHJ1Y3RIAFIIbWV0YWRhdGGIAQESLAoPZW5jcn'
    'lwdGVkX3ZhbHVlGAUgASgJSAFSDmVuY3J5cHRlZFZhbHVliAEBGjwKCEZ1bmN0aW9uEhIKBG5h'
    'bWUYASABKAlSBG5hbWUSHAoJYXJndW1lbnRzGAIgASgJUglhcmd1bWVudHNCCwoJX21ldGFkYX'
    'RhQhIKEF9lbmNyeXB0ZWRfdmFsdWU=');

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
    {
      '1': 'metadata',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Struct',
      '9': 4,
      '10': 'metadata',
      '17': true
    },
    {
      '1': 'subagent_run_id',
      '3': 10,
      '4': 1,
      '5': 9,
      '9': 5,
      '10': 'subagentRunId',
      '17': true
    },
    {
      '1': 'encrypted_value',
      '3': 11,
      '4': 1,
      '5': 9,
      '9': 6,
      '10': 'encryptedValue',
      '17': true
    },
    {
      '1': 'activity_type',
      '3': 12,
      '4': 1,
      '5': 9,
      '9': 7,
      '10': 'activityType',
      '17': true
    },
    {
      '1': 'activity_content',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Struct',
      '9': 8,
      '10': 'activityContent',
      '17': true
    },
  ],
  '8': [
    {'1': '_content'},
    {'1': '_name'},
    {'1': '_tool_call_id'},
    {'1': '_error'},
    {'1': '_metadata'},
    {'1': '_subagent_run_id'},
    {'1': '_encrypted_value'},
    {'1': '_activity_type'},
    {'1': '_activity_content'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode(
    'CgdNZXNzYWdlEg4KAmlkGAEgASgJUgJpZBISCgRyb2xlGAIgASgJUgRyb2xlEh0KB2NvbnRlbn'
    'QYAyABKAlIAFIHY29udGVudIgBARIXCgRuYW1lGAQgASgJSAFSBG5hbWWIAQESLgoKdG9vbF9j'
    'YWxscxgFIAMoCzIPLmFnX3VpLlRvb2xDYWxsUgl0b29sQ2FsbHMSJQoMdG9vbF9jYWxsX2lkGA'
    'YgASgJSAJSCnRvb2xDYWxsSWSIAQESGQoFZXJyb3IYByABKAlIA1IFZXJyb3KIAQESOAoNY29u'
    'dGVudF9wYXJ0cxgIIAMoCzITLmFnX3VpLklucHV0Q29udGVudFIMY29udGVudFBhcnRzEjgKCG'
    '1ldGFkYXRhGAkgASgLMhcuZ29vZ2xlLnByb3RvYnVmLlN0cnVjdEgEUghtZXRhZGF0YYgBARIr'
    'Cg9zdWJhZ2VudF9ydW5faWQYCiABKAlIBVINc3ViYWdlbnRSdW5JZIgBARIsCg9lbmNyeXB0ZW'
    'RfdmFsdWUYCyABKAlIBlIOZW5jcnlwdGVkVmFsdWWIAQESKAoNYWN0aXZpdHlfdHlwZRgMIAEo'
    'CUgHUgxhY3Rpdml0eVR5cGWIAQESRwoQYWN0aXZpdHlfY29udGVudBgNIAEoCzIXLmdvb2dsZS'
    '5wcm90b2J1Zi5TdHJ1Y3RICFIPYWN0aXZpdHlDb250ZW50iAEBQgoKCF9jb250ZW50QgcKBV9u'
    'YW1lQg8KDV90b29sX2NhbGxfaWRCCAoGX2Vycm9yQgsKCV9tZXRhZGF0YUISChBfc3ViYWdlbn'
    'RfcnVuX2lkQhIKEF9lbmNyeXB0ZWRfdmFsdWVCEAoOX2FjdGl2aXR5X3R5cGVCEwoRX2FjdGl2'
    'aXR5X2NvbnRlbnQ=');

@$core.Deprecated('Use toolDescriptor instead')
const Tool$json = {
  '1': 'Tool',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'parameters',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Value',
      '9': 0,
      '10': 'parameters',
      '17': true
    },
    {
      '1': 'metadata',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Struct',
      '9': 1,
      '10': 'metadata',
      '17': true
    },
  ],
  '8': [
    {'1': '_parameters'},
    {'1': '_metadata'},
  ],
};

/// Descriptor for `Tool`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolDescriptor = $convert.base64Decode(
    'CgRUb29sEhIKBG5hbWUYASABKAlSBG5hbWUSIAoLZGVzY3JpcHRpb24YAiABKAlSC2Rlc2NyaX'
    'B0aW9uEjsKCnBhcmFtZXRlcnMYAyABKAsyFi5nb29nbGUucHJvdG9idWYuVmFsdWVIAFIKcGFy'
    'YW1ldGVyc4gBARI4CghtZXRhZGF0YRgEIAEoCzIXLmdvb2dsZS5wcm90b2J1Zi5TdHJ1Y3RIAV'
    'IIbWV0YWRhdGGIAQFCDQoLX3BhcmFtZXRlcnNCCwoJX21ldGFkYXRh');

@$core.Deprecated('Use contextDescriptor instead')
const Context$json = {
  '1': 'Context',
  '2': [
    {'1': 'description', '3': 1, '4': 1, '5': 9, '10': 'description'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `Context`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contextDescriptor = $convert.base64Decode(
    'CgdDb250ZXh0EiAKC2Rlc2NyaXB0aW9uGAEgASgJUgtkZXNjcmlwdGlvbhIUCgV2YWx1ZRgCIA'
    'EoCVIFdmFsdWU=');

@$core.Deprecated('Use resumeEntryDescriptor instead')
const ResumeEntry$json = {
  '1': 'ResumeEntry',
  '2': [
    {'1': 'interrupt_id', '3': 1, '4': 1, '5': 9, '10': 'interruptId'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {
      '1': 'payload',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Value',
      '9': 0,
      '10': 'payload',
      '17': true
    },
    {
      '1': 'metadata',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Struct',
      '9': 1,
      '10': 'metadata',
      '17': true
    },
  ],
  '8': [
    {'1': '_payload'},
    {'1': '_metadata'},
  ],
};

/// Descriptor for `ResumeEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resumeEntryDescriptor = $convert.base64Decode(
    'CgtSZXN1bWVFbnRyeRIhCgxpbnRlcnJ1cHRfaWQYASABKAlSC2ludGVycnVwdElkEhYKBnN0YX'
    'R1cxgCIAEoCVIGc3RhdHVzEjUKB3BheWxvYWQYAyABKAsyFi5nb29nbGUucHJvdG9idWYuVmFs'
    'dWVIAFIHcGF5bG9hZIgBARI4CghtZXRhZGF0YRgEIAEoCzIXLmdvb2dsZS5wcm90b2J1Zi5TdH'
    'J1Y3RIAVIIbWV0YWRhdGGIAQFCCgoIX3BheWxvYWRCCwoJX21ldGFkYXRh');

@$core.Deprecated('Use runAgentInputDescriptor instead')
const RunAgentInput$json = {
  '1': 'RunAgentInput',
  '2': [
    {'1': 'thread_id', '3': 1, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'run_id', '3': 2, '4': 1, '5': 9, '10': 'runId'},
    {
      '1': 'parent_run_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'parentRunId',
      '17': true
    },
    {
      '1': 'state',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Value',
      '9': 1,
      '10': 'state',
      '17': true
    },
    {
      '1': 'messages',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.ag_ui.Message',
      '10': 'messages'
    },
    {'1': 'tools', '3': 6, '4': 3, '5': 11, '6': '.ag_ui.Tool', '10': 'tools'},
    {
      '1': 'context',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.ag_ui.Context',
      '10': 'context'
    },
    {
      '1': 'forwarded_props',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Value',
      '9': 2,
      '10': 'forwardedProps',
      '17': true
    },
    {
      '1': 'resume',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.ag_ui.ResumeEntry',
      '10': 'resume'
    },
    {
      '1': 'protocol_version',
      '3': 10,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'protocolVersion',
      '17': true
    },
  ],
  '8': [
    {'1': '_parent_run_id'},
    {'1': '_state'},
    {'1': '_forwarded_props'},
    {'1': '_protocol_version'},
  ],
};

/// Descriptor for `RunAgentInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runAgentInputDescriptor = $convert.base64Decode(
    'Cg1SdW5BZ2VudElucHV0EhsKCXRocmVhZF9pZBgBIAEoCVIIdGhyZWFkSWQSFQoGcnVuX2lkGA'
    'IgASgJUgVydW5JZBInCg1wYXJlbnRfcnVuX2lkGAMgASgJSABSC3BhcmVudFJ1bklkiAEBEjEK'
    'BXN0YXRlGAQgASgLMhYuZ29vZ2xlLnByb3RvYnVmLlZhbHVlSAFSBXN0YXRliAEBEioKCG1lc3'
    'NhZ2VzGAUgAygLMg4uYWdfdWkuTWVzc2FnZVIIbWVzc2FnZXMSIQoFdG9vbHMYBiADKAsyCy5h'
    'Z191aS5Ub29sUgV0b29scxIoCgdjb250ZXh0GAcgAygLMg4uYWdfdWkuQ29udGV4dFIHY29udG'
    'V4dBJECg9mb3J3YXJkZWRfcHJvcHMYCCABKAsyFi5nb29nbGUucHJvdG9idWYuVmFsdWVIAlIO'
    'Zm9yd2FyZGVkUHJvcHOIAQESKgoGcmVzdW1lGAkgAygLMhIuYWdfdWkuUmVzdW1lRW50cnlSBn'
    'Jlc3VtZRIuChBwcm90b2NvbF92ZXJzaW9uGAogASgJSANSD3Byb3RvY29sVmVyc2lvbogBAUIQ'
    'Cg5fcGFyZW50X3J1bl9pZEIICgZfc3RhdGVCEgoQX2ZvcndhcmRlZF9wcm9wc0ITChFfcHJvdG'
    '9jb2xfdmVyc2lvbg==');

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
    {
      '1': 'subagent_run_id',
      '3': 8,
      '4': 1,
      '5': 9,
      '9': 5,
      '10': 'subagentRunId',
      '17': true
    },
  ],
  '8': [
    {'1': '_message'},
    {'1': '_tool_call_id'},
    {'1': '_response_schema'},
    {'1': '_expires_at'},
    {'1': '_metadata'},
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `Interrupt`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List interruptDescriptor = $convert.base64Decode(
    'CglJbnRlcnJ1cHQSDgoCaWQYASABKAlSAmlkEhYKBnJlYXNvbhgCIAEoCVIGcmVhc29uEh0KB2'
    '1lc3NhZ2UYAyABKAlIAFIHbWVzc2FnZYgBARIlCgx0b29sX2NhbGxfaWQYBCABKAlIAVIKdG9v'
    'bENhbGxJZIgBARJECg9yZXNwb25zZV9zY2hlbWEYBSABKAsyFi5nb29nbGUucHJvdG9idWYuVm'
    'FsdWVIAlIOcmVzcG9uc2VTY2hlbWGIAQESIgoKZXhwaXJlc19hdBgGIAEoCUgDUglleHBpcmVz'
    'QXSIAQESNwoIbWV0YWRhdGEYByABKAsyFi5nb29nbGUucHJvdG9idWYuVmFsdWVIBFIIbWV0YW'
    'RhdGGIAQESKwoPc3ViYWdlbnRfcnVuX2lkGAggASgJSAVSDXN1YmFnZW50UnVuSWSIAQFCCgoI'
    'X21lc3NhZ2VCDwoNX3Rvb2xfY2FsbF9pZEISChBfcmVzcG9uc2Vfc2NoZW1hQg0KC19leHBpcm'
    'VzX2F0QgsKCV9tZXRhZGF0YUISChBfc3ViYWdlbnRfcnVuX2lk');
