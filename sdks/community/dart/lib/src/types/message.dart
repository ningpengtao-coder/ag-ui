/// Message types for AG-UI protocol.
library;

import 'base.dart';
import 'tool.dart';

enum MessageRole {
  developer('developer'),
  system('system'),
  assistant('assistant'),
  user('user'),
  tool('tool'),
  activity('activity'),
  reasoning('reasoning');

  final String value;
  const MessageRole(this.value);

  static MessageRole fromString(String value) {
    return MessageRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => throw AGUIValidationError(
        message: 'Invalid message role: $value',
        field: 'role',
        value: value,
      ),
    );
  }
}

sealed class InputContentSource extends AGUIModel with TypeDiscriminator {
  const InputContentSource();

  factory InputContentSource.fromJson(Map<String, dynamic> json) {
    final type = JsonDecoder.requireField<String>(json, 'type');
    switch (type) {
      case 'data':
        return InputContentDataSource.fromJson(json);
      case 'url':
        return InputContentUrlSource.fromJson(json);
      default:
        throw AGUIValidationError(
          message: 'Invalid input content source type: $type',
          field: 'type',
          value: type,
          json: json,
        );
    }
  }
}

final class InputContentDataSource extends InputContentSource {
  final String value;
  final String mimeType;

  const InputContentDataSource({
    required this.value,
    required this.mimeType,
  });

  factory InputContentDataSource.fromJson(Map<String, dynamic> json) {
    return InputContentDataSource(
      value: JsonDecoder.requireField<String>(json, 'value'),
      mimeType: JsonDecoder.requireField<String>(json, 'mimeType'),
    );
  }

  @override
  String get type => 'data';

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'value': value,
    'mimeType': mimeType,
  };

  @override
  InputContentDataSource copyWith({
    String? value,
    String? mimeType,
  }) {
    return InputContentDataSource(
      value: value ?? this.value,
      mimeType: mimeType ?? this.mimeType,
    );
  }
}

final class InputContentUrlSource extends InputContentSource {
  final String value;
  final String? mimeType;

  const InputContentUrlSource({
    required this.value,
    this.mimeType,
  });

  factory InputContentUrlSource.fromJson(Map<String, dynamic> json) {
    return InputContentUrlSource(
      value: JsonDecoder.requireField<String>(json, 'value'),
      mimeType: JsonDecoder.optionalField<String>(json, 'mimeType'),
    );
  }

  @override
  String get type => 'url';

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'value': value,
    if (mimeType != null) 'mimeType': mimeType,
  };

  @override
  InputContentUrlSource copyWith({
    String? value,
    String? mimeType,
  }) {
    return InputContentUrlSource(
      value: value ?? this.value,
      mimeType: mimeType ?? this.mimeType,
    );
  }
}

sealed class InputContent extends AGUIModel with TypeDiscriminator {
  const InputContent();

  factory InputContent.fromJson(Map<String, dynamic> json) {
    final type = JsonDecoder.requireField<String>(json, 'type');
    switch (type) {
      case 'text':
        return TextInputContent.fromJson(json);
      case 'image':
        return ImageInputContent.fromJson(json);
      case 'audio':
        return AudioInputContent.fromJson(json);
      case 'video':
        return VideoInputContent.fromJson(json);
      case 'document':
        return DocumentInputContent.fromJson(json);
      case 'binary':
        return BinaryInputContent.fromJson(json);
      default:
        throw AGUIValidationError(
          message: 'Invalid input content type: $type',
          field: 'type',
          value: type,
          json: json,
        );
    }
  }
}

final class TextInputContent extends InputContent {
  final String text;

  const TextInputContent({
    required this.text,
  });

  factory TextInputContent.fromJson(Map<String, dynamic> json) {
    return TextInputContent(
      text: JsonDecoder.requireField<String>(json, 'text'),
    );
  }

  @override
  String get type => 'text';

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'text': text,
  };

  @override
  TextInputContent copyWith({
    String? text,
  }) {
    return TextInputContent(
      text: text ?? this.text,
    );
  }
}

abstract class _SourceBackedInputContent extends InputContent {
  final InputContentSource source;
  final Object? metadata;

  const _SourceBackedInputContent({
    required this.source,
    this.metadata,
  });

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'source': source.toJson(),
    if (metadata != null) 'metadata': metadata,
  };
}

final class ImageInputContent extends _SourceBackedInputContent {
  const ImageInputContent({
    required super.source,
    super.metadata,
  });

