library;

import 'dart:typed_data';

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/well_known_types/google/protobuf/struct.pb.dart' as $struct;

import '../events/events.dart';
import '../types/base.dart';
import '../types/context.dart';
import '../types/message.dart';
import '../types/tool.dart';
import 'generated/events.pb.dart' as $proto_events;
import 'generated/patch.pb.dart' as $proto_patch;
import 'generated/patch.pbenum.dart' as $proto_patch_enum;
import 'generated/types.pb.dart' as $proto_types;

const String agUiMediaType = 'application/vnd.ag-ui.event+proto';

Uint8List encodeProto(BaseEvent event) {
  return Uint8List.fromList(_toProtoEnvelope(event).writeToBuffer());
}

BaseEvent decodeProto(Uint8List data) {
  if (data.isEmpty) {
    throw ArgumentError('Invalid event');
  }

  return _fromProtoEnvelope($proto_events.Event.fromBuffer(data));
}

Uint8List encodeProtoFrame(BaseEvent event) {
  final payload = encodeProto(event);
  final framed = Uint8List(4 + payload.length);
  final header = ByteData.sublistView(framed, 0, 4);
  header.setUint32(0, payload.length, Endian.big);
  framed.setRange(4, framed.length, payload);
  return framed;
}

bool isProtoFrame(Uint8List data) {
  if (data.length < 4) {
    return false;
  }

  final header = ByteData.sublistView(data, 0, 4);
  final payloadLength = header.getUint32(0, Endian.big);
  return payloadLength == data.length - 4;
}

BaseEvent decodeProtoFrame(Uint8List data) {
  if (data.length < 4) {
    throw ArgumentError('Invalid event frame');
  }

  final header = ByteData.sublistView(data, 0, 4);
  final payloadLength = header.getUint32(0, Endian.big);
  if (payloadLength != data.length - 4) {
    throw ArgumentError('Invalid event frame');
  }

  return decodeProto(Uint8List.sublistView(data, 4));
}

