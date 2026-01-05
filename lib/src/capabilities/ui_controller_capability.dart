import "package:duit_kernel/duit_kernel.dart";
import "package:duit_kernel/src/capabilities/driver_ref.dart";
import "package:meta/meta.dart";

/// Mixin that provides an interface for managing and interacting with UI element controllers
/// in the Duit driver.
///
/// Classes that mix in [UIControllerCapabilityDelegate] are expected to implement
/// logic for tracking, attaching, detaching, and updating UI controllers (typically wrapping
/// widgets, inputs, or other interactive elements).
///
/// By default, all methods throw [MissingCapabilityMethodImplementation] if not overridden, enforcing
/// that concrete platform or application drivers provide required behaviors.
///
/// Typical responsibilities include:
///   - Mapping UI controller IDs to their active controller instances
///   - Attaching/detaching controllers dynamically as UI is built or disposed
///   - Applying state and attribute updates received from the server or driver logic
///   - Exposing helpers to query or enumerate attached controllers
mixin UIControllerCapabilityDelegate implements DriverRefHolder {
  @override
  @mustBeOverridden
  void linkDriver(UIDriver driver) =>
      throw const MissingCapabilityMethodImplementation(
        "eventStream",
        "ViewModelCapabilityDelegate",
      );

  /// Attaches a UI element controller to the driver.
  ///
  /// Called when a new UI element or interactive widget is created and
  /// needs to be tracked or managed by the driver. The [id] should be a
  /// unique identifier for the controller within the driver context.
  ///
  /// The [controller] instance provides control over state, events, and
  /// properties of the associated UI element.
  ///
  /// Implementations are responsible for tracking the mapping and making the
  /// controller available for updates and lookups using [getController].
  ///
  /// Throws [MissingCapabilityMethodImplementation] if not overridden.
  @mustBeOverridden
  void attachController(
    String id,
    UIElementController controller,
  ) =>
      throw const MissingCapabilityMethodImplementation(
        "attachController",
        "UIControllerCapabilityDelegate",
      );

  /// Detaches the UI element controller associated with the given [id].
  ///
  /// Called when a UI element or interactive widget is disposed or no longer
  /// needs to be managed by the driver. The implementation should remove any
  /// references to the controller to allow for proper garbage collection and to
  /// prevent memory leaks.
  ///
  /// If the controller for the given [id] does not exist, this method may be a no-op.
  ///
  /// Throws [MissingCapabilityMethodImplementation] if not overridden.
  @mustBeOverridden
  void detachController(String id) =>
      throw const MissingCapabilityMethodImplementation(
        "detachController",
        "UIControllerCapabilityDelegate",
      );

  /// Returns the [UIElementController] associated with the given [id], or `null` if
  /// no such controller is currently attached to the driver.
  ///
  /// The [id] should match the unique identifier provided when [attachController] was called.
  ///
  /// This method enables lookups for dynamic access to element state, imperative methods,
  /// or for integrating with widgets that need to control or listen to specific UI element controllers.
  ///
  /// Throws [MissingCapabilityMethodImplementation] if not overridden.
  @mustBeOverridden
  UIElementController? getController(String id) =>
      throw const MissingCapabilityMethodImplementation(
        "getController",
        "UIControllerCapabilityDelegate",
      );

  /// Updates the attributes (properties) of the UI element controller identified by [controllerId].
  ///
  /// The [json] parameter is a `Map<String, dynamic>` containing key-value pairs representing
  /// the attributes to update on the specified controller. Implementations should deserialize
  /// or assign these values as appropriate for the UI element's state, triggering any necessary
  /// UI updates, re-rendering, or side effects.
  ///
  /// - If the controller with [controllerId] does not exist, this method may throw,
  ///   be a no-op, or handle the situation gracefully depending on implementation.
  /// - Values in [json] are expected to match the schema or interface supported by
  ///   the associated [UIElementController].
  ///
  /// Throws [MissingCapabilityMethodImplementation] if not overridden.
  @mustBeOverridden
  Future<void> updateAttributes(
    String controllerId,
    Map<String, dynamic> json,
  ) =>
      throw const MissingCapabilityMethodImplementation(
        "updateAttributes",
        "UIControllerCapabilityDelegate",
      );

  /// Returns the number of currently attached [UIElementController]s managed by this delegate.
  ///
  /// This getter should provide a count of all active UI element controllers that have been
  /// attached via [attachController], and not subsequently detached via [detachController].
  ///
  /// The value is useful for diagnostics, debugging, or for systems needing to monitor or
  /// iterate over all registered UI controllers at runtime.
  ///
  /// Throws [MissingCapabilityMethodImplementation] if not overridden.
  @mustBeOverridden
  int get controllersCount => throw const MissingCapabilityMethodImplementation(
        "controllersCount",
        "UIControllerCapabilityDelegate",
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
        "UIControllerCapabilityDelegate",
      );
}
