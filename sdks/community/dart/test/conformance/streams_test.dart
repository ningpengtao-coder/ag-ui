/// The Dart conformance lane: every shared fixture stream, replayed over real
/// HTTP/SSE into a real [HttpAgent], asserted against the outcome the
/// specification requires.
///
/// The fixtures live in `spec/1.0/conformance/streams/` and are the same files
/// the TypeScript and .NET lanes replay. The stream arrives the way a producer
/// would send it — one SSE frame per event — so this exercises the whole
/// consumer: the SSE reader, the compatibility boundary, middleware,
/// enforcement, chunk expansion, verification and the reducer.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ag_ui/ag_ui.dart';
import 'package:test/test.dart';

/// Walks up from this file rather than counting `..`, so moving the runner
/// cannot silently point it at a directory that does not exist.
Directory _repoRoot() {
  var dir = Directory.current;
  while (true) {
    final candidate = Directory('${dir.path}/spec/1.0/conformance');
    if (candidate.existsSync()) return dir;
    final parent = dir.parent;
    if (parent.path == dir.path) {
      throw StateError('no repository root above the conformance runner');
    }
    dir = parent;
  }
}

final Directory _streamsDir = Directory(
  '${_repoRoot().path}/spec/1.0/conformance/streams',
);

List<Map<String, dynamic>> _loadFixtures() {
  final names = _streamsDir
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.json'))
      .map((file) => file.uri.pathSegments.last)
      .toList()
    ..sort();
  return names
      .map(
        (name) =>
            jsonDecode(File('${_streamsDir.path}/$name').readAsStringSync())
                as Map<String, dynamic>,
      )
      .toList();
}

/// Deep subset match: every key the expectation names must be present and
/// equal; keys it does not name are ignored.
bool _matchesSubset(Object? actual, Object? expected) {
  if (expected is List) {
    if (actual is! List || actual.length != expected.length) return false;
    for (var index = 0; index < expected.length; index++) {
      if (!_matchesSubset(actual[index], expected[index])) return false;
    }
    return true;
  }
  if (expected is Map) {
    if (actual is! Map) return false;
    for (final entry in expected.entries) {
      if (!actual.containsKey(entry.key)) return false;
      if (!_matchesSubset(actual[entry.key], entry.value)) return false;
    }
    return true;
  }
  return actual == expected;
}

bool _pathExists(Object? value, String path) =>
    _readPath(value, path) != _absent;

Object? _readPath(Object? value, String path) {
  Object? node = value;
  for (final key in path.split('.')) {
    if (node is List) {
      final index = int.tryParse(key);
      if (index == null || index < 0 || index >= node.length) return _absent;
      node = node[index];
      continue;
    }
    if (node is! Map) return _absent;
    if (!node.containsKey(key)) return _absent;
    node = node[key];
  }
  return node;
}

const Object _absent = Object();

class _Replay {
  final List<String> eventTypes = [];
  final List<Map<String, dynamic>> events = [];
  final List<String> warnings = [];
  String? runError;
  String outcome = 'completed';
  String? error;
  Map<String, dynamic>? request;
  List<Map<String, dynamic>> messages = [];
  Object? state;
}

class _FixtureAgent extends HttpAgent {
  final String? pinned;

  _FixtureAgent(HttpAgentConfig config, this.pinned) : super(config);

  @override
  String get maxProtocolVersion => pinned ?? super.maxProtocolVersion;
}

Future<_Replay> _replay(Map<String, dynamic> fixture) async {
  final stream = (fixture['stream'] as List).cast<Map<String, dynamic>>();
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  final replay = _Replay();

  server.listen((request) async {
    final body = await utf8.decoder.bind(request).join();
    replay.request = jsonDecode(body) as Map<String, dynamic>;
    request.response.headers.contentType = ContentType('text', 'event-stream');
    for (final event in stream) {
      request.response.write('data: ${jsonEncode(event)}\n\n');
    }
    await request.response.close();
  });

  final fixtureClient = fixture['client'] as Map<String, dynamic>?;
  final pinned = fixtureClient?['maxProtocolVersion'] as String?;

  final client = AgUiClient(
    config: AgUiClientConfig(baseUrl: 'http://127.0.0.1:${server.port}'),
  );
  final agent = _FixtureAgent(
    HttpAgentConfig(
      client: client,
      endpoint: 'agent',
      threadId: 'conformance-thread',
    ),
    pinned,
  );

  final input = fixture['input'] as Map<String, dynamic>?;
  if (input?['messages'] != null) {
    agent.messages = (input!['messages'] as List)
        .cast<Map<String, dynamic>>()
        .map(Message.fromJson)
        .toList();
  }

  final subscriber = AgentSubscriber(
    onEvent: (context) {
      replay.eventTypes.add(context.event.type);
      replay.events.add(context.event.toJson());
      return null;
    },
    onRunErrorEvent: (context) {
      replay.runError = context.event.message;
      return null;
    },
  );

  final previousHandler = AgUiDiagnostics.handler;
  final previousSuppress = AgUiDiagnostics.suppress;
  AgUiDiagnostics.handler = replay.warnings.add;
  AgUiDiagnostics.suppress = true;

  try {
    await agent.runAgent(
      RunAgentParameters(
        tools: (input?['tools'] as List?)
            ?.cast<Map<String, dynamic>>()
            .map(Tool.fromJson)
            .toList(),
        context: (input?['context'] as List?)
            ?.cast<Map<String, dynamic>>()
            .map(Context.fromJson)
            .toList(),
        forwardedProps: input?['forwardedProps'],
      ),
      subscriber,
    );
  } catch (thrown) {
    replay.outcome = 'failed';
    replay.error = _messageOf(thrown);
  } finally {
    AgUiDiagnostics.handler = previousHandler;
    AgUiDiagnostics.suppress = previousSuppress;
    await client.close();
    await server.close(force: true);
  }

  replay.messages = agent.messages.map((message) => message.toJson()).toList();
  replay.state = agent.state;
  return replay;
}

