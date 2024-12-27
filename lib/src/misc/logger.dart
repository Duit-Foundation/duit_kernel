// import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:logger/logger.dart';

/// The [DebugLogger] interface defines a contract for logger implementations.
///
/// The methods in [DebugLogger] are used to log messages to the console.
abstract interface class DebugLogger {
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
final class DefaultLogger implements DebugLogger {
  late final Logger _logger = Logger();

  /// The [DefaultLogger] singleton instance.
  static final instance = DefaultLogger._internal();

  /// The internal constructor for the singleton instance.
  DefaultLogger._internal();

  @override
  void error(
    String message, {
    error,
    StackTrace? stackTrace,
  }) =>
      _logger.e(
        "[DUIT FRAMEWORK]: $message",
        time: DateTime.now(),
        error: error,
        stackTrace: stackTrace,
      );

  @override
  void info(String message) => _logger.i(
        "[DUIT FRAMEWORK]: $message",
        time: DateTime.now(),
      );

  @override
  void warn(String message) => _logger.w(
        "[DUIT FRAMEWORK]: $message",
        time: DateTime.now(),
      );
}
