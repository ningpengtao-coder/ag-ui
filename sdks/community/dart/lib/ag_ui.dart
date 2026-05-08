/// AG-UI Dart SDK.
///
/// `package:ag_ui/ag_ui.dart` is the main public entry point for the Dart SDK.
/// It mirrors the TypeScript `@ag-ui/client` package by exposing:
///
/// - `HttpAgent` for stateful agent runs with middleware and subscribers
/// - `AgUiClient` for direct HTTP streaming to AG-UI servers
/// - protocol types, event models, transforms, verification, and encoding helpers
///
/// ## Getting started
///
/// ```dart
/// import 'package:ag_ui/ag_ui.dart';
///
/// Future<void> main() async {
///   final client = AgUiClient(
///     config: AgUiClientConfig(
///       baseUrl: 'http://localhost:8000',
///     ),
///   );
///
///   final agent = HttpAgent(
///     HttpAgentConfig(
///       client: client,
///       endpoint: 'agent',
///       initialMessages: [
///         UserMessage(
///           id: 'msg_1',
///           content: 'Hello, world!',
///         ),
///       ],
///     ),
///   );
///
///   final result = await agent.runAgent();
///   print(result.newMessages);
///
///   await client.close();
/// }
/// ```
library ag_ui;

// Match the TypeScript client package shape as closely as Dart allows.
export 'src/apply/index.dart';
export 'src/verify/index.dart';
export 'src/transform/index.dart';
export 'src/run/http_request.dart';
export 'src/legacy/convert.dart';
export 'src/agent/index.dart';
export 'src/compact/index.dart';
export 'src/types/types.dart';
export 'src/events/events.dart';
export 'src/middleware/middleware.dart';
export 'src/interrupts/index.dart';
export 'src/capabilities.dart';
export 'src/event_factories.dart';
export 'src/debug_logger.dart';
export 'src/proto/proto.dart';

// Direct client API used by Dart applications to connect to AG-UI servers.
export 'src/client/client.dart';
export 'src/client/config.dart';
export 'src/client/errors.dart';
export 'src/client/validators.dart';

// Encoder/decoder utilities.
export 'src/encoder/encoder.dart';
export 'src/encoder/decoder.dart';
export 'src/encoder/stream_adapter.dart';
export 'src/encoder/errors.dart' hide ValidationError;
export 'src/encoder/client_codec.dart' hide ToolResult;

// Lower-level SSE helpers.
export 'src/sse/sse_client.dart';
export 'src/sse/sse_message.dart';
export 'src/sse/backoff_strategy.dart';

/// SDK version
const String agUiVersion = '0.0.53';

/// AG-UI does not require global initialization.
@Deprecated(
  'Initialization is not required. Import package:ag_ui/ag_ui.dart and '
  'construct AgUiClient or HttpAgent directly.',
)
void initAgUI() {
  // No-op kept for backward compatibility.
}
