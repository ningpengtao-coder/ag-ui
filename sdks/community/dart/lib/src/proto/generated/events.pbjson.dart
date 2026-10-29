// This is a generated file - do not edit.
//
// Generated from events.proto.

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

@$core.Deprecated('Use eventTypeDescriptor instead')
const EventType$json = {
  '1': 'EventType',
  '2': [
    {'1': 'TEXT_MESSAGE_START', '2': 0},
    {'1': 'TEXT_MESSAGE_CONTENT', '2': 1},
    {'1': 'TEXT_MESSAGE_END', '2': 2},
    {'1': 'TOOL_CALL_START', '2': 3},
    {'1': 'TOOL_CALL_ARGS', '2': 4},
    {'1': 'TOOL_CALL_END', '2': 5},
    {'1': 'STATE_SNAPSHOT', '2': 6},
    {'1': 'STATE_DELTA', '2': 7},
    {'1': 'MESSAGES_SNAPSHOT', '2': 8},
    {'1': 'RAW', '2': 9},
    {'1': 'CUSTOM', '2': 10},
    {'1': 'RUN_STARTED', '2': 11},
    {'1': 'RUN_FINISHED', '2': 12},
    {'1': 'RUN_ERROR', '2': 13},
    {'1': 'STEP_STARTED', '2': 14},
    {'1': 'STEP_FINISHED', '2': 15},
    {'1': 'SUBAGENT_STARTED', '2': 16},
    {'1': 'SUBAGENT_FINISHED', '2': 17},
    {'1': 'SUBAGENT_ERROR', '2': 18},
    {'1': 'TEXT_MESSAGE_CHUNK', '2': 19},
    {'1': 'TOOL_CALL_CHUNK', '2': 20},
    {'1': 'TOOL_CALL_RESULT', '2': 21},
    {'1': 'ACTIVITY_SNAPSHOT', '2': 22},
    {'1': 'ACTIVITY_DELTA', '2': 23},
    {'1': 'REASONING_START', '2': 24},
    {'1': 'REASONING_MESSAGE_START', '2': 25},
    {'1': 'REASONING_MESSAGE_CONTENT', '2': 26},
    {'1': 'REASONING_MESSAGE_END', '2': 27},
    {'1': 'REASONING_MESSAGE_CHUNK', '2': 28},
    {'1': 'REASONING_END', '2': 29},
    {'1': 'REASONING_ENCRYPTED_VALUE', '2': 30},
  ],
};

/// Descriptor for `EventType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List eventTypeDescriptor = $convert.base64Decode(
    'CglFdmVudFR5cGUSFgoSVEVYVF9NRVNTQUdFX1NUQVJUEAASGAoUVEVYVF9NRVNTQUdFX0NPTl'
    'RFTlQQARIUChBURVhUX01FU1NBR0VfRU5EEAISEwoPVE9PTF9DQUxMX1NUQVJUEAMSEgoOVE9P'
    'TF9DQUxMX0FSR1MQBBIRCg1UT09MX0NBTExfRU5EEAUSEgoOU1RBVEVfU05BUFNIT1QQBhIPCg'
    'tTVEFURV9ERUxUQRAHEhUKEU1FU1NBR0VTX1NOQVBTSE9UEAgSBwoDUkFXEAkSCgoGQ1VTVE9N'
    'EAoSDwoLUlVOX1NUQVJURUQQCxIQCgxSVU5fRklOSVNIRUQQDBINCglSVU5fRVJST1IQDRIQCg'
    'xTVEVQX1NUQVJURUQQDhIRCg1TVEVQX0ZJTklTSEVEEA8SFAoQU1VCQUdFTlRfU1RBUlRFRBAQ'
    'EhUKEVNVQkFHRU5UX0ZJTklTSEVEEBESEgoOU1VCQUdFTlRfRVJST1IQEhIWChJURVhUX01FU1'
    'NBR0VfQ0hVTksQExITCg9UT09MX0NBTExfQ0hVTksQFBIUChBUT09MX0NBTExfUkVTVUxUEBUS'
    'FQoRQUNUSVZJVFlfU05BUFNIT1QQFhISCg5BQ1RJVklUWV9ERUxUQRAXEhMKD1JFQVNPTklOR1'
    '9TVEFSVBAYEhsKF1JFQVNPTklOR19NRVNTQUdFX1NUQVJUEBkSHQoZUkVBU09OSU5HX01FU1NB'
    'R0VfQ09OVEVOVBAaEhkKFVJFQVNPTklOR19NRVNTQUdFX0VORBAbEhsKF1JFQVNPTklOR19NRV'
    'NTQUdFX0NIVU5LEBwSEQoNUkVBU09OSU5HX0VORBAdEh0KGVJFQVNPTklOR19FTkNSWVBURURf'
    'VkFMVUUQHg==');

@$core.Deprecated('Use baseEventDescriptor instead')
const BaseEvent$json = {
  '1': 'BaseEvent',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.ag_ui.EventType',
      '10': 'type'
    },
    {
      '1': 'timestamp',
      '3': 2,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'timestamp',
      '17': true
    },
    {
      '1': 'raw_event',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Value',
      '9': 1,
      '10': 'rawEvent',
      '17': true
    },
    {
      '1': 'metadata',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Struct',
      '9': 2,
      '10': 'metadata',
      '17': true
    },
  ],
  '8': [
    {'1': '_timestamp'},
    {'1': '_raw_event'},
    {'1': '_metadata'},
  ],
};

/// Descriptor for `BaseEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List baseEventDescriptor = $convert.base64Decode(
    'CglCYXNlRXZlbnQSJAoEdHlwZRgBIAEoDjIQLmFnX3VpLkV2ZW50VHlwZVIEdHlwZRIhCgl0aW'
    '1lc3RhbXAYAiABKANIAFIJdGltZXN0YW1wiAEBEjgKCXJhd19ldmVudBgDIAEoCzIWLmdvb2ds'
    'ZS5wcm90b2J1Zi5WYWx1ZUgBUghyYXdFdmVudIgBARI4CghtZXRhZGF0YRgEIAEoCzIXLmdvb2'
    'dsZS5wcm90b2J1Zi5TdHJ1Y3RIAlIIbWV0YWRhdGGIAQFCDAoKX3RpbWVzdGFtcEIMCgpfcmF3'
    'X2V2ZW50QgsKCV9tZXRhZGF0YQ==');

