import "package:duit_kernel/duit_kernel.dart";
import "package:flutter/widgets.dart";
import "package:meta/meta.dart";

/// A mixin that provides an interface for managing focus nodes
/// within the Duit kernel driver API.
///
/// Classes that use [FocusDelegate] must implement focus management
/// behaviors by overriding the methods. By default, methods throw
/// [MissingMethodImplementation] if not overridden.
///
/// See also:
///  * [UnfocusDisposition], for handling how focus should be removed.
///  * [TraversalDirection], for spatial focus navigation.
mixin FocusDelegate {
  @mustBeOverridden
  void requestFocus(String nodeId) =>
      throw const MissingMethodImplementation("requestFocus", "FocusDelegate");

  @mustBeOverridden
  bool nextFocus(String nodeId) =>
      throw const MissingMethodImplementation("nextFocus", "FocusDelegate");

  @mustBeOverridden
  bool previousFocus(String nodeId) =>
      throw const MissingMethodImplementation("previousFocus", "FocusDelegate");

  @mustBeOverridden
  void unfocus(
    String nodeId, {
    UnfocusDisposition disposition = UnfocusDisposition.scope,
  }) =>
      throw const MissingMethodImplementation("unfocus", "FocusDelegate");

  @mustBeOverridden
  bool focusInDirection(String nodeId, TraversalDirection direction) =>
      throw const MissingMethodImplementation(
        "focusInDirection",
        "FocusDelegate",
      );

  @mustBeOverridden
  void attachFocusNode(String nodeId, FocusNode node) =>
      throw const MissingMethodImplementation(
        "attachFocusNode",
        "FocusDelegate",
      );

  @mustBeOverridden
  void detachFocusNode(String nodeId) =>
      throw const MissingMethodImplementation(
        "detachFocusNode",
        "FocusDelegate",
      );

  @mustBeOverridden
  FocusNode? getNode(Object? key) =>
      throw const MissingMethodImplementation("getNode", "FocusDelegate");
}
