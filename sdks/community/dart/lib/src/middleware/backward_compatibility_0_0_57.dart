/// Downgrade for agents pinned at or below 0.0.57, the last era before
/// subagents.
///
/// The subagent feature is purely additive, so this shim is a pure removal in
/// both directions — there is no field or event to translate:
///
/// - client -> agent: `subagentRunId` is stripped from every top-level message
///   so a pre-subagent agent never receives attribution it cannot interpret.
///   This is the load-bearing half: the client's replayed history can carry
///   the tag.
/// - agent -> client: `SUBAGENT_STARTED`/`SUBAGENT_FINISHED`/`SUBAGENT_ERROR`
///   are dropped with a warning, and `subagentRunId` is stripped from every
///   remaining event, from `MESSAGES_SNAPSHOT` messages and from the
///   `RUN_STARTED.input` echo. A genuinely 0.0.57 agent cannot emit any of
///   that, so this half guards mixed or proxied pipelines.
///
/// Scope: the protocol-level `subagentRunId` and the `SUBAGENT_*` event types
/// only. Opaque application payloads are never walked.
library;

import '../agent/agent.dart';
import '../diagnostics.dart';
import '../events/events.dart';
import '../types/types.dart';
import 'middleware.dart';

class BackwardCompatibility_0_0_57 extends Middleware {
  @override
  Stream<BaseEvent> run(RunAgentInput input, AbstractAgent next) async* {
    final sanitizedInput = input.copyWith(
      messages: input.messages.map(_stripMessageSubagentRunId).toList(),
    );

    await for (final event in runNext(sanitizedInput, next)) {
      switch (event) {
        case SubagentStartedEvent():
          _warnDroppedLifecycleEvent('SUBAGENT_STARTED');
          continue;
        case SubagentFinishedEvent():
          _warnDroppedLifecycleEvent('SUBAGENT_FINISHED');
          continue;
        case SubagentErrorEvent():
          _warnDroppedLifecycleEvent('SUBAGENT_ERROR');
          continue;
        default:
          yield _stripEventSubagentRunId(event);
      }
    }
  }

  void _warnDroppedLifecycleEvent(String eventType) {
    AgUiDiagnostics.warn(
      'AG-UI is dropping $eventType because the target agent predates subagent '
      'support. To remove this warning, upgrade your AG-UI integration '
      'package.',
    );
  }
}

/// [message] without its top-level `subagentRunId`.
///
/// Rebuilt field by field rather than through JSON so a message the model can
/// hold is never rejected on the way past; every field the constructors accept
/// is carried over.
Message _stripMessageSubagentRunId(Message message) {
  if (message.subagentRunId == null) {
    return message;
  }
  return switch (message) {
    DeveloperMessage() => DeveloperMessage(
        id: message.id,
        content: message.content,
        name: message.name,
        encryptedValue: message.encryptedValue,
        metadata: message.metadata,
      ),
    SystemMessage() => SystemMessage(
        id: message.id,
        content: message.content,
        name: message.name,
        encryptedValue: message.encryptedValue,
        metadata: message.metadata,
      ),
    AssistantMessage() => AssistantMessage(
        id: message.id,
        content: message.content,
        name: message.name,
        encryptedValue: message.encryptedValue,
        toolCalls: message.toolCalls,
      ),
    UserMessage() => UserMessage(
        id: message.id,
        content: message.content,
        name: message.name,
        encryptedValue: message.encryptedValue,
        metadata: message.metadata,
      ),
    ToolMessage() => ToolMessage(
        id: message.id,
        content: message.content,
        toolCallId: message.toolCallId,
        error: message.error,
        encryptedValue: message.encryptedValue,
        metadata: message.metadata,
      ),
    ActivityMessage() => ActivityMessage(
        id: message.id,
        activityType: message.activityType,
        content: message.content,
        metadata: message.metadata,
      ),
    ReasoningMessage() => ReasoningMessage(
        id: message.id,
        content: message.content,
        encryptedValue: message.encryptedValue,
        metadata: message.metadata,
      ),
  };
}

/// [event] without its top-level `subagentRunId`, and without the tags nested
/// in the members that embed messages.
///
/// The top-level strip round-trips the wire form, which is how every event
/// class already serializes itself; the nested members are handled explicitly
/// below.
BaseEvent _stripEventSubagentRunId(BaseEvent event) {
  final stripped = event.subagentRunId == null
      ? event
      : BaseEvent.fromJson(
          Map<String, dynamic>.from(event.toJson())..remove('subagentRunId'),
        );

  if (stripped is MessagesSnapshotEvent) {
    return stripped.copyWith(
      messages: stripped.messages.map(_stripMessageSubagentRunId).toList(),
    );
  }

  // RUN_FINISHED's interrupt outcome attributes each interrupt to the subagent
  // that raised it — nested, so the top-level strip above never reaches it. A
  // genuinely pre-subagent peer cannot read the field, and leaking a fragment
  // of the subagent contract without its lifecycle context is exactly what this
  // direction exists to prevent.
  if (stripped is RunFinishedEvent) {
    final outcome = stripped.outcome;
    if (outcome is RunFinishedInterruptOutcome) {
      return stripped.copyWith(
        outcome: RunFinishedInterruptOutcome(
          interrupts:
              outcome.interrupts.map(_stripInterruptSubagentRunId).toList(),
        ),
      );
    }
  }

  if (stripped is RunStartedEvent && stripped.input != null) {
    final messages = stripped.input!.messages;
    return stripped.copyWith(
      input: stripped.input!.copyWith(
        messages: messages.map(_stripMessageSubagentRunId).toList(),
      ),
    );
  }

  return stripped;
}

Interrupt _stripInterruptSubagentRunId(Interrupt interrupt) {
  return Interrupt(
    id: interrupt.id,
    reason: interrupt.reason,
    message: interrupt.message,
    toolCallId: interrupt.toolCallId,
    responseSchema: interrupt.responseSchema,
    expiresAt: interrupt.expiresAt,
    metadata: interrupt.metadata,
  );
}
