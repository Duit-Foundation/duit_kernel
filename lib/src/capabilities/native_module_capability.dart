import "package:duit_kernel/duit_kernel.dart";
import "package:duit_kernel/src/capabilities/driver_ref.dart";
import "package:meta/meta.dart";

mixin NativeModuleCapabilityDelegate implements DriverRefHolder {
  @override
  @mustBeOverridden
  void linkDriver(UIDriver driver) => throw const MissingCapabilityMethodImplementation(
        "linkDriver",
        "NativeModuleCapabilityDelegate",
      );

  @mustBeOverridden
  Future<void> initNativeModule() => throw const MissingCapabilityMethodImplementation(
        "initNativeModule",
        "NativeModuleCapabilityDelegate",
      );
}