@$core.Deprecated('Use textMessageStartEventDescriptor instead')
const TextMessageStartEvent$json = {
  '1': 'TextMessageStartEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {'1': 'message_id', '3': 2, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'role', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'role', '17': true},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '9': 1, '10': 'name', '17': true},
    {
      '1': 'subagent_run_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'subagentRunId',
      '17': true
    },
  ],
  '8': [
    {'1': '_role'},
    {'1': '_name'},
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `TextMessageStartEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textMessageStartEventDescriptor = $convert.base64Decode(
    'ChVUZXh0TWVzc2FnZVN0YXJ0RXZlbnQSLwoKYmFzZV9ldmVudBgBIAEoCzIQLmFnX3VpLkJhc2'
    'VFdmVudFIJYmFzZUV2ZW50Eh0KCm1lc3NhZ2VfaWQYAiABKAlSCW1lc3NhZ2VJZBIXCgRyb2xl'
    'GAMgASgJSABSBHJvbGWIAQESFwoEbmFtZRgEIAEoCUgBUgRuYW1liAEBEisKD3N1YmFnZW50X3'
    'J1bl9pZBgFIAEoCUgCUg1zdWJhZ2VudFJ1bklkiAEBQgcKBV9yb2xlQgcKBV9uYW1lQhIKEF9z'
    'dWJhZ2VudF9ydW5faWQ=');

@$core.Deprecated('Use textMessageContentEventDescriptor instead')
const TextMessageContentEvent$json = {
  '1': 'TextMessageContentEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {'1': 'message_id', '3': 2, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'delta', '3': 3, '4': 1, '5': 9, '10': 'delta'},
    {
      '1': 'subagent_run_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'subagentRunId',
      '17': true
    },
  ],
  '8': [
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `TextMessageContentEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textMessageContentEventDescriptor = $convert.base64Decode(
    'ChdUZXh0TWVzc2FnZUNvbnRlbnRFdmVudBIvCgpiYXNlX2V2ZW50GAEgASgLMhAuYWdfdWkuQm'
    'FzZUV2ZW50UgliYXNlRXZlbnQSHQoKbWVzc2FnZV9pZBgCIAEoCVIJbWVzc2FnZUlkEhQKBWRl'
    'bHRhGAMgASgJUgVkZWx0YRIrCg9zdWJhZ2VudF9ydW5faWQYBCABKAlIAFINc3ViYWdlbnRSdW'
    '5JZIgBAUISChBfc3ViYWdlbnRfcnVuX2lk');

@$core.Deprecated('Use textMessageEndEventDescriptor instead')
const TextMessageEndEvent$json = {
  '1': 'TextMessageEndEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {'1': 'message_id', '3': 2, '4': 1, '5': 9, '10': 'messageId'},
    {
      '1': 'subagent_run_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'subagentRunId',
      '17': true
    },
  ],
  '8': [
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `TextMessageEndEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textMessageEndEventDescriptor = $convert.base64Decode(
    'ChNUZXh0TWVzc2FnZUVuZEV2ZW50Ei8KCmJhc2VfZXZlbnQYASABKAsyEC5hZ191aS5CYXNlRX'
    'ZlbnRSCWJhc2VFdmVudBIdCgptZXNzYWdlX2lkGAIgASgJUgltZXNzYWdlSWQSKwoPc3ViYWdl'
    'bnRfcnVuX2lkGAMgASgJSABSDXN1YmFnZW50UnVuSWSIAQFCEgoQX3N1YmFnZW50X3J1bl9pZA'
    '==');

@$core.Deprecated('Use textMessageChunkEventDescriptor instead')
const TextMessageChunkEvent$json = {
  '1': 'TextMessageChunkEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {
      '1': 'message_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'messageId',
      '17': true
    },
    {'1': 'role', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'role', '17': true},
    {'1': 'delta', '3': 4, '4': 1, '5': 9, '9': 2, '10': 'delta', '17': true},
    {'1': 'name', '3': 5, '4': 1, '5': 9, '9': 3, '10': 'name', '17': true},
    {
      '1': 'subagent_run_id',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'subagentRunId',
      '17': true
    },
  ],
  '8': [
    {'1': '_message_id'},
    {'1': '_role'},
    {'1': '_delta'},
    {'1': '_name'},
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `TextMessageChunkEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textMessageChunkEventDescriptor = $convert.base64Decode(
    'ChVUZXh0TWVzc2FnZUNodW5rRXZlbnQSLwoKYmFzZV9ldmVudBgBIAEoCzIQLmFnX3VpLkJhc2'
    'VFdmVudFIJYmFzZUV2ZW50EiIKCm1lc3NhZ2VfaWQYAiABKAlIAFIJbWVzc2FnZUlkiAEBEhcK'
    'BHJvbGUYAyABKAlIAVIEcm9sZYgBARIZCgVkZWx0YRgEIAEoCUgCUgVkZWx0YYgBARIXCgRuYW'
    '1lGAUgASgJSANSBG5hbWWIAQESKwoPc3ViYWdlbnRfcnVuX2lkGAYgASgJSARSDXN1YmFnZW50'
    'UnVuSWSIAQFCDQoLX21lc3NhZ2VfaWRCBwoFX3JvbGVCCAoGX2RlbHRhQgcKBV9uYW1lQhIKEF'
    '9zdWJhZ2VudF9ydW5faWQ=');

@$core.Deprecated('Use toolCallStartEventDescriptor instead')
const ToolCallStartEvent$json = {
  '1': 'ToolCallStartEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {'1': 'tool_call_id', '3': 2, '4': 1, '5': 9, '10': 'toolCallId'},
    {'1': 'tool_call_name', '3': 3, '4': 1, '5': 9, '10': 'toolCallName'},
    {
      '1': 'parent_message_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'parentMessageId',
      '17': true
    },
    {
      '1': 'subagent_run_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'subagentRunId',
      '17': true
    },
  ],
  '8': [
    {'1': '_parent_message_id'},
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `ToolCallStartEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolCallStartEventDescriptor = $convert.base64Decode(
    'ChJUb29sQ2FsbFN0YXJ0RXZlbnQSLwoKYmFzZV9ldmVudBgBIAEoCzIQLmFnX3VpLkJhc2VFdm'
    'VudFIJYmFzZUV2ZW50EiAKDHRvb2xfY2FsbF9pZBgCIAEoCVIKdG9vbENhbGxJZBIkCg50b29s'
    'X2NhbGxfbmFtZRgDIAEoCVIMdG9vbENhbGxOYW1lEi8KEXBhcmVudF9tZXNzYWdlX2lkGAQgAS'
    'gJSABSD3BhcmVudE1lc3NhZ2VJZIgBARIrCg9zdWJhZ2VudF9ydW5faWQYBSABKAlIAVINc3Vi'
    'YWdlbnRSdW5JZIgBAUIUChJfcGFyZW50X21lc3NhZ2VfaWRCEgoQX3N1YmFnZW50X3J1bl9pZA'
    '==');

@$core.Deprecated('Use toolCallArgsEventDescriptor instead')
const ToolCallArgsEvent$json = {
  '1': 'ToolCallArgsEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {'1': 'tool_call_id', '3': 2, '4': 1, '5': 9, '10': 'toolCallId'},
    {'1': 'delta', '3': 3, '4': 1, '5': 9, '10': 'delta'},
    {
      '1': 'subagent_run_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'subagentRunId',
      '17': true
    },
  ],
  '8': [
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `ToolCallArgsEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolCallArgsEventDescriptor = $convert.base64Decode(
    'ChFUb29sQ2FsbEFyZ3NFdmVudBIvCgpiYXNlX2V2ZW50GAEgASgLMhAuYWdfdWkuQmFzZUV2ZW'
    '50UgliYXNlRXZlbnQSIAoMdG9vbF9jYWxsX2lkGAIgASgJUgp0b29sQ2FsbElkEhQKBWRlbHRh'
    'GAMgASgJUgVkZWx0YRIrCg9zdWJhZ2VudF9ydW5faWQYBCABKAlIAFINc3ViYWdlbnRSdW5JZI'
    'gBAUISChBfc3ViYWdlbnRfcnVuX2lk');

@$core.Deprecated('Use toolCallEndEventDescriptor instead')
const ToolCallEndEvent$json = {
  '1': 'ToolCallEndEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {'1': 'tool_call_id', '3': 2, '4': 1, '5': 9, '10': 'toolCallId'},
    {
      '1': 'subagent_run_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'subagentRunId',
      '17': true
    },
  ],
  '8': [
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `ToolCallEndEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolCallEndEventDescriptor = $convert.base64Decode(
    'ChBUb29sQ2FsbEVuZEV2ZW50Ei8KCmJhc2VfZXZlbnQYASABKAsyEC5hZ191aS5CYXNlRXZlbn'
    'RSCWJhc2VFdmVudBIgCgx0b29sX2NhbGxfaWQYAiABKAlSCnRvb2xDYWxsSWQSKwoPc3ViYWdl'
    'bnRfcnVuX2lkGAMgASgJSABSDXN1YmFnZW50UnVuSWSIAQFCEgoQX3N1YmFnZW50X3J1bl9pZA'
    '==');

@$core.Deprecated('Use toolCallChunkEventDescriptor instead')
const ToolCallChunkEvent$json = {
  '1': 'ToolCallChunkEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {
      '1': 'tool_call_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'toolCallId',
      '17': true
    },
    {
      '1': 'tool_call_name',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'toolCallName',
      '17': true
    },
    {
      '1': 'parent_message_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'parentMessageId',
      '17': true
    },
    {'1': 'delta', '3': 5, '4': 1, '5': 9, '9': 3, '10': 'delta', '17': true},
    {
      '1': 'subagent_run_id',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'subagentRunId',
      '17': true
    },
  ],
  '8': [
    {'1': '_tool_call_id'},
    {'1': '_tool_call_name'},
    {'1': '_parent_message_id'},
    {'1': '_delta'},
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `ToolCallChunkEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolCallChunkEventDescriptor = $convert.base64Decode(
    'ChJUb29sQ2FsbENodW5rRXZlbnQSLwoKYmFzZV9ldmVudBgBIAEoCzIQLmFnX3VpLkJhc2VFdm'
    'VudFIJYmFzZUV2ZW50EiUKDHRvb2xfY2FsbF9pZBgCIAEoCUgAUgp0b29sQ2FsbElkiAEBEikK'
    'DnRvb2xfY2FsbF9uYW1lGAMgASgJSAFSDHRvb2xDYWxsTmFtZYgBARIvChFwYXJlbnRfbWVzc2'
    'FnZV9pZBgEIAEoCUgCUg9wYXJlbnRNZXNzYWdlSWSIAQESGQoFZGVsdGEYBSABKAlIA1IFZGVs'
    'dGGIAQESKwoPc3ViYWdlbnRfcnVuX2lkGAYgASgJSARSDXN1YmFnZW50UnVuSWSIAQFCDwoNX3'
    'Rvb2xfY2FsbF9pZEIRCg9fdG9vbF9jYWxsX25hbWVCFAoSX3BhcmVudF9tZXNzYWdlX2lkQggK'
    'Bl9kZWx0YUISChBfc3ViYWdlbnRfcnVuX2lk');

@$core.Deprecated('Use toolCallResultEventDescriptor instead')
const ToolCallResultEvent$json = {
  '1': 'ToolCallResultEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {
      '1': 'subagent_run_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'subagentRunId',
      '17': true
    },
    {'1': 'message_id', '3': 3, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'tool_call_id', '3': 4, '4': 1, '5': 9, '10': 'toolCallId'},
    {
      '1': 'content',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'content',
      '17': true
    },
    {'1': 'role', '3': 6, '4': 1, '5': 9, '9': 2, '10': 'role', '17': true},
    {
      '1': 'content_parts',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.ag_ui.InputContent',
      '10': 'contentParts'
    },
  ],
  '8': [
    {'1': '_subagent_run_id'},
    {'1': '_content'},
    {'1': '_role'},
  ],
};

/// Descriptor for `ToolCallResultEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolCallResultEventDescriptor = $convert.base64Decode(
    'ChNUb29sQ2FsbFJlc3VsdEV2ZW50Ei8KCmJhc2VfZXZlbnQYASABKAsyEC5hZ191aS5CYXNlRX'
    'ZlbnRSCWJhc2VFdmVudBIrCg9zdWJhZ2VudF9ydW5faWQYAiABKAlIAFINc3ViYWdlbnRSdW5J'
    'ZIgBARIdCgptZXNzYWdlX2lkGAMgASgJUgltZXNzYWdlSWQSIAoMdG9vbF9jYWxsX2lkGAQgAS'
    'gJUgp0b29sQ2FsbElkEh0KB2NvbnRlbnQYBSABKAlIAVIHY29udGVudIgBARIXCgRyb2xlGAYg'
    'ASgJSAJSBHJvbGWIAQESOAoNY29udGVudF9wYXJ0cxgHIAMoCzITLmFnX3VpLklucHV0Q29udG'
    'VudFIMY29udGVudFBhcnRzQhIKEF9zdWJhZ2VudF9ydW5faWRCCgoIX2NvbnRlbnRCBwoFX3Jv'
    'bGU=');

@$core.Deprecated('Use stateSnapshotEventDescriptor instead')
const StateSnapshotEvent$json = {
  '1': 'StateSnapshotEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {
      '1': 'snapshot',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Value',
      '10': 'snapshot'
    },
    {
      '1': 'subagent_run_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'subagentRunId',
      '17': true
    },
  ],
  '8': [
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `StateSnapshotEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stateSnapshotEventDescriptor = $convert.base64Decode(
    'ChJTdGF0ZVNuYXBzaG90RXZlbnQSLwoKYmFzZV9ldmVudBgBIAEoCzIQLmFnX3VpLkJhc2VFdm'
    'VudFIJYmFzZUV2ZW50EjIKCHNuYXBzaG90GAIgASgLMhYuZ29vZ2xlLnByb3RvYnVmLlZhbHVl'
    'UghzbmFwc2hvdBIrCg9zdWJhZ2VudF9ydW5faWQYAyABKAlIAFINc3ViYWdlbnRSdW5JZIgBAU'
    'ISChBfc3ViYWdlbnRfcnVuX2lk');

@$core.Deprecated('Use stateDeltaEventDescriptor instead')
const StateDeltaEvent$json = {
  '1': 'StateDeltaEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {
      '1': 'delta',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.ag_ui.JsonPatchOperation',
      '10': 'delta'
    },
    {
      '1': 'subagent_run_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'subagentRunId',
      '17': true
    },
  ],
  '8': [
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `StateDeltaEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stateDeltaEventDescriptor = $convert.base64Decode(
    'Cg9TdGF0ZURlbHRhRXZlbnQSLwoKYmFzZV9ldmVudBgBIAEoCzIQLmFnX3VpLkJhc2VFdmVudF'
    'IJYmFzZUV2ZW50Ei8KBWRlbHRhGAIgAygLMhkuYWdfdWkuSnNvblBhdGNoT3BlcmF0aW9uUgVk'
    'ZWx0YRIrCg9zdWJhZ2VudF9ydW5faWQYAyABKAlIAFINc3ViYWdlbnRSdW5JZIgBAUISChBfc3'
    'ViYWdlbnRfcnVuX2lk');

@$core.Deprecated('Use messagesSnapshotEventDescriptor instead')
const MessagesSnapshotEvent$json = {
  '1': 'MessagesSnapshotEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {
      '1': 'messages',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.ag_ui.Message',
      '10': 'messages'
    },
  ],
};

