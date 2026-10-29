/// Metadata helpers for events and messages.
library;

/// The key AG-UI reserves for its own use inside a metadata object.
///
/// Reservation is by convention: nothing rejects a write to this key at
/// runtime, because metadata is open by key and validating its shape would
/// contradict that.
const String agUiMetadataKey = 'ag-ui';

/// Folds [incoming] metadata into [existing], key by key, with the last write
/// winning.
///
/// A message is assembled from a sequence of events, and the interesting values
/// — token usage and finish reason among them — are only known at the end. So
/// metadata accumulates as the sequence arrives rather than being fixed at the
/// start.
///
/// A key's value is replaced outright. This never recurses, so an array or
/// object under any key — including [agUiMetadataKey] — is replaced wholesale
/// rather than blended with what was there before.
///
/// Returns a new map rather than mutating either argument. An absent [incoming]
/// returns [existing] untouched; an empty [incoming] changes nothing.
Map<String, dynamic>? mergeMetadata(
  Map<String, dynamic>? existing,
  Map<String, dynamic>? incoming,
) {
  if (incoming == null) {
    return existing;
  }
  if (existing == null) {
    return Map<String, dynamic>.from(incoming);
  }
  return <String, dynamic>{...existing, ...incoming};
}
