/// Regenerates the Dart protobuf bindings from the upstream `.proto` sources.
///
/// The wire schema is authored once, in the TypeScript package
/// (`sdks/typescript/packages/proto/src/proto`), which is itself generated from
/// `spec/1.0/schema.json`. Everything under `lib/src/proto/generated` is a
/// projection of it and is never hand-edited, so syncing the repository is
/// followed by:
///
/// ```sh
/// dart run tool/generate_proto.dart
/// ```
///
/// Requirements:
/// - `protoc`, 3.15 or newer (the schema uses proto3 `optional` fields).
/// - The Dart plugin from `dart pub global activate protoc_plugin`.
///
/// Both are located automatically; override the search with `--protoc=`,
/// `--protoc-gen-dart=` or `--include=` (or the `PROTOC` / `PROTOC_GEN_DART`
/// environment variables). The output depends on the versions of both, so both
/// are printed: an unexplained diff is usually one of them changing.
library;

import 'dart:io';

const String _usage = '''
Regenerates lib/src/proto/generated from the upstream .proto sources.

Usage: dart run tool/generate_proto.dart [options]

Options:
  --protoc=<path>           protoc executable (default: PROTOC, then PATH)
  --protoc-gen-dart=<path>  Dart plugin (default: PROTOC_GEN_DART, then the pub
                            cache, then PATH)
  --include=<dir>           Directory holding google/protobuf/*.proto
                            (default: derived from the protoc location)
  -h, --help                Show this message''';

void main(List<String> arguments) {
  if (arguments.contains('--help') || arguments.contains('-h')) {
    stdout.writeln(_usage);
    return;
  }

  final overrides = _parseArguments(arguments);
  final repoRoot = _findRepoRoot();
  final protoDir = Directory(
    '${repoRoot.path}/sdks/typescript/packages/proto/src/proto',
  );
  final outputDir = Directory(
    '${repoRoot.path}/sdks/community/dart/lib/src/proto/generated',
  );
  if (!protoDir.existsSync()) {
    _fail('The upstream .proto sources are missing: ${protoDir.path}');
  }

  final protos = _protoFileNames(protoDir);
  if (protos.isEmpty) {
    _fail('No .proto files found in ${protoDir.path}');
  }

  final protoc = _findProtoc(overrides['protoc']);
  final plugin = _findPlugin(overrides['protoc-gen-dart']);
  final include = overrides['include'] ?? _findWellKnownTypes(protoc);

  stdout
    ..writeln('protoc:  $protoc (${_versionOf(protoc)})')
    ..writeln('plugin:  $plugin')
    ..writeln('include: $include');

  // Generate into a scratch directory and only then replace the bindings, so a
  // failed run leaves the committed ones untouched and a renamed .proto cannot
  // leave its old output behind.
  final scratch = Directory.systemTemp.createTempSync('ag_ui_proto_');
  try {
    final result = Process.runSync(
      protoc,
      <String>[
        '-I',
        protoDir.path,
        '-I',
        include,
        '--plugin=protoc-gen-dart=$plugin',
        '--dart_out=${scratch.path}',
        ...protos,
      ],
      workingDirectory: protoDir.path,
    );
    if (result.exitCode != 0) {
      _fail('protoc failed (exit ${result.exitCode}):\n${result.stderr}'
          '${result.stdout}');
    }

    final generated = scratch
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .toList()
      ..sort((left, right) => left.path.compareTo(right.path));
    if (generated.isEmpty) {
      _fail('protoc produced no Dart files; check the --dart_out plugin.');
    }

    outputDir.createSync(recursive: true);
    for (final stale in outputDir.listSync().whereType<File>()) {
      if (stale.path.endsWith('.dart')) {
        stale.deleteSync();
      }
    }
    for (final file in generated) {
      final name = _basename(file.path);
      file.copySync('${outputDir.path}/$name');
      stdout.writeln('  $name (${file.lengthSync()} bytes)');
    }

    stdout.writeln(
      'Generated ${generated.length} files from ${protos.length} .proto '
      'sources into ${_relative(repoRoot, outputDir.path)}.',
    );
  } finally {
    scratch.deleteSync(recursive: true);
  }
}

