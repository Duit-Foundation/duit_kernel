import "dart:async";

import "package:duit_kernel/duit_kernel.dart";
import "package:duit_kernel/src/capabilities/driver_ref.dart";
import "package:meta/meta.dart";

/// A mixin that provides capabilities for managing and interacting with
/// transport in the Duit UI system. Classes that mix in this delegate should
/// provide concrete implementations for handling server actions, requests,
/// and connections to the server.
mixin TransportCapabilityDelegate implements DriverRefHolder {
  @override
  @mustBeOverridden
  void linkDriver(UIDriver driver) =>
      throw const MissingCapabilityMethodImplementation(
        "linkDriver",
        "TransportCapabilityDelegate",
      );

  /// Executes a server action with the given payload and returns a server event.
  ///
  /// The [action] parameter represents the server action to execute.
  /// The [payload] parameter contains any additional data required for the action.
  ///
  /// This method must be overridden by implementers.
  ///
  /// Throws [MissingCapabilityMethodImplementation] by default.
  @mustBeOverridden
  Future<Map<String, dynamic>?> executeRemoteAction(
    ServerAction action,
    Map<String, dynamic> payload,
  ) =>
      throw const MissingCapabilityMethodImplementation(
        "executeRemoteAction",
        "TransportCapabilityDelegate",
      );

  /// Sends a request to the server.
  ///
  /// The [url] parameter represents the URL to send the request to.
  /// The [meta] parameter contains any additional metadata for the request.
  /// The [body] parameter contains the body of the request.
  ///
  /// This method must be overridden by implementers.
  ///
  /// Throws [MissingCapabilityMethodImplementation] by default.
  @mustBeOverridden
  Future<Map<String, dynamic>?> request(
    String url,
    Map<String, dynamic> meta,
    Map<String, dynamic> body,
  ) =>
      throw const MissingCapabilityMethodImplementation(
        "request",
        "TransportCapabilityDelegate",
      );

  /// Establishes a connection to the server.
  ///
  /// Returns a [Stream] that emits server events. The stream may emit a single event
  /// when the connection is established or continue emitting events in streaming mode.
  ///
  /// This method must be overridden by implementers.
  ///
  /// Throws [MissingCapabilityMethodImplementation] by default.
  @mustBeOverridden
  Stream<Map<String, dynamic>> connect({
    Map<String, dynamic>? initialRequestData,
    Map<String, dynamic>? staticContent,
  }) =>
      throw const MissingCapabilityMethodImplementation(
        "connect",
        "TransportCapabilityDelegate",
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
        "TransportCapabilityDelegate",
      );
}