$proto_events.Event _toProtoEnvelope(BaseEvent event) {
  switch (event) {
    case TextMessageStartEvent():
      return $proto_events.Event(
        textMessageStart: $proto_events.TextMessageStartEvent(
          baseEvent: _toProtoBaseEvent(event, $proto_events.EventType.TEXT_MESSAGE_START),
          messageId: event.messageId,
          role: event.role.value,
          name: event.name,
        ),
      );
    case TextMessageContentEvent():
      return $proto_events.Event(
        textMessageContent: $proto_events.TextMessageContentEvent(
          baseEvent: _toProtoBaseEvent(event, $proto_events.EventType.TEXT_MESSAGE_CONTENT),
          messageId: event.messageId,
          delta: event.delta,
        ),
      );
    case TextMessageEndEvent():
      return $proto_events.Event(
        textMessageEnd: $proto_events.TextMessageEndEvent(
          baseEvent: _toProtoBaseEvent(event, $proto_events.EventType.TEXT_MESSAGE_END),
          messageId: event.messageId,
        ),
      );
    case ToolCallStartEvent():
      return $proto_events.Event(
        toolCallStart: $proto_events.ToolCallStartEvent(
          baseEvent: _toProtoBaseEvent(event, $proto_events.EventType.TOOL_CALL_START),
          toolCallId: event.toolCallId,
          toolCallName: event.toolCallName,
          parentMessageId: event.parentMessageId,
        ),
      );
    case ToolCallArgsEvent():
      return $proto_events.Event(
        toolCallArgs: $proto_events.ToolCallArgsEvent(
          baseEvent: _toProtoBaseEvent(event, $proto_events.EventType.TOOL_CALL_ARGS),
          toolCallId: event.toolCallId,
          delta: event.delta,
        ),
      );
    case ToolCallEndEvent():
      return $proto_events.Event(
        toolCallEnd: $proto_events.ToolCallEndEvent(
          baseEvent: _toProtoBaseEvent(event, $proto_events.EventType.TOOL_CALL_END),
          toolCallId: event.toolCallId,
        ),
      );
    case StateSnapshotEvent():
      return $proto_events.Event(
        stateSnapshot: $proto_events.StateSnapshotEvent(
          baseEvent: _toProtoBaseEvent(event, $proto_events.EventType.STATE_SNAPSHOT),
          snapshot: _toProtoValue(event.snapshot),
        ),
      );
    case StateDeltaEvent():
      return $proto_events.Event(
        stateDelta: $proto_events.StateDeltaEvent(
          baseEvent: _toProtoBaseEvent(event, $proto_events.EventType.STATE_DELTA),
          delta: event.delta.map(_toProtoPatchOperation),
        ),
      );
    case MessagesSnapshotEvent():
      return $proto_events.Event(
        messagesSnapshot: $proto_events.MessagesSnapshotEvent(
          baseEvent: _toProtoBaseEvent(event, $proto_events.EventType.MESSAGES_SNAPSHOT),
          messages: event.messages.map(_toProtoMessage),
        ),
      );
    case RawEvent():
      return $proto_events.Event(
        raw: $proto_events.RawEvent(
          baseEvent: _toProtoBaseEvent(event, $proto_events.EventType.RAW),
          event: _toProtoValue(event.event),
          source: event.source,
        ),
      );
    case CustomEvent():
      return $proto_events.Event(
        custom: $proto_events.CustomEvent(
          baseEvent: _toProtoBaseEvent(event, $proto_events.EventType.CUSTOM),
          name: event.name,
          value: event.value == null ? null : _toProtoValue(event.value),
        ),
      );
    case RunStartedEvent():
      return $proto_events.Event(
        runStarted: $proto_events.RunStartedEvent(
          baseEvent: _toProtoBaseEvent(event, $proto_events.EventType.RUN_STARTED),
          threadId: event.threadId,
          runId: event.runId,
        ),
      );
    case RunFinishedEvent():
      final outcome = event.outcome;
      final Iterable<$proto_types.Interrupt> interrupts = switch (outcome) {
        RunFinishedInterruptOutcome() => outcome.interrupts.map(_toProtoInterrupt),
        _ => const <$proto_types.Interrupt>[],
      };
      final wireOutcome = switch (outcome) {
        RunFinishedSuccessOutcome() => 'success',
        RunFinishedInterruptOutcome() => 'interrupt',
        _ => '',
      };

      return $proto_events.Event(
        runFinished: $proto_events.RunFinishedEvent(
          baseEvent: _toProtoBaseEvent(event, $proto_events.EventType.RUN_FINISHED),
          threadId: event.threadId,
          runId: event.runId,
          result: event.result == null ? null : _toProtoValue(event.result),
          outcome: wireOutcome,
          interrupts: interrupts,
        ),
      );
    case RunErrorEvent():
      return $proto_events.Event(
        runError: $proto_events.RunErrorEvent(
          baseEvent: _toProtoBaseEvent(event, $proto_events.EventType.RUN_ERROR),
          code: event.code,
          message: event.message,
        ),
      );
    case StepStartedEvent():
      return $proto_events.Event(
        stepStarted: $proto_events.StepStartedEvent(
          baseEvent: _toProtoBaseEvent(event, $proto_events.EventType.STEP_STARTED),
          stepName: event.stepName,
        ),
      );
    case StepFinishedEvent():
      return $proto_events.Event(
        stepFinished: $proto_events.StepFinishedEvent(
          baseEvent: _toProtoBaseEvent(event, $proto_events.EventType.STEP_FINISHED),
          stepName: event.stepName,
        ),
      );
    case TextMessageChunkEvent():
      return $proto_events.Event(
        textMessageChunk: $proto_events.TextMessageChunkEvent(
          baseEvent: _toProtoBaseEvent(event, null),
          messageId: event.messageId,
          role: event.role?.value,
          delta: event.delta,
          name: event.name,
        ),
      );
    case ToolCallChunkEvent():
      return $proto_events.Event(
        toolCallChunk: $proto_events.ToolCallChunkEvent(
          baseEvent: _toProtoBaseEvent(event, null),
          toolCallId: event.toolCallId,
          toolCallName: event.toolCallName,
          parentMessageId: event.parentMessageId,
          delta: event.delta,
        ),
      );
    default:
      throw UnsupportedError(
        'Proto encoding is not implemented for event type ${event.type}',
      );
  }
}

