// This is a generated file - do not edit.
//
// Generated from types.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/struct.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// A text part.
class TextInputPart extends $pb.GeneratedMessage {
  factory TextInputPart({
    $core.String? text,
    $core.String? id,
    $0.Value? metadata,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (id != null) result.id = id;
    if (metadata != null) result.metadata = metadata;
    return result;
  }

  TextInputPart._();

  factory TextInputPart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TextInputPart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TextInputPart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..aOM<$0.Value>(3, _omitFieldNames ? '' : 'metadata',
        subBuilder: $0.Value.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextInputPart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextInputPart copyWith(void Function(TextInputPart) updates) =>
      super.copyWith((message) => updates(message as TextInputPart))
          as TextInputPart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TextInputPart create() => TextInputPart._();
  @$core.override
  TextInputPart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TextInputPart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TextInputPart>(create);
  static TextInputPart? _defaultInstance;

  /// The text.
  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  /// Identifies this part within its message. Optional, and nothing reads it yet:
  /// reserved so that a streamed part can be matched to its entry in history once
  /// assistant messages carry parts too.
  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  /// Extra information about this part. Unconstrained, as on the media parts.
  /// This is where a text search hit carries its source and title, rather than
  /// the protocol modelling a search-result part of its own.
  @$pb.TagNumber(3)
  $0.Value get metadata => $_getN(2);
  @$pb.TagNumber(3)
  set metadata($0.Value value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMetadata() => $_has(2);
  @$pb.TagNumber(3)
  void clearMetadata() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Value ensureMetadata() => $_ensure(2);
}

/// An image part.
class ImageInputPart extends $pb.GeneratedMessage {
  factory ImageInputPart({
    InputContentSource? source,
    $0.Value? metadata,
    $core.String? id,
  }) {
    final result = create();
    if (source != null) result.source = source;
    if (metadata != null) result.metadata = metadata;
    if (id != null) result.id = id;
    return result;
  }

  ImageInputPart._();

  factory ImageInputPart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ImageInputPart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImageInputPart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<InputContentSource>(1, _omitFieldNames ? '' : 'source',
        subBuilder: InputContentSource.create)
    ..aOM<$0.Value>(2, _omitFieldNames ? '' : 'metadata',
        subBuilder: $0.Value.create)
    ..aOS(3, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImageInputPart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImageInputPart copyWith(void Function(ImageInputPart) updates) =>
      super.copyWith((message) => updates(message as ImageInputPart))
          as ImageInputPart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ImageInputPart create() => ImageInputPart._();
  @$core.override
  ImageInputPart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ImageInputPart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ImageInputPart>(create);
  static ImageInputPart? _defaultInstance;

  /// Where the image comes from.
  @$pb.TagNumber(1)
  InputContentSource get source => $_getN(0);
  @$pb.TagNumber(1)
  set source(InputContentSource value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSource() => $_has(0);
  @$pb.TagNumber(1)
  void clearSource() => $_clearField(1);
  @$pb.TagNumber(1)
  InputContentSource ensureSource() => $_ensure(0);

  /// Extra information about this part. Unconstrained rather than an object:
  /// inherited from the SDKs, which declare it unknown rather than a record;
  /// listed under known divergences in the README rather than resolved here.
  @$pb.TagNumber(2)
  $0.Value get metadata => $_getN(1);
  @$pb.TagNumber(2)
  set metadata($0.Value value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMetadata() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetadata() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Value ensureMetadata() => $_ensure(1);

  /// Identifies this part within its message. Optional, and nothing reads it yet:
  /// reserved as on the text part.
  @$pb.TagNumber(3)
  $core.String get id => $_getSZ(2);
  @$pb.TagNumber(3)
  set id($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasId() => $_has(2);
  @$pb.TagNumber(3)
  void clearId() => $_clearField(3);
}

/// Bytes carried inline.
class InputContentDataSource extends $pb.GeneratedMessage {
  factory InputContentDataSource({
    $core.String? value,
    $core.String? mimeType,
  }) {
    final result = create();
    if (value != null) result.value = value;
    if (mimeType != null) result.mimeType = mimeType;
    return result;
  }

  InputContentDataSource._();

  factory InputContentDataSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InputContentDataSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InputContentDataSource',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'value')
    ..aOS(2, _omitFieldNames ? '' : 'mimeType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InputContentDataSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InputContentDataSource copyWith(
          void Function(InputContentDataSource) updates) =>
      super.copyWith((message) => updates(message as InputContentDataSource))
          as InputContentDataSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InputContentDataSource create() => InputContentDataSource._();
  @$core.override
  InputContentDataSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InputContentDataSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InputContentDataSource>(create);
  static InputContentDataSource? _defaultInstance;

  /// The bytes, base64-encoded. contentEncoding is an annotation rather than a
  /// constraint in 2020-12, so a malformed string still validates here; rejecting
  /// one is the decoder's job.
  @$pb.TagNumber(1)
  $core.String get value => $_getSZ(0);
  @$pb.TagNumber(1)
  set value($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);

  /// What the bytes are. Required here, unlike on a URL source, because nothing
  /// else can tell a consumer how to read them.
  @$pb.TagNumber(2)
  $core.String get mimeType => $_getSZ(1);
  @$pb.TagNumber(2)
  set mimeType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMimeType() => $_has(1);
  @$pb.TagNumber(2)
  void clearMimeType() => $_clearField(2);
}

/// Bytes referenced by URL, fetched by whoever needs them.
class InputContentUrlSource extends $pb.GeneratedMessage {
  factory InputContentUrlSource({
    $core.String? value,
    $core.String? mimeType,
  }) {
    final result = create();
    if (value != null) result.value = value;
    if (mimeType != null) result.mimeType = mimeType;
    return result;
  }

  InputContentUrlSource._();

  factory InputContentUrlSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InputContentUrlSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InputContentUrlSource',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'value')
    ..aOS(2, _omitFieldNames ? '' : 'mimeType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InputContentUrlSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InputContentUrlSource copyWith(
          void Function(InputContentUrlSource) updates) =>
      super.copyWith((message) => updates(message as InputContentUrlSource))
          as InputContentUrlSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InputContentUrlSource create() => InputContentUrlSource._();
  @$core.override
  InputContentUrlSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InputContentUrlSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InputContentUrlSource>(create);
  static InputContentUrlSource? _defaultInstance;

  /// The URL. Deliberately not constrained to a URI format, so a scheme a
  /// producer already uses is not rejected here.
  @$pb.TagNumber(1)
  $core.String get value => $_getSZ(0);
  @$pb.TagNumber(1)
  set value($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);

  /// What the resource is, when the producer knows. Optional, because the
  /// response can say.
  @$pb.TagNumber(2)
  $core.String get mimeType => $_getSZ(1);
  @$pb.TagNumber(2)
  set mimeType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMimeType() => $_has(1);
  @$pb.TagNumber(2)
  void clearMimeType() => $_clearField(2);
}

/// Bytes already at the provider, named by a handle the provider issued: an
/// OpenAI or Anthropic file id, a Gemini file URI, a storage URL only that
/// provider can read. No bytes travel and nothing is fetched. Only the provider
/// that minted the handle can resolve it; a peer that cannot drops the part as it
/// drops any part it cannot use.
class InputContentFileSource extends $pb.GeneratedMessage {
  factory InputContentFileSource({
    $core.String? value,
    $core.String? provider,
    $core.String? mimeType,
  }) {
    final result = create();
    if (value != null) result.value = value;
    if (provider != null) result.provider = provider;
    if (mimeType != null) result.mimeType = mimeType;
    return result;
  }

  InputContentFileSource._();

  factory InputContentFileSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InputContentFileSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InputContentFileSource',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'value')
    ..aOS(2, _omitFieldNames ? '' : 'provider')
    ..aOS(3, _omitFieldNames ? '' : 'mimeType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InputContentFileSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InputContentFileSource copyWith(
          void Function(InputContentFileSource) updates) =>
      super.copyWith((message) => updates(message as InputContentFileSource))
          as InputContentFileSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InputContentFileSource create() => InputContentFileSource._();
  @$core.override
  InputContentFileSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InputContentFileSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InputContentFileSource>(create);
  static InputContentFileSource? _defaultInstance;

  /// The handle, exactly as the provider issued it. Opaque: a consumer MUST NOT
  /// fetch it, parse it or read a scheme out of it.
  @$pb.TagNumber(1)
  $core.String get value => $_getSZ(0);
  @$pb.TagNumber(1)
  set value($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);

  /// Who issued the handle, when the producer knows. Optional: an agent already
  /// knows which provider it talks to. When present, SHOULD be the lowercase
  /// vendor id (openai, anthropic, google) that TokenUsage.provider uses, so a
  /// peer can tell before sending whether a handle is one it can use.
  @$pb.TagNumber(2)
  $core.String get provider => $_getSZ(1);
  @$pb.TagNumber(2)
  set provider($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProvider() => $_has(1);
  @$pb.TagNumber(2)
  void clearProvider() => $_clearField(2);

  /// What the file is, when the producer knows. Optional, because the provider
  /// that holds the bytes knows.
  @$pb.TagNumber(3)
  $core.String get mimeType => $_getSZ(2);
  @$pb.TagNumber(3)
  set mimeType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMimeType() => $_has(2);
  @$pb.TagNumber(3)
  void clearMimeType() => $_clearField(3);
}

enum InputContentSource_Source { data, url, file, notSet }

/// Where a media part's bytes come from: carried inline, referenced by URL, or
/// already at the provider under a handle it issued.
class InputContentSource extends $pb.GeneratedMessage {
  factory InputContentSource({
    InputContentDataSource? data,
    InputContentUrlSource? url,
    InputContentFileSource? file,
  }) {
    final result = create();
    if (data != null) result.data = data;
    if (url != null) result.url = url;
    if (file != null) result.file = file;
    return result;
  }

  InputContentSource._();

  factory InputContentSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InputContentSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, InputContentSource_Source>
      _InputContentSource_SourceByTag = {
    1: InputContentSource_Source.data,
    2: InputContentSource_Source.url,
    3: InputContentSource_Source.file,
    0: InputContentSource_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InputContentSource',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<InputContentDataSource>(1, _omitFieldNames ? '' : 'data',
        subBuilder: InputContentDataSource.create)
    ..aOM<InputContentUrlSource>(2, _omitFieldNames ? '' : 'url',
        subBuilder: InputContentUrlSource.create)
    ..aOM<InputContentFileSource>(3, _omitFieldNames ? '' : 'file',
        subBuilder: InputContentFileSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InputContentSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InputContentSource copyWith(void Function(InputContentSource) updates) =>
      super.copyWith((message) => updates(message as InputContentSource))
          as InputContentSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InputContentSource create() => InputContentSource._();
  @$core.override
  InputContentSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InputContentSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InputContentSource>(create);
  static InputContentSource? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  InputContentSource_Source whichSource() =>
      _InputContentSource_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  InputContentDataSource get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(InputContentDataSource value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => $_clearField(1);
  @$pb.TagNumber(1)
  InputContentDataSource ensureData() => $_ensure(0);

  @$pb.TagNumber(2)
  InputContentUrlSource get url => $_getN(1);
  @$pb.TagNumber(2)
  set url(InputContentUrlSource value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);
  @$pb.TagNumber(2)
  InputContentUrlSource ensureUrl() => $_ensure(1);

  @$pb.TagNumber(3)
  InputContentFileSource get file => $_getN(2);
  @$pb.TagNumber(3)
  set file(InputContentFileSource value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFile() => $_has(2);
  @$pb.TagNumber(3)
  void clearFile() => $_clearField(3);
  @$pb.TagNumber(3)
  InputContentFileSource ensureFile() => $_ensure(2);
}

/// An audio part.
class AudioInputPart extends $pb.GeneratedMessage {
  factory AudioInputPart({
    InputContentSource? source,
    $0.Value? metadata,
    $core.String? id,
  }) {
    final result = create();
    if (source != null) result.source = source;
    if (metadata != null) result.metadata = metadata;
    if (id != null) result.id = id;
    return result;
  }

  AudioInputPart._();

  factory AudioInputPart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AudioInputPart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AudioInputPart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<InputContentSource>(1, _omitFieldNames ? '' : 'source',
        subBuilder: InputContentSource.create)
    ..aOM<$0.Value>(2, _omitFieldNames ? '' : 'metadata',
        subBuilder: $0.Value.create)
    ..aOS(3, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AudioInputPart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AudioInputPart copyWith(void Function(AudioInputPart) updates) =>
      super.copyWith((message) => updates(message as AudioInputPart))
          as AudioInputPart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AudioInputPart create() => AudioInputPart._();
  @$core.override
  AudioInputPart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AudioInputPart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AudioInputPart>(create);
  static AudioInputPart? _defaultInstance;

  /// Where the audio comes from.
  @$pb.TagNumber(1)
  InputContentSource get source => $_getN(0);
  @$pb.TagNumber(1)
  set source(InputContentSource value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSource() => $_has(0);
  @$pb.TagNumber(1)
  void clearSource() => $_clearField(1);
  @$pb.TagNumber(1)
  InputContentSource ensureSource() => $_ensure(0);

  /// Extra information about this part. Unconstrained, as on the other media
  /// parts.
  @$pb.TagNumber(2)
  $0.Value get metadata => $_getN(1);
  @$pb.TagNumber(2)
  set metadata($0.Value value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMetadata() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetadata() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Value ensureMetadata() => $_ensure(1);

  /// Identifies this part within its message. Optional, and nothing reads it yet:
  /// reserved as on the text part.
  @$pb.TagNumber(3)
  $core.String get id => $_getSZ(2);
  @$pb.TagNumber(3)
  set id($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasId() => $_has(2);
  @$pb.TagNumber(3)
  void clearId() => $_clearField(3);
}

/// A video part.
class VideoInputPart extends $pb.GeneratedMessage {
  factory VideoInputPart({
    InputContentSource? source,
    $0.Value? metadata,
    $core.String? id,
  }) {
    final result = create();
    if (source != null) result.source = source;
    if (metadata != null) result.metadata = metadata;
    if (id != null) result.id = id;
    return result;
  }

  VideoInputPart._();

  factory VideoInputPart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VideoInputPart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoInputPart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<InputContentSource>(1, _omitFieldNames ? '' : 'source',
        subBuilder: InputContentSource.create)
    ..aOM<$0.Value>(2, _omitFieldNames ? '' : 'metadata',
        subBuilder: $0.Value.create)
    ..aOS(3, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoInputPart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoInputPart copyWith(void Function(VideoInputPart) updates) =>
      super.copyWith((message) => updates(message as VideoInputPart))
          as VideoInputPart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VideoInputPart create() => VideoInputPart._();
  @$core.override
  VideoInputPart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VideoInputPart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoInputPart>(create);
  static VideoInputPart? _defaultInstance;

  /// Where the video comes from.
  @$pb.TagNumber(1)
  InputContentSource get source => $_getN(0);
  @$pb.TagNumber(1)
  set source(InputContentSource value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSource() => $_has(0);
  @$pb.TagNumber(1)
  void clearSource() => $_clearField(1);
  @$pb.TagNumber(1)
  InputContentSource ensureSource() => $_ensure(0);

  /// Extra information about this part. Unconstrained, as on the other media
  /// parts.
  @$pb.TagNumber(2)
  $0.Value get metadata => $_getN(1);
  @$pb.TagNumber(2)
  set metadata($0.Value value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMetadata() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetadata() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Value ensureMetadata() => $_ensure(1);

  /// Identifies this part within its message. Optional, and nothing reads it yet:
  /// reserved as on the text part.
  @$pb.TagNumber(3)
  $core.String get id => $_getSZ(2);
  @$pb.TagNumber(3)
  set id($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasId() => $_has(2);
  @$pb.TagNumber(3)
  void clearId() => $_clearField(3);
}

/// A document part.
class DocumentInputPart extends $pb.GeneratedMessage {
  factory DocumentInputPart({
    InputContentSource? source,
    $0.Value? metadata,
    $core.String? id,
  }) {
    final result = create();
    if (source != null) result.source = source;
    if (metadata != null) result.metadata = metadata;
    if (id != null) result.id = id;
    return result;
  }

  DocumentInputPart._();

  factory DocumentInputPart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DocumentInputPart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DocumentInputPart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOM<InputContentSource>(1, _omitFieldNames ? '' : 'source',
        subBuilder: InputContentSource.create)
    ..aOM<$0.Value>(2, _omitFieldNames ? '' : 'metadata',
        subBuilder: $0.Value.create)
    ..aOS(3, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DocumentInputPart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DocumentInputPart copyWith(void Function(DocumentInputPart) updates) =>
      super.copyWith((message) => updates(message as DocumentInputPart))
          as DocumentInputPart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DocumentInputPart create() => DocumentInputPart._();
  @$core.override
  DocumentInputPart createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DocumentInputPart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DocumentInputPart>(create);
  static DocumentInputPart? _defaultInstance;

  /// Where the document comes from.
  @$pb.TagNumber(1)
  InputContentSource get source => $_getN(0);
  @$pb.TagNumber(1)
  set source(InputContentSource value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSource() => $_has(0);
  @$pb.TagNumber(1)
  void clearSource() => $_clearField(1);
  @$pb.TagNumber(1)
  InputContentSource ensureSource() => $_ensure(0);

  /// Extra information about this part. Unconstrained, as on the other media
  /// parts.
  @$pb.TagNumber(2)
  $0.Value get metadata => $_getN(1);
  @$pb.TagNumber(2)
  set metadata($0.Value value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMetadata() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetadata() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Value ensureMetadata() => $_ensure(1);

  /// Identifies this part within its message. Optional, and nothing reads it yet:
  /// reserved as on the text part.
  @$pb.TagNumber(3)
  $core.String get id => $_getSZ(2);
  @$pb.TagNumber(3)
  set id($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasId() => $_has(2);
  @$pb.TagNumber(3)
  void clearId() => $_clearField(3);
}

enum InputContent_Part { text, image, audio, video, document, notSet }

/// One part of a message body: what a person sends in a user message, or what a
/// tool returns in a tool message. Discriminated by type. Named by what the part
/// is rather than by direction, because the same part travels into the model
/// inside a user message and back out of the stream inside a tool result.
class InputContent extends $pb.GeneratedMessage {
  factory InputContent({
    TextInputPart? text,
    ImageInputPart? image,
    AudioInputPart? audio,
    VideoInputPart? video,
    DocumentInputPart? document,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (image != null) result.image = image;
    if (audio != null) result.audio = audio;
    if (video != null) result.video = video;
    if (document != null) result.document = document;
    return result;
  }

  InputContent._();

  factory InputContent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InputContent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, InputContent_Part> _InputContent_PartByTag =
      {
    1: InputContent_Part.text,
    2: InputContent_Part.image,
    3: InputContent_Part.audio,
    4: InputContent_Part.video,
    5: InputContent_Part.document,
    0: InputContent_Part.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InputContent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5])
    ..aOM<TextInputPart>(1, _omitFieldNames ? '' : 'text',
        subBuilder: TextInputPart.create)
    ..aOM<ImageInputPart>(2, _omitFieldNames ? '' : 'image',
        subBuilder: ImageInputPart.create)
    ..aOM<AudioInputPart>(3, _omitFieldNames ? '' : 'audio',
        subBuilder: AudioInputPart.create)
    ..aOM<VideoInputPart>(4, _omitFieldNames ? '' : 'video',
        subBuilder: VideoInputPart.create)
    ..aOM<DocumentInputPart>(5, _omitFieldNames ? '' : 'document',
        subBuilder: DocumentInputPart.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InputContent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InputContent copyWith(void Function(InputContent) updates) =>
      super.copyWith((message) => updates(message as InputContent))
          as InputContent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InputContent create() => InputContent._();
  @$core.override
  InputContent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InputContent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InputContent>(create);
  static InputContent? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  InputContent_Part whichPart() => _InputContent_PartByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearPart() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  TextInputPart get text => $_getN(0);
  @$pb.TagNumber(1)
  set text(TextInputPart value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);
  @$pb.TagNumber(1)
  TextInputPart ensureText() => $_ensure(0);

  @$pb.TagNumber(2)
  ImageInputPart get image => $_getN(1);
  @$pb.TagNumber(2)
  set image(ImageInputPart value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasImage() => $_has(1);
  @$pb.TagNumber(2)
  void clearImage() => $_clearField(2);
  @$pb.TagNumber(2)
  ImageInputPart ensureImage() => $_ensure(1);

  @$pb.TagNumber(3)
  AudioInputPart get audio => $_getN(2);
  @$pb.TagNumber(3)
  set audio(AudioInputPart value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAudio() => $_has(2);
  @$pb.TagNumber(3)
  void clearAudio() => $_clearField(3);
  @$pb.TagNumber(3)
  AudioInputPart ensureAudio() => $_ensure(2);

  @$pb.TagNumber(4)
  VideoInputPart get video => $_getN(3);
  @$pb.TagNumber(4)
  set video(VideoInputPart value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasVideo() => $_has(3);
  @$pb.TagNumber(4)
  void clearVideo() => $_clearField(4);
  @$pb.TagNumber(4)
  VideoInputPart ensureVideo() => $_ensure(3);

  @$pb.TagNumber(5)
  DocumentInputPart get document => $_getN(4);
  @$pb.TagNumber(5)
  set document(DocumentInputPart value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDocument() => $_has(4);
  @$pb.TagNumber(5)
  void clearDocument() => $_clearField(5);
  @$pb.TagNumber(5)
  DocumentInputPart ensureDocument() => $_ensure(4);
}

/// The name and arguments of a tool call.
class ToolCall_Function extends $pb.GeneratedMessage {
  factory ToolCall_Function({
    $core.String? name,
    $core.String? arguments,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (arguments != null) result.arguments = arguments;
    return result;
  }

  ToolCall_Function._();

  factory ToolCall_Function.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToolCall_Function.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToolCall.Function',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'arguments')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolCall_Function clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolCall_Function copyWith(void Function(ToolCall_Function) updates) =>
      super.copyWith((message) => updates(message as ToolCall_Function))
          as ToolCall_Function;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToolCall_Function create() => ToolCall_Function._();
  @$core.override
  ToolCall_Function createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ToolCall_Function getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToolCall_Function>(create);
  static ToolCall_Function? _defaultInstance;

  /// Which tool is being called.
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  /// The arguments as a JSON string, not as parsed JSON. Kept as written
  /// because a model can emit arguments that are not valid JSON, and losing
  /// them at the protocol boundary would hide the fault from the consumer that
  /// has to handle it.
  @$pb.TagNumber(2)
  $core.String get arguments => $_getSZ(1);
  @$pb.TagNumber(2)
  set arguments($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasArguments() => $_has(1);
  @$pb.TagNumber(2)
  void clearArguments() => $_clearField(2);
}

/// A call an assistant message made. Carries no subagent attribution of its own
/// and inherits its containing message's, since several calls can share one
/// parent.
class ToolCall extends $pb.GeneratedMessage {
  factory ToolCall({
    $core.String? id,
    $core.String? type,
    ToolCall_Function? function,
    $0.Struct? metadata,
    $core.String? encryptedValue,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (type != null) result.type = type;
    if (function != null) result.function = function;
    if (metadata != null) result.metadata = metadata;
    if (encryptedValue != null) result.encryptedValue = encryptedValue;
    return result;
  }

  ToolCall._();

  factory ToolCall.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToolCall.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToolCall',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'type')
    ..aOM<ToolCall_Function>(3, _omitFieldNames ? '' : 'function',
        subBuilder: ToolCall_Function.create)
    ..aOM<$0.Struct>(4, _omitFieldNames ? '' : 'metadata',
        subBuilder: $0.Struct.create)
    ..aOS(5, _omitFieldNames ? '' : 'encryptedValue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolCall clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolCall copyWith(void Function(ToolCall) updates) =>
      super.copyWith((message) => updates(message as ToolCall)) as ToolCall;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToolCall create() => ToolCall._();
  @$core.override
  ToolCall createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ToolCall getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ToolCall>(create);
  static ToolCall? _defaultInstance;

  /// Identifies the call. The answering tool message carries this as its
  /// toolCallId.
  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// The only kind of call the protocol models.
  @$pb.TagNumber(2)
  $core.String get type => $_getSZ(1);
  @$pb.TagNumber(2)
  set type($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  /// What is being called, and with what.
  @$pb.TagNumber(3)
  ToolCall_Function get function => $_getN(2);
  @$pb.TagNumber(3)
  set function(ToolCall_Function value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFunction() => $_has(2);
  @$pb.TagNumber(3)
  void clearFunction() => $_clearField(3);
  @$pb.TagNumber(3)
  ToolCall_Function ensureFunction() => $_ensure(2);

  /// Extra information attached to this call. Carried here rather than folded
  /// into the containing message, because several calls can share one parent and
  /// merging them would make the result depend on their order.
  @$pb.TagNumber(4)
  $0.Struct get metadata => $_getN(3);
  @$pb.TagNumber(4)
  set metadata($0.Struct value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMetadata() => $_has(3);
  @$pb.TagNumber(4)
  void clearMetadata() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Struct ensureMetadata() => $_ensure(3);

  /// A provider's opaque artefact belonging to this call.
  @$pb.TagNumber(5)
  $core.String get encryptedValue => $_getSZ(4);
  @$pb.TagNumber(5)
  set encryptedValue($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEncryptedValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearEncryptedValue() => $_clearField(5);
}

/// Any message in a conversation. Discriminated by role.
class Message extends $pb.GeneratedMessage {
  factory Message({
    $core.String? id,
    $core.String? role,
    $core.String? content,
    $core.String? name,
    $core.Iterable<ToolCall>? toolCalls,
    $core.String? toolCallId,
    $core.String? error,
    $core.Iterable<InputContent>? contentParts,
    $0.Struct? metadata,
    $core.String? subagentRunId,
    $core.String? encryptedValue,
    $core.String? activityType,
    $0.Struct? activityContent,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (role != null) result.role = role;
    if (content != null) result.content = content;
    if (name != null) result.name = name;
    if (toolCalls != null) result.toolCalls.addAll(toolCalls);
    if (toolCallId != null) result.toolCallId = toolCallId;
    if (error != null) result.error = error;
    if (contentParts != null) result.contentParts.addAll(contentParts);
    if (metadata != null) result.metadata = metadata;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    if (encryptedValue != null) result.encryptedValue = encryptedValue;
    if (activityType != null) result.activityType = activityType;
    if (activityContent != null) result.activityContent = activityContent;
    return result;
  }

  Message._();

  factory Message.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Message.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Message',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'role')
    ..aOS(3, _omitFieldNames ? '' : 'content')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..pPM<ToolCall>(5, _omitFieldNames ? '' : 'toolCalls',
        subBuilder: ToolCall.create)
    ..aOS(6, _omitFieldNames ? '' : 'toolCallId')
    ..aOS(7, _omitFieldNames ? '' : 'error')
    ..pPM<InputContent>(8, _omitFieldNames ? '' : 'contentParts',
        subBuilder: InputContent.create)
    ..aOM<$0.Struct>(9, _omitFieldNames ? '' : 'metadata',
        subBuilder: $0.Struct.create)
    ..aOS(10, _omitFieldNames ? '' : 'subagentRunId')
    ..aOS(11, _omitFieldNames ? '' : 'encryptedValue')
    ..aOS(12, _omitFieldNames ? '' : 'activityType')
    ..aOM<$0.Struct>(13, _omitFieldNames ? '' : 'activityContent',
        subBuilder: $0.Struct.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Message clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Message copyWith(void Function(Message) updates) =>
      super.copyWith((message) => updates(message as Message)) as Message;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Message create() => Message._();
  @$core.override
  Message createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Message getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Message>(create);
  static Message? _defaultInstance;

  /// Identifies the message within the conversation.
  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// Who the message is from. Each message definition narrows this to a single
  /// value.
  @$pb.TagNumber(2)
  $core.String get role => $_getSZ(1);
  @$pb.TagNumber(2)
  set role($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRole() => $_clearField(2);

  /// The instructions. Required: a developer message with nothing in it says
  /// nothing.
  @$pb.TagNumber(3)
  $core.String get content => $_getSZ(2);
  @$pb.TagNumber(3)
  set content($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => $_clearField(3);

  /// An optional display name for the author.
  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  /// The tool calls this turn made.
  @$pb.TagNumber(5)
  $pb.PbList<ToolCall> get toolCalls => $_getList(4);

  /// The call this answers.
  @$pb.TagNumber(6)
  $core.String get toolCallId => $_getSZ(5);
  @$pb.TagNumber(6)
  set toolCallId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasToolCallId() => $_has(5);
  @$pb.TagNumber(6)
  void clearToolCallId() => $_clearField(6);

  /// Why the tool failed, when it did. Present alongside content rather than
  /// instead of it, so a partial result survives a failure.
  @$pb.TagNumber(7)
  $core.String get error => $_getSZ(6);
  @$pb.TagNumber(7)
  set error($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasError() => $_has(6);
  @$pb.TagNumber(7)
  void clearError() => $_clearField(7);

  /// What the person sent: either plain text, or an ordered list of parts for a
  /// multimodal message.
  @$pb.TagNumber(8)
  $pb.PbList<InputContent> get contentParts => $_getList(7);

  /// Extra information attached to this message.
  @$pb.TagNumber(9)
  $0.Struct get metadata => $_getN(8);
  @$pb.TagNumber(9)
  set metadata($0.Struct value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasMetadata() => $_has(8);
  @$pb.TagNumber(9)
  void clearMetadata() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Struct ensureMetadata() => $_ensure(8);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(10)
  $core.String get subagentRunId => $_getSZ(9);
  @$pb.TagNumber(10)
  set subagentRunId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSubagentRunId() => $_has(9);
  @$pb.TagNumber(10)
  void clearSubagentRunId() => $_clearField(10);

  /// A provider's opaque artefact belonging to this message, stored by a consumer
  /// and returned on a later turn.
  @$pb.TagNumber(11)
  $core.String get encryptedValue => $_getSZ(10);
  @$pb.TagNumber(11)
  set encryptedValue($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasEncryptedValue() => $_has(10);
  @$pb.TagNumber(11)
  void clearEncryptedValue() => $_clearField(11);

  /// What kind of activity this is. An open string: the set is the producer's.
  @$pb.TagNumber(12)
  $core.String get activityType => $_getSZ(11);
  @$pb.TagNumber(12)
  set activityType($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasActivityType() => $_has(11);
  @$pb.TagNumber(12)
  void clearActivityType() => $_clearField(12);

  /// The activity's payload, open by key.
  @$pb.TagNumber(13)
  $0.Struct get activityContent => $_getN(12);
  @$pb.TagNumber(13)
  set activityContent($0.Struct value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasActivityContent() => $_has(12);
  @$pb.TagNumber(13)
  void clearActivityContent() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Struct ensureActivityContent() => $_ensure(12);
}

/// A tool the agent may call.
class Tool extends $pb.GeneratedMessage {
  factory Tool({
    $core.String? name,
    $core.String? description,
    $0.Value? parameters,
    $0.Struct? metadata,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (parameters != null) result.parameters = parameters;
    if (metadata != null) result.metadata = metadata;
    return result;
  }

  Tool._();

  factory Tool.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Tool.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Tool',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aOM<$0.Value>(3, _omitFieldNames ? '' : 'parameters',
        subBuilder: $0.Value.create)
    ..aOM<$0.Struct>(4, _omitFieldNames ? '' : 'metadata',
        subBuilder: $0.Struct.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tool clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tool copyWith(void Function(Tool) updates) =>
      super.copyWith((message) => updates(message as Tool)) as Tool;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Tool create() => Tool._();
  @$core.override
  Tool createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Tool getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Tool>(create);
  static Tool? _defaultInstance;

  /// The tool's name, as the agent will call it.
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  /// What the tool does, for the agent to decide when to use it.
  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  /// A JSON Schema describing the tool's arguments. Carried opaquely: the
  /// protocol does not constrain or validate it. Optional, because all three SDKs
  /// already treat it that way and a tool that takes no arguments has nothing to
  /// declare; an absent schema and an empty one mean the same thing to an agent.
  @$pb.TagNumber(3)
  $0.Value get parameters => $_getN(2);
  @$pb.TagNumber(3)
  set parameters($0.Value value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasParameters() => $_has(2);
  @$pb.TagNumber(3)
  void clearParameters() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Value ensureParameters() => $_ensure(2);

  /// Extra information about the tool, for consumers that attach their own
  /// rendering or routing information to it.
  @$pb.TagNumber(4)
  $0.Struct get metadata => $_getN(3);
  @$pb.TagNumber(4)
  set metadata($0.Struct value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMetadata() => $_has(3);
  @$pb.TagNumber(4)
  void clearMetadata() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Struct ensureMetadata() => $_ensure(3);
}

/// A named piece of ambient information given to the agent for the run, distinct
/// from the conversation.
class Context extends $pb.GeneratedMessage {
  factory Context({
    $core.String? description,
    $core.String? value,
  }) {
    final result = create();
    if (description != null) result.description = description;
    if (value != null) result.value = value;
    return result;
  }

  Context._();

  factory Context.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Context.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Context',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'description')
    ..aOS(2, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Context clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Context copyWith(void Function(Context) updates) =>
      super.copyWith((message) => updates(message as Context)) as Context;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Context create() => Context._();
  @$core.override
  Context createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Context getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Context>(create);
  static Context? _defaultInstance;

  /// What this context is, for the agent to interpret.
  @$pb.TagNumber(1)
  $core.String get description => $_getSZ(0);
  @$pb.TagNumber(1)
  set description($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDescription() => $_has(0);
  @$pb.TagNumber(1)
  void clearDescription() => $_clearField(1);

  /// The context itself.
  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
}

/// An answer to one interrupt, sent on the run that continues from it.
class ResumeEntry extends $pb.GeneratedMessage {
  factory ResumeEntry({
    $core.String? interruptId,
    $core.String? status,
    $0.Value? payload,
    $0.Struct? metadata,
  }) {
    final result = create();
    if (interruptId != null) result.interruptId = interruptId;
    if (status != null) result.status = status;
    if (payload != null) result.payload = payload;
    if (metadata != null) result.metadata = metadata;
    return result;
  }

  ResumeEntry._();

  factory ResumeEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResumeEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResumeEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'interruptId')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aOM<$0.Value>(3, _omitFieldNames ? '' : 'payload',
        subBuilder: $0.Value.create)
    ..aOM<$0.Struct>(4, _omitFieldNames ? '' : 'metadata',
        subBuilder: $0.Struct.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeEntry copyWith(void Function(ResumeEntry) updates) =>
      super.copyWith((message) => updates(message as ResumeEntry))
          as ResumeEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResumeEntry create() => ResumeEntry._();
  @$core.override
  ResumeEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResumeEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResumeEntry>(create);
  static ResumeEntry? _defaultInstance;

  /// The interrupt being answered.
  @$pb.TagNumber(1)
  $core.String get interruptId => $_getSZ(0);
  @$pb.TagNumber(1)
  set interruptId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInterruptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInterruptId() => $_clearField(1);

  /// Whether the interrupt was answered or abandoned.
  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  /// The answer the agent asked for and will act on. Any JSON value.
  @$pb.TagNumber(3)
  $0.Value get payload => $_getN(2);
  @$pb.TagNumber(3)
  set payload($0.Value value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPayload() => $_has(2);
  @$pb.TagNumber(3)
  void clearPayload() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Value ensurePayload() => $_ensure(2);

  /// Envelope information about the response, such as signatures or routing keys,
  /// as opposed to payload, which is the answer itself.
  @$pb.TagNumber(4)
  $0.Struct get metadata => $_getN(3);
  @$pb.TagNumber(4)
  set metadata($0.Struct value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMetadata() => $_has(3);
  @$pb.TagNumber(4)
  void clearMetadata() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Struct ensureMetadata() => $_ensure(3);
}

/// A request to run an agent. Also echoed back as RUN_STARTED.input. Only
/// threadId, runId and messages are required: those are the three the SDKs
/// already agree on, and for tools and context an absent key and an empty array
/// mean the same thing, so requiring them would catch nothing a producer could
/// get wrong.
class RunAgentInput extends $pb.GeneratedMessage {
  factory RunAgentInput({
    $core.String? threadId,
    $core.String? runId,
    $core.String? parentRunId,
    $0.Value? state,
    $core.Iterable<Message>? messages,
    $core.Iterable<Tool>? tools,
    $core.Iterable<Context>? context,
    $0.Value? forwardedProps,
    $core.Iterable<ResumeEntry>? resume,
    $core.String? protocolVersion,
  }) {
    final result = create();
    if (threadId != null) result.threadId = threadId;
    if (runId != null) result.runId = runId;
    if (parentRunId != null) result.parentRunId = parentRunId;
    if (state != null) result.state = state;
    if (messages != null) result.messages.addAll(messages);
    if (tools != null) result.tools.addAll(tools);
    if (context != null) result.context.addAll(context);
    if (forwardedProps != null) result.forwardedProps = forwardedProps;
    if (resume != null) result.resume.addAll(resume);
    if (protocolVersion != null) result.protocolVersion = protocolVersion;
    return result;
  }

  RunAgentInput._();

  factory RunAgentInput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RunAgentInput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RunAgentInput',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'threadId')
    ..aOS(2, _omitFieldNames ? '' : 'runId')
    ..aOS(3, _omitFieldNames ? '' : 'parentRunId')
    ..aOM<$0.Value>(4, _omitFieldNames ? '' : 'state',
        subBuilder: $0.Value.create)
    ..pPM<Message>(5, _omitFieldNames ? '' : 'messages',
        subBuilder: Message.create)
    ..pPM<Tool>(6, _omitFieldNames ? '' : 'tools', subBuilder: Tool.create)
    ..pPM<Context>(7, _omitFieldNames ? '' : 'context',
        subBuilder: Context.create)
    ..aOM<$0.Value>(8, _omitFieldNames ? '' : 'forwardedProps',
        subBuilder: $0.Value.create)
    ..pPM<ResumeEntry>(9, _omitFieldNames ? '' : 'resume',
        subBuilder: ResumeEntry.create)
    ..aOS(10, _omitFieldNames ? '' : 'protocolVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunAgentInput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunAgentInput copyWith(void Function(RunAgentInput) updates) =>
      super.copyWith((message) => updates(message as RunAgentInput))
          as RunAgentInput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RunAgentInput create() => RunAgentInput._();
  @$core.override
  RunAgentInput createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RunAgentInput getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RunAgentInput>(create);
  static RunAgentInput? _defaultInstance;

  /// The conversation this run belongs to.
  @$pb.TagNumber(1)
  $core.String get threadId => $_getSZ(0);
  @$pb.TagNumber(1)
  set threadId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasThreadId() => $_has(0);
  @$pb.TagNumber(1)
  void clearThreadId() => $_clearField(1);

  /// Identifies this run.
  @$pb.TagNumber(2)
  $core.String get runId => $_getSZ(1);
  @$pb.TagNumber(2)
  set runId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRunId() => $_clearField(2);

  /// The run that spawned this one.
  @$pb.TagNumber(3)
  $core.String get parentRunId => $_getSZ(2);
  @$pb.TagNumber(3)
  set parentRunId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasParentRunId() => $_has(2);
  @$pb.TagNumber(3)
  void clearParentRunId() => $_clearField(3);

  /// The state the run starts from.
  @$pb.TagNumber(4)
  $0.Value get state => $_getN(3);
  @$pb.TagNumber(4)
  set state($0.Value value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasState() => $_has(3);
  @$pb.TagNumber(4)
  void clearState() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Value ensureState() => $_ensure(3);

  /// The conversation so far, in order.
  @$pb.TagNumber(5)
  $pb.PbList<Message> get messages => $_getList(4);

  /// The tools the agent may call. Absent means none.
  @$pb.TagNumber(6)
  $pb.PbList<Tool> get tools => $_getList(5);

  /// Ambient information for the run. Absent means none.
  @$pb.TagNumber(7)
  $pb.PbList<Context> get context => $_getList(6);

  /// Application-specific values passed through to the agent untouched. Any JSON
  /// value.
  @$pb.TagNumber(8)
  $0.Value get forwardedProps => $_getN(7);
  @$pb.TagNumber(8)
  set forwardedProps($0.Value value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasForwardedProps() => $_has(7);
  @$pb.TagNumber(8)
  void clearForwardedProps() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Value ensureForwardedProps() => $_ensure(7);

  /// Answers to the interrupts that ended a previous run, when this run continues
  /// from one.
  @$pb.TagNumber(9)
  $pb.PbList<ResumeEntry> get resume => $_getList(8);

  /// The protocol version this consumer speaks, such as "1.0". Absent means the
  /// input was produced before the protocol carried a version — the versioning
  /// rules in the prose govern what each side does with that. Sent in-band rather
  /// than by the transport, so a recorded exchange stays self-describing.
  @$pb.TagNumber(10)
  $core.String get protocolVersion => $_getSZ(9);
  @$pb.TagNumber(10)
  set protocolVersion($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasProtocolVersion() => $_has(9);
  @$pb.TagNumber(10)
  void clearProtocolVersion() => $_clearField(10);
}

/// Something a run needs from outside before it can continue, such as an approval
/// or a missing value.
class Interrupt extends $pb.GeneratedMessage {
  factory Interrupt({
    $core.String? id,
    $core.String? reason,
    $core.String? message,
    $core.String? toolCallId,
    $0.Value? responseSchema,
    $core.String? expiresAt,
    $0.Value? metadata,
    $core.String? subagentRunId,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (reason != null) result.reason = reason;
    if (message != null) result.message = message;
    if (toolCallId != null) result.toolCallId = toolCallId;
    if (responseSchema != null) result.responseSchema = responseSchema;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (metadata != null) result.metadata = metadata;
    if (subagentRunId != null) result.subagentRunId = subagentRunId;
    return result;
  }

  Interrupt._();

  factory Interrupt.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Interrupt.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Interrupt',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..aOS(4, _omitFieldNames ? '' : 'toolCallId')
    ..aOM<$0.Value>(5, _omitFieldNames ? '' : 'responseSchema',
        subBuilder: $0.Value.create)
    ..aOS(6, _omitFieldNames ? '' : 'expiresAt')
    ..aOM<$0.Value>(7, _omitFieldNames ? '' : 'metadata',
        subBuilder: $0.Value.create)
    ..aOS(8, _omitFieldNames ? '' : 'subagentRunId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Interrupt clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Interrupt copyWith(void Function(Interrupt) updates) =>
      super.copyWith((message) => updates(message as Interrupt)) as Interrupt;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Interrupt create() => Interrupt._();
  @$core.override
  Interrupt createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Interrupt getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Interrupt>(create);
  static Interrupt? _defaultInstance;

  /// Identifies the interrupt. A resume entry answers it by this id.
  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// Why the run stopped. An open string rather than an enumeration: the protocol
  /// does not attempt to classify every reason an agent might need input.
  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  /// A human-readable prompt for whoever answers.
  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);

  /// The tool call this interrupt concerns, when it is a tool approval.
  @$pb.TagNumber(4)
  $core.String get toolCallId => $_getSZ(3);
  @$pb.TagNumber(4)
  set toolCallId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasToolCallId() => $_has(3);
  @$pb.TagNumber(4)
  void clearToolCallId() => $_clearField(4);

  /// A JSON Schema describing the answer this interrupt expects, so a consumer
  /// can build a form for it. Carried opaquely: the protocol does not constrain
  /// or validate it. Restricted to an object because TypeScript and Python both
  /// declare it that way; .NET holds it as any JSON, and the ticket that
  /// commissioned this schema lists it among the arbitrary-JSON fields. Following
  /// the two that constrain it keeps the schema from accepting documents the
  /// reference client rejects, at the cost of rejecting the boolean schemas JSON
  /// Schema also permits — a bare true for "any answer". Recorded as a known
  /// divergence rather than settled.
  @$pb.TagNumber(5)
  $0.Value get responseSchema => $_getN(4);
  @$pb.TagNumber(5)
  set responseSchema($0.Value value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasResponseSchema() => $_has(4);
  @$pb.TagNumber(5)
  void clearResponseSchema() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Value ensureResponseSchema() => $_ensure(4);

  /// When the interrupt stops being answerable. Deliberately unconstrained rather
  /// than a date-time format, because producers already disagree about the
  /// representation and tightening it here would reject streams that work today.
  /// The documented convention is ISO 8601, and a consumer comparing this value
  /// will parse it as a date, so a value that is not one leaves the interrupt
  /// looking permanently unexpired.
  @$pb.TagNumber(6)
  $core.String get expiresAt => $_getSZ(5);
  @$pb.TagNumber(6)
  set expiresAt($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExpiresAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpiresAt() => $_clearField(6);

  /// Extra information attached to this interrupt.
  @$pb.TagNumber(7)
  $0.Value get metadata => $_getN(6);
  @$pb.TagNumber(7)
  set metadata($0.Value value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasMetadata() => $_has(6);
  @$pb.TagNumber(7)
  void clearMetadata() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Value ensureMetadata() => $_ensure(6);

  /// The subagent invocation this belongs to. Absent means the parent agent
  /// produced it directly.
  @$pb.TagNumber(8)
  $core.String get subagentRunId => $_getSZ(7);
  @$pb.TagNumber(8)
  set subagentRunId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSubagentRunId() => $_has(7);
  @$pb.TagNumber(8)
  void clearSubagentRunId() => $_clearField(8);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