Map<String, String> _parseArguments(List<String> arguments) {
  final overrides = <String, String>{};
  final pattern = RegExp(r'^--([a-z-]+)=(.+)$');
  for (final argument in arguments) {
    final match = pattern.firstMatch(argument);
    if (match == null) {
      _fail('Unrecognised argument: $argument\n\n$_usage');
    }
    overrides[match.group(1)!] = match.group(2)!;
  }
  return overrides;
}

/// The repository root, found by walking up from this script to the checkout.
Directory _findRepoRoot() {
  var directory = File.fromUri(Platform.script).parent;
  while (true) {
    if (Directory('${directory.path}/.git').existsSync()) {
      return directory;
    }
    final parent = directory.parent;
    if (parent.path == directory.path) {
      _fail('Could not find the repository root above ${Platform.script}.');
    }
    directory = parent;
  }
}

List<String> _protoFileNames(Directory directory) {
  final names = <String>[];
  for (final entity in directory.listSync()) {
    if (entity is File && entity.path.endsWith('.proto')) {
      names.add(_basename(entity.path));
    }
  }
  names.sort();
  return names;
}

String _findProtoc(String? override) {
  if (override != null) {
    return override;
  }
  final fromEnvironment = Platform.environment['PROTOC'];
  if (fromEnvironment != null && fromEnvironment.isNotEmpty) {
    return fromEnvironment;
  }
  final onPath = _which('protoc');
  if (onPath != null) {
    return onPath;
  }
  _fail('protoc not found. Install it (3.15 or newer) or pass --protoc=<path>.');
}

String _findPlugin(String? override) {
  if (override != null) {
    return override;
  }
  final fromEnvironment = Platform.environment['PROTOC_GEN_DART'];
  if (fromEnvironment != null && fromEnvironment.isNotEmpty) {
    return fromEnvironment;
  }
  final executable =
      Platform.isWindows ? 'protoc-gen-dart.bat' : 'protoc-gen-dart';
  final cached = File('${_pubCache()}/bin/$executable');
  if (cached.existsSync()) {
    return cached.path;
  }
  final onPath = _which('protoc-gen-dart');
  if (onPath != null) {
    return onPath;
  }
  _fail('protoc-gen-dart not found. Run: dart pub global activate protoc_plugin');
}

String _pubCache() {
  final fromEnvironment = Platform.environment['PUB_CACHE'];
  if (fromEnvironment != null && fromEnvironment.isNotEmpty) {
    return fromEnvironment;
  }
  if (Platform.isWindows) {
    final localAppData = Platform.environment['LOCALAPPDATA'];
    if (localAppData != null) {
      return '$localAppData/Pub/Cache';
    }
  }
  return '${Platform.environment['HOME']}/.pub-cache';
}

/// The directory holding `google/protobuf/*.proto`, which `events.proto`
/// imports for `Struct` and `Value`.
String _findWellKnownTypes(String protoc) {
  final binDir = File(protoc).parent.path;
  for (final candidate in <String>[
    '$binDir/include',
    '$binDir/../include',
    binDir,
  ]) {
    if (File('$candidate/google/protobuf/struct.proto').existsSync()) {
      return candidate;
    }
  }
  _fail(
    'Could not find google/protobuf/struct.proto next to $protoc. '
    'Pass --include=<dir>.',
  );
}

String _versionOf(String executable) {
  final result = Process.runSync(
    executable,
    <String>['--version'],
  );
  if (result.exitCode != 0) {
    return 'unknown';
  }
  return (result.stdout as String).trim();
}

String? _which(String name) {
  final result = Process.runSync(
    Platform.isWindows ? 'where' : 'which',
    <String>[name],
    runInShell: true,
  );
  if (result.exitCode != 0) {
    return null;
  }
  for (final line in (result.stdout as String).split(RegExp(r'\r?\n'))) {
    final trimmed = line.trim();
    if (trimmed.isNotEmpty) {
      return trimmed;
    }
  }
  return null;
}

String _basename(String path) => path.split(RegExp(r'[/\\]')).last;

String _relative(Directory root, String path) =>
    path.startsWith('${root.path}/')
        ? path.substring(root.path.length + 1)
        : path;

Never _fail(String message) {
  stderr.writeln(message);
  exit(1);
}