/// The message a rejection must be matched against.
///
/// The TypeScript lane matches `Error.message`; the Dart SDK has two error
/// hierarchies, so unwrap both rather than falling back to `toString()`, whose
/// type prefix and cause chain could satisfy a `errorContains` the message
/// itself does not.
String _messageOf(Object error) {
  if (error is AgUiError) return error.message;
  if (error is AGUIError) return error.message;
  return error.toString();
}

/// Applies the TypeScript lane's override, exactly as `resolveExpectation`
/// does: keys present there replace the base expectation for this lane.
///
/// The Dart client expands chunks and enforces the protocol, which is what the
/// `typescript` override describes; ignoring it would discard the only
/// discriminating assertion in fixtures such as
/// `subagent-terminal-closes-open-chunk-stream`.
Map<String, dynamic> _resolveExpectation(Map<String, dynamic> fixture) {
  final resolved = Map<String, dynamic>.from(
    fixture['expect'] as Map<String, dynamic>,
  );
  final overrides = fixture['expectOverrides'] as Map<String, dynamic>?;
  final typescript = overrides?['typescript'] as Map<String, dynamic>?;
  if (typescript == null) return resolved;
  for (final entry in typescript.entries) {
    if (entry.key == 'intentional') continue;
    resolved[entry.key] = entry.value;
  }
  return resolved;
}

void _assertExpectation(_Replay replay, Map<String, dynamic> fixture) {
  final expectation = _resolveExpectation(fixture);
  final name = fixture['name'];
  final reason = 'fixture $name: ${replay.error ?? ''}';

  if (expectation['outcome'] != null) {
    expect(replay.outcome, expectation['outcome'], reason: reason);
  }
  if (expectation['errorContains'] != null) {
    expect(
        replay.error ?? '', contains(expectation['errorContains'] as String));
  }
  if (expectation['eventTypes'] != null) {
    expect(replay.eventTypes, expectation['eventTypes']);
  }
  for (final type in (expectation['eventTypesAbsent'] as List?) ?? const []) {
    expect(replay.eventTypes, isNot(contains(type)));
  }
  final eventPaths = expectation['eventPaths'] as Map<String, dynamic>?;
  if (eventPaths != null) {
    eventPaths.forEach((path, value) {
      expect(_pathExists(replay.events, path), isTrue, reason: '$path missing');
      expect(_readPath(replay.events, path), value);
    });
  }
  for (final path in (expectation['eventAbsentPaths'] as List?) ?? const []) {
    expect(
      _pathExists(replay.events, path as String),
      isFalse,
      reason: '$path present',
    );
  }
  if (expectation['runError'] != null) {
    if (expectation['runError'] == false) {
      expect(replay.runError, isNull);
    } else {
      expect(replay.runError, isNotNull);
      if (expectation['runError'] is String) {
        expect(replay.runError, contains(expectation['runError'] as String));
      }
    }
  }
  for (final substring in (expectation['warnings'] as List?) ?? const []) {
    expect(
      replay.warnings.any((warning) => warning.contains(substring as String)),
      isTrue,
      reason:
          'expected a warning containing "$substring"; saw ${replay.warnings}',
    );
  }
  if (expectation['noWarnings'] == true) {
    expect(replay.warnings, isEmpty);
  }
  if (expectation['messageCount'] != null) {
    expect(replay.messages.length, expectation['messageCount']);
  }
  if (expectation['messages'] != null) {
    expect(
      _matchesSubset(replay.messages, expectation['messages']),
      isTrue,
      reason: 'messages: ${jsonEncode(replay.messages)}',
    );
  }
  // Presence, not non-null: `state: null` is a value the fixture asserts,
  // exactly like the TypeScript lane's `!== undefined` check.
  if (expectation.containsKey('state')) {
    expect(
      _matchesSubset(replay.state, expectation['state']),
      isTrue,
      reason: 'state: ${jsonEncode(replay.state)}',
    );
  }
  if (expectation['request'] != null) {
    expect(
      _matchesSubset(replay.request, expectation['request']),
      isTrue,
      reason: 'request: ${jsonEncode(replay.request)}',
    );
  }
  for (final path in (expectation['requestAbsentPaths'] as List?) ?? const []) {
    expect(
      _pathExists(replay.request, path as String),
      isFalse,
      reason: '$path present in request',
    );
  }
}

void main() {
  final fixtures = _loadFixtures();

  test('has fixtures to run', () {
    expect(fixtures, isNotEmpty);
  });

  for (final fixture in fixtures) {
    test(
      '${fixture['area']}: ${fixture['name']} — ${fixture['description']}',
      () async {
        final replay = await _replay(fixture);
        _assertExpectation(replay, fixture);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  }
}
