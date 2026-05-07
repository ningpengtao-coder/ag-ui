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
  ],
};

/// Descriptor for `EventType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List eventTypeDescriptor = $convert.base64Decode(
    'CglFdmVudFR5cGUSFgoSVEVYVF9NRVNTQUdFX1NUQVJUEAASGAoUVEVYVF9NRVNTQUdFX0NPTl'
    'RFTlQQARIUChBURVhUX01FU1NBR0VfRU5EEAISEwoPVE9PTF9DQUxMX1NUQVJUEAMSEgoOVE9P'
    'TF9DQUxMX0FSR1MQBBIRCg1UT09MX0NBTExfRU5EEAUSEgoOU1RBVEVfU05BUFNIT1QQBhIPCg'
    'tTVEFURV9ERUxUQRAHEhUKEU1FU1NBR0VTX1NOQVBTSE9UEAgSBwoDUkFXEAkSCgoGQ1VTVE9N'
    'EAoSDwoLUlVOX1NUQVJURUQQCxIQCgxSVU5fRklOSVNIRUQQDBINCglSVU5fRVJST1IQDRIQCg'
    'xTVEVQX1NUQVJURUQQDhIRCg1TVEVQX0ZJTklTSEVEEA8=');

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
  ],
  '8': [
    {'1': '_timestamp'},
    {'1': '_raw_event'},
  ],
};

/// Descriptor for `BaseEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List baseEventDescriptor = $convert.base64Decode(
    'CglCYXNlRXZlbnQSJAoEdHlwZRgBIAEoDjIQLmFnX3VpLkV2ZW50VHlwZVIEdHlwZRIhCgl0aW'
    '1lc3RhbXAYAiABKANIAFIJdGltZXN0YW1wiAEBEjgKCXJhd19ldmVudBgDIAEoCzIWLmdvb2ds'
    'ZS5wcm90b2J1Zi5WYWx1ZUgBUghyYXdFdmVudIgBAUIMCgpfdGltZXN0YW1wQgwKCl9yYXdfZX'
    'ZlbnQ=');

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
  ],
  '8': [
    {'1': '_role'},
    {'1': '_name'},
  ],
};

/// Descriptor for `TextMessageStartEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textMessageStartEventDescriptor = $convert.base64Decode(
    'ChVUZXh0TWVzc2FnZVN0YXJ0RXZlbnQSLwoKYmFzZV9ldmVudBgBIAEoCzIQLmFnX3VpLkJhc2'
    'VFdmVudFIJYmFzZUV2ZW50Eh0KCm1lc3NhZ2VfaWQYAiABKAlSCW1lc3NhZ2VJZBIXCgRyb2xl'
    'GAMgASgJSABSBHJvbGWIAQESFwoEbmFtZRgEIAEoCUgBUgRuYW1liAEBQgcKBV9yb2xlQgcKBV'
    '9uYW1l');

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
  ],
};

/// Descriptor for `TextMessageContentEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textMessageContentEventDescriptor = $convert.base64Decode(
    'ChdUZXh0TWVzc2FnZUNvbnRlbnRFdmVudBIvCgpiYXNlX2V2ZW50GAEgASgLMhAuYWdfdWkuQm'
    'FzZUV2ZW50UgliYXNlRXZlbnQSHQoKbWVzc2FnZV9pZBgCIAEoCVIJbWVzc2FnZUlkEhQKBWRl'
    'bHRhGAMgASgJUgVkZWx0YQ==');

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
  ],
};

/// Descriptor for `TextMessageEndEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textMessageEndEventDescriptor = $convert.base64Decode(
    'ChNUZXh0TWVzc2FnZUVuZEV2ZW50Ei8KCmJhc2VfZXZlbnQYASABKAsyEC5hZ191aS5CYXNlRX'
    'ZlbnRSCWJhc2VFdmVudBIdCgptZXNzYWdlX2lkGAIgASgJUgltZXNzYWdlSWQ=');

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
  ],
  '8': [
    {'1': '_parent_message_id'},
  ],
};

