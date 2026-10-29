/// The enforcement stage of the consumer pipeline.
///
/// Sits after the middleware chain and before verification: it guarantees
/// that nothing unrecognised survives to subscribers or application code, and
/// that every deviation it makes is named in a warning.
///
/// - An event whose `type` nothing translated is dropped, with a warning.
/// - Unknown properties, unknown discriminated-union members and unknown
///   content parts on a known event are stripped, each with a warning naming
///   its path.
/// - A malformed value on a field the protocol DOES describe stays fatal: the
///   decoder rejects it before this stage is reached.
library;

import '../debug_logger.dart';
import '../diagnostics.dart';
import '../events/events.dart';

/// Fields the 1.0 schema describes for each event, including the ones every
/// event inherits from `BaseEvent` / `Attributable`.
const Map<String, Set<String>> _eventFields = {
  'TEXT_MESSAGE_START': {'messageId', 'role', 'name'},
  'TEXT_MESSAGE_CONTENT': {'messageId', 'delta'},
  'TEXT_MESSAGE_END': {'messageId'},
  'TEXT_MESSAGE_CHUNK': {'messageId', 'role', 'delta', 'name'},
  'TOOL_CALL_START': {'toolCallId', 'toolCallName', 'parentMessageId'},
  'TOOL_CALL_ARGS': {'toolCallId', 'delta'},
  'TOOL_CALL_END': {'toolCallId'},
  'TOOL_CALL_CHUNK': {
    'toolCallId',
    'toolCallName',
    'parentMessageId',
    'delta',
  },
  'TOOL_CALL_RESULT': {'messageId', 'toolCallId', 'content', 'role'},
  'STATE_SNAPSHOT': {'snapshot'},
  'STATE_DELTA': {'delta'},
  'MESSAGES_SNAPSHOT': {'messages'},
  'ACTIVITY_SNAPSHOT': {'messageId', 'activityType', 'content', 'replace'},
  'ACTIVITY_DELTA': {'messageId', 'activityType', 'patch'},
  'RAW': {'event', 'source'},
  'CUSTOM': {'name', 'value'},
  'RUN_STARTED': {
    'threadId',
    'runId',
    'protocolVersion',
    'parentRunId',
    'input'
  },
  'RUN_FINISHED': {'threadId', 'runId', 'result', 'outcome', 'usage'},
  'RUN_ERROR': {'message', 'code', 'usage'},
  'STEP_STARTED': {'stepName'},
  'STEP_FINISHED': {'stepName'},
  'REASONING_START': {'messageId'},
  'REASONING_MESSAGE_START': {'messageId', 'role'},
  'REASONING_MESSAGE_CONTENT': {'messageId', 'delta'},
  'REASONING_MESSAGE_END': {'messageId'},
  'REASONING_MESSAGE_CHUNK': {'messageId', 'delta'},
  'REASONING_END': {'messageId'},
  'REASONING_ENCRYPTED_VALUE': {'subtype', 'entityId', 'encryptedValue'},
  'SUBAGENT_STARTED': {
    'subagentRunId',
    'name',
    'description',
    'parentSubagentRunId',
    'parentToolCallId',
    'parentMessageId',
  },
  'SUBAGENT_FINISHED': {'subagentRunId', 'result', 'outcome'},
  'SUBAGENT_ERROR': {'subagentRunId', 'message', 'code'},
};

const Set<String> _baseFields = {
  'type',
  'timestamp',
  'rawEvent',
  'metadata',
};

/// The events the schema does not compose with `Attributable`.
///
/// `SUBAGENT_STARTED/FINISHED/ERROR` name their own `subagentRunId` field, so
/// they stay attributable; these four do not describe it at all.
const Set<String> _notAttributable = {
  'MESSAGES_SNAPSHOT',
  'RUN_STARTED',
  'RUN_FINISHED',
  'RUN_ERROR',
};

const Set<String> _contentPartTypes = {
  'text',
  'image',
  'audio',
  'video',
  'document',
};

