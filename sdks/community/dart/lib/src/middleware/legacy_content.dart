/// Retired pre-1.0 message-content shapes and their modern replacements.
///
/// The legacy `{"type": "binary"}` content part left the protocol in 1.0: a
/// media part is now typed (`image`, `audio`, `video`, `document`) and carries
/// its payload in a `source` object. This module owns the one conversion, so
/// the always-on compatibility boundary and the retained 0.0.47 shim share it
/// instead of each carrying a copy.
library;

import '../diagnostics.dart';
import '../types/types.dart';

/// Whether [part] is the retired `{"type": "binary"}` content part.
bool isLegacyBinaryContent(Object? part) => part is BinaryInputContent;

/// The modern media part standing in for [binary].
///
/// A part carrying `data` becomes a `data` source and one carrying `url` a
/// `url` source; `data` wins when both are present. A part carrying only `id`
/// has no source to map to, so it is returned unchanged — which the 1.0
/// contract no longer accepts — and the loss is announced rather than made
/// silently.
InputContent convertBinaryToNewFormat(BinaryInputContent binary) {
  final metadata = binary.filename == null
      ? null
      : <String, dynamic>{'filename': binary.filename};

  final InputContentSource? source;
  if (binary.data != null) {
    source = InputContentDataSource(
      value: binary.data!,
      mimeType: binary.mimeType,
    );
  } else if (binary.url != null) {
    source = InputContentUrlSource(
      value: binary.url!,
      mimeType: binary.mimeType,
    );
  } else {
    source = null;
  }

  if (source == null) {
    AgUiDiagnostics.warn(
      "A binary content part carries only an id ('${binary.id ?? ''}') and "
      'cannot be converted to a modern media part; a 1.0 peer will not accept '
      'it. Provide data or a url.',
    );
    return binary;
  }

  return switch (_contentTypeFor(binary.mimeType)) {
    'image' => ImageInputContent(source: source, metadata: metadata),
    'audio' => AudioInputContent(source: source, metadata: metadata),
    'video' => VideoInputContent(source: source, metadata: metadata),
    _ => DocumentInputContent(source: source, metadata: metadata),
  };
}

/// [message] with every legacy binary content part replaced by the modern
/// media part it describes.
///
/// Returns the same instance when there is nothing to convert, or when the
/// message's content cannot hold parts. A converted part that already exists
/// in the message — the same type and source, and the same `filename` when the
/// legacy part carried one — is dropped rather than duplicated.
Message upgradeMessageContent(Message message) {
  final parts = _contentPartsOf(message);
  if (parts == null) {
    return message;
  }

  final upgraded = <InputContent>[];
  var changed = false;
  for (final part in parts) {
    if (!isLegacyBinaryContent(part)) {
      upgraded.add(part);
      continue;
    }

    final binary = part as BinaryInputContent;
    final converted = convertBinaryToNewFormat(binary);
    if (converted is! BinaryInputContent &&
        parts.any(
          (other) => _matchesModernPart(other, converted, binary.filename),
        )) {
      changed = true;
      continue;
    }
    if (!identical(converted, binary)) {
      changed = true;
    }
    upgraded.add(converted);
  }

  if (!changed) {
    return message;
  }
  return _copyMessageWithParts(message, upgraded);
}

String _contentTypeFor(String mimeType) {
  if (mimeType.startsWith('image/')) {
    return 'image';
  }
  if (mimeType.startsWith('audio/')) {
    return 'audio';
  }
  if (mimeType.startsWith('video/')) {
    return 'video';
  }
  return 'document';
}

List<InputContent>? _contentPartsOf(Message message) {
  return switch (message) {
    UserMessage() => message.content.partsOrNull,
    ToolMessage() => message.contentParts,
    _ => null,
  };
}

bool _matchesModernPart(
  InputContent part,
  InputContent converted,
  String? filename,
) {
  if (part is BinaryInputContent) {
    return false;
  }

  final partJson = part.toJson();
  final convertedJson = converted.toJson();
  if (partJson['type'] != convertedJson['type']) {
    return false;
  }

  final partSource = partJson['source'];
  final convertedSource = convertedJson['source'];
  if (partSource is! Map<String, dynamic> ||
      convertedSource is! Map<String, dynamic>) {
    return false;
  }
  if (partSource['type'] != convertedSource['type'] ||
      partSource['value'] != convertedSource['value'] ||
      partSource['mimeType'] != convertedSource['mimeType']) {
    return false;
  }

  // A legacy filename is data too: only discard it if the modern part keeps it.
  if (filename == null) {
    return true;
  }
  final metadata = partJson['metadata'];
  return metadata is Map<String, dynamic> && metadata['filename'] == filename;
}

Message _copyMessageWithParts(Message message, List<InputContent> parts) {
  return switch (message) {
    UserMessage() => message.copyWith(content: parts),
    ToolMessage() => message.copyWith(content: parts),
    _ => message,
  };
}
