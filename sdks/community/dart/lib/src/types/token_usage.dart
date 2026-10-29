/// Token usage reported by a producer on `RUN_FINISHED` / `RUN_ERROR`.
library;

import '../diagnostics.dart';
import 'base.dart';

/// Token accounting for one model call.
///
/// Mirrors the 1.0 `TokenUsage` definition: every field is optional because a
/// producer only reports what its provider exposes.
class TokenUsage extends AGUIModel {
  final String? provider;
  final String? model;
  final int? inputTokens;
  final int? outputTokens;
  final int? totalTokens;
  final int? reasoningTokens;
  final int? cachedInputTokens;
  final int? cacheWriteInputTokens;

  const TokenUsage({
    this.provider,
    this.model,
    this.inputTokens,
    this.outputTokens,
    this.totalTokens,
    this.reasoningTokens,
    this.cachedInputTokens,
    this.cacheWriteInputTokens,
  });

  factory TokenUsage.fromJson(Map<String, dynamic> json) {
    return TokenUsage(
      provider: JsonDecoder.optionalField<String>(json, 'provider'),
      model: JsonDecoder.optionalField<String>(json, 'model'),
      inputTokens: _tokenCount(json, 'inputTokens'),
      outputTokens: _tokenCount(json, 'outputTokens'),
      totalTokens: _tokenCount(json, 'totalTokens'),
      reasoningTokens: _tokenCount(json, 'reasoningTokens'),
      cachedInputTokens: _tokenCount(json, 'cachedInputTokens'),
      cacheWriteInputTokens: _tokenCount(json, 'cacheWriteInputTokens'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        if (provider != null) 'provider': provider,
        if (model != null) 'model': model,
        if (inputTokens != null) 'inputTokens': inputTokens,
        if (outputTokens != null) 'outputTokens': outputTokens,
        if (totalTokens != null) 'totalTokens': totalTokens,
        if (reasoningTokens != null) 'reasoningTokens': reasoningTokens,
        if (cachedInputTokens != null) 'cachedInputTokens': cachedInputTokens,
        if (cacheWriteInputTokens != null)
          'cacheWriteInputTokens': cacheWriteInputTokens,
      };

  @override
  TokenUsage copyWith({
    String? provider,
    String? model,
    int? inputTokens,
    int? outputTokens,
    int? totalTokens,
    int? reasoningTokens,
    int? cachedInputTokens,
    int? cacheWriteInputTokens,
  }) {
    return TokenUsage(
      provider: provider ?? this.provider,
      model: model ?? this.model,
      inputTokens: inputTokens ?? this.inputTokens,
      outputTokens: outputTokens ?? this.outputTokens,
      totalTokens: totalTokens ?? this.totalTokens,
      reasoningTokens: reasoningTokens ?? this.reasoningTokens,
      cachedInputTokens: cachedInputTokens ?? this.cachedInputTokens,
      cacheWriteInputTokens:
          cacheWriteInputTokens ?? this.cacheWriteInputTokens,
    );
  }
}

/// The largest count the schema allows: `2^53 - 1`, the integer range JSON
/// numbers stay exact in.
const int _maxTokenCount = 9007199254740991;

/// Reads a count under the schema's bounds.
///
/// Consumers compare and sum these numbers, so a negative count or one past the
/// safe-integer range is a malformed known value rather than something to
/// clamp: clamping would report accounting the producer never measured.
int? _tokenCount(Map<String, dynamic> json, String field) {
  final value = JsonDecoder.optionalField<int>(json, field);
  if (value == null) return null;
  if (value < 0 || value > _maxTokenCount) {
    throw AGUIValidationError(
      message: "Field '$field' must be between 0 and $_maxTokenCount, "
          'received $value',
      field: field,
      value: value,
      json: json,
    );
  }
  return value;
}

// --- Vendor mappings and aggregation -------------------------------------

/// The AG-UI names of the six token counts, in the order an entry lists them.
const List<String> _countKeys = <String>[
  'inputTokens',
  'outputTokens',
  'totalTokens',
  'reasoningTokens',
  'cachedInputTokens',
  'cacheWriteInputTokens',
];

/// The count keys already warned about, so the diagnostic below fires once per
/// process per key rather than once per event. A provider that hands over a
/// string count hands one over on every call, and a per-call warning would bury
/// the stream it is meant to annotate.
final Set<String> _warnedCountKeys = <String>{};

int? _countAt(Object? value, String key) {
  if (value is int) {
    return value;
  }
  // A fractional count is malformed, not something to round: truncating would
  // report accounting the producer never measured.
  if (value is double && value.isFinite && value == value.truncateToDouble()) {
    return value.toInt();
  }
  // `null` and a non-finite number are how a provider spells "did not report
  // this count", not defects — warning on them would fire on ordinary traffic.
  final absent = value == null || (value is num && value.isNaN);
  if (!absent && !_warnedCountKeys.contains(key)) {
    _warnedCountKeys.add(key);
    AgUiDiagnostics.warn(
      'usage.$key was ${_describeRejected(value)}, not a number — omitted from '
      "this run's usage. Reported once per key.",
    );
  }
  return null;
}

String _describeRejected(Object? value) {
  if (value is String) return '"$value" (a string)';
  if (value is num) {
    return value.isFinite
        ? '$value (not a whole number)'
        : '$value (a non-finite number)';
  }
  if (value is Map) return 'an object';
  return '$value (a ${value.runtimeType})';
}

/// Reads a property from a value of unknown shape, yielding `null` for anything
/// that is not a map. Vendor payloads are untrusted, so every access is narrowed
/// rather than assumed.
Object? _property(Object? value, String key) =>
    value is Map ? value[key] : null;

/// Builds a [TokenUsage] from already-guarded counts, or `null` when no count
/// survived. Returning `null` rather than a labels-only entry keeps "the
/// provider reported no usage" distinct from "the provider reported usage", so
/// callers omit the field instead of emitting an entry that claims nothing.
TokenUsage? _buildEntry(
  Map<String, int?> counts, {
  String? provider,
  String? model,
}) {
  if (!_countKeys.any((key) => counts[key] != null)) {
    return null;
  }
  return TokenUsage(
    provider: provider,
    model: model,
    inputTokens: counts['inputTokens'],
    outputTokens: counts['outputTokens'],
    totalTokens: counts['totalTokens'],
    reasoningTokens: counts['reasoningTokens'],
    cachedInputTokens: counts['cachedInputTokens'],
    cacheWriteInputTokens: counts['cacheWriteInputTokens'],
  );
}

/// Maps a LangChain-family `usage_metadata` object into a [TokenUsage].
///
/// LangChain and LangGraph both attach usage as `{ input_tokens, output_tokens,
/// total_tokens, input_token_details: { cache_read, cache_creation },
/// output_token_details: { reasoning } }`. LangChain's accounting is the
/// protocol's — `input_tokens` already includes the cache details and
/// `output_tokens` the reasoning detail — so every count passes through as is.
/// This maps only those numeric counts plus optional provider/model labels —
/// never prompt/completion content. Returns `null` when no usable count is
/// present, so callers can omit usage rather than report zeros.
TokenUsage? tokenUsageFromLangChainMetadata(
  Object? usageMetadata, {
  String? provider,
  String? model,
}) {
  if (usageMetadata == null) return null;

  final inputDetails = _property(usageMetadata, 'input_token_details');
  final outputDetails = _property(usageMetadata, 'output_token_details');

  return _buildEntry(
    <String, int?>{
      'inputTokens': _countAt(
        _property(usageMetadata, 'input_tokens'),
        'inputTokens',
      ),
      'outputTokens': _countAt(
        _property(usageMetadata, 'output_tokens'),
        'outputTokens',
      ),
      'totalTokens': _countAt(
        _property(usageMetadata, 'total_tokens'),
        'totalTokens',
      ),
      'reasoningTokens': _countAt(
        _property(outputDetails, 'reasoning'),
        'reasoningTokens',
      ),
      'cachedInputTokens': _countAt(
        _property(inputDetails, 'cache_read'),
        'cachedInputTokens',
      ),
      'cacheWriteInputTokens': _countAt(
        _property(inputDetails, 'cache_creation'),
        'cacheWriteInputTokens',
      ),
    },
    provider: provider,
    model: model,
  );
}

/// Maps an AI-SDK `LanguageModelUsage` object into a [TokenUsage].
///
/// AI-SDK's v5 keys already match — `inputTokens`, `outputTokens`,
/// `totalTokens`, `reasoningTokens`, `cachedInputTokens` — with the totals
/// inclusive the way the protocol counts them. v6 adds `inputTokenDetails:
/// { cacheReadTokens, cacheWriteTokens }` and `outputTokenDetails:
/// { reasoningTokens }`; the cache-write count exists only there, and the two
/// counts present in both forms are read from the top level first. AI-SDK
/// reports `NaN` / `null` for counts a provider did not return, so only finite
/// numbers are copied. Returns `null` when no finite count is present.
TokenUsage? tokenUsageFromAiSdkUsage(
  Object? usage, {
  String? provider,
  String? model,
}) {
  if (usage == null) return null;

  final inputDetails = _property(usage, 'inputTokenDetails');
  final outputDetails = _property(usage, 'outputTokenDetails');

  return _buildEntry(
    <String, int?>{
      'inputTokens': _countAt(_property(usage, 'inputTokens'), 'inputTokens'),
      'outputTokens': _countAt(_property(usage, 'outputTokens'), 'outputTokens'),
      'totalTokens': _countAt(_property(usage, 'totalTokens'), 'totalTokens'),
      'reasoningTokens': _countAt(
            _property(usage, 'reasoningTokens'),
            'reasoningTokens',
          ) ??
          _countAt(
            _property(outputDetails, 'reasoningTokens'),
            'reasoningTokens',
          ),
      'cachedInputTokens': _countAt(
            _property(usage, 'cachedInputTokens'),
            'cachedInputTokens',
          ) ??
          _countAt(
            _property(inputDetails, 'cacheReadTokens'),
            'cachedInputTokens',
          ),
      'cacheWriteInputTokens': _countAt(
        _property(inputDetails, 'cacheWriteTokens'),
        'cacheWriteInputTokens',
      ),
    },
    provider: provider,
    model: model,
  );
}

/// Sums per-call [TokenUsage] entries into one entry per `(provider, model)`
/// pair. Order follows first appearance. A count field stays absent when no
/// member of the group reported it, so "not reported" stays distinct from zero.
///
/// Protocol-agnostic: works on any producer's `TokenUsage` list, so integrations
/// share it rather than reimplementing aggregation.
List<TokenUsage> aggregateTokenUsage(Iterable<TokenUsage> entries) {
  final grouped = <String, TokenUsage>{};

  for (final entry in entries) {
    final key = '${entry.provider ?? ''} ${entry.model ?? ''}';
    var target = grouped[key] ??
        TokenUsage(provider: entry.provider, model: entry.model);
    for (final field in _countKeys) {
      final value = _countOf(entry, field);
      if (value == null) continue;
      target = _withCount(target, field, (_countOf(target, field) ?? 0) + value);
    }
    grouped[key] = target;
  }

  return grouped.values.toList();
}

int? _countOf(TokenUsage usage, String field) {
  return switch (field) {
    'inputTokens' => usage.inputTokens,
    'outputTokens' => usage.outputTokens,
    'totalTokens' => usage.totalTokens,
    'reasoningTokens' => usage.reasoningTokens,
    'cachedInputTokens' => usage.cachedInputTokens,
    'cacheWriteInputTokens' => usage.cacheWriteInputTokens,
    _ => null,
  };
}

TokenUsage _withCount(TokenUsage usage, String field, int value) {
  return switch (field) {
    'inputTokens' => usage.copyWith(inputTokens: value),
    'outputTokens' => usage.copyWith(outputTokens: value),
    'totalTokens' => usage.copyWith(totalTokens: value),
    'reasoningTokens' => usage.copyWith(reasoningTokens: value),
    'cachedInputTokens' => usage.copyWith(cachedInputTokens: value),
    'cacheWriteInputTokens' => usage.copyWith(cacheWriteInputTokens: value),
    _ => usage,
  };
}
