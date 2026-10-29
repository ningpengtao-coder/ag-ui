/// Protocol diagnostics.
///
/// The 1.0 compatibility boundary warns about everything it strips or
/// translates, because a consumer that silently drops material gives an
/// application no way to notice. Dart has no `console.warn`, so the SDK routes
/// those warnings through this collector: the default handler writes them to
/// the zone's `print`, and tests (or applications that want structured
/// logging) install their own.
library;

typedef AgUiWarningHandler = void Function(String message);

class AgUiDiagnostics {
  AgUiDiagnostics._();

  /// Receives every warning the compatibility boundary emits.
  ///
  /// `null` restores the default handler.
  static AgUiWarningHandler? handler;

  /// When true, warnings are collected but never written to the default sink.
  static bool suppress = false;

  static void warn(String message) {
    final installed = handler;
    if (installed != null) {
      installed(message);
      return;
    }
    if (!suppress) {
      // ignore: avoid_print
      print('[ag-ui] $message');
    }
  }

  /// Runs [body] with [collector] installed, restoring the previous handler
  /// afterwards. Returns the warnings raised while it ran.
  static Future<List<String>> capture(Future<void> Function() body) async {
    final warnings = <String>[];
    final previous = handler;
    handler = warnings.add;
    try {
      await body();
    } finally {
      handler = previous;
    }
    return warnings;
  }
}
