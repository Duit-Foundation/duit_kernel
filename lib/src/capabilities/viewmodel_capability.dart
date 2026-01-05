import "package:duit_kernel/duit_kernel.dart";
import "package:duit_kernel/src/capabilities/driver_ref.dart";
import "package:flutter/widgets.dart";
import "package:meta/meta.dart";

/// A mixin that provides capabilities for managing and interacting with
/// views in the Duit UI system. Classes that mix in this delegate should
/// provide concrete implementations for handling driver events, widget
/// build context, error reporting, and display state changes.
///
/// Implementing this mixin allows a class to interact with [UIDriver]s,
/// respond to UI events, and manage view lifecycle updates in a
/// decoupled, extensible manner.
mixin ViewModelCapabilityDelegate implements DriverRefHolder {
  @override
  @mustBeOverridden
  void linkDriver(UIDriver driver) =>
      throw const MissingCapabilityMethodImplementation(
        "eventStream",
        "ViewModelCapabilityDelegate",
      );

  /// A stream of [UIDriverEvent]s that this delegate manages or receives.
  ///
  /// Implementors must provide access to a broadcast stream (or similar)
  /// that emits UI driver events as they occur in the view layer, such as
  /// UI interactions, state changes, or system notifications.
  ///
  /// This is typically used for listening to driver-originated events and
  /// updating state or triggering additional actions in response.
  ///
  /// Throws [MissingCapabilityMethodImplementation] if not overridden.
  @mustBeOverridden
  Stream<UIDriverEvent> get eventStream =>
      throw const MissingCapabilityMethodImplementation(
        "eventStream",
        "ViewModelCapabilityDelegate",
      );

  /// The build context associated with the UI driver.
  @mustBeOverridden
  BuildContext get buildContext =>
      throw const MissingCapabilityMethodImplementation(
        "buildContext",
        "ViewModelCapabilityDelegate",
      );

  /// Sets the current [BuildContext] for the delegate.
  ///
  /// This setter is called to update the internal context used by this view
  /// capability delegate, typically when the underlying widget is rebuilt or
  /// the associated element changes.
  ///
  /// Implementors should retain the provided [value] for use in subsequent
  /// operations that require contextual widget access, theme resolution,
  /// localization, or interaction with the widget tree.
  ///
  /// Throws [MissingCapabilityMethodImplementation] if not overridden.
  @mustBeOverridden
  set context(BuildContext value) =>
      throw const MissingCapabilityMethodImplementation(
        "context",
        "ViewModelCapabilityDelegate",
      );

  /// Adds a [UIDriverEvent] to the event stream or processes it within the
  /// view capability delegate.
  ///
  /// [event]: The event originating from the UI driver that should be handled,
  /// dispatched, or recorded by the delegate.
  ///
  /// Implementors should ensure this method properly incorporates the event
  /// into the delegate’s event handling pipeline, such as by adding it to a
  /// stream, queue, or directly updating application/UI state as necessary.
  ///
  /// Throws [MissingCapabilityMethodImplementation] if not overridden.
  @mustBeOverridden
  void addUIDriverEvent(UIDriverEvent event) =>
      throw const MissingCapabilityMethodImplementation(
        "addUIDriverEvent",
        "ViewModelCapabilityDelegate",
      );

  /// Reports an error that occurred within the UI driver context to the delegate.
  ///
  /// [error] is the error object or exception that was caught by the driver or related UI logic.
  /// [stackTrace] is optional and, if provided, gives debugging context for where the error occurred.
  ///
  /// Implementors should handle or log the error appropriately, such as reporting to diagnostics,
  /// updating UI state, or propagating it to a higher-level error handler.
  ///
  /// Throws [MissingCapabilityMethodImplementation] if not overridden.
  @mustBeOverridden
  void addUIDriverError(Object error, [StackTrace? stackTrace]) =>
      throw const MissingCapabilityMethodImplementation(
        "addUIDriverError",
        "ViewModelCapabilityDelegate",
      );

  /// Notify the driver that the display state of a widget has changed.
  ///
  /// The [viewTag] parameter specifies which widget's display state has changed.
  /// The [state] parameter specifies the new display state of the widget.
  ///
  /// The possible values for [state] are:
  ///
  /// * 0: the widget is not visible
  /// * 1: the widget is visible and displayed
  @mustBeOverridden
  void notifyWidgetDisplayStateChanged(String viewTag, int state) =>
      throw const MissingCapabilityMethodImplementation(
        "notifyWidgetDisplayStateChanged",
        "ViewModelCapabilityDelegate",
      );

  /// Check if a widget is ready to be displayed.
  ///
  /// The [viewTag] parameter specifies which widget to check.
  ///
  /// The returned value is true if the widget is ready to be displayed, and false
  /// otherwise.
  @mustBeOverridden
  bool isWidgetReady(String viewTag) =>
      throw const MissingCapabilityMethodImplementation(
        "isWidgetReady",
        "ViewModelCapabilityDelegate",
      );

  /// Prepares and validates a layout configuration from a JSON-like map, returning a [DuitView] instance.
  ///
  /// The [json] parameter contains the layout structure, typically representing
  /// widgets, properties, and relationships as parsed from a JSON document.
  ///
  /// Implementations are responsible for parsing the provided structure, constructing
  /// the corresponding [DuitView], and returning it for further use, such as rendering.
  /// Returning `null` may indicate an invalid or unrecognized layout.
  ///
  /// Throws [MissingCapabilityMethodImplementation] if not overridden.
  @mustBeOverridden
  Future<DuitView?> prepareLayout(Map<String, dynamic> json) =>
      throw const MissingCapabilityMethodImplementation(
        "prepareLayout",
        "ViewModelCapabilityDelegate",
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
        "ViewModelCapabilityDelegate",
      );
}
