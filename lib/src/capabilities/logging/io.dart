import "package:duit_kernel/src/capabilities/logging/logging_capability.dart";
import "package:flutter/foundation.dart";

final class LoggingManager with LoggingCapabilityDelegate {
  const LoggingManager();

  @override
  void logCritical(message, [Object? exception, StackTrace? stackTrace]) {
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
  void logDebug(message, [Object? exception, StackTrace? stackTrace]) {
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
  void logError(message, [Object? exception, StackTrace? stackTrace]) {
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
  void logInfo(message, [Object? exception, StackTrace? stackTrace]) {
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
  void logVerbose(message, [Object? exception, StackTrace? stackTrace]) {
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
  void logWarning(message, [Object? exception, StackTrace? stackTrace]) {
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
