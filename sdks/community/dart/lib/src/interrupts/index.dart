library;

import '../events/events.dart';
import '../types/context.dart';

RunFinishedOutcome? getRunOutcome(RunFinishedEvent event) => event.outcome;

bool isInterruptExpired(Interrupt interrupt, [DateTime? now]) {
  final expiresAt = interrupt.expiresAt;
  if (expiresAt == null) {
    return false;
  }
  return DateTime.parse(expiresAt).isBefore(now ?? DateTime.now()) ||
      DateTime.parse(expiresAt).isAtSameMomentAs(now ?? DateTime.now());
}

class ResumeResponse {
  final ResumeStatus status;
  final Object? payload;

  const ResumeResponse.resolved([this.payload]) : status = ResumeStatus.resolved;
  const ResumeResponse.cancelled()
      : status = ResumeStatus.cancelled,
        payload = null;
}

List<ResumeEntry> buildResumeArray(
  List<Interrupt> interrupts,
  Map<String, ResumeResponse> responses,
) {
  final openIds = interrupts.map((interrupt) => interrupt.id).toSet();
  final responseIds = responses.keys.toSet();

  final missing = openIds.where((id) => !responseIds.contains(id)).toList();
  if (missing.isNotEmpty) {
    throw ArgumentError(
      'buildResumeArray: missing responses for open interrupts: ${missing.join(", ")}',
    );
  }

  final unknown = responseIds.where((id) => !openIds.contains(id)).toList();
  if (unknown.isNotEmpty) {
    throw ArgumentError(
      'buildResumeArray: responses reference unknown interrupt ids: ${unknown.join(", ")}',
    );
  }

  return interrupts.map((interrupt) {
    final response = responses[interrupt.id]!;
    return ResumeEntry(
      interruptId: interrupt.id,
      status: response.status,
      payload: response.payload,
    );
  }).toList();
}
