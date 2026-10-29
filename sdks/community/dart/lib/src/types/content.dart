/// Helpers for `string | parts` content values.
library;

import 'message.dart';

/// The text of string-or-parts content, for a consumer that can only hold a
/// string: the text parts concatenated in order, every other part dropped.
///
/// This is the downgrade the specification permits for a peer that predates
/// content parts: it removes and reshapes, and it invents nothing — no
/// placeholder stands in for a dropped image, because a downgrade must not
/// supply a value the producer never sent. Content that is entirely media
/// flattens to the empty string, which the same rule allows.
///
/// Losing content is never meant to be silent. This helper only reshapes; a
/// caller that knows it is talking to an older peer warns as well, the way the
/// era shims do.
String contentToText(Object? content) {
  if (content == null) {
    return '';
  }
  if (content is String) {
    return content;
  }
  if (content is UserMessageContent) {
    final text = content.textOrNull;
    return text ?? _textOfParts(content.partsOrNull ?? const <InputContent>[]);
  }
  if (content is Iterable) {
    return _textOfParts(content);
  }
  return '';
}

/// Whether string-or-parts content carries anything but text — the question a
/// caller asks before flattening, so it can warn about what the flattening
/// would drop.
bool contentHasMedia(Object? content) {
  if (content is UserMessageContent) {
    final parts = content.partsOrNull;
    return parts != null && _hasMedia(parts);
  }
  return content is Iterable && _hasMedia(content);
}

String _textOfParts(Iterable<Object?> parts) => parts
    .whereType<TextInputContent>()
    .map((part) => part.text)
    .join();

bool _hasMedia(Iterable<Object?> parts) =>
    parts.any((part) => part is! TextInputContent);
