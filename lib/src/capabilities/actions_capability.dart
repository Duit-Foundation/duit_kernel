import "dart:async";

import "package:duit_kernel/duit_kernel.dart";
import "package:duit_kernel/src/capabilities/driver_ref.dart";
import "package:flutter/widgets.dart";
import "package:meta/meta.dart";

/// Signature for functions that handle user-defined events.
///
/// Used as an external handler for events such as navigation, opening URLs,
/// or custom application events. The handler receives the build context,
/// a string path (which may represent a route or URL), and an optional
/// extra payload (which could be any additional data required by the handler).
typedef UserDefinedEventHandler = FutureOr<void> Function(
  BuildContext context,
  String path,
  Object? extra,
);

/// The kind of user-defined event handler to be attached to an action manager.
///
/// This enum allows distinguishing between several kinds of external or
/// user-provided event handling mechanisms:
///
/// - [openUrl]: Handles actions related to opening a URL in a browser or app.
/// - [navigation]: Handles navigation within the app, such as pushing a route.
/// - [custom]: Handles custom user-defined event logic.
enum UserDefinedHandlerKind {
  /// Handler for "open URL" events.
  openUrl,

  /// Handler for navigation events.
  navigation,

  /// Handler for custom, user-defined events.
  custom;
}

/// A mixin that provides an interface for managing [ServerAction] execution
/// and [ServerEvent] handling
///
/// Classes that use [ServerActionExecutionCapabilityDelegate] must implement action/event management
/// behaviors by overriding the methods. By default, methods throw
/// [MissingCapabilityMethodImplementation] if not overridden.
///
/// See also:
/// - https://duit.pro/en/docs/core_concepts/actions_events
mixin ServerActionExecutionCapabilityDelegate implements DriverRefHolder {
  @override
  @mustBeOverridden
  void linkDriver(UIDriver driver) =>
      throw const MissingCapabilityMethodImplementation(
        "eventStream",
        "ViewModelCapabilityDelegate",
      );

  /// Executes the given [ServerAction].
  ///
  /// Implementations must provide the logic for handling and executing a [ServerAction],
  /// which may include communication with an external API, running scripts, or carrying out
  /// local operations depending on the action type.
  ///
  /// If the action requires asynchronous processing, this method should perform those
  /// operations and complete when execution is finished.
  ///
  /// Throws [MissingCapabilityMethodImplementation] by default if not overridden.
  @mustBeOverridden
  Future<void> execute(ServerAction action) =>
      throw const MissingCapabilityMethodImplementation(
        "execute",
        "ServerActionExecutionCapabilityDelegate",
      );

  /// Prepares and returns a payload map from the provided [dependencies] to be sent
  /// along with a [ServerAction] execution.
  ///
  /// Implementations should extract necessary values from each [ActionDependency]
  /// and build a serializable `Map<String, dynamic>` that represents the required
  /// input data for the action, suitable for sending to an API or other handler.
  ///
  /// This is typically used to resolve local values, form state, or referenced data,
  /// ensuring that all conditions required by the action are met.
  ///
  /// Throws [MissingCapabilityMethodImplementation] by default if not overridden.
  @mustBeOverridden
  Map<String, dynamic> preparePayload(
    Iterable<ActionDependency> dependencies,
  ) =>
      throw const MissingCapabilityMethodImplementation(
        "preparePayload",
        "ServerActionExecutionCapabilityDelegate",
      );

  /// Handles and resolves an incoming [eventData] in the given [context].
  ///
  /// Implementations must process the [eventData] (typically a parsed [ServerEvent]
  /// or compatible structure), and perform any side-effects, state changes,
  /// or UI updates as required by the event.
  ///
  /// The [context] provides access to the widget tree and can be used for navigation,
  /// showing dialogs, updating state, or other widget-level interactions.
  ///
  /// Concrete delegates must override this method to integrate event handling
  /// logic suitable for their application's flow.
  ///
  /// Throws [MissingCapabilityMethodImplementation] by default if not overridden.
  @mustBeOverridden
  Future<void> resolveEvent(BuildContext context, eventData) =>
      throw const MissingCapabilityMethodImplementation(
        "resolveEvent",
        "ServerActionExecutionCapabilityDelegate",
      );

  /// Registers an external [stream] of events to be handled by the delegate.
  ///
  /// This method allows the integration of external event sources, such as socket streams,
  /// platform channels, or any asynchronous data emitting [Stream] containing `Map<String, dynamic>`.
  ///
  /// Each event in the stream should be parsed and resolved by the delegate. Typical usage includes
  /// listening for third-party or system events and injecting them into the Duit action/event system.
  ///
  /// Throws [MissingCapabilityMethodImplementation] by default if not overridden.
  @mustBeOverridden
  void addExternalEventStream(
    Stream<Map<String, dynamic>> stream,
  ) =>
      throw const MissingCapabilityMethodImplementation(
        "addExternalEventStream",
        "ServerActionExecutionCapabilityDelegate",
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
        "ServerActionExecutionCapabilityDelegate",
      );

  /// Registers an external handler for a given kind of user-defined action or
  /// event.
  ///
  /// [type] specifies what kind of handler is to be attached (e.g. navigation, openUrl, custom).
  /// [handle] is a function that will be invoked to handle this type of event.
  ///
  /// Example usage:
  /// ```dart
  /// @override
  /// void attachExternalHandler(UserDefinedHandlerKind type, UserDefinedEventHandler handle) {
  ///   // Save handler for later invocation
  /// }
  /// ```
  /// This method must be overridden by implementers.
  ///
  /// Throws [MissingCapabilityMethodImplementation] by default.
  @mustBeOverridden
  void attachExternalHandler(
    UserDefinedHandlerKind type,
    UserDefinedEventHandler handle,
  ) =>
      throw const MissingCapabilityMethodImplementation(
        "attachExternalHandler",
        "ServerActionExecutionCapabilityDelegate",
      );
}