BaseEvent _fromProtoEnvelope($proto_events.Event envelope) {
  switch (envelope.whichEvent()) {
    case $proto_events.Event_Event.textMessageStart:
      final event = envelope.textMessageStart;
      return TextMessageStartEvent(
        messageId: event.messageId,
        role: event.hasRole()
            ? TextMessageRole.fromString(event.role)
            : TextMessageRole.assistant,
        name: event.hasName() ? event.name : null,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
      );
    case $proto_events.Event_Event.textMessageContent:
      final event = envelope.textMessageContent;
      return TextMessageContentEvent(
        messageId: event.messageId,
        delta: event.delta,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
      );
    case $proto_events.Event_Event.textMessageEnd:
      final event = envelope.textMessageEnd;
      return TextMessageEndEvent(
        messageId: event.messageId,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
      );
    case $proto_events.Event_Event.toolCallStart:
      final event = envelope.toolCallStart;
      return ToolCallStartEvent(
        toolCallId: event.toolCallId,
        toolCallName: event.toolCallName,
        parentMessageId: event.hasParentMessageId() ? event.parentMessageId : null,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
      );
    case $proto_events.Event_Event.toolCallArgs:
      final event = envelope.toolCallArgs;
      return ToolCallArgsEvent(
        toolCallId: event.toolCallId,
        delta: event.delta,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
      );
    case $proto_events.Event_Event.toolCallEnd:
      final event = envelope.toolCallEnd;
      return ToolCallEndEvent(
        toolCallId: event.toolCallId,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
      );
    case $proto_events.Event_Event.stateSnapshot:
      final event = envelope.stateSnapshot;
      return StateSnapshotEvent(
        snapshot: _fromProtoValue(event.snapshot),
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
      );
    case $proto_events.Event_Event.stateDelta:
      final event = envelope.stateDelta;
      return StateDeltaEvent(
        delta: event.delta.map(_fromProtoPatchOperation).toList(),
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
      );
    case $proto_events.Event_Event.messagesSnapshot:
      final event = envelope.messagesSnapshot;
      return MessagesSnapshotEvent(
        messages: event.messages.map(_fromProtoMessage).toList(),
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
      );
    case $proto_events.Event_Event.raw:
      final event = envelope.raw;
      return RawEvent(
        event: _fromProtoValue(event.event),
        source: event.hasSource() ? event.source : null,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
      );
    case $proto_events.Event_Event.custom:
      final event = envelope.custom;
      return CustomEvent(
        name: event.name,
        value: _fromOptionalProtoValue(event.hasValue(), event.value),
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
      );
    case $proto_events.Event_Event.runStarted:
      final event = envelope.runStarted;
      return RunStartedEvent(
        threadId: event.threadId,
        runId: event.runId,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
      );
    case $proto_events.Event_Event.runFinished:
      final event = envelope.runFinished;
      final wireOutcome = event.outcome.isEmpty ? null : event.outcome;
      final outcome = switch (wireOutcome) {
        'success' => const RunFinishedSuccessOutcome(),
        'interrupt' => RunFinishedInterruptOutcome(
            interrupts: event.interrupts.map(_fromProtoInterrupt).toList(),
          ),
        _ => null,
      };

      return RunFinishedEvent(
        threadId: event.threadId,
        runId: event.runId,
        result: _fromOptionalProtoValue(event.hasResult(), event.result),
        outcome: outcome,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
      );
    case $proto_events.Event_Event.runError:
      final event = envelope.runError;
      return RunErrorEvent(
        code: event.hasCode() ? event.code : null,
        message: event.message,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
      );
    case $proto_events.Event_Event.stepStarted:
      final event = envelope.stepStarted;
      return StepStartedEvent(
        stepName: event.stepName,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
      );
    case $proto_events.Event_Event.stepFinished:
      final event = envelope.stepFinished;
      return StepFinishedEvent(
        stepName: event.stepName,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
      );
    case $proto_events.Event_Event.textMessageChunk:
      final event = envelope.textMessageChunk;
      return TextMessageChunkEvent(
        messageId: event.hasMessageId() ? event.messageId : null,
        role: event.hasRole() ? TextMessageRole.fromString(event.role) : null,
        delta: event.hasDelta() ? event.delta : null,
        name: event.hasName() ? event.name : null,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
      );
    case $proto_events.Event_Event.toolCallChunk:
      final event = envelope.toolCallChunk;
      return ToolCallChunkEvent(
        toolCallId: event.hasToolCallId() ? event.toolCallId : null,
        toolCallName: event.hasToolCallName() ? event.toolCallName : null,
        parentMessageId: event.hasParentMessageId() ? event.parentMessageId : null,
        delta: event.hasDelta() ? event.delta : null,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
      );
    case $proto_events.Event_Event.notSet:
      throw ArgumentError('Invalid event');
  }
}

