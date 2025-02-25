import 'dart:io';

import 'package:duit_kernel/duit_kernel.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

/// The [DefaultLogger] class provides a default logger implementation for the DUIT library.
///
/// It logs messages to the console if the app is running in debug mode.
final class DefaultLogger implements DebugLogger {
  String? _tag;

  /// The [DefaultLogger] singleton instance.
  static final instance = DefaultLogger._internal();

  /// The internal constructor for the singleton instance.
  DefaultLogger._internal();

  String _colorize(String m, String escapeCode) =>
      "\x1b[${escapeCode}m$m\x1b[0m";

  //ignore: avoid_print
  void _outPrinter(String m) => m.split("\n").forEach(print);

  String _createTag() => _colorize(DebugLogger.logTag, "32");

  static final _isApple = Platform.isIOS || Platform.isMacOS;

  @override
  void error(
    String message, {
    error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      if (_isApple) {
        _outPrinter(
            "${DebugLogger.logTag}$message\nError text: ${error.toString()}\nStackTrace: ${stackTrace.toString()}");
      } else {
        _tag ??= _createTag();
        final text =
            "$message\n Error text: ${error.toString()} \n StackTrace: ${stackTrace.toString()}";
        _outPrinter("$_tag${_colorize("ERR: $text", "31")}");
      }
    }
  }

  @override
  void info(String message) {
    if (kDebugMode) {
      if (_isApple) {
        _outPrinter("${DebugLogger.logTag}$message");
      } else {
        _tag ??= _createTag();
        _outPrinter("$_tag${_colorize("INFO: $message", "37")}");
      }
    }
  }

  @override
  void warn(String message) {
    if (kDebugMode) {
      if (_isApple) {
        _outPrinter("${DebugLogger.logTag}$message");
      } else {
        _tag ??= _createTag();
        _outPrinter("$_tag${_colorize("WARN: $message", "33")}");
      }
    }
  }
}
