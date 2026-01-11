/// The [DebugLogger] interface defines a contract for logger implementations.
///
/// The methods in [DebugLogger] are used to log messages to the console.
@Deprecated("Use [LoggingCapabilityDelegate] instead")
abstract interface class DebugLogger {
  static const logTag = "[DUIT FRAMEWORK] ";

  const DebugLogger();

  void info(String message);
  void warn(String message);
  void error(
    String message, {
    error,
    StackTrace? stackTrace,
  });
}
