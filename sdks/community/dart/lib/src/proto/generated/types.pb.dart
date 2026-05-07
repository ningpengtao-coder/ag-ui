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

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get arguments => $_getSZ(1);
  @$pb.TagNumber(2)
  set arguments($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasArguments() => $_has(1);
  @$pb.TagNumber(2)
  void clearArguments() => $_clearField(2);
}

class ToolCall extends $pb.GeneratedMessage {
  factory ToolCall({
    $core.String? id,
    $core.String? type,
    ToolCall_Function? function,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (type != null) result.type = type;
    if (function != null) result.function = function;
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

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get type => $_getSZ(1);
  @$pb.TagNumber(2)
  set type($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

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
}

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

  @$pb.TagNumber(1)
  $core.String get value => $_getSZ(0);
  @$pb.TagNumber(1)
  set value($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mimeType => $_getSZ(1);
  @$pb.TagNumber(2)
  set mimeType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMimeType() => $_has(1);
  @$pb.TagNumber(2)
  void clearMimeType() => $_clearField(2);
}

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

  @$pb.TagNumber(1)
  $core.String get value => $_getSZ(0);
  @$pb.TagNumber(1)
  set value($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mimeType => $_getSZ(1);
  @$pb.TagNumber(2)
  set mimeType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMimeType() => $_has(1);
  @$pb.TagNumber(2)
  void clearMimeType() => $_clearField(2);
}

enum InputContentSource_Source { data, url, notSet }

class InputContentSource extends $pb.GeneratedMessage {
  factory InputContentSource({
    InputContentDataSource? data,
    InputContentUrlSource? url,
  }) {
    final result = create();
    if (data != null) result.data = data;
    if (url != null) result.url = url;
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
    0: InputContentSource_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InputContentSource',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ag_ui'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<InputContentDataSource>(1, _omitFieldNames ? '' : 'data',
        subBuilder: InputContentDataSource.create)
    ..aOM<InputContentUrlSource>(2, _omitFieldNames ? '' : 'url',
        subBuilder: InputContentUrlSource.create)
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
  InputContentSource_Source whichSource() =>
      _InputContentSource_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
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
}

class TextInputPart extends $pb.GeneratedMessage {
  factory TextInputPart({
    $core.String? text,
  }) {
    final result = create();
    if (text != null) result.text = text;
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

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);
}

class ImageInputPart extends $pb.GeneratedMessage {
  factory ImageInputPart({
    InputContentSource? source,
    $0.Value? metadata,
  }) {
    final result = create();
    if (source != null) result.source = source;
    if (metadata != null) result.metadata = metadata;
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
}

class AudioInputPart extends $pb.GeneratedMessage {
  factory AudioInputPart({
    InputContentSource? source,
    $0.Value? metadata,
  }) {
    final result = create();
    if (source != null) result.source = source;
    if (metadata != null) result.metadata = metadata;
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
}

class VideoInputPart extends $pb.GeneratedMessage {
  factory VideoInputPart({
    InputContentSource? source,
    $0.Value? metadata,
  }) {
    final result = create();
    if (source != null) result.source = source;
    if (metadata != null) result.metadata = metadata;
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
}

class DocumentInputPart extends $pb.GeneratedMessage {
  factory DocumentInputPart({
    InputContentSource? source,
    $0.Value? metadata,
  }) {
    final result = create();
    if (source != null) result.source = source;
    if (metadata != null) result.metadata = metadata;
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
}

enum InputContent_Part { text, image, audio, video, document, notSet }

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

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get role => $_getSZ(1);
  @$pb.TagNumber(2)
  set role($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRole() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get content => $_getSZ(2);
  @$pb.TagNumber(3)
  set content($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<ToolCall> get toolCalls => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get toolCallId => $_getSZ(5);
  @$pb.TagNumber(6)
  set toolCallId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasToolCallId() => $_has(5);
  @$pb.TagNumber(6)
  void clearToolCallId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get error => $_getSZ(6);
  @$pb.TagNumber(7)
  set error($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasError() => $_has(6);
  @$pb.TagNumber(7)
  void clearError() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<InputContent> get contentParts => $_getList(7);
}

class Interrupt extends $pb.GeneratedMessage {
  factory Interrupt({
    $core.String? id,
    $core.String? reason,
    $core.String? message,
    $core.String? toolCallId,
    $0.Value? responseSchema,
    $core.String? expiresAt,
    $0.Value? metadata,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (reason != null) result.reason = reason;
    if (message != null) result.message = message;
    if (toolCallId != null) result.toolCallId = toolCallId;
    if (responseSchema != null) result.responseSchema = responseSchema;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (metadata != null) result.metadata = metadata;
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

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get toolCallId => $_getSZ(3);
  @$pb.TagNumber(4)
  set toolCallId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasToolCallId() => $_has(3);
  @$pb.TagNumber(4)
  void clearToolCallId() => $_clearField(4);

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

  @$pb.TagNumber(6)
  $core.String get expiresAt => $_getSZ(5);
  @$pb.TagNumber(6)
  set expiresAt($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExpiresAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpiresAt() => $_clearField(6);

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
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
