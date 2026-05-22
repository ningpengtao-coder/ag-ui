# ag_ui

Client SDK for connecting to **Agent-User Interaction (AG-UI) Protocol** servers.

`ag_ui` mirrors the TypeScript `@ag-ui/client` package as closely as Dart allows:

- `HttpAgent` for stateful agent execution with middleware and subscribers
- `AgUiClient` for direct HTTP streaming to AG-UI servers
- protocol events, types, transforms, verification, and encoding utilities from one import

## Configuring The Server URL

In Dart, `HttpAgent` uses the same transport client as `AgUiClient`:

- `AgUiClientConfig.baseUrl` is the AG-UI server base address
- `HttpAgentConfig.endpoint` is the agent path, such as `agent` or `agentic_chat`
- if `endpoint` is an absolute URL, it is used directly

Example:

```dart
final client = AgUiClient(
  config: AgUiClientConfig(
    baseUrl: 'https://api.example.com',
  ),
);

final agent = HttpAgent(
  HttpAgentConfig(
    client: client,
    endpoint: 'agentic_chat',
  ),
);
```

This resolves to `https://api.example.com/agentic_chat`.

## Installation

```bash
dart pub add ag_ui
```

Or add to your `pubspec.yaml`:

```yaml
dependencies:
  ag_ui: ^0.0.53
```

## Features

- HTTP connectivity with SSE support via `AgUiClient`
- Stateful agent execution via `HttpAgent`
- Event streaming with verification and chunk normalization
- State and message application helpers
- Middleware and subscriber hooks
- Protocol types, event factories, and protobuf helpers

## Quick Example

```dart
import 'package:ag_ui/ag_ui.dart';

Future<void> main() async {
  final client = AgUiClient(
    config: AgUiClientConfig(
      baseUrl: 'https://api.example.com', // AG-UI server base URL
      defaultHeaders: {'Authorization': 'Bearer token'},
    ),
  );

  final agent = HttpAgent(
    HttpAgentConfig(
      client: client,
      endpoint: 'agent', // Agent endpoint path
      initialMessages: [
        UserMessage(
          id: 'msg_1',
          content: 'Hello!',
        ),
      ],
    ),
  );

  final result = await agent.runAgent();
  print(result.newMessages);

  await client.close();
}
```

If you prefer, you can also pass a full URL as the endpoint:

```dart
final agent = HttpAgent(
  HttpAgentConfig(
    client: client,
    endpoint: 'https://api.example.com/agent',
  ),
);
```

## Direct Client Example

```dart
import 'package:ag_ui/ag_ui.dart';

Future<void> main() async {
  final client = AgUiClient(
    config: AgUiClientConfig(
      baseUrl: 'https://api.example.com',
      defaultHeaders: {'Authorization': 'Bearer token'},
    ),
  );

  final input = SimpleRunAgentInput(
    messages: [
      UserMessage(
        id: 'msg_123',
        content: 'Hello from Dart!',
      ),
    ],
  );

  await for (final event in client.runAgent('agentic_chat', input)) {
    if (event is TextMessageContentEvent) {
      print('Assistant: ${event.delta}');
    } else if (event is ToolCallStartEvent) {
      print('Calling tool: ${event.toolCallName}');
    }
  }

  await client.close();
}
```

## Using Middleware

```dart
import 'package:ag_ui/ag_ui.dart';

Future<void> main() async {
  final client = AgUiClient(
    config: AgUiClientConfig(
      baseUrl: 'https://api.example.com',
    ),
  );

  final agent = HttpAgent(
    HttpAgentConfig(
      client: client,
      endpoint: 'agent',
      initialMessages: [
        UserMessage(
          id: 'msg_1',
          content: 'Hello!',
        ),
      ],
    ),
  );

  agent.use(
    (input, next) {
      print('Starting run: ${input.runId}');
      return next.run(input);
    },
    FilterToolCallsMiddleware(
      allowedToolCalls: ['search', 'calculate'],
    ),
  );

  await agent.runAgent();
  await client.close();
}
```

## Using A2UI Middleware

The Dart SDK now includes `A2UIMiddleware` for bridging AG-UI runs to
client-rendered A2UI surfaces.

It can:

- inject the `render_a2ui` tool definition
- inject component catalog schema into `RunAgentInput.context`
- convert `forwardedProps.a2uiAction` into synthetic tool-call messages
- transform streamed or final A2UI tool output into `ActivitySnapshotEvent`

Example:

```dart
import 'package:ag_ui/ag_ui.dart';

Future<void> main() async {
  final client = AgUiClient(
    config: AgUiClientConfig(
      baseUrl: 'https://api.example.com',
    ),
  );

  final agent = HttpAgent(
    HttpAgentConfig(
      client: client,
      endpoint: 'agent',
    ),
  );

  agent.use(
    A2UIMiddleware(
      A2UIMiddlewareConfig(
        injectA2UITool: true,
        schema: const A2UIInlineCatalogSchema(
          catalogId: 'copilotkit://app-dashboard-catalog',
          components: {
            'Text': {'type': 'object'},
            'Column': {'type': 'object'},
            'Button': {'type': 'object'},
          },
        ),
      ),
    ),
  );

  final result = await agent.runAgent(
    RunAgentParameters(
      context: const [
        Context(
          description: 'Product requirements',
          value: 'Build a compact dashboard surface when helpful.',
        ),
      ],
    ),
  );

  final activityMessages = result.newMessages.whereType<ActivityMessage>();
  for (final activity in activityMessages) {
    print('${activity.activityType}: ${activity.content}');
  }

  await client.close();
}
```

If the UI forwards an A2UI interaction back to the agent, attach it to
`forwardedProps`:

```dart
final result = await agent.runAgent(
  RunAgentParameters(
    forwardedProps: {
      'a2uiAction': {
        'userAction': {
          'name': 'submit_form',
          'surfaceId': 'contact-form',
          'sourceComponentId': 'submit-btn',
          'context': {'email': 'alice@example.com'},
        },
      },
    },
  ),
);
```

The middleware converts that payload into synthetic `AssistantMessage` and
`ToolMessage` entries so the next run can react to the user action naturally.

### Switching catalogs by skill

`A2UIMiddlewareConfig.schema` is configured on the middleware instance, so the
catalog is not switched automatically per `runAgent()` call. If you want
different skills to expose different UI components, the most reliable pattern
is:

- route the request to a skill first
- give each skill its own agent or middleware configuration
- attach `A2UIMiddleware` with the catalog for that skill
- let the chosen skill decide whether to call `render_a2ui`

Example:

```dart
import 'package:ag_ui/ag_ui.dart';

const salesCatalog = A2UIInlineCatalogSchema(
  catalogId: 'myapp://sales-catalog',
  components: {
    'Column': {'type': 'object'},
    'Text': {'type': 'object'},
    'MetricCard': {
      'type': 'object',
      'properties': {
        'label': {'type': 'string'},
        'value': {'type': 'string'},
      },
    },
  },
);

const supportCatalog = A2UIInlineCatalogSchema(
  catalogId: 'myapp://support-catalog',
  components: {
    'Column': {'type': 'object'},
    'Text': {'type': 'object'},
    'TicketList': {'type': 'object'},
  },
);

AbstractAgent attachCatalog(
  AbstractAgent agent,
  A2UIInlineCatalogSchema catalog,
) {
  agent.use(
    A2UIMiddleware(
      A2UIMiddlewareConfig(
        injectA2UITool: true,
        schema: catalog,
      ),
    ),
  );

  return agent;
}

Future<RunAgentResult> routeBySkill({
  required String skill,
  required AbstractAgent Function() createAgent,
  RunAgentParameters parameters = const RunAgentParameters(),
}) {
  final catalog = switch (skill) {
    'sales' => salesCatalog,
    'support' => supportCatalog,
    _ => throw UnsupportedError('Unknown skill: $skill'),
  };

  final agent = attachCatalog(createAgent(), catalog);
  return agent.runAgent(parameters);
}
```

The important split is:

- the skill decides when UI is needed
- the middleware schema limits which components that skill can render
- `render_a2ui` carries the structured UI payload
- `forwardedProps.a2uiAction` sends user interaction back into the same skill

## Lower-Level Modules

All common APIs are exported from `package:ag_ui/ag_ui.dart`, including:

- agent types and subscribers
- events and protocol models
- `transform`, `verify`, `apply`, and `compact`
- middleware and interrupt helpers
- protobuf and encoder utilities

## Documentation

- Concepts & architecture: [`docs/concepts`](https://docs.ag-ui.com/concepts/architecture)
- Full API reference: [`docs/sdk/dart`](https://docs.ag-ui.com/sdk/dart/client/overview)

## License

This SDK is part of the AG-UI Protocol project. See the [main repository](https://github.com/ag-ui-protocol/ag-ui) for license information.