$proto_events.BaseEvent _toProtoBaseEvent(
  BaseEvent event,
  $proto_events.EventType? type,
) {
  return $proto_events.BaseEvent(
    type: type,
    timestamp: event.timestamp == null ? null : $fixnum.Int64(event.timestamp!),
    rawEvent: event.rawEvent == null ? null : _toProtoValue(event.rawEvent),
  );
}

int? _fromProtoTimestamp($proto_events.BaseEvent baseEvent) {
  return baseEvent.hasTimestamp() ? baseEvent.timestamp.toInt() : null;
}

Object? _fromOptionalProtoValue(bool hasValue, $struct.Value value) {
  return hasValue ? _fromProtoValue(value) : null;
}

$struct.Value _toProtoValue(Object? value) {
  final normalized = _normalizeJsonLike(value);

  if (normalized == null) {
    return $struct.Value(nullValue: $struct.NullValue.NULL_VALUE);
  }
  if (normalized is bool) {
    return $struct.Value(boolValue: normalized);
  }
  if (normalized is num) {
    return $struct.Value(numberValue: normalized.toDouble());
  }
  if (normalized is String) {
    return $struct.Value(stringValue: normalized);
  }
  if (normalized is List) {
    return $struct.Value(
      listValue: $struct.ListValue(
        values: normalized.map(_toProtoValue),
      ),
    );
  }
  if (normalized is Map) {
    final fields = normalized.map(
      (key, item) => MapEntry(key.toString(), _toProtoValue(item)),
    );
    return $struct.Value(
      structValue: $struct.Struct(fields: fields.entries),
    );
  }

  return $struct.Value(stringValue: normalized.toString());
}

Object? _normalizeJsonLike(Object? value) {
  if (value is AGUIModel) {
    return _normalizeJsonLike(value.toJson());
  }
  if (value is Map) {
    return value.map(
      (key, item) => MapEntry(key.toString(), _normalizeJsonLike(item)),
    );
  }
  if (value is Iterable) {
    return value.map(_normalizeJsonLike).toList();
  }
  return value;
}

Object? _fromProtoValue($struct.Value value) {
  switch (value.whichKind()) {
    case $struct.Value_Kind.nullValue:
      return null;
    case $struct.Value_Kind.numberValue:
      final number = value.numberValue;
      if (number.isFinite && number == number.truncateToDouble()) {
        return number.toInt();
      }
      return number;
    case $struct.Value_Kind.stringValue:
      return value.stringValue;
    case $struct.Value_Kind.boolValue:
      return value.boolValue;
    case $struct.Value_Kind.structValue:
      return value.structValue.fields.map(
        (key, item) => MapEntry(key, _fromProtoValue(item)),
      );
    case $struct.Value_Kind.listValue:
      return value.listValue.values.map(_fromProtoValue).toList();
    case $struct.Value_Kind.notSet:
      return null;
  }
}