/// Descriptor for `ToolCallStartEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolCallStartEventDescriptor = $convert.base64Decode(
    'ChJUb29sQ2FsbFN0YXJ0RXZlbnQSLwoKYmFzZV9ldmVudBgBIAEoCzIQLmFnX3VpLkJhc2VFdm'
    'VudFIJYmFzZUV2ZW50EiAKDHRvb2xfY2FsbF9pZBgCIAEoCVIKdG9vbENhbGxJZBIkCg50b29s'
    'X2NhbGxfbmFtZRgDIAEoCVIMdG9vbENhbGxOYW1lEi8KEXBhcmVudF9tZXNzYWdlX2lkGAQgAS'
    'gJSABSD3BhcmVudE1lc3NhZ2VJZIgBAUIUChJfcGFyZW50X21lc3NhZ2VfaWQ=');

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
  ],
};

/// Descriptor for `ToolCallArgsEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolCallArgsEventDescriptor = $convert.base64Decode(
    'ChFUb29sQ2FsbEFyZ3NFdmVudBIvCgpiYXNlX2V2ZW50GAEgASgLMhAuYWdfdWkuQmFzZUV2ZW'
    '50UgliYXNlRXZlbnQSIAoMdG9vbF9jYWxsX2lkGAIgASgJUgp0b29sQ2FsbElkEhQKBWRlbHRh'
    'GAMgASgJUgVkZWx0YQ==');

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
  ],
};

/// Descriptor for `ToolCallEndEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolCallEndEventDescriptor = $convert.base64Decode(
    'ChBUb29sQ2FsbEVuZEV2ZW50Ei8KCmJhc2VfZXZlbnQYASABKAsyEC5hZ191aS5CYXNlRXZlbn'
    'RSCWJhc2VFdmVudBIgCgx0b29sX2NhbGxfaWQYAiABKAlSCnRvb2xDYWxsSWQ=');

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
  ],
};

/// Descriptor for `StateSnapshotEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stateSnapshotEventDescriptor = $convert.base64Decode(
    'ChJTdGF0ZVNuYXBzaG90RXZlbnQSLwoKYmFzZV9ldmVudBgBIAEoCzIQLmFnX3VpLkJhc2VFdm'
    'VudFIJYmFzZUV2ZW50EjIKCHNuYXBzaG90GAIgASgLMhYuZ29vZ2xlLnByb3RvYnVmLlZhbHVl'
    'UghzbmFwc2hvdA==');

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
  ],
};

/// Descriptor for `StateDeltaEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stateDeltaEventDescriptor = $convert.base64Decode(
    'Cg9TdGF0ZURlbHRhRXZlbnQSLwoKYmFzZV9ldmVudBgBIAEoCzIQLmFnX3VpLkJhc2VFdmVudF'
    'IJYmFzZUV2ZW50Ei8KBWRlbHRhGAIgAygLMhkuYWdfdWkuSnNvblBhdGNoT3BlcmF0aW9uUgVk'
    'ZWx0YQ==');

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
  ],
  '8': [
    {'1': '_source'},
  ],
};

/// Descriptor for `RawEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rawEventDescriptor = $convert.base64Decode(
    'CghSYXdFdmVudBIvCgpiYXNlX2V2ZW50GAEgASgLMhAuYWdfdWkuQmFzZUV2ZW50UgliYXNlRX'
    'ZlbnQSLAoFZXZlbnQYAiABKAsyFi5nb29nbGUucHJvdG9idWYuVmFsdWVSBWV2ZW50EhsKBnNv'
    'dXJjZRgDIAEoCUgAUgZzb3VyY2WIAQFCCQoHX3NvdXJjZQ==');

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
      '9': 0,
      '10': 'value',
      '17': true
    },
  ],
  '8': [
    {'1': '_value'},
  ],
};

/// Descriptor for `CustomEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List customEventDescriptor = $convert.base64Decode(
    'CgtDdXN0b21FdmVudBIvCgpiYXNlX2V2ZW50GAEgASgLMhAuYWdfdWkuQmFzZUV2ZW50UgliYX'
    'NlRXZlbnQSEgoEbmFtZRgCIAEoCVIEbmFtZRIxCgV2YWx1ZRgDIAEoCzIWLmdvb2dsZS5wcm90'
    'b2J1Zi5WYWx1ZUgAUgV2YWx1ZYgBAUIICgZfdmFsdWU=');

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
  ],
};

