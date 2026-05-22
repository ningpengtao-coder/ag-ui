library;

import '../types/tool.dart';

/// Tool name for the structured render_a2ui tool.
const String renderA2UIToolName = 'render_a2ui';

/// Tool name for logging A2UI events.
const String logA2UIEventToolName = 'log_a2ui_event';

/// Tool definition for rendering A2UI surfaces.
const Tool renderA2UITool = Tool(
  name: renderA2UIToolName,
  description:
      'Render a dynamic A2UI v0.9 surface with structured parameters. '
      'Follow the A2UI render tool usage guide provided in context.',
  parameters: {
    'type': 'object',
    'properties': {
      'surfaceId': {
        'type': 'string',
        'description': 'Unique surface identifier.',
      },
      'catalogId': {
        'type': 'string',
        'description': 'The catalog ID for the component catalog.',
      },
      'components': {
        'type': 'array',
        'description':
            'A2UI v0.9 component array in flat format. '
            'The root component must have id "root".',
        'items': {'type': 'object'},
      },
      'data': {
        'type': 'object',
        'description':
            'Initial data model for the surface. Written to the root path.',
      },
    },
    'required': ['surfaceId', 'components'],
  },
);

String renderA2UIToolGuidelines(String toolName) => '''
## How to call $toolName

You MUST provide all required arguments when calling $toolName:

- `surfaceId` (string, required): unique ID for the surface.
- `catalogId` (string): the catalog ID from the available components context.
- `components` (array, required): A2UI v0.9 flat component array.
- `data` (object, optional): initial data model for path-bound values.

### Component format

- Components are a flat array.
- Every component has `id` and `component`.
- The root component MUST have `id: "root"`.
- Use `children: ["id1", "id2"]` for multiple children.
- Use `child: "id"` for a single child.

### Minimal example

```json
{
  "surfaceId": "my-dashboard",
  "catalogId": "copilotkit://app-dashboard-catalog",
  "components": [
    { "id": "root", "component": "Column", "children": ["title"] },
    { "id": "title", "component": "Text", "text": "Overview" }
  ]
}
```
''';