  factory ImageInputContent.fromJson(Map<String, dynamic> json) {
    return ImageInputContent(
      source: InputContentSource.fromJson(
        JsonDecoder.requireField<Map<String, dynamic>>(json, 'source'),
      ),
      metadata: json['metadata'],
    );
  }

  @override
  String get type => 'image';

  @override
  ImageInputContent copyWith({
    InputContentSource? source,
    Object? metadata,
  }) {
    return ImageInputContent(
      source: source ?? this.source,
      metadata: metadata ?? this.metadata,
    );
  }
}

final class AudioInputContent extends _SourceBackedInputContent {
  const AudioInputContent({
    required super.source,
    super.metadata,
  });

  factory AudioInputContent.fromJson(Map<String, dynamic> json) {
    return AudioInputContent(
      source: InputContentSource.fromJson(
        JsonDecoder.requireField<Map<String, dynamic>>(json, 'source'),
      ),
      metadata: json['metadata'],
    );
  }

  @override
  String get type => 'audio';

  @override
  AudioInputContent copyWith({
    InputContentSource? source,
    Object? metadata,
  }) {
    return AudioInputContent(
      source: source ?? this.source,
      metadata: metadata ?? this.metadata,
    );
  }
}

final class VideoInputContent extends _SourceBackedInputContent {
  const VideoInputContent({
    required super.source,
    super.metadata,
  });

  factory VideoInputContent.fromJson(Map<String, dynamic> json) {
    return VideoInputContent(
      source: InputContentSource.fromJson(
        JsonDecoder.requireField<Map<String, dynamic>>(json, 'source'),
      ),
      metadata: json['metadata'],
    );
  }

  @override
  String get type => 'video';

  @override
  VideoInputContent copyWith({
    InputContentSource? source,
    Object? metadata,
  }) {
    return VideoInputContent(
      source: source ?? this.source,
      metadata: metadata ?? this.metadata,
    );
  }
}

final class DocumentInputContent extends _SourceBackedInputContent {
  const DocumentInputContent({
    required super.source,
    super.metadata,
  });

  factory DocumentInputContent.fromJson(Map<String, dynamic> json) {
    return DocumentInputContent(
      source: InputContentSource.fromJson(
        JsonDecoder.requireField<Map<String, dynamic>>(json, 'source'),
      ),
      metadata: json['metadata'],
    );
  }

  @override
  String get type => 'document';

  @override
  DocumentInputContent copyWith({
    InputContentSource? source,
    Object? metadata,
  }) {
    return DocumentInputContent(
      source: source ?? this.source,
      metadata: metadata ?? this.metadata,
    );
  }
}

final class BinaryInputContent extends InputContent {
  final String mimeType;
  final String? id;
  final String? url;
  final String? data;
  final String? filename;

  const BinaryInputContent({
    required this.mimeType,
    this.id,
    this.url,
    this.data,
    this.filename,
  });

  factory BinaryInputContent.fromJson(Map<String, dynamic> json) {
    final binary = BinaryInputContent(
      mimeType: JsonDecoder.requireField<String>(json, 'mimeType'),
      id: JsonDecoder.optionalField<String>(json, 'id'),
      url: JsonDecoder.optionalField<String>(json, 'url'),
      data: JsonDecoder.optionalField<String>(json, 'data'),
      filename: JsonDecoder.optionalField<String>(json, 'filename'),
    );

    if (binary.id == null && binary.url == null && binary.data == null) {
      throw AGUIValidationError(
        message: 'BinaryInputContent requires at least one of id, url, or data.',
        field: 'id',
        json: json,
      );
    }

    return binary;
  }

  @override
  String get type => 'binary';

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'mimeType': mimeType,
    if (id != null) 'id': id,
    if (url != null) 'url': url,
    if (data != null) 'data': data,
    if (filename != null) 'filename': filename,
  };

  @override
  BinaryInputContent copyWith({
    String? mimeType,
    String? id,
    String? url,
    String? data,
    String? filename,
  }) {
    return BinaryInputContent(
      mimeType: mimeType ?? this.mimeType,
      id: id ?? this.id,
      url: url ?? this.url,
      data: data ?? this.data,
      filename: filename ?? this.filename,
    );
  }
}

typedef ImageInputPart = ImageInputContent;
typedef AudioInputPart = AudioInputContent;
typedef VideoInputPart = VideoInputContent;
typedef DocumentInputPart = DocumentInputContent;
typedef InputContentPart = InputContent;

