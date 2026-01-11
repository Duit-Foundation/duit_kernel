import "package:duit_kernel/src/misc/error.dart";
import "package:meta/meta.dart";

/// A mixin that provides logging capabilities compatible with Talker API.
///
/// This mixin defines methods for logging messages at different levels,
/// handling exceptions, and logging custom log types. All methods must be
/// overridden by implementing classes.
mixin LoggingCapabilityDelegate {
  /// Logs an informational message.
  ///
  /// Use this method to log general informational messages about the
  /// application's state or flow.
  @mustBeOverridden
  void logInfo(
    message, [
    Object? exception,
    StackTrace? stackTrace,
  ]) =>
      throw const MissingCapabilityMethodImplementation(
        "info",
        "LoggingCapabilityDelegate",
      );

  /// Logs a debug message.
  ///
  /// Use this method to log detailed debugging information that is typically
  /// only useful during development.
  @mustBeOverridden
  void logDebug(
    message, [
    Object? exception,
    StackTrace? stackTrace,
  ]) =>
      throw const MissingCapabilityMethodImplementation(
        "debug",
        "LoggingCapabilityDelegate",
      );

  /// Logs a warning message.
  ///
  /// Use this method to log warnings about potential issues or unexpected
  /// conditions that don't prevent the application from functioning.
  @mustBeOverridden
  void logWarning(
    message, [
    Object? exception,
    StackTrace? stackTrace,
  ]) =>
      throw const MissingCapabilityMethodImplementation(
        "warning",
        "LoggingCapabilityDelegate",
      );

  /// Logs an error message.
  ///
  /// Use this method to log error messages that indicate problems or failures
  /// in the application.
  @mustBeOverridden
  void logError(
    message, [
    Object? exception,
    StackTrace? stackTrace,
  ]) =>
      throw const MissingCapabilityMethodImplementation(
        "error",
        "LoggingCapabilityDelegate",
      );

  /// Logs a critical error message.
  ///
  /// Use this method to log critical errors that require immediate attention
  /// and may indicate serious problems in the application.
  @mustBeOverridden
  void logCritical(
    message, [
    Object? exception,
    StackTrace? stackTrace,
  ]) =>
      throw const MissingCapabilityMethodImplementation(
        "critical",
        "LoggingCapabilityDelegate",
      );

  /// Logs a verbose message.
  ///
  /// Use this method to log very detailed information that is typically only
  /// useful for deep debugging or troubleshooting.
  @mustBeOverridden
  void logVerbose(
    message, [
    Object? exception,
    StackTrace? stackTrace,
  ]) =>
      throw const MissingCapabilityMethodImplementation(
        "verbose",
        "LoggingCapabilityDelegate",
      );
}