/// Descriptor for `MessagesSnapshotEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messagesSnapshotEventDescriptor = $convert.base64Decode(
    'ChVNZXNzYWdlc1NuYXBzaG90RXZlbnQSLwoKYmFzZV9ldmVudBgBIAEoCzIQLmFnX3VpLkJhc2'
    'VFdmVudFIJYmFzZUV2ZW50EioKCG1lc3NhZ2VzGAIgAygLMg4uYWdfdWkuTWVzc2FnZVIIbWVz'
    'c2FnZXM=');

@$core.Deprecated('Use activitySnapshotEventDescriptor instead')
const ActivitySnapshotEvent$json = {
  '1': 'ActivitySnapshotEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {
      '1': 'subagent_run_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'subagentRunId',
      '17': true
    },
    {'1': 'message_id', '3': 3, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'activity_type', '3': 4, '4': 1, '5': 9, '10': 'activityType'},
    {
      '1': 'content',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Struct',
      '10': 'content'
    },
    {
      '1': 'replace',
      '3': 6,
      '4': 1,
      '5': 8,
      '9': 1,
      '10': 'replace',
      '17': true
    },
  ],
  '8': [
    {'1': '_subagent_run_id'},
    {'1': '_replace'},
  ],
};

/// Descriptor for `ActivitySnapshotEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List activitySnapshotEventDescriptor = $convert.base64Decode(
    'ChVBY3Rpdml0eVNuYXBzaG90RXZlbnQSLwoKYmFzZV9ldmVudBgBIAEoCzIQLmFnX3VpLkJhc2'
    'VFdmVudFIJYmFzZUV2ZW50EisKD3N1YmFnZW50X3J1bl9pZBgCIAEoCUgAUg1zdWJhZ2VudFJ1'
    'bklkiAEBEh0KCm1lc3NhZ2VfaWQYAyABKAlSCW1lc3NhZ2VJZBIjCg1hY3Rpdml0eV90eXBlGA'
    'QgASgJUgxhY3Rpdml0eVR5cGUSMQoHY29udGVudBgFIAEoCzIXLmdvb2dsZS5wcm90b2J1Zi5T'
    'dHJ1Y3RSB2NvbnRlbnQSHQoHcmVwbGFjZRgGIAEoCEgBUgdyZXBsYWNliAEBQhIKEF9zdWJhZ2'
    'VudF9ydW5faWRCCgoIX3JlcGxhY2U=');

