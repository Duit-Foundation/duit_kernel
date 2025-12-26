import "package:duit_kernel/duit_kernel.dart";
import "package:meta/meta.dart";

mixin UIControllerCapabilityDelegate {
  late final UIDriver driver;

  /// Attaches a controller to the UI driver.
  ///
  /// Parameters:
  /// - [id]: The ID of the controller.
  /// - [controller]: The UI element controller to attach.
  @mustBeOverridden
  void attachController(
    String id,
    UIElementController controller,
  ) =>
      throw const MissingCapabilityMethodImplementation(
        "attachController",
        "UIControllerCapabilityDelegate",
      );

  /// Detaches a controller from the UI driver.
  @mustBeOverridden
  void detachController(String id) =>
      throw const MissingCapabilityMethodImplementation(
        "detachController",
        "UIControllerCapabilityDelegate",
      );

  /// Gets the controller associated with the given ID
  @mustBeOverridden
  UIElementController? getController(String id) =>
      throw const MissingCapabilityMethodImplementation(
        "getController",
        "UIControllerCapabilityDelegate",
      );

  /// Updates the attributes of a controller.
  @mustBeOverridden
  Future<void> updateAttributes(
    String controllerId,
    Map<String, dynamic> json,
  ) =>
      throw const MissingCapabilityMethodImplementation(
        "updateAttributes",
        "UIControllerCapabilityDelegate",
      );

  @mustBeOverridden
  int get controllersCount => throw const MissingCapabilityMethodImplementation(
        "controllersCount",
        "UIControllerCapabilityDelegate",
      );

  @mustBeOverridden
  void releaseResources() => throw const MissingCapabilityMethodImplementation(
        "releaseResources",
        "UIControllerCapabilityDelegate",
      );
}