sealed class Message extends AGUIModel with TypeDiscriminator {
  final String id;
  final MessageRole role;
  final Object? content;
  final String? name;
  final String? encryptedValue;

  const Message({
    required this.id,
    required this.role,
    this.content,
    this.name,
    this.encryptedValue,
  });

  @override
  String get type => role.value;

  factory Message.fromJson(Map<String, dynamic> json) {
    final role = MessageRole.fromString(JsonDecoder.requireField<String>(json, 'role'));
    switch (role) {
      case MessageRole.developer:
        return DeveloperMessage.fromJson(json);
      case MessageRole.system:
        return SystemMessage.fromJson(json);
      case MessageRole.assistant:
        return AssistantMessage.fromJson(json);
      case MessageRole.user:
        return UserMessage.fromJson(json);
      case MessageRole.tool:
        return ToolMessage.fromJson(json);
      case MessageRole.activity:
        return ActivityMessage.fromJson(json);
      case MessageRole.reasoning:
        return ReasoningMessage.fromJson(json);
    }
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role.value,
    if (content != null) 'content': _serializeMessageContent(content),
    if (name != null) 'name': name,
    if (encryptedValue != null) 'encryptedValue': encryptedValue,
  };
}

Object? _serializeMessageContent(Object? content) {
  if (content is List<InputContent>) {
    return content.map((item) => item.toJson()).toList();
  }
  return content;
}

Object _parseUserContent(Map<String, dynamic> json) {
  final content = json['content'];
  if (content is String) {
    return content;
  }
  if (content is List) {
    return content
        .map((item) => InputContent.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }
  throw AGUIValidationError(
    message: 'User message content must be a string or a list of content parts.',
    field: 'content',
    value: content,
    json: json,
  );
}

final class DeveloperMessage extends Message {
  @override
  final String content;

  const DeveloperMessage({
    required super.id,
    required this.content,
    super.name,
    super.encryptedValue,
  }) : super(role: MessageRole.developer);

  factory DeveloperMessage.fromJson(Map<String, dynamic> json) {
    return DeveloperMessage(
      id: JsonDecoder.requireField<String>(json, 'id'),
      content: JsonDecoder.requireField<String>(json, 'content'),
      name: JsonDecoder.optionalField<String>(json, 'name'),
      encryptedValue: JsonDecoder.optionalField<String>(json, 'encryptedValue'),
    );
  }

  @override
  DeveloperMessage copyWith({
    String? id,
    String? content,
    String? name,
    String? encryptedValue,
  }) {
    return DeveloperMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      name: name ?? this.name,
      encryptedValue: encryptedValue ?? this.encryptedValue,
    );
  }
}

final class SystemMessage extends Message {
  @override
  final String content;

  const SystemMessage({
    required super.id,
    required this.content,
    super.name,
    super.encryptedValue,
  }) : super(role: MessageRole.system);

  factory SystemMessage.fromJson(Map<String, dynamic> json) {
    return SystemMessage(
      id: JsonDecoder.requireField<String>(json, 'id'),
      content: JsonDecoder.requireField<String>(json, 'content'),
      name: JsonDecoder.optionalField<String>(json, 'name'),
      encryptedValue: JsonDecoder.optionalField<String>(json, 'encryptedValue'),
    );
  }

  @override
  SystemMessage copyWith({
    String? id,
    String? content,
    String? name,
    String? encryptedValue,
  }) {
    return SystemMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      name: name ?? this.name,
      encryptedValue: encryptedValue ?? this.encryptedValue,
    );
  }
}

final class AssistantMessage extends Message {
  @override
  final String? content;
  final List<ToolCall>? toolCalls;

  const AssistantMessage({
    required super.id,
    this.content,
    super.name,
    super.encryptedValue,
    this.toolCalls,
  }) : super(role: MessageRole.assistant);

  factory AssistantMessage.fromJson(Map<String, dynamic> json) {
    final toolCalls =
        JsonDecoder.optionalListField<Map<String, dynamic>>(json, 'toolCalls') ??
        JsonDecoder.optionalListField<Map<String, dynamic>>(json, 'tool_calls');

    return AssistantMessage(
      id: JsonDecoder.requireField<String>(json, 'id'),
      content: JsonDecoder.optionalField<String>(json, 'content'),
      name: JsonDecoder.optionalField<String>(json, 'name'),
      encryptedValue: JsonDecoder.optionalField<String>(json, 'encryptedValue'),
      toolCalls: toolCalls?.map((item) => ToolCall.fromJson(item)).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    if (toolCalls != null) 'toolCalls': toolCalls!.map((item) => item.toJson()).toList(),
  };

  @override
  AssistantMessage copyWith({
    String? id,
    String? content,
    String? name,
    String? encryptedValue,
    List<ToolCall>? toolCalls,
  }) {
    return AssistantMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      name: name ?? this.name,
      encryptedValue: encryptedValue ?? this.encryptedValue,
      toolCalls: toolCalls ?? this.toolCalls,
    );
  }
}