$proto_patch.JsonPatchOperation _toProtoPatchOperation(dynamic operation) {
  final map = Map<String, dynamic>.from(operation as Map);
  final proto = $proto_patch.JsonPatchOperation(
    op: _toProtoPatchOperationType(map['op'] as String?),
    path: map['path'] as String? ?? '',
    from: map['from'] as String?,
  );

  if (map.containsKey('value')) {
    proto.value = _toProtoValue(map['value']);
  }

  return proto;
}

Map<String, dynamic> _fromProtoPatchOperation($proto_patch.JsonPatchOperation operation) {
  return {
    'op': _fromProtoPatchOperationType(operation.op),
    'path': operation.path,
    if (operation.hasFrom()) 'from': operation.from,
    if (operation.hasValue()) 'value': _fromProtoValue(operation.value),
  };
}

$proto_patch_enum.JsonPatchOperationType _toProtoPatchOperationType(String? op) {
  switch ((op ?? '').toLowerCase()) {
    case 'add':
      return $proto_patch_enum.JsonPatchOperationType.ADD;
    case 'remove':
      return $proto_patch_enum.JsonPatchOperationType.REMOVE;
    case 'replace':
      return $proto_patch_enum.JsonPatchOperationType.REPLACE;
    case 'move':
      return $proto_patch_enum.JsonPatchOperationType.MOVE;
    case 'copy':
      return $proto_patch_enum.JsonPatchOperationType.COPY;
    case 'test':
      return $proto_patch_enum.JsonPatchOperationType.TEST;
    default:
      throw UnsupportedError('Unsupported JSON patch operation: $op');
  }
}

String _fromProtoPatchOperationType($proto_patch_enum.JsonPatchOperationType op) {
  switch (op) {
    case $proto_patch_enum.JsonPatchOperationType.ADD:
      return 'add';
    case $proto_patch_enum.JsonPatchOperationType.REMOVE:
      return 'remove';
    case $proto_patch_enum.JsonPatchOperationType.REPLACE:
      return 'replace';
    case $proto_patch_enum.JsonPatchOperationType.MOVE:
      return 'move';
    case $proto_patch_enum.JsonPatchOperationType.COPY:
      return 'copy';
    case $proto_patch_enum.JsonPatchOperationType.TEST:
      return 'test';
    default:
      throw UnsupportedError('Unsupported protobuf patch operation: $op');
  }
}

$proto_types.Message _toProtoMessage(Message message) {
  switch (message) {
    case DeveloperMessage():
      return $proto_types.Message(
        id: message.id,
        role: message.role.value,
        content: message.content,
        name: message.name,
      );
    case SystemMessage():
      return $proto_types.Message(
        id: message.id,
        role: message.role.value,
        content: message.content,
        name: message.name,
      );
    case AssistantMessage():
      return $proto_types.Message(
        id: message.id,
        role: message.role.value,
        content: message.content,
        name: message.name,
        toolCalls: message.toolCalls?.map(_toProtoToolCall),
      );
    case UserMessage():
      final content = message.content;
      return $proto_types.Message(
        id: message.id,
        role: message.role.value,
        content: content is String ? content : null,
        name: message.name,
        contentParts: content is List
            ? content.whereType<InputContent>().map(_toProtoInputContent)
            : null,
      );
    case ToolMessage():
      return $proto_types.Message(
        id: message.id,
        role: message.role.value,
        content: message.content,
        toolCallId: message.toolCallId,
        error: message.error,
      );
    case ReasoningMessage():
      return $proto_types.Message(
        id: message.id,
        role: message.role.value,
        content: message.content,
      );
    case ActivityMessage():
      throw UnsupportedError(
        'Proto encoding is not implemented for activity messages',
      );
  }
}

