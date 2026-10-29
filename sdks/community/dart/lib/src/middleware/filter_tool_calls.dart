library;

import '../agent/agent.dart';
import '../events/events.dart';
import '../types/types.dart';
import 'middleware.dart';

class FilterToolCallsMiddleware extends Middleware {
  final Set<String>? _allowedTools;
  final Set<String>? _disallowedTools;

  FilterToolCallsMiddleware({
    List<String>? allowedToolCalls,
    List<String>? disallowedToolCalls,
  }) : _allowedTools = allowedToolCalls == null ? null : Set<String>.from(allowedToolCalls),
       _disallowedTools =
           disallowedToolCalls == null ? null : Set<String>.from(disallowedToolCalls) {
    if (allowedToolCalls != null && disallowedToolCalls != null) {
      throw ArgumentError('Cannot specify both allowedToolCalls and disallowedToolCalls');
    }
    if (allowedToolCalls == null && disallowedToolCalls == null) {
      throw ArgumentError('Must specify either allowedToolCalls or disallowedToolCalls');
    }
  }

  @override
  Stream<BaseEvent> run(RunAgentInput input, AbstractAgent next) async* {
    // Per subscription, not per middleware instance: one instance serves every
    // run, and keeping the set on it lets a starting run wipe the ids that are
    // still filtering a stalled run's events.
    final blockedToolCallIds = <String>{};

    await for (final event in runNext(input, next)) {
      if (event is RunStartedEvent) {
        // A run boundary invalidates ids left over from a run that was
        // interrupted before its TOOL_CALL_RESULT arrived, and stops a reused
        // tool call id being shadowed by one.
        blockedToolCallIds.clear();
        yield event;
        continue;
      }

      switch (event) {
        case ToolCallStartEvent():
          if (_shouldFilterTool(event.toolCallName)) {
            blockedToolCallIds.add(event.toolCallId);
            continue;
          }
          yield event;
        case ToolCallArgsEvent():
          if (!blockedToolCallIds.contains(event.toolCallId)) {
            yield event;
          }
        case ToolCallEndEvent():
          if (!blockedToolCallIds.contains(event.toolCallId)) {
            yield event;
          }
        case ToolCallResultEvent():
          final blocked = blockedToolCallIds.remove(event.toolCallId);
          if (!blocked) {
            yield event;
          }
        default:
          yield event;
      }
    }
  }

  bool _shouldFilterTool(String toolName) {
    if (_allowedTools != null) {
      return !_allowedTools.contains(toolName);
    }
    if (_disallowedTools != null) {
      return _disallowedTools.contains(toolName);
    }
    return false;
  }
}
