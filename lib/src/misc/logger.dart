// import 'package:flutter/foundation.dart' show kDebugMode;
import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/foundation.dart' show kDebugMode, defaultTargetPlatform;

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
  final _errorPen = AnsiPen()..red();
  final _warnPen = AnsiPen()..yellow();
  final _infoPen = AnsiPen()..white();
  final _headingPen = AnsiPen()..green();
  String? _tag;
  static const logTag = "[DUIT FRAMEWORK]: ";

  /// The [DefaultLogger] singleton instance.
  static final instance = DefaultLogger._internal();

  /// The internal constructor for the singleton instance.
  DefaultLogger._internal();

  String _colorize(String m, AnsiPen c) {
    var lines = m.split('\n');
    lines = lines.map((e) => c.write(e)).toList();
    final coloredMsg = lines.join('\n');
    return coloredMsg;
  }

  //ignore: avoid_print
  void _outPrinter(String m) => m.split("\n").forEach(print);

  String _createTag() => _colorize(logTag, _headingPen);

  static final _isApple =
      [Platform.isIOS || Platform.isMacOS].contains(defaultTargetPlatform);

  @override
  void error(
    String message, {
    error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      if (_isApple) {
        _outPrinter(
            "$logTag$message\nError text: ${error.toString()}\nStackTrace: ${stackTrace.toString()}");
      } else {
        _tag ??= _createTag();
        final text =
            "$message\n Error text: ${error.toString()} \n StackTrace: ${stackTrace.toString()}";
        _outPrinter("$_tag${_colorize(text, _errorPen)}");
      }
    }
  }

  @override
  void info(String message) {
    if (kDebugMode) {
      if (_isApple) {
        _outPrinter("$logTag$message");
      } else {
        _tag ??= _createTag();
        _outPrinter("$_tag${_colorize(message, _infoPen)}");
      }
    }
  }

  @override
  void warn(String message) {
    if (kDebugMode) {
      if (_isApple) {
        _outPrinter("$logTag$message");
      } else {
        _tag ??= _createTag();
        _outPrinter("$_tag${_colorize(message, _warnPen)}");
      }
    }
  }
}
