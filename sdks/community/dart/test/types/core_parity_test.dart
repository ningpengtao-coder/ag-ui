import 'package:ag_ui/ag_ui.dart';
import 'package:test/test.dart';

void main() {
  group('RunFinishedEvent compatibility', () {
    test('parses legacy event with no outcome', () {
      final parsed = BaseEvent.fromJson({
        'type': EventType.runFinished.value,
        'threadId': 't-1',
        'runId': 'r-1',
      }) as RunFinishedEvent;

      expect(parsed.outcome, isNull);
    });

    test('parses explicit success outcome', () {
      final parsed = BaseEvent.fromJson({
        'type': EventType.runFinished.value,
        'threadId': 't-1',
        'runId': 'r-1',
        'outcome': {'type': 'success'},
      }) as RunFinishedEvent;

      expect(parsed.outcome, isA<RunFinishedSuccessOutcome>());
    });

    test('parses interrupt outcome', () {
      final parsed = BaseEvent.fromJson({
        'type': EventType.runFinished.value,
        'threadId': 't-1',
        'runId': 'r-1',
        'outcome': {
          'type': 'interrupt',
          'interrupts': [
            {'id': 'int-1', 'reason': 'tool_call'},
          ],
        },
      }) as RunFinishedEvent;

      expect(parsed.outcome, isA<RunFinishedInterruptOutcome>());
      expect((parsed.outcome as RunFinishedInterruptOutcome).interrupts, hasLength(1));
    });
  });

  group('TokenUsage', () {
    test('parses the counts a producer reports', () {
      final usage = TokenUsage.fromJson(const {
        'provider': 'openai',
        'model': 'gpt-4.1',
        'inputTokens': 10,
        'outputTokens': 4,
        'totalTokens': 14,
        'reasoningTokens': 0,
      });

      expect(usage.provider, 'openai');
      expect(usage.totalTokens, 14);
      expect(usage.cachedInputTokens, isNull);
    });

    test('rejects a negative count', () {
      expect(
        () => TokenUsage.fromJson(const {'inputTokens': -1}),
        throwsA(isA<AGUIValidationError>()),
      );
    });

    test('rejects a count past the safe-integer range', () {
      expect(
        () => TokenUsage.fromJson(const {'outputTokens': 9007199254740992}),
        throwsA(isA<AGUIValidationError>()),
      );
    });
  });

  group('Multimodal messages', () {
    test('parses user message with content array', () {
      final parsed = Message.fromJson({
        'id': 'user_multimodal',
        'role': 'user',
        'content': [
          {'type': 'text', 'text': 'Check this out'},
          {
            'type': 'image',
            'source': {
              'type': 'url',
              'value': 'https://example.com/image.png',
              'mimeType': 'image/png',
            },
          },
        ],
      }) as UserMessage;

      expect(parsed.contentParts, isNotNull);
      final content = parsed.contentParts!;
      expect((content[0] as TextInputContent).text, 'Check this out');
      expect((content[1] as ImageInputContent).source, isA<InputContentUrlSource>());
    });

    test('requires a payload source for binary input content', () {
      expect(
        () => BinaryInputContent.fromJson({
          'type': 'binary',
          'mimeType': 'image/png',
        }),
        throwsA(isA<AGUIValidationError>()),
      );
    });
  });

  group('Event role defaults', () {
    test('defaults TextMessageStartEvent role to assistant', () {
      final parsed = BaseEvent.fromJson({
        'type': EventType.textMessageStart.value,
        'messageId': 'test-msg',
      }) as TextMessageStartEvent;

      expect(parsed.role, TextMessageRole.assistant);
    });

    test('keeps role optional in TextMessageChunkEvent', () {
      final parsed = BaseEvent.fromJson({
        'type': EventType.textMessageChunk.value,
        'messageId': 'test-msg',
        'delta': 'test content',
      }) as TextMessageChunkEvent;

      expect(parsed.role, isNull);
    });

    test('supports name field on text message events', () {
      final start = BaseEvent.fromJson({
        'type': EventType.textMessageStart.value,
        'messageId': 'test-msg',
        'name': 'research-agent',
      }) as TextMessageStartEvent;
      final chunk = BaseEvent.fromJson({
        'type': EventType.textMessageChunk.value,
        'messageId': 'test-msg',
        'delta': 'Hello',
        'name': 'research-agent',
      }) as TextMessageChunkEvent;

      expect(start.name, 'research-agent');
      expect(chunk.name, 'research-agent');
    });
  });

  group('mergeMetadata', () {
    test('is key-by-key with the last write winning', () {
      final merged = mergeMetadata(
        {'keep': 1, agUiMetadataKey: {'hint': 'old'}},
        {
          'keep': 2,
          agUiMetadataKey: {'hint': 'new'},
        },
      );

      expect(merged, {
        'keep': 2,
        agUiMetadataKey: {'hint': 'new'},
      });
    });

    test('returns the existing map untouched when nothing comes in', () {
      final existing = {'keep': 1};

      expect(identical(mergeMetadata(existing, null), existing), isTrue);
    });

    test('copies rather than aliasing the incoming map', () {
      final incoming = {'a': 1};
      final merged = mergeMetadata(null, incoming)!;
      incoming['a'] = 2;

      expect(merged['a'], 1);
    });
  });

  group('contentToText', () {
    test('passes a string through', () {
      expect(contentToText('hello'), 'hello');
    });

    test('concatenates text parts and drops media', () {
      final message = UserMessage(
        id: 'm-1',
        content: const [
          TextInputContent(text: 'a'),
          ImageInputContent(
            source: InputContentUrlSource(value: 'https://example.com/i.png'),
          ),
          TextInputContent(text: 'b'),
        ],
      );

      expect(contentToText(message.content), 'ab');
    });

    test('flattens media-only content to the empty string', () {
      final content = [
        ImageInputContent(
          source: InputContentUrlSource(value: 'https://example.com/i.png'),
        ),
      ];

      expect(contentToText(content), '');
      expect(contentToText(null), '');
    });
  });

  group('contentHasMedia', () {
    test('is false for strings and text-only parts', () {
      expect(contentHasMedia('hello'), isFalse);
      expect(
        contentHasMedia(const [TextInputContent(text: 'hello')]),
        isFalse,
      );
    });

    test('is true when a non-text part is present', () {
      expect(
        contentHasMedia(const [
          TextInputContent(text: 'see'),
          ImageInputContent(
            source: InputContentUrlSource(value: 'https://example.com/i.png'),
          ),
        ]),
        isTrue,
      );
    });
  });

  group('token usage mappings', () {
    test('maps a LangChain usage_metadata object', () {
      final usage = tokenUsageFromLangChainMetadata(
        const {
          'input_tokens': 100,
          'output_tokens': 40,
          'total_tokens': 140,
          'input_token_details': {'cache_read': 30, 'cache_creation': 10},
          'output_token_details': {'reasoning': 5},
        },
        provider: 'langchain',
        model: 'gpt-4.1',
      )!;

      expect(usage.provider, 'langchain');
      expect(usage.model, 'gpt-4.1');
      expect(usage.inputTokens, 100);
      expect(usage.outputTokens, 40);
      expect(usage.totalTokens, 140);
      expect(usage.reasoningTokens, 5);
      expect(usage.cachedInputTokens, 30);
      expect(usage.cacheWriteInputTokens, 10);
    });

    test('maps an AI SDK v6 usage object, preferring the top-level counts', () {
      final usage = tokenUsageFromAiSdkUsage(
        const {
          'inputTokens': 100,
          'outputTokens': 40,
          'totalTokens': 140,
          'reasoningTokens': 7,
          'inputTokenDetails': {
            'cacheReadTokens': 30,
            'cacheWriteTokens': 10,
          },
          'outputTokenDetails': {'reasoningTokens': 999},
        },
      )!;

      expect(usage.reasoningTokens, 7);
      expect(usage.cachedInputTokens, 30);
      expect(usage.cacheWriteInputTokens, 10);
    });

    test('omits usage when the provider reported no count', () {
      expect(tokenUsageFromLangChainMetadata(null), isNull);
      expect(tokenUsageFromAiSdkUsage(const {}), isNull);
      expect(
        tokenUsageFromLangChainMetadata(
          const {'input_tokens': '100'},
          provider: 'langchain',
        ),
        isNull,
      );
    });

    test('aggregates per provider and model, keeping absent counts absent', () {
      final aggregated = aggregateTokenUsage(const [
        TokenUsage(provider: 'openai', model: 'gpt-4.1', inputTokens: 10),
        TokenUsage(provider: 'openai', model: 'gpt-4.1', outputTokens: 4),
        TokenUsage(provider: 'anthropic', model: 'claude', inputTokens: 3),
        TokenUsage(
          provider: 'openai',
          model: 'gpt-4.1',
          inputTokens: 1,
          cachedInputTokens: 2,
        ),
      ]);

      expect(aggregated.map((entry) => entry.provider), ['openai', 'anthropic']);
      final openai = aggregated.first;
      expect(openai.inputTokens, 11);
      expect(openai.outputTokens, 4);
      expect(openai.cachedInputTokens, 2);
      expect(openai.totalTokens, isNull);
    });
  });
}
