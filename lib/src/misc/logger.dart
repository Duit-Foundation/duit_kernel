import 'package:flutter/foundation.dart' show kDebugMode;

/// The [Logger] interface defines a contract for logger implementations.
///
/// The methods in [Logger] are used to log messages to the console.
abstract interface class Logger {
  void info(String message);
  void warn(String message);
  void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
  });
}

/// The [DefaultLogger] class provides a default logger implementation for the DUIT library.
///
/// It logs messages to the console if the app is running in debug mode.
final class DefaultLogger implements Logger {
  /// The [DefaultLogger] singleton instance.
  static final instance = DefaultLogger._internal();

  /// The internal constructor for the singleton instance.
  DefaultLogger._internal();

  @override
  void error(String message, {error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      print("\x1B[32m[DUIT FRAMEWORK]: "
          "\x1B[31m$message, Err: $error, StackTrace: ${stackTrace.toString()}\t\t");
    }
  }

  @override
  void info(String message) {
    if (kDebugMode) {
      print("\x1B[32m[DUIT FRAMEWORK]: " "\x1B[37m$message\t\t");
    }
  }

  @override
  void warn(String message) {
    if (kDebugMode) {
      print("\x1B[32m[DUIT FRAMEWORK]: " "\x1B[33m$message\t\t");
    }
  }
}