@$core.Deprecated('Use activityDeltaEventDescriptor instead')
const ActivityDeltaEvent$json = {
  '1': 'ActivityDeltaEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {
      '1': 'subagent_run_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'subagentRunId',
      '17': true
    },
    {'1': 'message_id', '3': 3, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'activity_type', '3': 4, '4': 1, '5': 9, '10': 'activityType'},
    {
      '1': 'patch',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.ag_ui.JsonPatchOperation',
      '10': 'patch'
    },
  ],
  '8': [
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `ActivityDeltaEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List activityDeltaEventDescriptor = $convert.base64Decode(
    'ChJBY3Rpdml0eURlbHRhRXZlbnQSLwoKYmFzZV9ldmVudBgBIAEoCzIQLmFnX3VpLkJhc2VFdm'
    'VudFIJYmFzZUV2ZW50EisKD3N1YmFnZW50X3J1bl9pZBgCIAEoCUgAUg1zdWJhZ2VudFJ1bklk'
    'iAEBEh0KCm1lc3NhZ2VfaWQYAyABKAlSCW1lc3NhZ2VJZBIjCg1hY3Rpdml0eV90eXBlGAQgAS'
    'gJUgxhY3Rpdml0eVR5cGUSLwoFcGF0Y2gYBSADKAsyGS5hZ191aS5Kc29uUGF0Y2hPcGVyYXRp'
    'b25SBXBhdGNoQhIKEF9zdWJhZ2VudF9ydW5faWQ=');

@$core.Deprecated('Use rawEventDescriptor instead')
const RawEvent$json = {
  '1': 'RawEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {
      '1': 'event',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Value',
      '10': 'event'
    },
    {'1': 'source', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'source', '17': true},
    {
      '1': 'subagent_run_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'subagentRunId',
      '17': true
    },
  ],
  '8': [
    {'1': '_source'},
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `RawEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rawEventDescriptor = $convert.base64Decode(
    'CghSYXdFdmVudBIvCgpiYXNlX2V2ZW50GAEgASgLMhAuYWdfdWkuQmFzZUV2ZW50UgliYXNlRX'
    'ZlbnQSLAoFZXZlbnQYAiABKAsyFi5nb29nbGUucHJvdG9idWYuVmFsdWVSBWV2ZW50EhsKBnNv'
    'dXJjZRgDIAEoCUgAUgZzb3VyY2WIAQESKwoPc3ViYWdlbnRfcnVuX2lkGAQgASgJSAFSDXN1Ym'
    'FnZW50UnVuSWSIAQFCCQoHX3NvdXJjZUISChBfc3ViYWdlbnRfcnVuX2lk');

@$core.Deprecated('Use customEventDescriptor instead')
const CustomEvent$json = {
  '1': 'CustomEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'value',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Value',
      '10': 'value'
    },
    {
      '1': 'subagent_run_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'subagentRunId',
      '17': true
    },
  ],
  '8': [
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `CustomEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List customEventDescriptor = $convert.base64Decode(
    'CgtDdXN0b21FdmVudBIvCgpiYXNlX2V2ZW50GAEgASgLMhAuYWdfdWkuQmFzZUV2ZW50UgliYX'
    'NlRXZlbnQSEgoEbmFtZRgCIAEoCVIEbmFtZRIsCgV2YWx1ZRgDIAEoCzIWLmdvb2dsZS5wcm90'
    'b2J1Zi5WYWx1ZVIFdmFsdWUSKwoPc3ViYWdlbnRfcnVuX2lkGAQgASgJSABSDXN1YmFnZW50Un'
    'VuSWSIAQFCEgoQX3N1YmFnZW50X3J1bl9pZA==');

@$core.Deprecated('Use runStartedEventDescriptor instead')
const RunStartedEvent$json = {
  '1': 'RunStartedEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'run_id', '3': 3, '4': 1, '5': 9, '10': 'runId'},
    {
      '1': 'parent_run_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'parentRunId',
      '17': true
    },
    {
      '1': 'input',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.RunAgentInput',
      '9': 1,
      '10': 'input',
      '17': true
    },
    {
      '1': 'protocol_version',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'protocolVersion',
      '17': true
    },
  ],
  '8': [
    {'1': '_parent_run_id'},
    {'1': '_input'},
    {'1': '_protocol_version'},
  ],
};

/// Descriptor for `RunStartedEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runStartedEventDescriptor = $convert.base64Decode(
    'Cg9SdW5TdGFydGVkRXZlbnQSLwoKYmFzZV9ldmVudBgBIAEoCzIQLmFnX3VpLkJhc2VFdmVudF'
    'IJYmFzZUV2ZW50EhsKCXRocmVhZF9pZBgCIAEoCVIIdGhyZWFkSWQSFQoGcnVuX2lkGAMgASgJ'
    'UgVydW5JZBInCg1wYXJlbnRfcnVuX2lkGAQgASgJSABSC3BhcmVudFJ1bklkiAEBEi8KBWlucH'
    'V0GAUgASgLMhQuYWdfdWkuUnVuQWdlbnRJbnB1dEgBUgVpbnB1dIgBARIuChBwcm90b2NvbF92'
    'ZXJzaW9uGAYgASgJSAJSD3Byb3RvY29sVmVyc2lvbogBAUIQCg5fcGFyZW50X3J1bl9pZEIICg'
    'ZfaW5wdXRCEwoRX3Byb3RvY29sX3ZlcnNpb24=');

@$core.Deprecated('Use runFinishedEventDescriptor instead')
const RunFinishedEvent$json = {
  '1': 'RunFinishedEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'run_id', '3': 3, '4': 1, '5': 9, '10': 'runId'},
    {
      '1': 'result',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Value',
      '9': 0,
      '10': 'result',
      '17': true
    },
    {'1': 'outcome', '3': 5, '4': 1, '5': 9, '10': 'outcome'},
    {
      '1': 'interrupts',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.ag_ui.Interrupt',
      '10': 'interrupts'
    },
    {'1': 'usage', '3': 7, '4': 3, '5': 11, '6': '.ag_ui.Usage', '10': 'usage'},
    {
      '1': 'pending_tool_call_ids',
      '3': 8,
      '4': 3,
      '5': 9,
      '10': 'pendingToolCallIds'
    },
  ],
  '8': [
    {'1': '_result'},
  ],
};

/// Descriptor for `RunFinishedEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runFinishedEventDescriptor = $convert.base64Decode(
    'ChBSdW5GaW5pc2hlZEV2ZW50Ei8KCmJhc2VfZXZlbnQYASABKAsyEC5hZ191aS5CYXNlRXZlbn'
    'RSCWJhc2VFdmVudBIbCgl0aHJlYWRfaWQYAiABKAlSCHRocmVhZElkEhUKBnJ1bl9pZBgDIAEo'
    'CVIFcnVuSWQSMwoGcmVzdWx0GAQgASgLMhYuZ29vZ2xlLnByb3RvYnVmLlZhbHVlSABSBnJlc3'
    'VsdIgBARIYCgdvdXRjb21lGAUgASgJUgdvdXRjb21lEjAKCmludGVycnVwdHMYBiADKAsyEC5h'
    'Z191aS5JbnRlcnJ1cHRSCmludGVycnVwdHMSIgoFdXNhZ2UYByADKAsyDC5hZ191aS5Vc2FnZV'
    'IFdXNhZ2USMQoVcGVuZGluZ190b29sX2NhbGxfaWRzGAggAygJUhJwZW5kaW5nVG9vbENhbGxJ'
    'ZHNCCQoHX3Jlc3VsdA==');