final class UserMessage extends Message {
  @override
  final Object content;

  const UserMessage({
    required super.id,
    required this.content,
    super.name,
    super.encryptedValue,
  }) : super(role: MessageRole.user);

  factory UserMessage.fromJson(Map<String, dynamic> json) {
    return UserMessage(
      id: JsonDecoder.requireField<String>(json, 'id'),
      content: _parseUserContent(json),
      name: JsonDecoder.optionalField<String>(json, 'name'),
      encryptedValue: JsonDecoder.optionalField<String>(json, 'encryptedValue'),
    );
  }

  @override
  UserMessage copyWith({
    String? id,
    Object? content,
    String? name,
    String? encryptedValue,
  }) {
    return UserMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      name: name ?? this.name,
      encryptedValue: encryptedValue ?? this.encryptedValue,
    );
  }
}

final class ToolMessage extends Message {
  @override
  final String content;
  final String toolCallId;
  final String? error;

  const ToolMessage({
    required super.id,
    required this.content,
    required this.toolCallId,
    this.error,
    super.encryptedValue,
  }) : super(role: MessageRole.tool);

  factory ToolMessage.fromJson(Map<String, dynamic> json) {
    final toolCallId = JsonDecoder.optionalField<String>(json, 'toolCallId') ??
        JsonDecoder.optionalField<String>(json, 'tool_call_id');

    if (toolCallId == null) {
      throw AGUIValidationError(
        message: 'Missing required field: toolCallId or tool_call_id',
        field: 'toolCallId',
        json: json,
      );
    }

    return ToolMessage(
      id: JsonDecoder.requireField<String>(json, 'id'),
      content: JsonDecoder.requireField<String>(json, 'content'),
      toolCallId: toolCallId,
      error: JsonDecoder.optionalField<String>(json, 'error'),
      encryptedValue: JsonDecoder.optionalField<String>(json, 'encryptedValue'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'toolCallId': toolCallId,
    if (error != null) 'error': error,
  };

  @override
  ToolMessage copyWith({
    String? id,
    String? content,
    String? toolCallId,
    String? error,
    String? encryptedValue,
  }) {
    return ToolMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      toolCallId: toolCallId ?? this.toolCallId,
      error: error ?? this.error,
      encryptedValue: encryptedValue ?? this.encryptedValue,
    );
  }
}

final class ActivityMessage extends Message {
  final String activityType;
  @override
  final Map<String, dynamic> content;

  const ActivityMessage({
    required super.id,
    required this.activityType,
    required this.content,
  }) : super(role: MessageRole.activity);

  factory ActivityMessage.fromJson(Map<String, dynamic> json) {
    return ActivityMessage(
      id: JsonDecoder.requireField<String>(json, 'id'),
      activityType: JsonDecoder.requireField<String>(json, 'activityType'),
      content: Map<String, dynamic>.from(
        JsonDecoder.requireField<Map<String, dynamic>>(json, 'content'),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'activityType': activityType,
  };

  @override
  ActivityMessage copyWith({
    String? id,
    String? activityType,
    Map<String, dynamic>? content,
  }) {
    return ActivityMessage(
      id: id ?? this.id,
      activityType: activityType ?? this.activityType,
      content: content ?? this.content,
    );
  }
}

final class ReasoningMessage extends Message {
  @override
  final String content;

  const ReasoningMessage({
    required super.id,
    required this.content,
    super.encryptedValue,
  }) : super(role: MessageRole.reasoning);

  factory ReasoningMessage.fromJson(Map<String, dynamic> json) {
    return ReasoningMessage(
      id: JsonDecoder.requireField<String>(json, 'id'),
      content: JsonDecoder.requireField<String>(json, 'content'),
      encryptedValue: JsonDecoder.optionalField<String>(json, 'encryptedValue'),
    );
  }

  @override
  ReasoningMessage copyWith({
    String? id,
    String? content,
    String? encryptedValue,
  }) {
    return ReasoningMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      encryptedValue: encryptedValue ?? this.encryptedValue,
    );
  }
}
