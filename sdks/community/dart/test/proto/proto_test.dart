import 'dart:typed_data';

import 'package:ag_ui/ag_ui.dart';
import 'package:ag_ui/src/proto/generated/events.pb.dart' as proto_events;
import 'package:test/test.dart';

void main() {
  group('proto wire format', () {
    test('encodes events as protobuf bytes', () {
      final encoded = encodeProto(
        const ToolCallStartEvent(
          toolCallId: 'call-1',
          toolCallName: 'test-tool',
        ),
      );

      expect(encoded, isA<Uint8List>());
      expect(encoded, isNotEmpty);
      expect(encoded.first, isNot('{'.codeUnitAt(0)));
      expect(proto_events.Event.fromBuffer(encoded).hasToolCallStart(), isTrue);
    });

    test('round-trips a state delta event', () {
      final original = const StateDeltaEvent(
        timestamp: 1698765432123,
        delta: [
          {'op': 'add', 'path': '/foo', 'value': 'bar'},
          {'op': 'remove', 'path': '/baz'},
        ],
      );

      final decoded = decodeProto(encodeProto(original)) as StateDeltaEvent;
      expect(decoded.type, original.type);
      expect(decoded.timestamp, original.timestamp);
      expect(decoded.delta, original.delta);
    });

    test('round-trips a complex state snapshot', () {
      final original = StateSnapshotEvent(
        timestamp: 1698765432123,
        snapshot: {
          'counter': 42,
          'items': ['apple', 'banana', 'cherry'],
          'config': {
            'enabled': true,
            'maxRetries': 3,
          },
          'nested': {
            'user': {'name': 'John Doe', 'age': 30},
            'stats': [1, 2, 3],
          },
        },
      );

      final decoded = decodeProto(encodeProto(original)) as StateSnapshotEvent;
      expect(decoded.timestamp, original.timestamp);
      expect(decoded.snapshot, original.snapshot);
    });

    test('round-trips special values in state snapshot', () {
      final original = StateSnapshotEvent(
        snapshot: {
          'nullValue': null,
          'emptyString': '',
          'zero': 0,
          'negativeNumber': -123,
          'floatNumber': 3.14159,
          'emptyArray': <Object?>[],
          'emptyObject': <String, Object?>{},
          'boolValues': {'true': true, 'false': false},
          'infinityValue': double.infinity,
          'nanValue': double.nan,
        },
      );

      final decoded = decodeProto(encodeProto(original)) as StateSnapshotEvent;
      final snapshot = decoded.snapshot as Map;
      expect(snapshot['nullValue'], isNull);
      expect(snapshot['emptyString'], '');
      expect(snapshot['zero'], 0);
      expect(snapshot['negativeNumber'], -123);
      expect(snapshot['floatNumber'], 3.14159);
      expect(snapshot['emptyArray'], isEmpty);
      expect(snapshot['emptyObject'], isEmpty);
      expect(snapshot['boolValues'], {'true': true, 'false': false});
      expect(snapshot['infinityValue'], double.infinity);
      expect(snapshot['nanValue'], isNaN);
    });

    test('round-trips a text message chunk event', () {
      const original = TextMessageChunkEvent(
        messageId: 'msg-1',
        role: TextMessageRole.assistant,
        delta: 'Hello',
        name: 'research-agent',
      );

      final decoded = decodeProto(encodeProto(original)) as TextMessageChunkEvent;
      expect(decoded.messageId, original.messageId);
      expect(decoded.role, original.role);
      expect(decoded.delta, original.delta);
      expect(decoded.name, original.name);
    });

    test('round-trips a tool call chunk event', () {
      const original = ToolCallChunkEvent(
        toolCallId: 'tc-1',
        toolCallName: 'search',
        parentMessageId: 'msg-1',
        delta: '{"query":"hel',
      );

      final decoded = decodeProto(encodeProto(original)) as ToolCallChunkEvent;
      expect(decoded.toolCallId, original.toolCallId);
      expect(decoded.toolCallName, original.toolCallName);
      expect(decoded.parentMessageId, original.parentMessageId);
      expect(decoded.delta, original.delta);
    });

    test('round-trips a legacy run finished event with no outcome', () {
      const original = RunFinishedEvent(
        threadId: 't-legacy',
        runId: 'r-legacy',
      );

      final decoded = decodeProto(encodeProto(original)) as RunFinishedEvent;
      expect(decoded.threadId, original.threadId);
      expect(decoded.runId, original.runId);
      expect(decoded.outcome, isNull);
      expect(decoded.result, isNull);
    });

    test('round-trips a legacy run finished event with result but no outcome', () {
      final original = RunFinishedEvent(
        threadId: 't-legacy',
        runId: 'r-legacy',
        result: const {'answer': 42},
      );

      final decoded = decodeProto(encodeProto(original)) as RunFinishedEvent;
      expect(decoded.threadId, original.threadId);
      expect(decoded.runId, original.runId);
      expect(decoded.result, {'answer': 42});
      expect(decoded.outcome, isNull);
    });

    test('round-trips a framed event payload', () {
      final original = const RunFinishedEvent(
        threadId: 't-1',
        runId: 'r-1',
        outcome: RunFinishedSuccessOutcome(),
      );

      final decoded = decodeProtoFrame(encodeProtoFrame(original)) as RunFinishedEvent;
      expect(decoded.threadId, original.threadId);
      expect(decoded.runId, original.runId);
      expect(decoded.outcome, isA<RunFinishedSuccessOutcome>());
    });

    test('round-trips a success run finished event with complex result', () {
      final original = RunFinishedEvent(
        threadId: 't-success',
        runId: 'r-success',
        outcome: const RunFinishedSuccessOutcome(),
        result: {
          'analysis': {
            'conclusion': 'Complete',
            'metrics': {'accuracy': 0.95, 'confidence': 0.87},
            'details': ['step1', 'step2', 'step3'],
          },
        },
      );

      final decoded = decodeProto(encodeProto(original)) as RunFinishedEvent;
      expect(decoded.outcome, isA<RunFinishedSuccessOutcome>());
      expect(decoded.result, original.result);
    });

    test('round-trips a run finished interrupt outcome', () {
      final original = RunFinishedEvent(
        threadId: 't-1',
        runId: 'r-1',
        result: const {'ok': false},
        outcome: const RunFinishedInterruptOutcome(
          interrupts: [
            Interrupt(
              id: 'int-1',
              reason: 'tool-approval',
              message: 'Need approval',
              toolCallId: 'tool-1',
              responseSchema: {'type': 'object'},
              expiresAt: '2026-05-08T12:00:00Z',
              metadata: {'severity': 'high'},
            ),
          ],
        ),
      );

      final decoded = decodeProto(encodeProto(original)) as RunFinishedEvent;
      expect(decoded.result, {'ok': false});
      expect(decoded.outcome, isA<RunFinishedInterruptOutcome>());
      final interrupt = (decoded.outcome as RunFinishedInterruptOutcome).interrupts.single;
      expect(interrupt.id, 'int-1');
      expect(interrupt.reason, 'tool-approval');
      expect(interrupt.toolCallId, 'tool-1');
      expect(interrupt.responseSchema, {'type': 'object'});
      expect(interrupt.metadata, {'severity': 'high'});
    });

    test('round-trips multiple minimal interrupts', () {
      final original = RunFinishedEvent(
        threadId: 't-1',
        runId: 'r-1',
        outcome: const RunFinishedInterruptOutcome(
          interrupts: [
            Interrupt(id: 'int-1', reason: 'tool_call'),
            Interrupt(id: 'int-2', reason: 'confirmation'),
          ],
        ),
      );

      final decoded = decodeProto(encodeProto(original)) as RunFinishedEvent;
      final interrupts = (decoded.outcome as RunFinishedInterruptOutcome).interrupts;
      expect(interrupts, hasLength(2));
      expect(interrupts[0].id, 'int-1');
      expect(interrupts[0].reason, 'tool_call');
      expect(interrupts[1].id, 'int-2');
      expect(interrupts[1].reason, 'confirmation');
    });

    test('round-trips run events with all base fields', () {
      final started = RunStartedEvent(
        threadId: 'thread-full',
        runId: 'run-full',
        timestamp: 1234567890,
        rawEvent: const {'original': 'data', 'from': 'external_system'},
      );
      final finished = RunFinishedEvent(
        threadId: 'thread-full',
        runId: 'run-full',
        timestamp: 1234567891,
        rawEvent: const {'original': 'data', 'from': 'external_system'},
      );

      final decodedStarted = decodeProto(encodeProto(started)) as RunStartedEvent;
      final decodedFinished = decodeProto(encodeProto(finished)) as RunFinishedEvent;

      expect(decodedStarted.timestamp, 1234567890);
      expect(decodedStarted.rawEvent, {'original': 'data', 'from': 'external_system'});
      expect(decodedFinished.timestamp, 1234567891);
      expect(decodedFinished.rawEvent, {'original': 'data', 'from': 'external_system'});
    });

    test('round-trips run error and step events', () {
      const runError = RunErrorEvent(
        message: 'API request failed',
        code: 'API_ERROR',
      );
      const stepStarted = StepStartedEvent(stepName: 'data_analysis');
      const stepFinished = StepFinishedEvent(stepName: 'data_analysis');

      final decodedError = decodeProto(encodeProto(runError)) as RunErrorEvent;
      final decodedStepStarted = decodeProto(encodeProto(stepStarted)) as StepStartedEvent;
      final decodedStepFinished = decodeProto(encodeProto(stepFinished)) as StepFinishedEvent;

      expect(decodedError.message, runError.message);
      expect(decodedError.code, runError.code);
      expect(decodedStepStarted.stepName, stepStarted.stepName);
      expect(decodedStepFinished.stepName, stepFinished.stepName);
    });

    test('round-trips raw and custom events', () {
      final raw = RawEvent(
        timestamp: 123,
        event: {
          'type': 'analytics_event',
          'session': {
            'id': 'sess-12345',
            'actions': [
              {'type': 'page_view', 'path': '/home'},
              {'type': 'button_click', 'elementId': 'cta-1'},
            ],
          },
        },
        source: 'frontend',
      );
      final custom = CustomEvent(
        name: 'analytics_update',
        value: {
          'metrics': {'active_users': 12345, 'conversion_rate': 0.0354},
          'segments': [
            {'name': 'new_users', 'count': 543},
            {'name': 'power_users', 'count': 234},
          ],
        },
      );
      const customWithoutValue = CustomEvent(name: 'heartbeat', value: null);

      final decodedRaw = decodeProto(encodeProto(raw)) as RawEvent;
      final decodedCustom = decodeProto(encodeProto(custom)) as CustomEvent;
      final decodedCustomWithoutValue =
          decodeProto(encodeProto(customWithoutValue)) as CustomEvent;

      expect(decodedRaw.source, 'frontend');
      expect(decodedRaw.event, raw.event);
      expect(decodedCustom.name, custom.name);
      expect(decodedCustom.value, custom.value);
      expect(decodedCustomWithoutValue.name, 'heartbeat');
      expect(decodedCustomWithoutValue.value, isNull);
    });

    test('round-trips messages snapshot with tool calls', () {
      final original = MessagesSnapshotEvent(
        timestamp: 1698765432123,
        messages: const [
          UserMessage(id: 'msg-1', content: 'Hello'),
          AssistantMessage(
            id: 'msg-2',
            content: 'I can help',
            toolCalls: [
              ToolCall(
                id: 'tool-call-1',
                type: 'function',
                function: FunctionCall(
                  name: 'analyze_data',
                  arguments: '{"dataset":"sales_q2"}',
                ),
              ),
            ],
          ),
        ],
      );

      final decoded = decodeProto(encodeProto(original)) as MessagesSnapshotEvent;
      expect(decoded.messages, hasLength(2));
      expect((decoded.messages[1] as AssistantMessage).toolCalls, hasLength(1));
      expect(
        (decoded.messages[1] as AssistantMessage).toolCalls!.first.function.name,
        'analyze_data',
      );
    });

    test('round-trips a user message containing all supported modalities', () {
      final original = MessagesSnapshotEvent(
        messages: const [
          UserMessage(
            id: 'msg-user-all-modalities',
            content: [
              TextInputContent(text: 'Process all modalities'),
              ImageInputContent(
                source: InputContentUrlSource(
                  value: 'https://example.com/image.png',
                  mimeType: 'image/png',
                ),
              ),
              AudioInputContent(
                source: InputContentDataSource(
                  value: 'UklGRiQAAABXQVZF',
                  mimeType: 'audio/wav',
                ),
              ),
              VideoInputContent(
                source: InputContentUrlSource(
                  value: 'https://example.com/video.mp4',
                  mimeType: 'video/mp4',
                ),
                metadata: {'duration': 12},
              ),
              DocumentInputContent(
                source: InputContentDataSource(
                  value: 'JVBERi0xLjcK',
                  mimeType: 'application/pdf',
                ),
                metadata: {'media_type': 'application/pdf'},
              ),
            ],
          ),
        ],
      );

      final decoded = decodeProto(encodeProto(original)) as MessagesSnapshotEvent;
      final parts = (decoded.messages.single as UserMessage).content as List;
      expect(parts, hasLength(5));
      expect(parts[1], isA<ImageInputContent>());
      expect(parts[2], isA<AudioInputContent>());
      expect(parts[3], isA<VideoInputContent>());
      expect(parts[4], isA<DocumentInputContent>());
      expect((parts[3] as VideoInputContent).metadata, {'duration': 12});
    });

    test('drops empty assistant toolCalls back to null', () {
      final original = MessagesSnapshotEvent(
        messages: const [
          AssistantMessage(
            id: 'msg-1',
            content: 'I processed your request.',
            toolCalls: [],
          ),
        ],
      );

      final decoded = decodeProto(encodeProto(original)) as MessagesSnapshotEvent;
      final assistant = decoded.messages.single as AssistantMessage;
      expect(assistant.content, 'I processed your request.');
      expect(assistant.toolCalls, isNull);
    });

    test('preserves missing assistant toolCalls as null', () {
      final original = MessagesSnapshotEvent(
        messages: const [
          UserMessage(id: 'msg-1', content: 'Hello'),
          AssistantMessage(id: 'msg-2', content: 'Hi there!'),
        ],
      );

      final decoded = decodeProto(encodeProto(original)) as MessagesSnapshotEvent;
      expect((decoded.messages[0] as UserMessage).content, 'Hello');
      expect((decoded.messages[1] as AssistantMessage).content, 'Hi there!');
      expect((decoded.messages[1] as AssistantMessage).toolCalls, isNull);
    });

    test('round-trips multimodal user content parts', () {
      final original = MessagesSnapshotEvent(
        messages: const [
          UserMessage(
            id: 'msg-user-mm',
            content: [
              TextInputContent(text: 'Compare these files'),
              ImageInputContent(
                source: InputContentUrlSource(
                  value: 'https://example.com/image.png',
                  mimeType: 'image/png',
                ),
              ),
              DocumentInputContent(
                source: InputContentDataSource(
                  value: 'JVBERi0xLjcK',
                  mimeType: 'application/pdf',
                ),
                metadata: {'media_type': 'application/pdf'},
              ),
            ],
          ),
        ],
      );

      final decoded = decodeProto(encodeProto(original)) as MessagesSnapshotEvent;
      final user = decoded.messages.single as UserMessage;
      final parts = user.content as List;

      expect(parts, hasLength(3));
      expect(parts[0], isA<TextInputContent>());
      expect((parts[0] as TextInputContent).text, 'Compare these files');
      expect(parts[1], isA<ImageInputContent>());
      expect(parts[2], isA<DocumentInputContent>());
      expect((parts[2] as DocumentInputContent).metadata, {'media_type': 'application/pdf'});
    });

    test('round-trips legacy binary content as document proto payload', () {
      final original = MessagesSnapshotEvent(
        messages: const [
          UserMessage(
            id: 'msg-binary',
            content: [
              BinaryInputContent(
                mimeType: 'application/pdf',
                data: 'JVBERi0xLjcK',
                filename: 'file.pdf',
                id: 'legacy-file-id',
              ),
            ],
          ),
        ],
      );

      final decoded = decodeProto(encodeProto(original)) as MessagesSnapshotEvent;
      final user = decoded.messages.single as UserMessage;
      final document = (user.content as List).single as DocumentInputContent;

      expect(document.source, isA<InputContentDataSource>());
      expect((document.source as InputContentDataSource).mimeType, 'application/pdf');
      expect(document.metadata, {
        'legacyBinary': true,
        'filename': 'file.pdf',
        'id': 'legacy-file-id',
      });
    });

    test('throws on invalid event payload', () {
      expect(
        () => decodeProto(Uint8List(0)),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws when decoding an empty protobuf event envelope', () {
      final encoded = proto_events.Event().writeToBuffer();

      expect(
        () => decodeProto(Uint8List.fromList(encoded)),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
