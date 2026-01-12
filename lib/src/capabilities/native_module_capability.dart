import "package:duit_kernel/duit_kernel.dart";
import "package:duit_kernel/src/capabilities/driver_ref.dart";
import "package:meta/meta.dart";

/// A mixin that provides capabilities for managing and interacting with
/// native code in the Duit UI system. Classes that mix in this delegate should
/// provide concrete implementations for handling native module interactions,
/// such as invoking native methods and initializing the native module.
mixin NativeModuleCapabilityDelegate implements DriverRefHolder {
  @override
  @mustBeOverridden
  void linkDriver(UIDriver driver) =>
      throw const MissingCapabilityMethodImplementation(
        "linkDriver",
        "NativeModuleCapabilityDelegate",
      );

  /// Initializes the native module.
  ///
  /// This method must be overridden by implementers.
  ///
  /// Throws [MissingCapabilityMethodImplementation] if not overridden.
  @mustBeOverridden
  Future<void> initNativeModule() =>
      throw const MissingCapabilityMethodImplementation(
        "initNativeModule",
        "NativeModuleCapabilityDelegate",
      );

  /// Invokes a native method.
  ///
  /// The [method] parameter represents the name of the native method to invoke.
  /// The [arguments] parameter contains any additional data required for the method.
  ///
  /// This method must be overridden by implementers.
  ///
  /// Throws [MissingCapabilityMethodImplementation] if not overridden.
  @mustBeOverridden
  Future<T?> invokeNativeMethod<T>(
    String method, [
    arguments,
  ]) =>
      throw const MissingCapabilityMethodImplementation(
        "invokeNativeMethod",
        "NativeModuleCapabilityDelegate",
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
        "NativeModuleCapabilityDelegate",
      );
}
