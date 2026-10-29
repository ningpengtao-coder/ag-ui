/// Retained for API compatibility: upgrades legacy binary content parts into
/// the modern media parts.
///
/// The conversion itself is not version-gated. A legacy `{"type":"binary"}`
/// part is retired material whose shape identifies the conversion regardless of
/// the peer ceiling, so the always-on compatibility boundary performs it for
/// every run. This class now delegates to that one implementation
/// ([upgradeMessageContent]) and is no longer installed automatically.
library;

import '../agent/agent.dart';
import '../events/events.dart';
import '../types/types.dart';
import 'legacy_content.dart';
import 'middleware.dart';

class BackwardCompatibility_0_0_47 extends Middleware {
  @override
  Stream<BaseEvent> run(RunAgentInput input, AbstractAgent next) {
    final upgradedInput = input.copyWith(
      messages: input.messages.map(upgradeMessageContent).toList(),
    );

    return runNext(upgradedInput, next);
  }
}
