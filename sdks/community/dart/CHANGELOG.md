# Changelog

All notable changes to the AG-UI Dart SDK will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- AG-UI protocol 1.0 support, migrated from the TypeScript SDK:
  - `SUBAGENT_STARTED` / `SUBAGENT_FINISHED` / `SUBAGENT_ERROR` events and
    subagent attribution (`subagentRunId`) on events and messages.
  - `RUN_FINISHED` outcomes (`success`, `interrupt`, `cancelled`), pending tool
    call ids, `TokenUsage` on `RUN_FINISHED` / `RUN_ERROR`, and
    `RUN_STARTED.protocolVersion`.
  - Message metadata, `ToolMessage` content parts, `FileSource`, and content
    part ids.
  - `enforceEvents` stage: unknown event types are dropped, undescribed
    properties and union members are stripped, each with a warning naming its
    path; malformed known fields stay fatal.
  - Protocol diagnostics collector (`AgUiDiagnostics`) for every warning the
    compatibility boundary emits.
- Dart conformance lane: `test/conformance/streams_test.dart` replays all
  `spec/1.0/conformance/streams` fixtures over real HTTP/SSE.
- Subscriber hooks for the subagent lifecycle
  (`onSubagentStartedEvent` / `onSubagentFinishedEvent` /
  `onSubagentErrorEvent`), and `pendingToolCallIds` on the run-finished
  context, derived from the stream when the producer names none.
- Proto transport covers the whole 1.0 event set: `TOOL_CALL_RESULT`, activity,
  reasoning (including `REASONING_ENCRYPTED_VALUE`) and `SUBAGENT_*` events now
  encode and decode instead of throwing, and every event carries its
  attribution and `metadata`. `RUN_STARTED` echoes `parentRunId`,
  `protocolVersion` and the full `input`; `RUN_FINISHED` / `RUN_ERROR` carry
  `usage` and the run's `pendingToolCallIds`; activity messages, file content
  sources and part ids round-trip. The generated bindings under
  `lib/src/proto/generated/` were regenerated from
  `sdks/typescript/packages/proto/src/proto` with
  `dart run tool/generate_proto.dart`, which is how they are kept in sync.
- Helpers the TypeScript SDK exposes from `@ag-ui/core`:
  `mergeMetadata` / `agUiMetadataKey`, `contentToText` / `contentHasMedia`,
  `tokenUsageFromLangChainMetadata`, `tokenUsageFromAiSdkUsage` and
  `aggregateTokenUsage`. Vendor counts that are present but unusable are named
  once per key and omitted, and a fractional count is omitted rather than
  rounded.
- `authoritativeActivityTypes` / `withAuthoritativeActivityTypes` and the
  `@ag-ui/client` metadata key, so application code reads the same declaration
  the reducer uses to decide which `activity` messages a snapshot owns.
- Event factories accept the fields the events actually carry — `metadata`,
  `rawEvent`, `subagentRunId` — `createToolCallResultEvent` takes the
  string-or-parts content union, and `createMessagesSnapshotEvent` takes typed
  messages.
- `AbstractAgent.getCapabilities()`, optional in the TypeScript SDK and
  answering `null` here when unadvertised.
- `ResumeResponse` carries `metadata`, which reaches the `ResumeEntry` the
  helper builds.

### Changed
- Chunk expansion, stream verification, the state/message reducer and the
  version-gated compatibility shims now follow the 1.0 reference semantics
  (0.0.39 / 0.0.45 / 0.0.57 eras; `THINKING_*` translates to `REASONING_*`).
- Unknown event types decode to `UnknownEvent` instead of throwing; enforcement
  decides whether they are dropped.
- `onNewMessage` fires at a message's closing event (`TEXT_MESSAGE_END`,
  `REASONING_MESSAGE_END`, `TOOL_CALL_RESULT`) rather than at its first, and
  `onNewToolCall` at `TOOL_CALL_END` when the arguments are final.
- A run's input re-pairs tool results next to the call that issued them, so a
  stored history cannot reach a provider as `tool` before
  `assistant(tool_call)`; the agent keeps the history it holds.
- Pending interrupts survive every event of a run that is not its terminal,
  and a cloned agent no longer installs the compatibility shims twice.
- `AgUiError` now implements `AGUIError`, so one `on AGUIError catch` covers
  both the protocol-layer and transport-layer error families.
- `SimpleRunAgentInput` carries exactly the fields the 1.0 input schema
  describes. The `config` and `metadata` keys it used to add are gone: the
  schema is closed (`unevaluatedProperties: false`), so a receiver that
  validates would reject the whole run for them.
- A cancelled HTTP run ends with a terminal `RUN_ERROR` carrying
  `code: "abort"` instead of throwing out of the stream, so verify, apply and
  the run result all finalize on the event every one of them already handles.
