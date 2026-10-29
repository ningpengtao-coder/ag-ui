library;

import '../events/events.dart';
import '../types/context.dart';

RunFinishedOutcome? getRunOutcome(RunFinishedEvent event) => event.outcome;

bool isInterruptExpired(Interrupt interrupt, [DateTime? now]) {
  final expiresAt = interrupt.expiresAt;
  if (expiresAt == null) {
    return false;
  }
  // An unparseable deadline is not a deadline: the producer said something this
  // client cannot read, and reading it as "already expired" would lock the
  // thread instead of leaving the interrupt answerable.
  final parsed = DateTime.tryParse(expiresAt);
  if (parsed == null) {
    return false;
  }
  return !parsed.isAfter(now ?? DateTime.now());
}

class ResumeResponse {
  final ResumeStatus status;
  final Object? payload;
  final Map<String, dynamic>? metadata;

  const ResumeResponse.resolved([this.payload, this.metadata])
      : status = ResumeStatus.resolved;
  const ResumeResponse.cancelled([this.metadata])
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
      metadata: response.metadata,
    );
  }).toList();
}
