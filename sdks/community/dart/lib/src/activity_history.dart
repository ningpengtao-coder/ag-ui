/// Which activity types a `MESSAGES_SNAPSHOT` declares it owns.
///
/// `activity` messages are only sometimes client-only: a producer that never
/// tracks them cannot list them, so a local copy has to be preserved; a producer
/// that does track them re-delivers the whole set it owns, and one it leaves out
/// has been removed. This module holds the convention that tells the two apart,
/// so the reducer and application code read the same declaration.
library;

import 'events/events.dart';
import 'types/message.dart';

/// Package-owned convention. The protocol-reserved `ag-ui` namespace is
/// untouched.
const String agUiClientMetadataKey = '@ag-ui/client';

/// The activity types [event] declares it owns.
///
/// Tri-state, mirroring the wire convention:
/// - `declared == false`: the snapshot said nothing, so the legacy inference
///   applies (it owns activity only if it carries any).
/// - `declared == true` with `types == null`: it owns every type, including an
///   empty set.
/// - `declared == true` with a list: it owns exactly those types.
///
/// A declaration of the wrong shape owns no types, because no omission-based
/// deletion may be inferred from it.
({bool declared, List<String>? types}) authoritativeActivityTypes(
  MessagesSnapshotEvent event,
) {
  final metadata = event.metadata;
  if (metadata == null || !metadata.containsKey(agUiClientMetadataKey)) {
    return (declared: false, types: null);
  }

  final value = metadata[agUiClientMetadataKey];
  if (value is! Map) {
    return (declared: true, types: const <String>[]);
  }
  if (!value.containsKey('authoritativeActivityTypes')) {
    return (declared: false, types: null);
  }

  final types = value['authoritativeActivityTypes'];
  if (types == null) {
    return (declared: true, types: null);
  }
  if (types is List && types.every((item) => item is String)) {
    return (declared: true, types: List<String>.from(types));
  }
  return (declared: true, types: const <String>[]);
}

/// Adds a projector scope to [event], preserving full authority.
///
/// Call on the incoming snapshot before replacing its messages, so the inferred
/// authority describes the original set.
MessagesSnapshotEvent withAuthoritativeActivityTypes(
  MessagesSnapshotEvent event,
  Iterable<String> activityTypes,
) {
  final prior = event.metadata?[agUiClientMetadataKey];
  final scope = authoritativeActivityTypes(event);
  final ownsAll = (scope.declared && scope.types == null) ||
      (!scope.declared &&
          event.messages.any((message) => message is ActivityMessage));

  return MessagesSnapshotEvent(
    messages: event.messages,
    timestamp: event.timestamp,
    rawEvent: event.rawEvent,
    metadata: <String, dynamic>{
      ...?event.metadata,
      agUiClientMetadataKey: <String, dynamic>{
        if (prior is Map) ...Map<String, dynamic>.from(prior),
        'authoritativeActivityTypes':
            ownsAll ? null : <String>{...?scope.types, ...activityTypes}.toList(),
      },
    },
  );
}