@$core.Deprecated('Use runErrorEventDescriptor instead')
const RunErrorEvent$json = {
  '1': 'RunErrorEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {'1': 'code', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'code', '17': true},
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
    {'1': 'usage', '3': 4, '4': 3, '5': 11, '6': '.ag_ui.Usage', '10': 'usage'},
  ],
  '8': [
    {'1': '_code'},
  ],
};

/// Descriptor for `RunErrorEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runErrorEventDescriptor = $convert.base64Decode(
    'Cg1SdW5FcnJvckV2ZW50Ei8KCmJhc2VfZXZlbnQYASABKAsyEC5hZ191aS5CYXNlRXZlbnRSCW'
    'Jhc2VFdmVudBIXCgRjb2RlGAIgASgJSABSBGNvZGWIAQESGAoHbWVzc2FnZRgDIAEoCVIHbWVz'
    'c2FnZRIiCgV1c2FnZRgEIAMoCzIMLmFnX3VpLlVzYWdlUgV1c2FnZUIHCgVfY29kZQ==');

@$core.Deprecated('Use stepStartedEventDescriptor instead')
const StepStartedEvent$json = {
  '1': 'StepStartedEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {'1': 'step_name', '3': 2, '4': 1, '5': 9, '10': 'stepName'},
    {
      '1': 'subagent_run_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'subagentRunId',
      '17': true
    },
  ],
  '8': [
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `StepStartedEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stepStartedEventDescriptor = $convert.base64Decode(
    'ChBTdGVwU3RhcnRlZEV2ZW50Ei8KCmJhc2VfZXZlbnQYASABKAsyEC5hZ191aS5CYXNlRXZlbn'
    'RSCWJhc2VFdmVudBIbCglzdGVwX25hbWUYAiABKAlSCHN0ZXBOYW1lEisKD3N1YmFnZW50X3J1'
    'bl9pZBgDIAEoCUgAUg1zdWJhZ2VudFJ1bklkiAEBQhIKEF9zdWJhZ2VudF9ydW5faWQ=');

@$core.Deprecated('Use stepFinishedEventDescriptor instead')
const StepFinishedEvent$json = {
  '1': 'StepFinishedEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {'1': 'step_name', '3': 2, '4': 1, '5': 9, '10': 'stepName'},
    {
      '1': 'subagent_run_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'subagentRunId',
      '17': true
    },
  ],
  '8': [
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `StepFinishedEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stepFinishedEventDescriptor = $convert.base64Decode(
    'ChFTdGVwRmluaXNoZWRFdmVudBIvCgpiYXNlX2V2ZW50GAEgASgLMhAuYWdfdWkuQmFzZUV2ZW'
    '50UgliYXNlRXZlbnQSGwoJc3RlcF9uYW1lGAIgASgJUghzdGVwTmFtZRIrCg9zdWJhZ2VudF9y'
    'dW5faWQYAyABKAlIAFINc3ViYWdlbnRSdW5JZIgBAUISChBfc3ViYWdlbnRfcnVuX2lk');

@$core.Deprecated('Use reasoningStartEventDescriptor instead')
const ReasoningStartEvent$json = {
  '1': 'ReasoningStartEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {
      '1': 'subagent_run_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'subagentRunId',
      '17': true
    },
    {'1': 'message_id', '3': 3, '4': 1, '5': 9, '10': 'messageId'},
  ],
  '8': [
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `ReasoningStartEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reasoningStartEventDescriptor = $convert.base64Decode(
    'ChNSZWFzb25pbmdTdGFydEV2ZW50Ei8KCmJhc2VfZXZlbnQYASABKAsyEC5hZ191aS5CYXNlRX'
    'ZlbnRSCWJhc2VFdmVudBIrCg9zdWJhZ2VudF9ydW5faWQYAiABKAlIAFINc3ViYWdlbnRSdW5J'
    'ZIgBARIdCgptZXNzYWdlX2lkGAMgASgJUgltZXNzYWdlSWRCEgoQX3N1YmFnZW50X3J1bl9pZA'
    '==');

@$core.Deprecated('Use reasoningMessageStartEventDescriptor instead')
const ReasoningMessageStartEvent$json = {
  '1': 'ReasoningMessageStartEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {
      '1': 'subagent_run_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'subagentRunId',
      '17': true
    },
    {'1': 'message_id', '3': 3, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'role', '3': 4, '4': 1, '5': 9, '10': 'role'},
  ],
  '8': [
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `ReasoningMessageStartEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reasoningMessageStartEventDescriptor = $convert.base64Decode(
    'ChpSZWFzb25pbmdNZXNzYWdlU3RhcnRFdmVudBIvCgpiYXNlX2V2ZW50GAEgASgLMhAuYWdfdW'
    'kuQmFzZUV2ZW50UgliYXNlRXZlbnQSKwoPc3ViYWdlbnRfcnVuX2lkGAIgASgJSABSDXN1YmFn'
    'ZW50UnVuSWSIAQESHQoKbWVzc2FnZV9pZBgDIAEoCVIJbWVzc2FnZUlkEhIKBHJvbGUYBCABKA'
    'lSBHJvbGVCEgoQX3N1YmFnZW50X3J1bl9pZA==');

@$core.Deprecated('Use reasoningMessageContentEventDescriptor instead')
const ReasoningMessageContentEvent$json = {
  '1': 'ReasoningMessageContentEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {
      '1': 'subagent_run_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'subagentRunId',
      '17': true
    },
    {'1': 'message_id', '3': 3, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'delta', '3': 4, '4': 1, '5': 9, '10': 'delta'},
  ],
  '8': [
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `ReasoningMessageContentEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reasoningMessageContentEventDescriptor = $convert.base64Decode(
    'ChxSZWFzb25pbmdNZXNzYWdlQ29udGVudEV2ZW50Ei8KCmJhc2VfZXZlbnQYASABKAsyEC5hZ1'
    '91aS5CYXNlRXZlbnRSCWJhc2VFdmVudBIrCg9zdWJhZ2VudF9ydW5faWQYAiABKAlIAFINc3Vi'
    'YWdlbnRSdW5JZIgBARIdCgptZXNzYWdlX2lkGAMgASgJUgltZXNzYWdlSWQSFAoFZGVsdGEYBC'
    'ABKAlSBWRlbHRhQhIKEF9zdWJhZ2VudF9ydW5faWQ=');

@$core.Deprecated('Use reasoningMessageEndEventDescriptor instead')
const ReasoningMessageEndEvent$json = {
  '1': 'ReasoningMessageEndEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {
      '1': 'subagent_run_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'subagentRunId',
      '17': true
    },
    {'1': 'message_id', '3': 3, '4': 1, '5': 9, '10': 'messageId'},
  ],
  '8': [
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `ReasoningMessageEndEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reasoningMessageEndEventDescriptor = $convert.base64Decode(
    'ChhSZWFzb25pbmdNZXNzYWdlRW5kRXZlbnQSLwoKYmFzZV9ldmVudBgBIAEoCzIQLmFnX3VpLk'
    'Jhc2VFdmVudFIJYmFzZUV2ZW50EisKD3N1YmFnZW50X3J1bl9pZBgCIAEoCUgAUg1zdWJhZ2Vu'
    'dFJ1bklkiAEBEh0KCm1lc3NhZ2VfaWQYAyABKAlSCW1lc3NhZ2VJZEISChBfc3ViYWdlbnRfcn'
    'VuX2lk');

@$core.Deprecated('Use reasoningMessageChunkEventDescriptor instead')
const ReasoningMessageChunkEvent$json = {
  '1': 'ReasoningMessageChunkEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {
      '1': 'subagent_run_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'subagentRunId',
      '17': true
    },
    {
      '1': 'message_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'messageId',
      '17': true
    },
    {'1': 'delta', '3': 4, '4': 1, '5': 9, '9': 2, '10': 'delta', '17': true},
  ],
  '8': [
    {'1': '_subagent_run_id'},
    {'1': '_message_id'},
    {'1': '_delta'},
  ],
};