/// Descriptor for `RunStartedEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runStartedEventDescriptor = $convert.base64Decode(
    'Cg9SdW5TdGFydGVkRXZlbnQSLwoKYmFzZV9ldmVudBgBIAEoCzIQLmFnX3VpLkJhc2VFdmVudF'
    'IJYmFzZUV2ZW50EhsKCXRocmVhZF9pZBgCIAEoCVIIdGhyZWFkSWQSFQoGcnVuX2lkGAMgASgJ'
    'UgVydW5JZA==');

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
    'Z191aS5JbnRlcnJ1cHRSCmludGVycnVwdHNCCQoHX3Jlc3VsdA==');

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
  ],
  '8': [
    {'1': '_code'},
  ],
};

/// Descriptor for `RunErrorEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runErrorEventDescriptor = $convert.base64Decode(
    'Cg1SdW5FcnJvckV2ZW50Ei8KCmJhc2VfZXZlbnQYASABKAsyEC5hZ191aS5CYXNlRXZlbnRSCW'
    'Jhc2VFdmVudBIXCgRjb2RlGAIgASgJSABSBGNvZGWIAQESGAoHbWVzc2FnZRgDIAEoCVIHbWVz'
    'c2FnZUIHCgVfY29kZQ==');

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
  ],
};

/// Descriptor for `StepStartedEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stepStartedEventDescriptor = $convert.base64Decode(
    'ChBTdGVwU3RhcnRlZEV2ZW50Ei8KCmJhc2VfZXZlbnQYASABKAsyEC5hZ191aS5CYXNlRXZlbn'
    'RSCWJhc2VFdmVudBIbCglzdGVwX25hbWUYAiABKAlSCHN0ZXBOYW1l');

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
  ],
};

/// Descriptor for `StepFinishedEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stepFinishedEventDescriptor = $convert.base64Decode(
    'ChFTdGVwRmluaXNoZWRFdmVudBIvCgpiYXNlX2V2ZW50GAEgASgLMhAuYWdfdWkuQmFzZUV2ZW'
    '50UgliYXNlRXZlbnQSGwoJc3RlcF9uYW1lGAIgASgJUghzdGVwTmFtZQ==');

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
  ],
  '8': [
    {'1': '_message_id'},
    {'1': '_role'},
    {'1': '_delta'},
    {'1': '_name'},
  ],
};

/// Descriptor for `TextMessageChunkEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textMessageChunkEventDescriptor = $convert.base64Decode(
    'ChVUZXh0TWVzc2FnZUNodW5rRXZlbnQSLwoKYmFzZV9ldmVudBgBIAEoCzIQLmFnX3VpLkJhc2'
    'VFdmVudFIJYmFzZUV2ZW50EiIKCm1lc3NhZ2VfaWQYAiABKAlIAFIJbWVzc2FnZUlkiAEBEhcK'
    'BHJvbGUYAyABKAlIAVIEcm9sZYgBARIZCgVkZWx0YRgEIAEoCUgCUgVkZWx0YYgBARIXCgRuYW'
    '1lGAUgASgJSANSBG5hbWWIAQFCDQoLX21lc3NhZ2VfaWRCBwoFX3JvbGVCCAoGX2RlbHRhQgcK'
    'BV9uYW1l');

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
  ],
  '8': [
    {'1': '_tool_call_id'},
    {'1': '_tool_call_name'},
    {'1': '_parent_message_id'},
    {'1': '_delta'},
  ],
};

/// Descriptor for `ToolCallChunkEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toolCallChunkEventDescriptor = $convert.base64Decode(
    'ChJUb29sQ2FsbENodW5rRXZlbnQSLwoKYmFzZV9ldmVudBgBIAEoCzIQLmFnX3VpLkJhc2VFdm'
    'VudFIJYmFzZUV2ZW50EiUKDHRvb2xfY2FsbF9pZBgCIAEoCUgAUgp0b29sQ2FsbElkiAEBEikK'
    'DnRvb2xfY2FsbF9uYW1lGAMgASgJSAFSDHRvb2xDYWxsTmFtZYgBARIvChFwYXJlbnRfbWVzc2'
    'FnZV9pZBgEIAEoCUgCUg9wYXJlbnRNZXNzYWdlSWSIAQESGQoFZGVsdGEYBSABKAlIA1IFZGVs'
    'dGGIAQFCDwoNX3Rvb2xfY2FsbF9pZEIRCg9fdG9vbF9jYWxsX25hbWVCFAoSX3BhcmVudF9tZX'
    'NzYWdlX2lkQggKBl9kZWx0YQ==');

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
    'NhbGxDaHVua0IHCgVldmVudA==');
