library;

import '../types/types.dart';

class AgentDebugConfig {
  final bool? events;
  final bool? lifecycle;
  final bool? verbose;

  const AgentDebugConfig({
    this.events,
    this.lifecycle,
    this.verbose,
  });
}

class ResolvedAgentDebugConfig {
  final bool enabled;
  final bool events;
  final bool lifecycle;
  final bool verbose;

  const ResolvedAgentDebugConfig({
    required this.enabled,
    required this.events,
    required this.lifecycle,
    required this.verbose,
  });

  @override
  bool operator ==(Object other) {
    return other is ResolvedAgentDebugConfig &&
        other.enabled == enabled &&
        other.events == events &&
        other.lifecycle == lifecycle &&
        other.verbose == verbose;
  }

  @override
  int get hashCode => Object.hash(enabled, events, lifecycle, verbose);
}

ResolvedAgentDebugConfig resolveAgentDebugConfig(Object? debug) {
  if (debug == null || debug == false) {
    return const ResolvedAgentDebugConfig(
      enabled: false,
      events: false,
      lifecycle: false,
      verbose: false,
    );
  }

  if (debug == true) {
    return const ResolvedAgentDebugConfig(
      enabled: true,
      events: true,
      lifecycle: true,
      verbose: true,
    );
  }

  if (debug is! AgentDebugConfig) {
    return const ResolvedAgentDebugConfig(
      enabled: false,
      events: false,
      lifecycle: false,
      verbose: false,
    );
  }

  final events = debug.events ?? true;
  final lifecycle = debug.lifecycle ?? true;
  final verbose = debug.verbose ?? false;
  return ResolvedAgentDebugConfig(
    enabled: events || lifecycle,
    events: events,
    lifecycle: lifecycle,
    verbose: verbose,
  );
}

class AgentConfig {
  final String? agentId;
  final String? description;
  final String? threadId;
  final List<Message>? initialMessages;
  final Object? initialState;
  final Object? debug;

  const AgentConfig({
    this.agentId,
    this.description,
    this.threadId,
    this.initialMessages,
    this.initialState,
    this.debug,
  });
}

class RunAgentParameters {
  final String? runId;
  final List<Tool>? tools;
  final List<Context>? context;
  final Object? forwardedProps;
  final List<ResumeEntry>? resume;

  const RunAgentParameters({
    this.runId,
    this.tools,
    this.context,
    this.forwardedProps,
    this.resume,
  });
}

class RunAgentResult {
  final Object? result;
  final List<Message> newMessages;

  const RunAgentResult({
    required this.result,
    required this.newMessages,
  });
}
