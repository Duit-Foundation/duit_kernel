import "package:duit_kernel/duit_kernel.dart";
import "package:duit_kernel/src/capabilities/driver_ref.dart";
import "package:meta/meta.dart";

/// A mixin that provides capabilities for managing and run scripts in the Duit UI system.
/// Classes that mix in this delegate
/// should provide concrete implementations for
/// handling script execution, evaluation, and initialization.
mixin ScriptingCapabilityDelegate implements DriverRefHolder {
  @override
  @mustBeOverridden
  void linkDriver(UIDriver driver) =>
      throw const MissingCapabilityMethodImplementation(
        "linkDriver",
        "ScriptingCapabilityDelegate",
      );

  /// Eval script source code
  @mustBeOverridden
  Future<void> evalScript(String source) =>
      throw const MissingCapabilityMethodImplementation(
        "evalScript",
        "ScriptingCapabilityDelegate",
      );

  ///Based on the name of the function, starts its execution.
  ///
  ///Accepts additional parameters [url], [meta], [body],
  ///necessary for working with the transport object,
  ///as well as for passing data to the executing script
  @mustBeOverridden
  Future<Map<String, dynamic>?> execScript(
    String functionName, {
    String? url,
    Map<String, dynamic>? meta,
    Map<String, dynamic>? body,
  }) =>
      throw const MissingCapabilityMethodImplementation(
        "execScript",
        "ScriptingCapabilityDelegate",
      );

  /// Initializes the scripting capability.
  @mustBeOverridden
  Future<void> initScriptingCapability() =>
      throw const MissingCapabilityMethodImplementation(
        "initScriptingCapability",
        "ScriptingCapabilityDelegate",
      );

  /// Called to clean up any external resources, subscriptions, or handlers
  /// typically when a delegate is being disposed of or detached. Implementations
  /// should ensure all open streams or event sources are closed.
  ///
  /// This method must be overridden by implementers.
  ///
  /// Throws [MissingCapabilityMethodImplementation] by default.
  @mustBeOverridden
  void releaseResources() => throw const MissingCapabilityMethodImplementation(
        "releaseResources",
        "ScriptingCapabilityDelegate",
      );
}