/// Removes everything the 1.0 protocol does not describe, warning once per
/// removal, and drops events nothing translated.
Stream<BaseEvent> enforceEvents(
  Stream<BaseEvent> source, {
  Object? debugLogger,
}) async* {
  final log = resolveDebugLogger(debugLogger);
  await for (final event in source) {
    if (!event.isProtocolEvent) {
      AgUiDiagnostics.warn(
        "Dropping unrecognised event '${event.type}': no middleware "
        'translated it and the protocol does not describe it.',
      );
      final summary = {'type': event.type};
      log?.event('ENFORCE', 'Unrecognised event dropped:', summary, summary);
      continue;
    }

    final raw = Map<String, dynamic>.from(wireJsonOf(event));
    final changed = _stripUnrecognised(event, raw);
    if (!changed) {
      yield event;
      continue;
    }
    yield BaseEvent.fromJson(raw);
  }
}

/// Strips unrecognised material from [raw] in place; returns whether anything
/// was removed.
bool _stripUnrecognised(BaseEvent event, Map<String, dynamic> raw) {
  var changed = false;
  final allowed = {
    ..._baseFields,
    ...?_eventFields[event.type],
    if (!_notAttributable.contains(event.type)) 'subagentRunId',
  };

  for (final key in raw.keys.toList()) {
    if (allowed.contains(key)) continue;
    AgUiDiagnostics.warn(
      "Removed unrecognised material at '/$key' on ${event.type}. "
      'Nothing handled it; see the repo-root DEPRECATIONS.md if it is a '
      'retired shape.',
    );
    raw.remove(key);
    changed = true;
  }

  // An outcome the protocol does not describe is an optional position, so it
  // is stripped rather than made fatal; the terminal event survives intact.
  if (event is RunFinishedEvent && event.outcome is UnknownRunFinishedOutcome) {
    AgUiDiagnostics.warn(
      "Removed unrecognised material at '/outcome' on ${event.type}. "
      'Nothing handled it; see the repo-root DEPRECATIONS.md if it is a '
      'retired shape.',
    );
    raw.remove('outcome');
    changed = true;
  }

  if (event is SubagentFinishedEvent &&
      event.outcome is UnknownSubagentFinishedOutcome) {
    AgUiDiagnostics.warn(
      "Removed unrecognised material at '/outcome' on ${event.type}. "
      'Nothing handled it; see the repo-root DEPRECATIONS.md if it is a '
      'retired shape.',
    );
    raw.remove('outcome');
    changed = true;
  }

  // Unknown members inside a list are skipped; the list and its conformant
  // members survive.
  changed |= _stripUnknownPartsIn(raw, 'content', []);

  final messages = raw['messages'];
  if (messages is List) {
    for (var index = 0; index < messages.length; index++) {
      final message = messages[index];
      if (message is! Map) continue;
      final map = Map<String, dynamic>.from(message);
      changed |= _stripUnknownPartsIn(map, 'content', ['messages', '$index']);
      messages[index] = map;
    }
  }

  final input = raw['input'];
  if (input is Map) {
    final inputMap = Map<String, dynamic>.from(input);
    final inputMessages = inputMap['messages'];
    if (inputMessages is List) {
      for (var index = 0; index < inputMessages.length; index++) {
        final message = inputMessages[index];
        if (message is! Map) continue;
        final map = Map<String, dynamic>.from(message);
        changed |= _stripUnknownPartsIn(
          map,
          'content',
          ['input', 'messages', '$index'],
        );
        inputMessages[index] = map;
      }
      raw['input'] = inputMap;
    }
  }

  return changed;
}

bool _stripUnknownPartsIn(
  Map<String, dynamic> holder,
  String field,
  List<String> pathPrefix,
) {
  final value = holder[field];
  if (value is! List) return false;

  var changed = false;
  final kept = <Object?>[];
  for (var index = 0; index < value.length; index++) {
    final part = value[index];
    final type = part is Map ? part['type'] : null;
    final recognised = type is String && _contentPartTypes.contains(type);
    if (recognised) {
      kept.add(part);
      continue;
    }
    final path = ['', ...pathPrefix, field, '$index'].join('/');
    AgUiDiagnostics.warn(
      "Removed unrecognised material at '$path'. Nothing handled it; see the "
      'repo-root DEPRECATIONS.md if it is a retired shape.',
    );
    changed = true;
  }
  if (changed) {
    holder[field] = kept;
  }
  return changed;
}
