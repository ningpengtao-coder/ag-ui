import 'dart:async';

import 'package:test/test.dart';

import '../bin/a2ui_custom_catalog_example.dart' as custom_catalog;
import '../bin/a2ui_middleware_example.dart' as legacy_alias;
import '../bin/a2ui_skill_routing_example.dart' as skill_routing;

Future<List<String>> _capturePrintedLines(Future<void> Function() action) async {
  final lines = <String>[];

  await runZoned(
    () async {
      await action();
    },
    zoneSpecification: ZoneSpecification(
      print: (_, __, ___, String line) {
        lines.add(line);
      },
    ),
  );

  return lines;
}

void main() {
  group('A2UI example binaries', () {
    test('custom catalog example prints custom catalog output', () async {
      final lines = await _capturePrintedLines(custom_catalog.main);
      final output = lines.join('\n');

      expect(output, contains('custom catalog run messages:'));
      expect(output, contains('assistant-custom-catalog'));
      expect(output, contains('myapp://custom-dashboard-catalog'));
      expect(output, contains('StatusBadge'));
      expect(output, contains('MetricCard'));
    });

    test('skill routing example prints render and follow-up output', () async {
      final lines = await _capturePrintedLines(skill_routing.main);
      final output = lines.join('\n');

      expect(output, contains('salesSkill render run messages:'));
      expect(output, contains('assistant-sales-skill'));
      expect(output, contains('myapp://sales-catalog'));
      expect(output, contains('FilterBar'));
      expect(output, contains('salesSkill action follow-up messages:'));
      expect(output, contains('assistant-msg-a2ui-action'));
    });

    test('legacy middleware example delegates to skill routing example', () async {
      final lines = await _capturePrintedLines(legacy_alias.main);
      final output = lines.join('\n');

      expect(output, contains('salesSkill render run messages:'));
      expect(output, contains('assistant-sales-skill'));
      expect(output, contains('assistant-msg-a2ui-action'));
    });
  });
}
