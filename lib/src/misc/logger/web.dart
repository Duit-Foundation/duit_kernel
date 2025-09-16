import "dart:js_interop";

import "package:duit_kernel/duit_kernel.dart";
import "package:web/web.dart";

/// The [DefaultLogger] class provides a default WASM compatible logger implementation for the DUIT library.
///
/// It logs messages to the console if the app is running in debug mode.
final class DefaultLogger implements DebugLogger {
  /// The [DefaultLogger] singleton instance.
  static final instance = DefaultLogger._internal();

  /// The internal constructor for the singleton instance.
  DefaultLogger._internal();

  @override
  void error(
    String message, {
    error,
    StackTrace? stackTrace,
  }) {
    final m =
        "${DebugLogger.logTag}$message\n Error text: ${error.toString()} \n StackTrace: ${stackTrace.toString()}";
    console.error(m.toJS);
  }

  @override
  void info(String message) {
    final m = "${DebugLogger.logTag}$message";
    console.log(m.toJS);
  }

  @override
  void warn(String message) {
    final m = "${DebugLogger.logTag}$message";
    console.warn(m.toJS);
  }
}
