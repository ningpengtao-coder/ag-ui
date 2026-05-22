library;

import '../types/base.dart';

/// A2UI v0.9 inline catalog schema.
class A2UIInlineCatalogSchema extends AGUIModel {
  final String catalogId;
  final Map<String, Map<String, dynamic>> components;

  const A2UIInlineCatalogSchema({
    required this.catalogId,
    required this.components,
  });

  factory A2UIInlineCatalogSchema.fromJson(Map<String, dynamic> json) {
    final rawComponents = JsonDecoder.requireField<Map<String, dynamic>>(
      json,
      'components',
    );
    return A2UIInlineCatalogSchema(
      catalogId: JsonDecoder.requireField<String>(json, 'catalogId'),
      components: rawComponents.map(
        (key, value) => MapEntry(
          key,
          Map<String, dynamic>.from(value as Map),
        ),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'catalogId': catalogId,
    'components': components,
  };

  @override
  A2UIInlineCatalogSchema copyWith({
    String? catalogId,
    Map<String, Map<String, dynamic>>? components,
  }) {
    return A2UIInlineCatalogSchema(
      catalogId: catalogId ?? this.catalogId,
      components: components ?? this.components,
    );
  }
}

/// Legacy component schema definition with `{ name, props }` format.
@Deprecated('Use A2UIInlineCatalogSchema instead.')
class A2UIComponentSchema extends AGUIModel {
  final String name;
  final String? description;
  final Map<String, dynamic>? props;
  final List<String>? slots;

  const A2UIComponentSchema({
    required this.name,
    this.description,
    this.props,
    this.slots,
  });

  factory A2UIComponentSchema.fromJson(Map<String, dynamic> json) {
    return A2UIComponentSchema(
      name: JsonDecoder.requireField<String>(json, 'name'),
      description: JsonDecoder.optionalField<String>(json, 'description'),
      props: JsonDecoder.optionalField<Map<String, dynamic>>(json, 'props'),
      slots: JsonDecoder.optionalListField<String>(json, 'slots'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
    if (description != null) 'description': description,
    if (props != null) 'props': props,
    if (slots != null) 'slots': slots,
  };

  @override
  A2UIComponentSchema copyWith({
    String? name,
    String? description,
    Map<String, dynamic>? props,
    List<String>? slots,
  }) {
    return A2UIComponentSchema(
      name: name ?? this.name,
      description: description ?? this.description,
      props: props ?? this.props,
      slots: slots ?? this.slots,
    );
  }
}

/// Configuration for the A2UI middleware.
class A2UIMiddlewareConfig extends AGUIModel {
  /// Accepts `A2UIInlineCatalogSchema` or `List<A2UIComponentSchema>`.
  final Object? schema;

  /// Accepts:
  /// - `true` to inject `render_a2ui`
  /// - `String` to inject a custom tool name
  /// - `false` / `null` to skip tool injection
  final Object? injectA2UITool;

  final List<String>? a2uiToolNames;

  const A2UIMiddlewareConfig({
    this.schema,
    this.injectA2UITool,
    this.a2uiToolNames,
  });

  @override
  Map<String, dynamic> toJson() => {
    if (schema != null) 'schema': _serializeSchema(schema),
    if (injectA2UITool != null) 'injectA2UITool': injectA2UITool,
    if (a2uiToolNames != null) 'a2uiToolNames': a2uiToolNames,
  };

  @override
  A2UIMiddlewareConfig copyWith({
    Object? schema,
    Object? injectA2UITool,
    List<String>? a2uiToolNames,
  }) {
    return A2UIMiddlewareConfig(
      schema: schema ?? this.schema,
      injectA2UITool: injectA2UITool ?? this.injectA2UITool,
      a2uiToolNames: a2uiToolNames ?? this.a2uiToolNames,
    );
  }
}

/// User action payload sent via `forwardedProps.a2uiAction`.
class A2UIUserAction extends AGUIModel {
  final String? name;
  final String? surfaceId;
  final String? sourceComponentId;
  final Map<String, dynamic>? context;
  final String? timestamp;

  const A2UIUserAction({
    this.name,
    this.surfaceId,
    this.sourceComponentId,
    this.context,
    this.timestamp,
  });

  factory A2UIUserAction.fromJson(Map<String, dynamic> json) {
    return A2UIUserAction(
      name: JsonDecoder.optionalField<String>(json, 'name'),
      surfaceId: JsonDecoder.optionalField<String>(json, 'surfaceId'),
      sourceComponentId: JsonDecoder.optionalField<String>(
        json,
        'sourceComponentId',
      ),
      context: JsonDecoder.optionalField<Map<String, dynamic>>(json, 'context'),
      timestamp: JsonDecoder.optionalField<String>(json, 'timestamp'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (surfaceId != null) 'surfaceId': surfaceId,
    if (sourceComponentId != null) 'sourceComponentId': sourceComponentId,
    if (context != null) 'context': context,
    if (timestamp != null) 'timestamp': timestamp,
  };

  @override
  A2UIUserAction copyWith({
    String? name,
    String? surfaceId,
    String? sourceComponentId,
    Map<String, dynamic>? context,
    String? timestamp,
  }) {
    return A2UIUserAction(
      name: name ?? this.name,
      surfaceId: surfaceId ?? this.surfaceId,
      sourceComponentId: sourceComponentId ?? this.sourceComponentId,
      context: context ?? this.context,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

Object? _serializeSchema(Object? schema) {
  if (schema is A2UIInlineCatalogSchema) {
    return schema.toJson();
  }
  if (schema is List<A2UIComponentSchema>) {
    return schema.map((item) => item.toJson()).toList();
  }
  return schema;
}