Message _fromProtoMessage($proto_types.Message message) {
  switch (message.role) {
    case 'developer':
      return DeveloperMessage(
        id: message.id,
        content: message.hasContent() ? message.content : '',
        name: message.hasName() ? message.name : null,
      );
    case 'system':
      return SystemMessage(
        id: message.id,
        content: message.hasContent() ? message.content : '',
        name: message.hasName() ? message.name : null,
      );
    case 'assistant':
      return AssistantMessage(
        id: message.id,
        content: message.hasContent() ? message.content : null,
        name: message.hasName() ? message.name : null,
        toolCalls: message.toolCalls.isEmpty
            ? null
            : message.toolCalls.map(_fromProtoToolCall).toList(),
      );
    case 'user':
      return UserMessage(
        id: message.id,
        content: message.contentParts.isNotEmpty
            ? message.contentParts.map(_fromProtoInputContent).toList()
            : (message.hasContent() ? message.content : ''),
        name: message.hasName() ? message.name : null,
      );
    case 'tool':
      return ToolMessage(
        id: message.id,
        content: message.hasContent() ? message.content : '',
        toolCallId: message.hasToolCallId() ? message.toolCallId : '',
        error: message.hasError() ? message.error : null,
      );
    case 'reasoning':
      return ReasoningMessage(
        id: message.id,
        content: message.hasContent() ? message.content : '',
      );
    default:
      throw UnsupportedError(
        'Proto decoding is not implemented for message role ${message.role}',
      );
  }
}

$proto_types.ToolCall _toProtoToolCall(ToolCall toolCall) {
  return $proto_types.ToolCall(
    id: toolCall.id,
    type: toolCall.type,
    function: $proto_types.ToolCall_Function(
      name: toolCall.function.name,
      arguments: toolCall.function.arguments,
    ),
  );
}

ToolCall _fromProtoToolCall($proto_types.ToolCall toolCall) {
  return ToolCall(
    id: toolCall.id,
    type: toolCall.type,
    function: FunctionCall(
      name: toolCall.function.name,
      arguments: toolCall.function.arguments,
    ),
  );
}

$proto_types.InputContent _toProtoInputContent(InputContent content) {
  if (content is TextInputContent) {
    return $proto_types.InputContent(
      text: $proto_types.TextInputPart(text: content.text),
    );
  }

  if (content is ImageInputContent) {
    return $proto_types.InputContent(
      image: $proto_types.ImageInputPart(
        source: _toProtoSource(content.source),
        metadata: content.metadata == null ? null : _toProtoValue(content.metadata),
      ),
    );
  }

  if (content is AudioInputContent) {
    return $proto_types.InputContent(
      audio: $proto_types.AudioInputPart(
        source: _toProtoSource(content.source),
        metadata: content.metadata == null ? null : _toProtoValue(content.metadata),
      ),
    );
  }

  if (content is VideoInputContent) {
    return $proto_types.InputContent(
      video: $proto_types.VideoInputPart(
        source: _toProtoSource(content.source),
        metadata: content.metadata == null ? null : _toProtoValue(content.metadata),
      ),
    );
  }

  if (content is DocumentInputContent) {
    return $proto_types.InputContent(
      document: $proto_types.DocumentInputPart(
        source: _toProtoSource(content.source),
        metadata: content.metadata == null ? null : _toProtoValue(content.metadata),
      ),
    );
  }

  if (content is BinaryInputContent) {
    final source = _toLegacyBinarySource(content);
    if (source == null) {
      throw UnsupportedError(
        'Legacy binary input requires id, url, or data to encode as proto',
      );
    }

    return $proto_types.InputContent(
      document: $proto_types.DocumentInputPart(
        source: source,
        metadata: _toProtoValue({
          'legacyBinary': true,
          if (content.filename != null) 'filename': content.filename,
          if (content.id != null) 'id': content.id,
        }),
      ),
    );
  }

  throw UnsupportedError('Unsupported input content type ${content.type}');
}

