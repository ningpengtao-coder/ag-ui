library;

import '../agent/agent.dart';
import '../events/events.dart';
import '../types/types.dart';
import 'middleware.dart';

class FilterToolCallsMiddleware extends Middleware {
  final Set<String>? _allowedTools;
  final Set<String>? _disallowedTools;
  final Set<String> _blockedToolCallIds = <String>{};

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
    _blockedToolCallIds.clear();

    await for (final event in runNext(input, next)) {
      switch (event) {
        case ToolCallStartEvent():
          if (_shouldFilterTool(event.toolCallName)) {
            _blockedToolCallIds.add(event.toolCallId);
            continue;
          }
          yield event;
        case ToolCallArgsEvent():
          if (!_blockedToolCallIds.contains(event.toolCallId)) {
            yield event;
          }
        case ToolCallEndEvent():
          if (!_blockedToolCallIds.contains(event.toolCallId)) {
            yield event;
          }
        case ToolCallResultEvent():
          final blocked = _blockedToolCallIds.remove(event.toolCallId);
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
