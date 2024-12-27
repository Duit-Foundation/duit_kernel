import 'dart:developer';

import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, debugPrint, defaultTargetPlatform, kDebugMode;

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

final _errorPen = AnsiPen()..red();
final _warnPen = AnsiPen()..yellow();
final _infoPen = AnsiPen()..white();
final _headingPen = AnsiPen()..green();

/// The [DefaultLogger] class provides a default logger implementation for the DUIT library.
///
/// It logs messages to the console if the app is running in debug mode.
final class DefaultLogger implements Logger {
  /// The [DefaultLogger] singleton instance.
  static final instance = DefaultLogger._internal();

  /// The internal constructor for the singleton instance.
  DefaultLogger._internal();

  String _fmt(String msg, AnsiPen pen) {
    var lines = msg.split('\n');
    lines = lines.map((e) => pen.write(e)).toList();
    return lines.join('\n');
  }

  // ignore: avoid_print
  void _out(String v) {
    if ([TargetPlatform.iOS, TargetPlatform.macOS]
        .contains(defaultTargetPlatform)) {
      log(v);
      return;
    }
    debugPrint(v);
  }

  @override
  void error(String message, {error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      final errorMessage =
          '$message \nError: ${error?.toString()}\nStackTrace => \n${stackTrace?.toString()}';

      final m =
          "${_fmt("[DUIT FRAMEWORK]: ", _headingPen)}${_fmt(errorMessage, _errorPen)}";
      _out(m);
    }
  }

  @override
  void info(String message) {
    if (kDebugMode) {
      final m =
          "${_fmt("[DUIT FRAMEWORK]: ", _headingPen)}${_fmt(message, _infoPen)}";
      _out(m);
    }
  }

  @override
  void warn(String message) {
    if (kDebugMode) {
      final m =
          "${_fmt("[DUIT FRAMEWORK]: ", _headingPen)}${_fmt(message, _warnPen)}";
      _out(m);
    }
  }
}