/// Descriptor for `ReasoningMessageChunkEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reasoningMessageChunkEventDescriptor = $convert.base64Decode(
    'ChpSZWFzb25pbmdNZXNzYWdlQ2h1bmtFdmVudBIvCgpiYXNlX2V2ZW50GAEgASgLMhAuYWdfdW'
    'kuQmFzZUV2ZW50UgliYXNlRXZlbnQSKwoPc3ViYWdlbnRfcnVuX2lkGAIgASgJSABSDXN1YmFn'
    'ZW50UnVuSWSIAQESIgoKbWVzc2FnZV9pZBgDIAEoCUgBUgltZXNzYWdlSWSIAQESGQoFZGVsdG'
    'EYBCABKAlIAlIFZGVsdGGIAQFCEgoQX3N1YmFnZW50X3J1bl9pZEINCgtfbWVzc2FnZV9pZEII'
    'CgZfZGVsdGE=');

@$core.Deprecated('Use reasoningEndEventDescriptor instead')
const ReasoningEndEvent$json = {
  '1': 'ReasoningEndEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {
      '1': 'subagent_run_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'subagentRunId',
      '17': true
    },
    {'1': 'message_id', '3': 3, '4': 1, '5': 9, '10': 'messageId'},
  ],
  '8': [
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `ReasoningEndEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reasoningEndEventDescriptor = $convert.base64Decode(
    'ChFSZWFzb25pbmdFbmRFdmVudBIvCgpiYXNlX2V2ZW50GAEgASgLMhAuYWdfdWkuQmFzZUV2ZW'
    '50UgliYXNlRXZlbnQSKwoPc3ViYWdlbnRfcnVuX2lkGAIgASgJSABSDXN1YmFnZW50UnVuSWSI'
    'AQESHQoKbWVzc2FnZV9pZBgDIAEoCVIJbWVzc2FnZUlkQhIKEF9zdWJhZ2VudF9ydW5faWQ=');

@$core.Deprecated('Use reasoningEncryptedValueEventDescriptor instead')
const ReasoningEncryptedValueEvent$json = {
  '1': 'ReasoningEncryptedValueEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {
      '1': 'subagent_run_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'subagentRunId',
      '17': true
    },
    {'1': 'subtype', '3': 3, '4': 1, '5': 9, '10': 'subtype'},
    {'1': 'entity_id', '3': 4, '4': 1, '5': 9, '10': 'entityId'},
    {'1': 'encrypted_value', '3': 5, '4': 1, '5': 9, '10': 'encryptedValue'},
  ],
  '8': [
    {'1': '_subagent_run_id'},
  ],
};

/// Descriptor for `ReasoningEncryptedValueEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reasoningEncryptedValueEventDescriptor = $convert.base64Decode(
    'ChxSZWFzb25pbmdFbmNyeXB0ZWRWYWx1ZUV2ZW50Ei8KCmJhc2VfZXZlbnQYASABKAsyEC5hZ1'
    '91aS5CYXNlRXZlbnRSCWJhc2VFdmVudBIrCg9zdWJhZ2VudF9ydW5faWQYAiABKAlIAFINc3Vi'
    'YWdlbnRSdW5JZIgBARIYCgdzdWJ0eXBlGAMgASgJUgdzdWJ0eXBlEhsKCWVudGl0eV9pZBgEIA'
    'EoCVIIZW50aXR5SWQSJwoPZW5jcnlwdGVkX3ZhbHVlGAUgASgJUg5lbmNyeXB0ZWRWYWx1ZUIS'
    'ChBfc3ViYWdlbnRfcnVuX2lk');

@$core.Deprecated('Use subagentStartedEventDescriptor instead')
const SubagentStartedEvent$json = {
  '1': 'SubagentStartedEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {'1': 'subagent_run_id', '3': 2, '4': 1, '5': 9, '10': 'subagentRunId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'description',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'description',
      '17': true
    },
    {
      '1': 'parent_subagent_run_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'parentSubagentRunId',
      '17': true
    },
    {
      '1': 'parent_tool_call_id',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'parentToolCallId',
      '17': true
    },
    {
      '1': 'parent_message_id',
      '3': 7,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'parentMessageId',
      '17': true
    },
  ],
  '8': [
    {'1': '_description'},
    {'1': '_parent_subagent_run_id'},
    {'1': '_parent_tool_call_id'},
    {'1': '_parent_message_id'},
  ],
};

/// Descriptor for `SubagentStartedEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subagentStartedEventDescriptor = $convert.base64Decode(
    'ChRTdWJhZ2VudFN0YXJ0ZWRFdmVudBIvCgpiYXNlX2V2ZW50GAEgASgLMhAuYWdfdWkuQmFzZU'
    'V2ZW50UgliYXNlRXZlbnQSJgoPc3ViYWdlbnRfcnVuX2lkGAIgASgJUg1zdWJhZ2VudFJ1bklk'
    'EhIKBG5hbWUYAyABKAlSBG5hbWUSJQoLZGVzY3JpcHRpb24YBCABKAlIAFILZGVzY3JpcHRpb2'
    '6IAQESOAoWcGFyZW50X3N1YmFnZW50X3J1bl9pZBgFIAEoCUgBUhNwYXJlbnRTdWJhZ2VudFJ1'
    'bklkiAEBEjIKE3BhcmVudF90b29sX2NhbGxfaWQYBiABKAlIAlIQcGFyZW50VG9vbENhbGxJZI'
    'gBARIvChFwYXJlbnRfbWVzc2FnZV9pZBgHIAEoCUgDUg9wYXJlbnRNZXNzYWdlSWSIAQFCDgoM'
    'X2Rlc2NyaXB0aW9uQhkKF19wYXJlbnRfc3ViYWdlbnRfcnVuX2lkQhYKFF9wYXJlbnRfdG9vbF'
    '9jYWxsX2lkQhQKEl9wYXJlbnRfbWVzc2FnZV9pZA==');

@$core.Deprecated('Use subagentFinishedEventDescriptor instead')
const SubagentFinishedEvent$json = {
  '1': 'SubagentFinishedEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {'1': 'subagent_run_id', '3': 2, '4': 1, '5': 9, '10': 'subagentRunId'},
    {
      '1': 'result',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Value',
      '9': 0,
      '10': 'result',
      '17': true
    },
    {'1': 'outcome', '3': 4, '4': 1, '5': 9, '10': 'outcome'},
    {'1': 'interrupt_ids', '3': 5, '4': 3, '5': 9, '10': 'interruptIds'},
  ],
  '8': [
    {'1': '_result'},
  ],
};

/// Descriptor for `SubagentFinishedEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subagentFinishedEventDescriptor = $convert.base64Decode(
    'ChVTdWJhZ2VudEZpbmlzaGVkRXZlbnQSLwoKYmFzZV9ldmVudBgBIAEoCzIQLmFnX3VpLkJhc2'
    'VFdmVudFIJYmFzZUV2ZW50EiYKD3N1YmFnZW50X3J1bl9pZBgCIAEoCVINc3ViYWdlbnRSdW5J'
    'ZBIzCgZyZXN1bHQYAyABKAsyFi5nb29nbGUucHJvdG9idWYuVmFsdWVIAFIGcmVzdWx0iAEBEh'
    'gKB291dGNvbWUYBCABKAlSB291dGNvbWUSIwoNaW50ZXJydXB0X2lkcxgFIAMoCVIMaW50ZXJy'
    'dXB0SWRzQgkKB19yZXN1bHQ=');

@$core.Deprecated('Use subagentErrorEventDescriptor instead')
const SubagentErrorEvent$json = {
  '1': 'SubagentErrorEvent',
  '2': [
    {
      '1': 'base_event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.BaseEvent',
      '10': 'baseEvent'
    },
    {'1': 'subagent_run_id', '3': 2, '4': 1, '5': 9, '10': 'subagentRunId'},
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
    {'1': 'code', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'code', '17': true},
  ],
  '8': [
    {'1': '_code'},
  ],
};

