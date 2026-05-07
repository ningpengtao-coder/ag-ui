import 'package:ag_ui/ag_ui.dart';
import 'package:test/test.dart';

void main() {
  group('HumanInTheLoopCapabilities', () {
    test('accepts interrupts flag', () {
      const capabilities = HumanInTheLoopCapabilities(interrupts: true);
      expect(capabilities.interrupts, isTrue);
    });

    test('accepts approveWithEdits flag', () {
      const capabilities = HumanInTheLoopCapabilities(approveWithEdits: true);
      expect(capabilities.approveWithEdits, isTrue);
    });

    test('keeps new flags nullable when omitted', () {
      const capabilities = HumanInTheLoopCapabilities(supported: true);
      expect(capabilities.interrupts, isNull);
      expect(capabilities.approveWithEdits, isNull);
    });
  });
}
