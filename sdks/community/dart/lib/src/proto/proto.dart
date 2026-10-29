library;

import 'dart:typed_data';

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/well_known_types/google/protobuf/struct.pb.dart'
    as $struct;

import '../events/events.dart';
import '../types/base.dart';
import '../types/context.dart';
import '../types/message.dart';
import '../types/token_usage.dart';
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
          baseEvent: _toProtoBaseEvent(
              event, $proto_events.EventType.TEXT_MESSAGE_START),
          messageId: event.messageId,
          role: event.role.value,
          name: event.name,
          subagentRunId: event.subagentRunId,
        ),
      );
    case TextMessageContentEvent():
      return $proto_events.Event(
        textMessageContent: $proto_events.TextMessageContentEvent(
          baseEvent: _toProtoBaseEvent(
              event, $proto_events.EventType.TEXT_MESSAGE_CONTENT),
          messageId: event.messageId,
          delta: event.delta,
          subagentRunId: event.subagentRunId,
        ),
      );
    case TextMessageEndEvent():
      return $proto_events.Event(
        textMessageEnd: $proto_events.TextMessageEndEvent(
          baseEvent: _toProtoBaseEvent(
              event, $proto_events.EventType.TEXT_MESSAGE_END),
          messageId: event.messageId,
          subagentRunId: event.subagentRunId,
        ),
      );
    case ToolCallStartEvent():
      return $proto_events.Event(
        toolCallStart: $proto_events.ToolCallStartEvent(
          baseEvent:
              _toProtoBaseEvent(event, $proto_events.EventType.TOOL_CALL_START),
          toolCallId: event.toolCallId,
          toolCallName: event.toolCallName,
          parentMessageId: event.parentMessageId,
          subagentRunId: event.subagentRunId,
        ),
      );
    case ToolCallArgsEvent():
      return $proto_events.Event(
        toolCallArgs: $proto_events.ToolCallArgsEvent(
          baseEvent:
              _toProtoBaseEvent(event, $proto_events.EventType.TOOL_CALL_ARGS),
          toolCallId: event.toolCallId,
          delta: event.delta,
          subagentRunId: event.subagentRunId,
        ),
      );
    case ToolCallEndEvent():
      return $proto_events.Event(
        toolCallEnd: $proto_events.ToolCallEndEvent(
          baseEvent:
              _toProtoBaseEvent(event, $proto_events.EventType.TOOL_CALL_END),
          toolCallId: event.toolCallId,
          subagentRunId: event.subagentRunId,
        ),
      );
    case ToolCallResultEvent():
      final content = event.content;
      return $proto_events.Event(
        toolCallResult: $proto_events.ToolCallResultEvent(
          baseEvent: _toProtoBaseEvent(
              event, $proto_events.EventType.TOOL_CALL_RESULT),
          messageId: event.messageId,
          toolCallId: event.toolCallId,
          role: event.role,
          content: content is String ? content : null,
          contentParts: content is List<InputContent>
              ? content.map(_toProtoInputContent)
              : null,
          subagentRunId: event.subagentRunId,
        ),
      );
    case StateSnapshotEvent():
      return $proto_events.Event(
        stateSnapshot: $proto_events.StateSnapshotEvent(
          baseEvent:
              _toProtoBaseEvent(event, $proto_events.EventType.STATE_SNAPSHOT),
          snapshot: _toProtoValue(event.snapshot),
          subagentRunId: event.subagentRunId,
        ),
      );
    case StateDeltaEvent():
      return $proto_events.Event(
        stateDelta: $proto_events.StateDeltaEvent(
          baseEvent:
              _toProtoBaseEvent(event, $proto_events.EventType.STATE_DELTA),
          delta: event.delta.map(_toProtoPatchOperation),
          subagentRunId: event.subagentRunId,
        ),
      );
    case MessagesSnapshotEvent():
      return $proto_events.Event(
        messagesSnapshot: $proto_events.MessagesSnapshotEvent(
          baseEvent: _toProtoBaseEvent(
              event, $proto_events.EventType.MESSAGES_SNAPSHOT),
          messages: event.messages.map(_toProtoMessage),
        ),
      );
    case ActivitySnapshotEvent():
      return $proto_events.Event(
        activitySnapshot: $proto_events.ActivitySnapshotEvent(
          baseEvent: _toProtoBaseEvent(
              event, $proto_events.EventType.ACTIVITY_SNAPSHOT),
          messageId: event.messageId,
          activityType: event.activityType,
          content: _toProtoStruct(event.content),
          replace: event.replace,
          subagentRunId: event.subagentRunId,
        ),
      );
    case ActivityDeltaEvent():
      return $proto_events.Event(
        activityDelta: $proto_events.ActivityDeltaEvent(
          baseEvent: _toProtoBaseEvent(
              event, $proto_events.EventType.ACTIVITY_DELTA),
          messageId: event.messageId,
          activityType: event.activityType,
          patch: event.patch.map(_toProtoPatchOperation),
          subagentRunId: event.subagentRunId,
        ),
      );
    case RawEvent():
      return $proto_events.Event(
        raw: $proto_events.RawEvent(
          baseEvent: _toProtoBaseEvent(event, $proto_events.EventType.RAW),
          event: _toProtoValue(event.event),
          source: event.source,
          subagentRunId: event.subagentRunId,
        ),
      );
    case CustomEvent():
      return $proto_events.Event(
        custom: $proto_events.CustomEvent(
          baseEvent: _toProtoBaseEvent(event, $proto_events.EventType.CUSTOM),
          name: event.name,
          value: event.value == null ? null : _toProtoValue(event.value),
          subagentRunId: event.subagentRunId,
        ),
      );
    case ReasoningStartEvent():
      return $proto_events.Event(
        reasoningStart: $proto_events.ReasoningStartEvent(
          baseEvent:
              _toProtoBaseEvent(event, $proto_events.EventType.REASONING_START),
          messageId: event.messageId,
          subagentRunId: event.subagentRunId,
        ),
      );
    case ReasoningMessageStartEvent():
      return $proto_events.Event(
        reasoningMessageStart: $proto_events.ReasoningMessageStartEvent(
          baseEvent: _toProtoBaseEvent(
              event, $proto_events.EventType.REASONING_MESSAGE_START),
          messageId: event.messageId,
          // The schema pins this field to the literal.
          role: 'reasoning',
          subagentRunId: event.subagentRunId,
        ),
      );
    case ReasoningMessageContentEvent():
      return $proto_events.Event(
        reasoningMessageContent: $proto_events.ReasoningMessageContentEvent(
          baseEvent: _toProtoBaseEvent(
              event, $proto_events.EventType.REASONING_MESSAGE_CONTENT),
          messageId: event.messageId,
          delta: event.delta,
          subagentRunId: event.subagentRunId,
        ),
      );
    case ReasoningMessageEndEvent():
      return $proto_events.Event(
        reasoningMessageEnd: $proto_events.ReasoningMessageEndEvent(
          baseEvent: _toProtoBaseEvent(
              event, $proto_events.EventType.REASONING_MESSAGE_END),
          messageId: event.messageId,
          subagentRunId: event.subagentRunId,
        ),
      );
    case ReasoningMessageChunkEvent():
      return $proto_events.Event(
        reasoningMessageChunk: $proto_events.ReasoningMessageChunkEvent(
          baseEvent: _toProtoBaseEvent(
              event, $proto_events.EventType.REASONING_MESSAGE_CHUNK),
          messageId: event.messageId,
          delta: event.delta,
          subagentRunId: event.subagentRunId,
        ),
      );
    case ReasoningEndEvent():
      return $proto_events.Event(
        reasoningEnd: $proto_events.ReasoningEndEvent(
          baseEvent:
              _toProtoBaseEvent(event, $proto_events.EventType.REASONING_END),
          messageId: event.messageId,
          subagentRunId: event.subagentRunId,
        ),
      );
    case ReasoningEncryptedValueEvent():
      return $proto_events.Event(
        reasoningEncryptedValue: $proto_events.ReasoningEncryptedValueEvent(
          baseEvent: _toProtoBaseEvent(
              event, $proto_events.EventType.REASONING_ENCRYPTED_VALUE),
          subtype: event.subtype.value,
          entityId: event.entityId,
          encryptedValue: event.encryptedValue,
          subagentRunId: event.subagentRunId,
        ),
      );
    case RunStartedEvent():
      return $proto_events.Event(
        runStarted: $proto_events.RunStartedEvent(
          baseEvent:
              _toProtoBaseEvent(event, $proto_events.EventType.RUN_STARTED),
          threadId: event.threadId,
          runId: event.runId,
          parentRunId: event.parentRunId,
          input: event.input == null
              ? null
              : _toProtoRunAgentInput(event.input!),
          protocolVersion: event.protocolVersion,
        ),
      );
    case RunFinishedEvent():
      final outcome = event.outcome;
      final wireOutcome = switch (outcome) {
        null => '',
        RunFinishedSuccessOutcome() => 'success',
        RunFinishedInterruptOutcome() => 'interrupt',
        RunFinishedCancelledOutcome() => 'cancelled',
        // An outcome a newer producer invented keeps its own name on the wire.
        // Folding it into `success` would report a run as complete that may
        // have been paused, which is the one thing an outcome exists to say.
        UnknownRunFinishedOutcome(raw: final raw) =>
          (raw['type'] as String?) ?? '',
      };
      final interrupts = switch (outcome) {
        RunFinishedInterruptOutcome() =>
          outcome.interrupts.map(_toProtoInterrupt),
        _ => const <$proto_types.Interrupt>[],
      };
      final pendingToolCallIds = switch (outcome) {
        RunFinishedSuccessOutcome() => outcome.pendingToolCallIds,
        _ => const <String>[],
      };

      return $proto_events.Event(
        runFinished: $proto_events.RunFinishedEvent(
          baseEvent:
              _toProtoBaseEvent(event, $proto_events.EventType.RUN_FINISHED),
          threadId: event.threadId,
          runId: event.runId,
          result: event.result == null ? null : _toProtoValue(event.result),
          outcome: wireOutcome,
          interrupts: interrupts,
          usage: event.usage.map(_toProtoUsage),
          pendingToolCallIds: pendingToolCallIds,
        ),
      );
    case RunErrorEvent():
      return $proto_events.Event(
        runError: $proto_events.RunErrorEvent(
          baseEvent:
              _toProtoBaseEvent(event, $proto_events.EventType.RUN_ERROR),
          code: event.code,
          message: event.message,
          usage: event.usage.map(_toProtoUsage),
        ),
      );
    case StepStartedEvent():
      return $proto_events.Event(
        stepStarted: $proto_events.StepStartedEvent(
          baseEvent:
              _toProtoBaseEvent(event, $proto_events.EventType.STEP_STARTED),
          stepName: event.stepName,
          subagentRunId: event.subagentRunId,
        ),
      );
    case StepFinishedEvent():
      return $proto_events.Event(
        stepFinished: $proto_events.StepFinishedEvent(
          baseEvent:
              _toProtoBaseEvent(event, $proto_events.EventType.STEP_FINISHED),
          stepName: event.stepName,
          subagentRunId: event.subagentRunId,
        ),
      );
    case TextMessageChunkEvent():
      return $proto_events.Event(
        textMessageChunk: $proto_events.TextMessageChunkEvent(
          baseEvent: _toProtoBaseEvent(
              event, $proto_events.EventType.TEXT_MESSAGE_CHUNK),
          messageId: event.messageId,
          role: event.role?.value,
          delta: event.delta,
          name: event.name,
          subagentRunId: event.subagentRunId,
        ),
      );
    case ToolCallChunkEvent():
      return $proto_events.Event(
        toolCallChunk: $proto_events.ToolCallChunkEvent(
          baseEvent: _toProtoBaseEvent(
              event, $proto_events.EventType.TOOL_CALL_CHUNK),
          toolCallId: event.toolCallId,
          toolCallName: event.toolCallName,
          parentMessageId: event.parentMessageId,
          delta: event.delta,
          subagentRunId: event.subagentRunId,
        ),
      );
    case SubagentStartedEvent():
      return $proto_events.Event(
        subagentStarted: $proto_events.SubagentStartedEvent(
          baseEvent: _toProtoBaseEvent(
              event, $proto_events.EventType.SUBAGENT_STARTED),
          subagentRunId: event.subagentRunId,
          name: event.name,
          description: event.description,
          parentSubagentRunId: event.parentSubagentRunId,
          parentToolCallId: event.parentToolCallId,
          parentMessageId: event.parentMessageId,
        ),
      );
    case SubagentFinishedEvent():
      final outcome = event.outcome;
      return $proto_events.Event(
        subagentFinished: $proto_events.SubagentFinishedEvent(
          baseEvent: _toProtoBaseEvent(
              event, $proto_events.EventType.SUBAGENT_FINISHED),
          subagentRunId: event.subagentRunId,
          result:
              event.result == null ? null : _toProtoValue(event.result),
          outcome: switch (outcome) {
            null => '',
            SubagentFinishedSuccessOutcome() => 'success',
            SubagentFinishedSuspendedOutcome() => 'suspended',
            // The producer's own name, not `success`: claiming a subagent
            // finished work it never reported finishing is worse than an
            // outcome a receiver has to strip.
            UnknownSubagentFinishedOutcome(raw: final raw) =>
              (raw['type'] as String?) ?? '',
          },
          interruptIds: outcome is SubagentFinishedSuspendedOutcome
              ? outcome.interruptIds
              : const <String>[],
        ),
      );
    case SubagentErrorEvent():
      return $proto_events.Event(
        subagentError: $proto_events.SubagentErrorEvent(
          baseEvent: _toProtoBaseEvent(
              event, $proto_events.EventType.SUBAGENT_ERROR),
          subagentRunId: event.subagentRunId,
          message: event.message,
          code: event.code,
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
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.textMessageContent:
      final event = envelope.textMessageContent;
      return TextMessageContentEvent(
        messageId: event.messageId,
        delta: event.delta,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.textMessageEnd:
      final event = envelope.textMessageEnd;
      return TextMessageEndEvent(
        messageId: event.messageId,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.toolCallStart:
      final event = envelope.toolCallStart;
      return ToolCallStartEvent(
        toolCallId: event.toolCallId,
        toolCallName: event.toolCallName,
        parentMessageId:
            event.hasParentMessageId() ? event.parentMessageId : null,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.toolCallArgs:
      final event = envelope.toolCallArgs;
      return ToolCallArgsEvent(
        toolCallId: event.toolCallId,
        delta: event.delta,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.toolCallEnd:
      final event = envelope.toolCallEnd;
      return ToolCallEndEvent(
        toolCallId: event.toolCallId,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.toolCallResult:
      final event = envelope.toolCallResult;
      return ToolCallResultEvent(
        messageId: event.messageId,
        toolCallId: event.toolCallId,
        role: event.hasRole() ? event.role : null,
        content: event.contentParts.isNotEmpty
            ? event.contentParts.map(_fromProtoInputContent).toList()
            : (event.hasContent() ? event.content : ''),
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.stateSnapshot:
      final event = envelope.stateSnapshot;
      return StateSnapshotEvent(
        snapshot: _fromProtoValue(event.snapshot),
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.stateDelta:
      final event = envelope.stateDelta;
      return StateDeltaEvent(
        delta: event.delta.map(_fromProtoPatchOperation).toList(),
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.messagesSnapshot:
      final event = envelope.messagesSnapshot;
      return MessagesSnapshotEvent(
        messages: event.messages.map(_fromProtoMessage).toList(),
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
      );
    case $proto_events.Event_Event.activitySnapshot:
      final event = envelope.activitySnapshot;
      return ActivitySnapshotEvent(
        messageId: event.messageId,
        activityType: event.activityType,
        content: _fromProtoStruct(event.content),
        replace: event.hasReplace() ? event.replace : true,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.activityDelta:
      final event = envelope.activityDelta;
      return ActivityDeltaEvent(
        messageId: event.messageId,
        activityType: event.activityType,
        patch: event.patch.map(_fromProtoPatchOperation).toList(),
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.raw:
      final event = envelope.raw;
      return RawEvent(
        event: _fromProtoValue(event.event),
        source: event.hasSource() ? event.source : null,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.custom:
      final event = envelope.custom;
      return CustomEvent(
        name: event.name,
        value: _fromOptionalProtoValue(event.hasValue(), event.value),
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.runStarted:
      final event = envelope.runStarted;
      return RunStartedEvent(
        threadId: event.threadId,
        runId: event.runId,
        parentRunId: event.hasParentRunId() ? event.parentRunId : null,
        input: event.hasInput() ? _fromProtoRunAgentInput(event.input) : null,
        protocolVersion:
            event.hasProtocolVersion() ? event.protocolVersion : null,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
      );
    case $proto_events.Event_Event.runFinished:
      final event = envelope.runFinished;
      final wireOutcome = event.outcome.isEmpty ? null : event.outcome;
      final outcome = switch (wireOutcome) {
        null => null,
        'success' => RunFinishedSuccessOutcome(
            pendingToolCallIds: event.pendingToolCallIds.toList(),
          ),
        'interrupt' => RunFinishedInterruptOutcome(
            interrupts: event.interrupts.map(_fromProtoInterrupt).toList(),
          ),
        'cancelled' => const RunFinishedCancelledOutcome(),
        // Kept verbatim, as on SUBAGENT_FINISHED: enforcement decides whether
        // to strip it with a warning, and `null` would read as "no outcome",
        // which every consumer treats as a success.
        final other => UnknownRunFinishedOutcome(raw: {'type': other}),
      };

      return RunFinishedEvent(
        threadId: event.threadId,
        runId: event.runId,
        result: _fromOptionalProtoValue(event.hasResult(), event.result),
        outcome: outcome,
        usage: event.usage.map(_fromProtoUsage).toList(),
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
      );
    case $proto_events.Event_Event.runError:
      final event = envelope.runError;
      return RunErrorEvent(
        code: event.hasCode() ? event.code : null,
        message: event.message,
        usage: event.usage.map(_fromProtoUsage).toList(),
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
      );
    case $proto_events.Event_Event.stepStarted:
      final event = envelope.stepStarted;
      return StepStartedEvent(
        stepName: event.stepName,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.stepFinished:
      final event = envelope.stepFinished;
      return StepFinishedEvent(
        stepName: event.stepName,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.textMessageChunk:
      final event = envelope.textMessageChunk;
      return TextMessageChunkEvent(
        messageId: event.hasMessageId() ? event.messageId : null,
        role: event.hasRole() ? TextMessageRole.fromString(event.role) : null,
        delta: event.hasDelta() ? event.delta : null,
        name: event.hasName() ? event.name : null,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.toolCallChunk:
      final event = envelope.toolCallChunk;
      return ToolCallChunkEvent(
        toolCallId: event.hasToolCallId() ? event.toolCallId : null,
        toolCallName: event.hasToolCallName() ? event.toolCallName : null,
        parentMessageId:
            event.hasParentMessageId() ? event.parentMessageId : null,
        delta: event.hasDelta() ? event.delta : null,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.reasoningStart:
      final event = envelope.reasoningStart;
      return ReasoningStartEvent(
        messageId: event.messageId,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.reasoningMessageStart:
      final event = envelope.reasoningMessageStart;
      return ReasoningMessageStartEvent(
        messageId: event.messageId,
        role: event.hasRole() ? event.role : 'reasoning',
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.reasoningMessageContent:
      final event = envelope.reasoningMessageContent;
      return ReasoningMessageContentEvent(
        messageId: event.messageId,
        delta: event.delta,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.reasoningMessageEnd:
      final event = envelope.reasoningMessageEnd;
      return ReasoningMessageEndEvent(
        messageId: event.messageId,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.reasoningMessageChunk:
      final event = envelope.reasoningMessageChunk;
      return ReasoningMessageChunkEvent(
        messageId: event.hasMessageId() ? event.messageId : null,
        delta: event.hasDelta() ? event.delta : null,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.reasoningEnd:
      final event = envelope.reasoningEnd;
      return ReasoningEndEvent(
        messageId: event.messageId,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.reasoningEncryptedValue:
      final event = envelope.reasoningEncryptedValue;
      return ReasoningEncryptedValueEvent(
        subtype: ReasoningEncryptedValueSubtype.fromString(event.subtype),
        entityId: event.entityId,
        encryptedValue: event.encryptedValue,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
        subagentRunId:
            _fromProtoAttribution(event.hasSubagentRunId(), event.subagentRunId),
      );
    case $proto_events.Event_Event.subagentStarted:
      final event = envelope.subagentStarted;
      return SubagentStartedEvent(
        subagentRunId: event.subagentRunId,
        name: event.name,
        description: event.hasDescription() ? event.description : null,
        parentSubagentRunId: event.hasParentSubagentRunId()
            ? event.parentSubagentRunId
            : null,
        parentToolCallId:
            event.hasParentToolCallId() ? event.parentToolCallId : null,
        parentMessageId:
            event.hasParentMessageId() ? event.parentMessageId : null,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
      );
    case $proto_events.Event_Event.subagentFinished:
      final event = envelope.subagentFinished;
      final outcome = switch (event.outcome) {
        'success' => const SubagentFinishedSuccessOutcome(),
        'suspended' => SubagentFinishedSuspendedOutcome(
            interruptIds: event.interruptIds.toList(),
          ),
        '' => null,
        // An outcome a newer producer invented: kept as-is rather than folded
        // into success, which would report work as complete that may not be.
        final other => UnknownSubagentFinishedOutcome(raw: {'type': other}),
      };
      return SubagentFinishedEvent(
        subagentRunId: event.subagentRunId,
        result: _fromOptionalProtoValue(event.hasResult(), event.result),
        outcome: outcome,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
      );
    case $proto_events.Event_Event.subagentError:
      final event = envelope.subagentError;
      return SubagentErrorEvent(
        subagentRunId: event.subagentRunId,
        message: event.message,
        code: event.hasCode() ? event.code : null,
        timestamp: _fromProtoTimestamp(event.baseEvent),
        rawEvent: _fromOptionalProtoValue(
            event.baseEvent.hasRawEvent(), event.baseEvent.rawEvent),
        metadata: _fromProtoMetadata(event.baseEvent),
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
    metadata: event.metadata == null ? null : _toProtoStruct(event.metadata!),
  );
}

$struct.Struct _toProtoStruct(Map<String, dynamic> metadata) {
  return $struct.Struct(
    fields: metadata.entries.map(
      (entry) => MapEntry(entry.key, _toProtoValue(entry.value)),
    ),
  );
}

Map<String, dynamic> _fromProtoStruct($struct.Struct value) {
  return value.fields.map(
    (key, item) => MapEntry(key, _fromProtoValue(item)),
  );
}

/// The `metadata` a base event carried, or `null` when it carried none.
Map<String, dynamic>? _fromProtoMetadata($proto_events.BaseEvent baseEvent) {
  if (!baseEvent.hasMetadata()) return null;
  return baseEvent.metadata.fields.map(
    (key, value) => MapEntry(key, _fromProtoValue(value)),
  );
}

/// The `subagentRunId` an attributable event carried, or `null` for the
/// parent agent.
String? _fromProtoAttribution(bool hasValue, String value) =>
    hasValue ? value : null;


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

Map<String, dynamic> _fromProtoPatchOperation(
    $proto_patch.JsonPatchOperation operation) {
  return {
    'op': _fromProtoPatchOperationType(operation.op),
    'path': operation.path,
    if (operation.hasFrom()) 'from': operation.from,
    if (operation.hasValue()) 'value': _fromProtoValue(operation.value),
  };
}

$proto_patch_enum.JsonPatchOperationType _toProtoPatchOperationType(
    String? op) {
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

String _fromProtoPatchOperationType(
    $proto_patch_enum.JsonPatchOperationType op) {
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
  final metadata =
      message.metadata == null ? null : _toProtoStruct(message.metadata!);
  switch (message) {
    case DeveloperMessage():
      return $proto_types.Message(
        id: message.id,
        role: message.role.value,
        content: message.content,
        name: message.name,
        encryptedValue: message.encryptedValue,
        metadata: metadata,
        subagentRunId: message.subagentRunId,
      );
    case SystemMessage():
      return $proto_types.Message(
        id: message.id,
        role: message.role.value,
        content: message.content,
        name: message.name,
        encryptedValue: message.encryptedValue,
        metadata: metadata,
        subagentRunId: message.subagentRunId,
      );
    case AssistantMessage():
      return $proto_types.Message(
        id: message.id,
        role: message.role.value,
        content: message.content,
        name: message.name,
        toolCalls: message.toolCalls?.map(_toProtoToolCall),
        encryptedValue: message.encryptedValue,
        metadata: metadata,
        subagentRunId: message.subagentRunId,
      );
    case UserMessage():
      final content = message.content;
      return $proto_types.Message(
        id: message.id,
        role: message.role.value,
        content: content.textOrNull,
        name: message.name,
        contentParts: content.partsOrNull?.map(_toProtoInputContent),
        encryptedValue: message.encryptedValue,
        metadata: metadata,
        subagentRunId: message.subagentRunId,
      );
    case ToolMessage():
      return $proto_types.Message(
        id: message.id,
        role: message.role.value,
        content: message.content is String ? message.content as String : null,
        name: message.name,
        contentParts: message.contentParts?.map(_toProtoInputContent),
        toolCallId: message.toolCallId,
        error: message.error,
        encryptedValue: message.encryptedValue,
        metadata: metadata,
        subagentRunId: message.subagentRunId,
      );
    case ReasoningMessage():
      return $proto_types.Message(
        id: message.id,
        role: message.role.value,
        content: message.content,
        encryptedValue: message.encryptedValue,
        metadata: metadata,
        subagentRunId: message.subagentRunId,
      );
    case ActivityMessage():
      // An activity message carries structured content rather than text, which
      // is why it has its own pair of fields.
      return $proto_types.Message(
        id: message.id,
        role: message.role.value,
        activityType: message.activityType,
        activityContent: _toProtoStruct(message.content),
        metadata: metadata,
        subagentRunId: message.subagentRunId,
      );
  }
}

Message _fromProtoMessage($proto_types.Message message) {
  final metadata = message.hasMetadata()
      ? _fromProtoStruct(message.metadata)
      : null;
  final subagentRunId = message.hasSubagentRunId()
      ? message.subagentRunId
      : null;
  final encryptedValue =
      message.hasEncryptedValue() ? message.encryptedValue : null;
  switch (message.role) {
    case 'developer':
      return DeveloperMessage(
        id: message.id,
        content: message.hasContent() ? message.content : '',
        name: message.hasName() ? message.name : null,
        encryptedValue: encryptedValue,
        metadata: metadata,
        subagentRunId: subagentRunId,
      );
    case 'system':
      return SystemMessage(
        id: message.id,
        content: message.hasContent() ? message.content : '',
        name: message.hasName() ? message.name : null,
        encryptedValue: encryptedValue,
        metadata: metadata,
        subagentRunId: subagentRunId,
      );
    case 'assistant':
      return AssistantMessage(
        id: message.id,
        content: message.hasContent() ? message.content : null,
        name: message.hasName() ? message.name : null,
        toolCalls: message.toolCalls.isEmpty
            ? null
            : message.toolCalls.map(_fromProtoToolCall).toList(),
        encryptedValue: encryptedValue,
        metadata: metadata,
        subagentRunId: subagentRunId,
      );
    case 'user':
      return UserMessage(
        id: message.id,
        content: message.contentParts.isNotEmpty
            ? message.contentParts.map(_fromProtoInputContent).toList()
            : (message.hasContent() ? message.content : ''),
        name: message.hasName() ? message.name : null,
        encryptedValue: encryptedValue,
        metadata: metadata,
        subagentRunId: subagentRunId,
      );
    case 'tool':
      return ToolMessage(
        id: message.id,
        content: message.contentParts.isNotEmpty
            ? message.contentParts.map(_fromProtoInputContent).toList()
            : (message.hasContent() ? message.content : ''),
        toolCallId: message.hasToolCallId() ? message.toolCallId : '',
        error: message.hasError() ? message.error : null,
        encryptedValue: encryptedValue,
        metadata: metadata,
        subagentRunId: subagentRunId,
      );
    case 'reasoning':
      return ReasoningMessage(
        id: message.id,
        content: message.hasContent() ? message.content : '',
        encryptedValue: encryptedValue,
        metadata: metadata,
        subagentRunId: subagentRunId,
      );
    case 'activity':
      return ActivityMessage(
        id: message.id,
        activityType: message.hasActivityType() ? message.activityType : '',
        content: message.hasActivityContent()
            ? _fromProtoStruct(message.activityContent)
            : const <String, dynamic>{},
        metadata: metadata,
        subagentRunId: subagentRunId,
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
    metadata:
        toolCall.metadata == null ? null : _toProtoStruct(toolCall.metadata!),
    encryptedValue: toolCall.encryptedValue,
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
    metadata: toolCall.hasMetadata()
        ? _fromProtoStruct(toolCall.metadata)
        : null,
    encryptedValue:
        toolCall.hasEncryptedValue() ? toolCall.encryptedValue : null,
  );
}

$proto_types.InputContent _toProtoInputContent(InputContent content) {
  if (content is TextInputContent) {
    return $proto_types.InputContent(
      text: $proto_types.TextInputPart(
        text: content.text,
        id: content.id,
        metadata:
            content.metadata == null ? null : _toProtoValue(content.metadata),
      ),
    );
  }

  if (content is ImageInputContent) {
    return $proto_types.InputContent(
      image: $proto_types.ImageInputPart(
        source: _toProtoSource(content.source),
        id: content.id,
        metadata:
            content.metadata == null ? null : _toProtoValue(content.metadata),
      ),
    );
  }

  if (content is AudioInputContent) {
    return $proto_types.InputContent(
      audio: $proto_types.AudioInputPart(
        source: _toProtoSource(content.source),
        id: content.id,
        metadata:
            content.metadata == null ? null : _toProtoValue(content.metadata),
      ),
    );
  }

  if (content is VideoInputContent) {
    return $proto_types.InputContent(
      video: $proto_types.VideoInputPart(
        source: _toProtoSource(content.source),
        id: content.id,
        metadata:
            content.metadata == null ? null : _toProtoValue(content.metadata),
      ),
    );
  }

  if (content is DocumentInputContent) {
    return $proto_types.InputContent(
      document: $proto_types.DocumentInputPart(
        source: _toProtoSource(content.source),
        id: content.id,
        metadata:
            content.metadata == null ? null : _toProtoValue(content.metadata),
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
      return TextInputContent(
        text: content.text.text,
        id: content.text.hasId() ? content.text.id : null,
        metadata: content.text.hasMetadata()
            ? _fromProtoValue(content.text.metadata)
            : null,
      );
    case $proto_types.InputContent_Part.image:
      return ImageInputContent(
        source: _fromProtoSource(content.image.source),
        id: content.image.hasId() ? content.image.id : null,
        metadata: _fromOptionalProtoValue(
            content.image.hasMetadata(), content.image.metadata),
      );
    case $proto_types.InputContent_Part.audio:
      return AudioInputContent(
        source: _fromProtoSource(content.audio.source),
        id: content.audio.hasId() ? content.audio.id : null,
        metadata: _fromOptionalProtoValue(
            content.audio.hasMetadata(), content.audio.metadata),
      );
    case $proto_types.InputContent_Part.video:
      return VideoInputContent(
        source: _fromProtoSource(content.video.source),
        id: content.video.hasId() ? content.video.id : null,
        metadata: _fromOptionalProtoValue(
            content.video.hasMetadata(), content.video.metadata),
      );
    case $proto_types.InputContent_Part.document:
      return DocumentInputContent(
        source: _fromProtoSource(content.document.source),
        id: content.document.hasId() ? content.document.id : null,
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
    case InputContentFileSource():
      return $proto_types.InputContentSource(
        file: $proto_types.InputContentFileSource(
          value: source.value,
          provider: source.provider,
          mimeType: source.mimeType,
        ),
      );
  }
}

$proto_types.InputContentSource? _toLegacyBinarySource(
    BinaryInputContent content) {
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
    case $proto_types.InputContentSource_Source.file:
      return InputContentFileSource(
        value: source.file.value,
        provider: source.file.hasProvider() ? source.file.provider : null,
        mimeType: source.file.hasMimeType() ? source.file.mimeType : null,
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
    metadata:
        interrupt.metadata == null ? null : _toProtoValue(interrupt.metadata),
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

$proto_events.Usage _toProtoUsage(TokenUsage usage) {
  return $proto_events.Usage(
    provider: usage.provider,
    model: usage.model,
    inputTokens:
        usage.inputTokens == null ? null : $fixnum.Int64(usage.inputTokens!),
    outputTokens:
        usage.outputTokens == null ? null : $fixnum.Int64(usage.outputTokens!),
    totalTokens:
        usage.totalTokens == null ? null : $fixnum.Int64(usage.totalTokens!),
    reasoningTokens: usage.reasoningTokens == null
        ? null
        : $fixnum.Int64(usage.reasoningTokens!),
    cachedInputTokens: usage.cachedInputTokens == null
        ? null
        : $fixnum.Int64(usage.cachedInputTokens!),
    cacheWriteInputTokens: usage.cacheWriteInputTokens == null
        ? null
        : $fixnum.Int64(usage.cacheWriteInputTokens!),
  );
}

TokenUsage _fromProtoUsage($proto_events.Usage usage) {
  return TokenUsage(
    provider: usage.hasProvider() ? usage.provider : null,
    model: usage.hasModel() ? usage.model : null,
    inputTokens: usage.hasInputTokens() ? usage.inputTokens.toInt() : null,
    outputTokens: usage.hasOutputTokens() ? usage.outputTokens.toInt() : null,
    totalTokens: usage.hasTotalTokens() ? usage.totalTokens.toInt() : null,
    reasoningTokens:
        usage.hasReasoningTokens() ? usage.reasoningTokens.toInt() : null,
    cachedInputTokens:
        usage.hasCachedInputTokens() ? usage.cachedInputTokens.toInt() : null,
    cacheWriteInputTokens: usage.hasCacheWriteInputTokens()
        ? usage.cacheWriteInputTokens.toInt()
        : null,
  );
}

$proto_types.RunAgentInput _toProtoRunAgentInput(RunAgentInput input) {
  return $proto_types.RunAgentInput(
    threadId: input.threadId,
    runId: input.runId,
    parentRunId: input.parentRunId,
    state: input.state == null ? null : _toProtoValue(input.state),
    messages: input.messages.map(_toProtoMessage),
    tools: input.tools.map(_toProtoTool),
    context: input.context.map(
      (item) => $proto_types.Context(
        description: item.description,
        value: item.value,
      ),
    ),
    forwardedProps: input.forwardedProps == null
        ? null
        : _toProtoValue(input.forwardedProps),
    resume: input.resume?.map(_toProtoResumeEntry),
    protocolVersion: input.protocolVersion,
  );
}

RunAgentInput _fromProtoRunAgentInput($proto_types.RunAgentInput input) {
  return RunAgentInput(
    threadId: input.threadId,
    runId: input.runId,
    parentRunId: input.hasParentRunId() ? input.parentRunId : null,
    protocolVersion:
        input.hasProtocolVersion() ? input.protocolVersion : null,
    state: input.hasState() ? _fromProtoValue(input.state) : null,
    messages: input.messages.map(_fromProtoMessage).toList(),
    tools: input.tools.map(_fromProtoTool).toList(),
    context: input.context
        .map((item) => Context(description: item.description, value: item.value))
        .toList(),
    forwardedProps: input.hasForwardedProps()
        ? _fromProtoValue(input.forwardedProps)
        : null,
    resume: input.resume.isEmpty
        ? null
        : input.resume.map(_fromProtoResumeEntry).toList(),
  );
}

$proto_types.Tool _toProtoTool(Tool tool) {
  return $proto_types.Tool(
    name: tool.name,
    description: tool.description,
    parameters:
        tool.parameters == null ? null : _toProtoValue(tool.parameters),
    metadata: tool.metadata == null ? null : _toProtoStruct(tool.metadata!),
  );
}

Tool _fromProtoTool($proto_types.Tool tool) {
  return Tool(
    name: tool.name,
    description: tool.description,
    parameters: tool.hasParameters() ? _fromProtoValue(tool.parameters) : null,
    metadata: tool.hasMetadata() ? _fromProtoStruct(tool.metadata) : null,
  );
}

$proto_types.ResumeEntry _toProtoResumeEntry(ResumeEntry entry) {
  return $proto_types.ResumeEntry(
    interruptId: entry.interruptId,
    status: entry.status.value,
    payload: entry.payload == null ? null : _toProtoValue(entry.payload),
    metadata: entry.metadata == null ? null : _toProtoStruct(entry.metadata!),
  );
}

ResumeEntry _fromProtoResumeEntry($proto_types.ResumeEntry entry) {
  return ResumeEntry(
    interruptId: entry.interruptId,
    status: ResumeStatus.fromString(entry.status),
    payload: entry.hasPayload() ? _fromProtoValue(entry.payload) : null,
    metadata: entry.hasMetadata() ? _fromProtoStruct(entry.metadata) : null,
  );
}
