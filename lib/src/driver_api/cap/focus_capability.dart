import "package:duit_kernel/duit_kernel.dart";
import "package:flutter/widgets.dart";
import "package:meta/meta.dart";

/// A mixin that provides an interface for managing focus nodes
/// within the Duit kernel driver API.
///
/// Classes that use [FocusCapabilityDelegate] must implement focus management
/// behaviors by overriding the methods. By default, methods throw
/// [MissingCapabilityMethodImplementation] if not overridden.
///
/// See also:
///  * [UnfocusDisposition], for handling how focus should be removed.
///  * [TraversalDirection], for spatial focus navigation.
mixin FocusCapabilityDelegate {
  @mustBeOverridden
  void requestFocus(String nodeId) =>
      throw const MissingCapabilityMethodImplementation("requestFocus", "FocusDelegate");

  @mustBeOverridden
  bool nextFocus(String nodeId) =>
      throw const MissingCapabilityMethodImplementation("nextFocus", "FocusDelegate");

  @mustBeOverridden
  bool previousFocus(String nodeId) =>
      throw const MissingCapabilityMethodImplementation("previousFocus", "FocusDelegate");

  @mustBeOverridden
  void unfocus(
    String nodeId, {
    UnfocusDisposition disposition = UnfocusDisposition.scope,
  }) =>
      throw const MissingCapabilityMethodImplementation("unfocus", "FocusDelegate");

  @mustBeOverridden
  bool focusInDirection(String nodeId, TraversalDirection direction) =>
      throw const MissingCapabilityMethodImplementation(
        "focusInDirection",
        "FocusDelegate",
      );

  @mustBeOverridden
  void attachFocusNode(String nodeId, FocusNode node) =>
      throw const MissingCapabilityMethodImplementation(
        "attachFocusNode",
        "FocusDelegate",
      );

  @mustBeOverridden
  void detachFocusNode(String nodeId) =>
      throw const MissingCapabilityMethodImplementation(
        "detachFocusNode",
        "FocusDelegate",
      );

  @mustBeOverridden
  FocusNode? getNode(Object? key) =>
      throw const MissingCapabilityMethodImplementation("getNode", "FocusDelegate");
}