/// Descriptor for `SubagentErrorEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subagentErrorEventDescriptor = $convert.base64Decode(
    'ChJTdWJhZ2VudEVycm9yRXZlbnQSLwoKYmFzZV9ldmVudBgBIAEoCzIQLmFnX3VpLkJhc2VFdm'
    'VudFIJYmFzZUV2ZW50EiYKD3N1YmFnZW50X3J1bl9pZBgCIAEoCVINc3ViYWdlbnRSdW5JZBIY'
    'CgdtZXNzYWdlGAMgASgJUgdtZXNzYWdlEhcKBGNvZGUYBCABKAlIAFIEY29kZYgBAUIHCgVfY2'
    '9kZQ==');

@$core.Deprecated('Use eventDescriptor instead')
const Event$json = {
  '1': 'Event',
  '2': [
    {
      '1': 'text_message_start',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.TextMessageStartEvent',
      '9': 0,
      '10': 'textMessageStart'
    },
    {
      '1': 'text_message_content',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.TextMessageContentEvent',
      '9': 0,
      '10': 'textMessageContent'
    },
    {
      '1': 'text_message_end',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.TextMessageEndEvent',
      '9': 0,
      '10': 'textMessageEnd'
    },
    {
      '1': 'tool_call_start',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.ToolCallStartEvent',
      '9': 0,
      '10': 'toolCallStart'
    },
    {
      '1': 'tool_call_args',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.ToolCallArgsEvent',
      '9': 0,
      '10': 'toolCallArgs'
    },
    {
      '1': 'tool_call_end',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.ToolCallEndEvent',
      '9': 0,
      '10': 'toolCallEnd'
    },
    {
      '1': 'state_snapshot',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.StateSnapshotEvent',
      '9': 0,
      '10': 'stateSnapshot'
    },
    {
      '1': 'state_delta',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.StateDeltaEvent',
      '9': 0,
      '10': 'stateDelta'
    },
    {
      '1': 'messages_snapshot',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.MessagesSnapshotEvent',
      '9': 0,
      '10': 'messagesSnapshot'
    },
    {
      '1': 'raw',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.RawEvent',
      '9': 0,
      '10': 'raw'
    },
    {
      '1': 'custom',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.CustomEvent',
      '9': 0,
      '10': 'custom'
    },
    {
      '1': 'run_started',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.RunStartedEvent',
      '9': 0,
      '10': 'runStarted'
    },
    {
      '1': 'run_finished',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.RunFinishedEvent',
      '9': 0,
      '10': 'runFinished'
    },
    {
      '1': 'run_error',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.RunErrorEvent',
      '9': 0,
      '10': 'runError'
    },
    {
      '1': 'step_started',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.StepStartedEvent',
      '9': 0,
      '10': 'stepStarted'
    },
    {
      '1': 'step_finished',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.StepFinishedEvent',
      '9': 0,
      '10': 'stepFinished'
    },
    {
      '1': 'text_message_chunk',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.TextMessageChunkEvent',
      '9': 0,
      '10': 'textMessageChunk'
    },
    {
      '1': 'tool_call_chunk',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.ToolCallChunkEvent',
      '9': 0,
      '10': 'toolCallChunk'
    },
    {
      '1': 'subagent_started',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.SubagentStartedEvent',
      '9': 0,
      '10': 'subagentStarted'
    },
    {
      '1': 'subagent_finished',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.SubagentFinishedEvent',
      '9': 0,
      '10': 'subagentFinished'
    },
    {
      '1': 'subagent_error',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.SubagentErrorEvent',
      '9': 0,
      '10': 'subagentError'
    },
    {
      '1': 'tool_call_result',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.ToolCallResultEvent',
      '9': 0,
      '10': 'toolCallResult'
    },
    {
      '1': 'activity_snapshot',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.ActivitySnapshotEvent',
      '9': 0,
      '10': 'activitySnapshot'
    },
    {
      '1': 'activity_delta',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.ActivityDeltaEvent',
      '9': 0,
      '10': 'activityDelta'
    },
    {
      '1': 'reasoning_start',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.ReasoningStartEvent',
      '9': 0,
      '10': 'reasoningStart'
    },
    {
      '1': 'reasoning_message_start',
      '3': 26,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.ReasoningMessageStartEvent',
      '9': 0,
      '10': 'reasoningMessageStart'
    },
    {
      '1': 'reasoning_message_content',
      '3': 27,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.ReasoningMessageContentEvent',
      '9': 0,
      '10': 'reasoningMessageContent'
    },
    {
      '1': 'reasoning_message_end',
      '3': 28,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.ReasoningMessageEndEvent',
      '9': 0,
      '10': 'reasoningMessageEnd'
    },
    {
      '1': 'reasoning_message_chunk',
      '3': 29,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.ReasoningMessageChunkEvent',
      '9': 0,
      '10': 'reasoningMessageChunk'
    },
    {
      '1': 'reasoning_end',
      '3': 30,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.ReasoningEndEvent',
      '9': 0,
      '10': 'reasoningEnd'
    },
    {
      '1': 'reasoning_encrypted_value',
      '3': 31,
      '4': 1,
      '5': 11,
      '6': '.ag_ui.ReasoningEncryptedValueEvent',
      '9': 0,
      '10': 'reasoningEncryptedValue'
    },
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `Event`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventDescriptor = $convert.base64Decode(
    'CgVFdmVudBJMChJ0ZXh0X21lc3NhZ2Vfc3RhcnQYASABKAsyHC5hZ191aS5UZXh0TWVzc2FnZV'
    'N0YXJ0RXZlbnRIAFIQdGV4dE1lc3NhZ2VTdGFydBJSChR0ZXh0X21lc3NhZ2VfY29udGVudBgC'
    'IAEoCzIeLmFnX3VpLlRleHRNZXNzYWdlQ29udGVudEV2ZW50SABSEnRleHRNZXNzYWdlQ29udG'
    'VudBJGChB0ZXh0X21lc3NhZ2VfZW5kGAMgASgLMhouYWdfdWkuVGV4dE1lc3NhZ2VFbmRFdmVu'
    'dEgAUg50ZXh0TWVzc2FnZUVuZBJDCg90b29sX2NhbGxfc3RhcnQYBCABKAsyGS5hZ191aS5Ub2'
    '9sQ2FsbFN0YXJ0RXZlbnRIAFINdG9vbENhbGxTdGFydBJACg50b29sX2NhbGxfYXJncxgFIAEo'
    'CzIYLmFnX3VpLlRvb2xDYWxsQXJnc0V2ZW50SABSDHRvb2xDYWxsQXJncxI9Cg10b29sX2NhbG'
    'xfZW5kGAYgASgLMhcuYWdfdWkuVG9vbENhbGxFbmRFdmVudEgAUgt0b29sQ2FsbEVuZBJCCg5z'
    'dGF0ZV9zbmFwc2hvdBgHIAEoCzIZLmFnX3VpLlN0YXRlU25hcHNob3RFdmVudEgAUg1zdGF0ZV'
    'NuYXBzaG90EjkKC3N0YXRlX2RlbHRhGAggASgLMhYuYWdfdWkuU3RhdGVEZWx0YUV2ZW50SABS'
    'CnN0YXRlRGVsdGESSwoRbWVzc2FnZXNfc25hcHNob3QYCSABKAsyHC5hZ191aS5NZXNzYWdlc1'
    'NuYXBzaG90RXZlbnRIAFIQbWVzc2FnZXNTbmFwc2hvdBIjCgNyYXcYCiABKAsyDy5hZ191aS5S'
    'YXdFdmVudEgAUgNyYXcSLAoGY3VzdG9tGAsgASgLMhIuYWdfdWkuQ3VzdG9tRXZlbnRIAFIGY3'
    'VzdG9tEjkKC3J1bl9zdGFydGVkGAwgASgLMhYuYWdfdWkuUnVuU3RhcnRlZEV2ZW50SABSCnJ1'
    'blN0YXJ0ZWQSPAoMcnVuX2ZpbmlzaGVkGA0gASgLMhcuYWdfdWkuUnVuRmluaXNoZWRFdmVudE'
    'gAUgtydW5GaW5pc2hlZBIzCglydW5fZXJyb3IYDiABKAsyFC5hZ191aS5SdW5FcnJvckV2ZW50'
    'SABSCHJ1bkVycm9yEjwKDHN0ZXBfc3RhcnRlZBgPIAEoCzIXLmFnX3VpLlN0ZXBTdGFydGVkRX'
    'ZlbnRIAFILc3RlcFN0YXJ0ZWQSPwoNc3RlcF9maW5pc2hlZBgQIAEoCzIYLmFnX3VpLlN0ZXBG'
    'aW5pc2hlZEV2ZW50SABSDHN0ZXBGaW5pc2hlZBJMChJ0ZXh0X21lc3NhZ2VfY2h1bmsYESABKA'
    'syHC5hZ191aS5UZXh0TWVzc2FnZUNodW5rRXZlbnRIAFIQdGV4dE1lc3NhZ2VDaHVuaxJDCg90'
    'b29sX2NhbGxfY2h1bmsYEiABKAsyGS5hZ191aS5Ub29sQ2FsbENodW5rRXZlbnRIAFINdG9vbE'
    'NhbGxDaHVuaxJIChBzdWJhZ2VudF9zdGFydGVkGBMgASgLMhsuYWdfdWkuU3ViYWdlbnRTdGFy'
    'dGVkRXZlbnRIAFIPc3ViYWdlbnRTdGFydGVkEksKEXN1YmFnZW50X2ZpbmlzaGVkGBQgASgLMh'
    'wuYWdfdWkuU3ViYWdlbnRGaW5pc2hlZEV2ZW50SABSEHN1YmFnZW50RmluaXNoZWQSQgoOc3Vi'
    'YWdlbnRfZXJyb3IYFSABKAsyGS5hZ191aS5TdWJhZ2VudEVycm9yRXZlbnRIAFINc3ViYWdlbn'
    'RFcnJvchJGChB0b29sX2NhbGxfcmVzdWx0GBYgASgLMhouYWdfdWkuVG9vbENhbGxSZXN1bHRF'
    'dmVudEgAUg50b29sQ2FsbFJlc3VsdBJLChFhY3Rpdml0eV9zbmFwc2hvdBgXIAEoCzIcLmFnX3'
    'VpLkFjdGl2aXR5U25hcHNob3RFdmVudEgAUhBhY3Rpdml0eVNuYXBzaG90EkIKDmFjdGl2aXR5'
    'X2RlbHRhGBggASgLMhkuYWdfdWkuQWN0aXZpdHlEZWx0YUV2ZW50SABSDWFjdGl2aXR5RGVsdG'
    'ESRQoPcmVhc29uaW5nX3N0YXJ0GBkgASgLMhouYWdfdWkuUmVhc29uaW5nU3RhcnRFdmVudEgA'
    'Ug5yZWFzb25pbmdTdGFydBJbChdyZWFzb25pbmdfbWVzc2FnZV9zdGFydBgaIAEoCzIhLmFnX3'
    'VpLlJlYXNvbmluZ01lc3NhZ2VTdGFydEV2ZW50SABSFXJlYXNvbmluZ01lc3NhZ2VTdGFydBJh'
    'ChlyZWFzb25pbmdfbWVzc2FnZV9jb250ZW50GBsgASgLMiMuYWdfdWkuUmVhc29uaW5nTWVzc2'
    'FnZUNvbnRlbnRFdmVudEgAUhdyZWFzb25pbmdNZXNzYWdlQ29udGVudBJVChVyZWFzb25pbmdf'
    'bWVzc2FnZV9lbmQYHCABKAsyHy5hZ191aS5SZWFzb25pbmdNZXNzYWdlRW5kRXZlbnRIAFITcm'
    'Vhc29uaW5nTWVzc2FnZUVuZBJbChdyZWFzb25pbmdfbWVzc2FnZV9jaHVuaxgdIAEoCzIhLmFn'
    'X3VpLlJlYXNvbmluZ01lc3NhZ2VDaHVua0V2ZW50SABSFXJlYXNvbmluZ01lc3NhZ2VDaHVuax'
    'I/Cg1yZWFzb25pbmdfZW5kGB4gASgLMhguYWdfdWkuUmVhc29uaW5nRW5kRXZlbnRIAFIMcmVh'
    'c29uaW5nRW5kEmEKGXJlYXNvbmluZ19lbmNyeXB0ZWRfdmFsdWUYHyABKAsyIy5hZ191aS5SZW'
    'Fzb25pbmdFbmNyeXB0ZWRWYWx1ZUV2ZW50SABSF3JlYXNvbmluZ0VuY3J5cHRlZFZhbHVlQgcK'
    'BWV2ZW50');

@$core.Deprecated('Use usageDescriptor instead')
const Usage$json = {
  '1': 'Usage',
  '2': [
    {
      '1': 'provider',
      '3': 1,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'provider',
      '17': true
    },
    {'1': 'model', '3': 2, '4': 1, '5': 9, '9': 1, '10': 'model', '17': true},
    {
      '1': 'input_tokens',
      '3': 3,
      '4': 1,
      '5': 3,
      '9': 2,
      '10': 'inputTokens',
      '17': true
    },
    {
      '1': 'output_tokens',
      '3': 4,
      '4': 1,
      '5': 3,
      '9': 3,
      '10': 'outputTokens',
      '17': true
    },
    {
      '1': 'total_tokens',
      '3': 5,
      '4': 1,
      '5': 3,
      '9': 4,
      '10': 'totalTokens',
      '17': true
    },
    {
      '1': 'reasoning_tokens',
      '3': 6,
      '4': 1,
      '5': 3,
      '9': 5,
      '10': 'reasoningTokens',
      '17': true
    },
    {
      '1': 'cached_input_tokens',
      '3': 7,
      '4': 1,
      '5': 3,
      '9': 6,
      '10': 'cachedInputTokens',
      '17': true
    },
    {
      '1': 'cache_write_input_tokens',
      '3': 8,
      '4': 1,
      '5': 3,
      '9': 7,
      '10': 'cacheWriteInputTokens',
      '17': true
    },
  ],
  '8': [
    {'1': '_provider'},
    {'1': '_model'},
    {'1': '_input_tokens'},
    {'1': '_output_tokens'},
    {'1': '_total_tokens'},
    {'1': '_reasoning_tokens'},
    {'1': '_cached_input_tokens'},
    {'1': '_cache_write_input_tokens'},
  ],
};

/// Descriptor for `Usage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List usageDescriptor = $convert.base64Decode(
    'CgVVc2FnZRIfCghwcm92aWRlchgBIAEoCUgAUghwcm92aWRlcogBARIZCgVtb2RlbBgCIAEoCU'
    'gBUgVtb2RlbIgBARImCgxpbnB1dF90b2tlbnMYAyABKANIAlILaW5wdXRUb2tlbnOIAQESKAoN'
    'b3V0cHV0X3Rva2VucxgEIAEoA0gDUgxvdXRwdXRUb2tlbnOIAQESJgoMdG90YWxfdG9rZW5zGA'
    'UgASgDSARSC3RvdGFsVG9rZW5ziAEBEi4KEHJlYXNvbmluZ190b2tlbnMYBiABKANIBVIPcmVh'
    'c29uaW5nVG9rZW5ziAEBEjMKE2NhY2hlZF9pbnB1dF90b2tlbnMYByABKANIBlIRY2FjaGVkSW'
    '5wdXRUb2tlbnOIAQESPAoYY2FjaGVfd3JpdGVfaW5wdXRfdG9rZW5zGAggASgDSAdSFWNhY2hl'
    'V3JpdGVJbnB1dFRva2Vuc4gBAUILCglfcHJvdmlkZXJCCAoGX21vZGVsQg8KDV9pbnB1dF90b2'
    'tlbnNCEAoOX291dHB1dF90b2tlbnNCDwoNX3RvdGFsX3Rva2Vuc0ITChFfcmVhc29uaW5nX3Rv'
    'a2Vuc0IWChRfY2FjaGVkX2lucHV0X3Rva2Vuc0IbChlfY2FjaGVfd3JpdGVfaW5wdXRfdG9rZW'
    '5z');
