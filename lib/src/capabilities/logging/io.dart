import "package:duit_kernel/src/capabilities/logging/logging_capability.dart";
import "package:flutter/foundation.dart";

final class LoggingManager with LoggingCapabilityDelegate {
  const LoggingManager();

  @override
  void critical(message, [Object? exception, StackTrace? stackTrace]) {
    final buff = StringBuffer("[DUIT FRAMEWORK] CRITICAL: $message \nTime: ${DateTime.now().toUtc()}");
    if (exception != null) {
      buff.write("\nException: ${exception.toString()}");
    }
    if (stackTrace != null) {
      buff.write("\nStackTrace: ${stackTrace.toString()}");
    }
    debugPrint(buff.toString());
  }

  @override
  void debug(message, [Object? exception, StackTrace? stackTrace]) {
    final buff = StringBuffer("[DUIT FRAMEWORK] DEBUG: $message \nTime: ${DateTime.now().toUtc()}");
    if (exception != null) {
      buff.write("\nException: ${exception.toString()}");
    }
    if (stackTrace != null) {
      buff.write("\nStackTrace: ${stackTrace.toString()}");
    }
    debugPrint(buff.toString());
  }

  @override
  void error(message, [Object? exception, StackTrace? stackTrace]) {
    final buff = StringBuffer("[DUIT FRAMEWORK] ERROR: $message \nTime: ${DateTime.now().toUtc()}");
    if (exception != null) {
      buff.write("\nException: ${exception.toString()}");
    }
    if (stackTrace != null) {
      buff.write("\nStackTrace: ${stackTrace.toString()}");
    }
    debugPrint(buff.toString());
  }

  @override
  void info(message, [Object? exception, StackTrace? stackTrace]) {
    final buff = StringBuffer("[DUIT FRAMEWORK] INFO: $message \nTime: ${DateTime.now().toUtc()}");
    if (exception != null) {
      buff.write("\nException: ${exception.toString()}");
    }
    if (stackTrace != null) {
      buff.write("\nStackTrace: ${stackTrace.toString()}");
    }
    debugPrint(buff.toString());
  }

  @override
  void verbose(message, [Object? exception, StackTrace? stackTrace]) {
    final buff = StringBuffer("[DUIT FRAMEWORK] VERBOSE: $message \nTime: ${DateTime.now().toUtc()}");
    if (exception != null) {
      buff.write("\nException: ${exception.toString()}");
    }
    if (stackTrace != null) {
      buff.write("\nStackTrace: ${stackTrace.toString()}");
    }
    debugPrint(buff.toString());
  }

  @override
  void warning(message, [Object? exception, StackTrace? stackTrace]) {
    final buff = StringBuffer("[DUIT FRAMEWORK] WARNING: $message \nTime: ${DateTime.now().toUtc()}");
    if (exception != null) {
      buff.write("\nException: ${exception.toString()}");
    }
    if (stackTrace != null) {
      buff.write("\nStackTrace: ${stackTrace.toString()}");
    }
    debugPrint(buff.toString());
  }
}
