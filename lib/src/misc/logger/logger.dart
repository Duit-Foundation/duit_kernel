/// The [DebugLogger] interface defines a contract for logger implementations.
///
/// The methods in [DebugLogger] are used to log messages to the console.
abstract interface class DebugLogger {
  static const logTag = "[DUIT FRAMEWORK] ";

  void info(String message);
  void warn(String message);
  void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
  });
}
