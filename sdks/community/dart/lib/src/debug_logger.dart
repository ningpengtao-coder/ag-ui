library;

import 'dart:convert';

import 'agent/types.dart';

class DebugLogger {
  final ResolvedAgentDebugConfig config;

  const DebugLogger(this.config);

  bool get enabled => config.enabled;
  bool get eventsEnabled => config.events;
  bool get lifecycleEnabled => config.lifecycle;

  void event(
    String prefix,
    String label,
    Object? data, [
    Object? summary,
  ]) {
    if (!config.events) {
      return;
    }

    final message = '[$prefix] $label';
    if (config.verbose) {
      final rendered = data is String ? data : _jsonEncodeSafe(data);
      // ignore: avoid_print
      print('$message ${rendered ?? ""}'.trimRight());
      return;
    }

    final payload = summary ?? data;
    // ignore: avoid_print
    print(payload == null ? message : '$message $payload');
  }

  void lifecycle(String prefix, String label, [Object? data]) {
    if (!config.lifecycle) {
      return;
    }

    final message = '[$prefix] $label';
    // ignore: avoid_print
    print(data == null ? message : '$message $data');
  }
}

DebugLogger? createDebugLogger(ResolvedAgentDebugConfig config) {
  if (!config.enabled) {
    return null;
  }
  return DebugLogger(config);
}

DebugLogger? resolveDebugLogger(Object? loggerOrConfig) {
  if (loggerOrConfig == null || loggerOrConfig == false) {
    return null;
  }
  if (loggerOrConfig is DebugLogger) {
    return loggerOrConfig;
  }
  if (loggerOrConfig is bool) {
    return createDebugLogger(resolveAgentDebugConfig(loggerOrConfig));
  }
  if (loggerOrConfig is AgentDebugConfig) {
    return createDebugLogger(resolveAgentDebugConfig(loggerOrConfig));
  }
  return null;
}

String? _jsonEncodeSafe(Object? value) {
  try {
    return value is String ? value : jsonEncode(value);
  } catch (_) {
    return value?.toString();
  }
}
