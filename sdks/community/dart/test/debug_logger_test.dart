import 'dart:async';

import 'package:ag_ui/ag_ui.dart';
import 'package:test/test.dart';

void main() {
  group('resolveAgentDebugConfig', () {
    test('null resolves to all false', () {
      expect(
        resolveAgentDebugConfig(null),
        const ResolvedAgentDebugConfig(
          enabled: false,
          events: false,
          lifecycle: false,
          verbose: false,
        ),
      );
    });

    test('true resolves to all true', () {
      expect(
        resolveAgentDebugConfig(true),
        const ResolvedAgentDebugConfig(
          enabled: true,
          events: true,
          lifecycle: true,
          verbose: true,
        ),
      );
    });

    test('granular config keeps TS defaults', () {
      expect(
        resolveAgentDebugConfig(const AgentDebugConfig(events: false)),
        const ResolvedAgentDebugConfig(
          enabled: true,
          events: false,
          lifecycle: true,
          verbose: false,
        ),
      );
    });
  });

  group('debug logger resolution', () {
    test('createDebugLogger returns null when disabled', () {
      expect(
        createDebugLogger(
          const ResolvedAgentDebugConfig(
            enabled: false,
            events: false,
            lifecycle: false,
            verbose: false,
          ),
        ),
        isNull,
      );
    });

    test('resolveDebugLogger handles booleans and instances', () {
      final logger = resolveDebugLogger(true);
      expect(logger, isA<DebugLogger>());
      expect(resolveDebugLogger(logger), same(logger));
      expect(resolveDebugLogger(false), isNull);
    });
  });

  group('DebugLogger output', () {
    test('event prints summarized payload when events enabled', () async {
      final lines = <String>[];
      await runZoned(
        () {
          const logger = DebugLogger(
            ResolvedAgentDebugConfig(
              enabled: true,
              events: true,
              lifecycle: true,
              verbose: false,
            ),
          );
          logger.event('PREFIX', 'label', {'value': 42}, {'type': 'TEST'});
        },
        zoneSpecification: ZoneSpecification(
          print: (_, __, ___, line) => lines.add(line),
        ),
      );

      expect(lines.single, '[PREFIX] label {type: TEST}');
    });

    test('lifecycle prints nothing when lifecycle disabled', () async {
      final lines = <String>[];
      await runZoned(
        () {
          const logger = DebugLogger(
            ResolvedAgentDebugConfig(
              enabled: true,
              events: true,
              lifecycle: false,
              verbose: false,
            ),
          );
          logger.lifecycle('PREFIX', 'label', {'key': 'value'});
        },
        zoneSpecification: ZoneSpecification(
          print: (_, __, ___, line) => lines.add(line),
        ),
      );

      expect(lines, isEmpty);
    });
  });
}
