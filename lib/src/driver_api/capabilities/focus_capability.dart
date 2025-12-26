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
///  - [UnfocusDisposition], for handling how focus should be removed.
///  - [TraversalDirection], for spatial focus navigation.
///  - Focus cookbook - https://docs.flutter.dev/cookbook/forms/focus
///  - [FocusNode] docs - https://api.flutter.dev/flutter/widgets/FocusNode-class.html
mixin FocusCapabilityDelegate {
  late final UIDriver driver;

  @mustBeOverridden
  void requestFocus(
    String nodeId, {
    String? targetNodeId,
  }) =>
      throw const MissingCapabilityMethodImplementation(
        "requestFocus",
        "FocusCapabilityDelegate",
      );

  @mustBeOverridden
  bool nextFocus(String nodeId) =>
      throw const MissingCapabilityMethodImplementation(
        "nextFocus",
        "FocusCapabilityDelegate",
      );

  @mustBeOverridden
  bool previousFocus(String nodeId) =>
      throw const MissingCapabilityMethodImplementation(
        "previousFocus",
        "FocusCapabilityDelegate",
      );

  @mustBeOverridden
  void unfocus(
    String nodeId, {
    UnfocusDisposition disposition = UnfocusDisposition.scope,
  }) =>
      throw const MissingCapabilityMethodImplementation(
        "unfocus",
        "FocusCapabilityDelegate",
      );

  @mustBeOverridden
  bool focusInDirection(String nodeId, TraversalDirection direction) =>
      throw const MissingCapabilityMethodImplementation(
        "focusInDirection",
        "FocusCapabilityDelegate",
      );

  @mustBeOverridden
  void attachFocusNode(String nodeId, FocusNode node) =>
      throw const MissingCapabilityMethodImplementation(
        "attachFocusNode",
        "FocusCapabilityDelegate",
      );

  @mustBeOverridden
  void detachFocusNode(String nodeId) =>
      throw const MissingCapabilityMethodImplementation(
        "detachFocusNode",
        "FocusCapabilityDelegate",
      );

  @mustBeOverridden
  FocusNode? getNode(Object? key) =>
      throw const MissingCapabilityMethodImplementation(
        "getNode",
        "FocusCapabilityDelegate",
      );

  @mustBeOverridden
  void releaseResources() => throw const MissingCapabilityMethodImplementation(
        "releaseResources",
        "FocusCapabilityDelegate",
      );
}
