/// Event type enumeration for AG-UI protocol.
library;

enum EventType {
  textMessageStart('TEXT_MESSAGE_START'),
  textMessageContent('TEXT_MESSAGE_CONTENT'),
  textMessageEnd('TEXT_MESSAGE_END'),
  textMessageChunk('TEXT_MESSAGE_CHUNK'),
  thinkingTextMessageStart('THINKING_TEXT_MESSAGE_START'),
  thinkingTextMessageContent('THINKING_TEXT_MESSAGE_CONTENT'),
  thinkingTextMessageEnd('THINKING_TEXT_MESSAGE_END'),
  toolCallStart('TOOL_CALL_START'),
  toolCallArgs('TOOL_CALL_ARGS'),
  toolCallEnd('TOOL_CALL_END'),
  toolCallChunk('TOOL_CALL_CHUNK'),
  toolCallResult('TOOL_CALL_RESULT'),
  thinkingStart('THINKING_START'),
  thinkingContent('THINKING_CONTENT'),
  thinkingEnd('THINKING_END'),
  stateSnapshot('STATE_SNAPSHOT'),
  stateDelta('STATE_DELTA'),
  messagesSnapshot('MESSAGES_SNAPSHOT'),
  activitySnapshot('ACTIVITY_SNAPSHOT'),
  activityDelta('ACTIVITY_DELTA'),
  raw('RAW'),
  custom('CUSTOM'),
  runStarted('RUN_STARTED'),
  runFinished('RUN_FINISHED'),
  runError('RUN_ERROR'),
  stepStarted('STEP_STARTED'),
  stepFinished('STEP_FINISHED'),
  reasoningStart('REASONING_START'),
  reasoningMessageStart('REASONING_MESSAGE_START'),
  reasoningMessageContent('REASONING_MESSAGE_CONTENT'),
  reasoningMessageEnd('REASONING_MESSAGE_END'),
  reasoningMessageChunk('REASONING_MESSAGE_CHUNK'),
  reasoningEnd('REASONING_END'),
  reasoningEncryptedValue('REASONING_ENCRYPTED_VALUE'),
  subagentStarted('SUBAGENT_STARTED'),
  subagentFinished('SUBAGENT_FINISHED'),
  subagentError('SUBAGENT_ERROR'),

  /// Sentinel used by [UnknownEvent] for a `type` the protocol does not
  /// describe. Never part of the protocol type set.
  unknown('UNKNOWN');

  final String value;
  const EventType(this.value);

  /// The event types the 1.0 protocol describes.
  ///
  /// The legacy `THINKING_*` members are Dart-only translations of the
  /// pre-0.0.47 reasoning events: they stay in the enum so the era shims can
  /// translate them, but they are not part of the protocol. Anything outside
  /// this set has to be translated before enforcement or is dropped with a
  /// warning, exactly like an unknown event from a newer producer.
  static final Set<String> protocolTypes = {
    for (final type in values)
      if (!type.value.startsWith('THINKING_') && type != EventType.unknown)
        type.value,
  };

  static EventType fromString(String value) {
    return EventType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw ArgumentError('Invalid event type: $value'),
    );
  }

  /// Parses [value] into a protocol event type, or returns `null` when the
  /// producer used a type the 1.0 protocol does not describe.
  static EventType? tryParseProtocol(String value) {
    if (!protocolTypes.contains(value)) return null;
    return fromString(value);
  }
}