- Only `runAgent` requires the resume array to cover the thread's pending
  interrupts; `connectAgent` reads history and answers nothing, so an
  interrupted thread still connects.
- An expired interrupt can be resolved by cancelling it: expiry forecloses
  answering, not closing the thread. `isInterruptExpired` also treats the
  deadline itself as expired and leaves an unparseable `expiresAt` answerable.
- The `protocolVersion` declaration is withheld when the peer's ceiling is
  pinned below the revision this client speaks. The ceiling defaults to that
  revision rather than the package version, which is still the pre-1.0
  `0.0.x` line and is not a protocol version at all.

### Fixed
- An unset agent state is omitted from the run input instead of being sent as
  `state: null`, which the 1.0 schema forbids (`state: { not: { type: "null" } }`).
- `RUN_FINISHED` with `outcome.type == "interrupt"` requires at least one
  interrupt (`minItems: 1`); an empty list is now rejected as a malformed
  known value instead of being accepted as a run with nothing to answer.
- `TokenUsage` counts are checked against the schema's `0 .. 2^53-1` range
  instead of being accepted as any integer.
- Protobuf: the three `*_CHUNK` events declare their own type on the base event
  instead of leaving it unset, which encoded as `TEXT_MESSAGE_START` and made
  every such frame malformed for a decoder that cross-checks the oneof against
  the declared type.
- Protobuf: a tool call's `metadata` and `encryptedValue` survive the round
  trip; both fields exist on the wire and were previously dropped.
- Protobuf: an outcome a newer producer invented is preserved on
  `RUN_FINISHED` and `SUBAGENT_FINISHED` instead of being re-read as "no
  outcome" or rewritten as `success`.
- SSE encoding keeps a required field that legitimately holds `null`
  (`snapshot`, `CustomEvent.value`, `RawEvent.event`); only optional nulls, which
  each model already omits, are left out.
- Legacy bridge: the state of `MESSAGES_SNAPSHOT` and `RUN_FINISHED` carries the
  message list again — every state went through a sanitizer that dropped
  `messages` — and tool results holding content parts are bridged as their text
  parts with a warning. A state patch that cannot be applied, or a message list
  whose tool arguments are not JSON, now warns or reports `RunError` instead of
  tearing the stream down.
- `compactEvents` keeps the stream replayable: an unclosed text or tool stream
  is flushed before `RUN_FINISHED` / `RUN_ERROR` (and in opening order at the
  end), the metadata of collapsed deltas and state events is folded into the
  event that replaces them, and a state window with no snapshot of its own is
  passed through unchanged instead of becoming a snapshot seeded from `{}`.
  Folding now starts at the last snapshot and a patch that cannot be applied
  warns and is skipped.
- `AgUiClient` dispatches on the response's content type, so a protobuf run is
  decoded instead of being handed to the SSE parser; the binary parser enforces
  a 10 MB frame limit, reports a stream that ends mid-frame, and surfaces a
  decode failure on the stream instead of dropping it silently.
- `FilterToolCallsMiddleware` keeps its blocked ids per subscription and clears
  them at `RUN_STARTED`, so one run can no longer shadow the ids or the reused
  tool call ids of another.
- A message created by `TOOL_CALL_START` inherits the event's `subagentRunId`
  when the event carries one; an existing message keeps its own attribution.
- A state mutation returned from `onRunInitialized` is written back to the run
  input, so the producer works from the state the subscriber just corrected.
- The 0.0.57 shim also strips `subagentRunId` from
  `RUN_FINISHED.outcome.interrupts`, where the attribution is nested and the
  top-level strip could not reach it.

## [0.0.53] - 2025-01-21

### Added
- Initial release of the AG-UI Dart SDK
- Core protocol implementation with full event type support
- HTTP client with Server-Sent Events (SSE) streaming
- Strongly-typed models for all AG-UI protocol entities
- Support for tool interactions and generative UI
- State management with snapshots and JSON Patch deltas (RFC 6902)
- Message history tracking across multiple runs
- Comprehensive error handling with typed exceptions
- Cancel token support for aborting long-running operations
- Environment variable configuration support
- Example CLI application demonstrating key features
- Integration tests validating protocol compliance

### Features
- `AgUiClient` - Main client for AG-UI server interactions
- `SimpleRunAgentInput` - Simplified input structure for common use cases
- Event streaming with backpressure handling
- Tool call processing and result handling
- State synchronization across agent runs
- Message accumulation and conversation context

### Known Limitations
- WebSocket transport not yet implemented
- Binary protocol encoding/decoding not yet supported
- Advanced retry strategies planned for future release
- Event caching and offline support planned for future release

[0.1.0]: https://github.com/ag-ui-protocol/ag-ui/releases/tag/dart-v0.1.0