InputContent _fromProtoInputContent($proto_types.InputContent content) {
  switch (content.whichPart()) {
    case $proto_types.InputContent_Part.text:
      return TextInputContent(text: content.text.text);
    case $proto_types.InputContent_Part.image:
      return ImageInputContent(
        source: _fromProtoSource(content.image.source),
        metadata: _fromOptionalProtoValue(content.image.hasMetadata(), content.image.metadata),
      );
    case $proto_types.InputContent_Part.audio:
      return AudioInputContent(
        source: _fromProtoSource(content.audio.source),
        metadata: _fromOptionalProtoValue(content.audio.hasMetadata(), content.audio.metadata),
      );
    case $proto_types.InputContent_Part.video:
      return VideoInputContent(
        source: _fromProtoSource(content.video.source),
        metadata: _fromOptionalProtoValue(content.video.hasMetadata(), content.video.metadata),
      );
    case $proto_types.InputContent_Part.document:
      return DocumentInputContent(
        source: _fromProtoSource(content.document.source),
        metadata: _fromOptionalProtoValue(
          content.document.hasMetadata(),
          content.document.metadata,
        ),
      );
    case $proto_types.InputContent_Part.notSet:
      throw ArgumentError('Invalid input content');
  }
}

$proto_types.InputContentSource _toProtoSource(InputContentSource source) {
  switch (source) {
    case InputContentDataSource():
      return $proto_types.InputContentSource(
        data: $proto_types.InputContentDataSource(
          value: source.value,
          mimeType: source.mimeType,
        ),
      );
    case InputContentUrlSource():
      return $proto_types.InputContentSource(
        url: $proto_types.InputContentUrlSource(
          value: source.value,
          mimeType: source.mimeType,
        ),
      );
  }
}

$proto_types.InputContentSource? _toLegacyBinarySource(BinaryInputContent content) {
  if (content.data != null) {
    return $proto_types.InputContentSource(
      data: $proto_types.InputContentDataSource(
        value: content.data!,
        mimeType: content.mimeType,
      ),
    );
  }
  if (content.url != null) {
    return $proto_types.InputContentSource(
      url: $proto_types.InputContentUrlSource(
        value: content.url!,
        mimeType: content.mimeType,
      ),
    );
  }
  if (content.id != null) {
    return $proto_types.InputContentSource(
      url: $proto_types.InputContentUrlSource(
        value: content.id!,
        mimeType: content.mimeType,
      ),
    );
  }
  return null;
}

InputContentSource _fromProtoSource($proto_types.InputContentSource source) {
  switch (source.whichSource()) {
    case $proto_types.InputContentSource_Source.data:
      return InputContentDataSource(
        value: source.data.value,
        mimeType: source.data.mimeType,
      );
    case $proto_types.InputContentSource_Source.url:
      return InputContentUrlSource(
        value: source.url.value,
        mimeType: source.url.hasMimeType() ? source.url.mimeType : null,
      );
    case $proto_types.InputContentSource_Source.notSet:
      throw ArgumentError('Invalid input content source');
  }
}

$proto_types.Interrupt _toProtoInterrupt(Interrupt interrupt) {
  return $proto_types.Interrupt(
    id: interrupt.id,
    reason: interrupt.reason,
    message: interrupt.message,
    toolCallId: interrupt.toolCallId,
    responseSchema: interrupt.responseSchema == null
        ? null
        : _toProtoValue(interrupt.responseSchema),
    expiresAt: interrupt.expiresAt,
    metadata: interrupt.metadata == null ? null : _toProtoValue(interrupt.metadata),
  );
}

Interrupt _fromProtoInterrupt($proto_types.Interrupt interrupt) {
  return Interrupt(
    id: interrupt.id,
    reason: interrupt.reason,
    message: interrupt.hasMessage() ? interrupt.message : null,
    toolCallId: interrupt.hasToolCallId() ? interrupt.toolCallId : null,
    responseSchema: interrupt.hasResponseSchema()
        ? Map<String, dynamic>.from(
            (_fromProtoValue(interrupt.responseSchema) as Map).map(
              (key, value) => MapEntry(key.toString(), value),
            ),
          )
        : null,
    expiresAt: interrupt.hasExpiresAt() ? interrupt.expiresAt : null,
    metadata: interrupt.hasMetadata()
        ? Map<String, dynamic>.from(
            (_fromProtoValue(interrupt.metadata) as Map).map(
              (key, value) => MapEntry(key.toString(), value),
            ),
          )
        : null,
  );
}
