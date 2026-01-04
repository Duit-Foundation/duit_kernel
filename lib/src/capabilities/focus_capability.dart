import "package:duit_kernel/duit_kernel.dart";
import "package:duit_kernel/src/capabilities/driver_ref.dart";
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
mixin FocusCapabilityDelegate implements DriverRefHolder {
  late final UIDriver _driver;

  @override
  @protected
  UIDriver get driver => _driver;

  @override
  void linkDriver(UIDriver driver) => _driver = driver;

  /// Requests that the focus be moved to the [FocusNode] associated with the given [nodeId].
  ///
  /// If [targetNodeId] is provided, the focus will move to the node represented by [targetNodeId]
  /// rather than [nodeId] itself. This allows redirecting focus requests to other elements, such as
  /// when managing focus scopes or proxy nodes.
  ///
  /// Implementations must ensure the correct [FocusNode] is resolved and the focus request is
  /// performed, triggering any side effects or UI updates required. Typical use cases include:
  ///   - Moving the input cursor to a text field,
  ///   - Focusing a button or other interactive widget,
  ///   - Coordinating focus changes in response to user actions or server commands.
  ///
  /// Throws [MissingCapabilityMethodImplementation] if not overridden.
  ///
  /// See also:
  ///  - [FocusNode.requestFocus], for the underlying Flutter mechanism.
  @mustBeOverridden
  void requestFocus(String nodeId) =>
      throw const MissingCapabilityMethodImplementation(
        "requestFocus",
        "FocusCapabilityDelegate",
      );

  /// Moves the focus to the next focusable node in the traversal order relative to the node
  /// identified by [nodeId].
  ///
  /// Returns `true` if the focus was successfully moved, or `false` if there was no next node to move to.
  ///
  /// Implementations should resolve the [FocusNode] associated with [nodeId] and call its
  /// underlying `nextFocus()` method, or use a platform-appropriate mechanism to advance focus
  /// in the forward direction. This is typically used for keyboard navigation (e.g., tab key)
  /// or programmatic focus traversal in forms, menus, or interactive interfaces.
  ///
  /// Throws [MissingCapabilityMethodImplementation] if not overridden.
  ///
  /// See also:
  ///  - [FocusNode.nextFocus], for the underlying Flutter implementation.
  @mustBeOverridden
  bool nextFocus(String nodeId) =>
      throw const MissingCapabilityMethodImplementation(
        "nextFocus",
        "FocusCapabilityDelegate",
      );

  /// Moves the focus to the previous focusable node in the traversal order relative to the node
  /// identified by [nodeId].
  ///
  /// Returns `true` if the focus was successfully moved to a previous node, or `false` if there was
  /// no previous node to move to (for example, if [nodeId] is the first node in the order).
  ///
  /// Implementations should resolve the [FocusNode] associated with [nodeId] and call its
  /// underlying `previousFocus()` method, or use a platform-appropriate mechanism to move focus
  /// backward in the order. This is commonly used for reverse keyboard navigation (e.g., Shift+Tab)
  /// or for programmatic focus traversal in complex UIs.
  ///
  /// Throws [MissingCapabilityMethodImplementation] if not overridden.
  ///
  /// See also:
  ///  - [FocusNode.previousFocus], for the underlying Flutter implementation.
  @mustBeOverridden
  bool previousFocus(String nodeId) =>
      throw const MissingCapabilityMethodImplementation(
        "previousFocus",
        "FocusCapabilityDelegate",
      );

  /// Removes focus from the node identified by [nodeId] and optionally determines the disposition
  /// for how focus should be handled within the focus scope.
  ///
  /// [nodeId]: The identifier of the focus node to unfocus.
  /// [disposition]: Specifies how focus should be handled when unfocusing (defaults to [UnfocusDisposition.scope]).
  ///   - [UnfocusDisposition.scope]: Unfocuses the node and its entire focus scope.
  ///   - [UnfocusDisposition.previouslyFocusedChild]: Attempts to return focus to the previously focused node.
  ///
  /// Implementations should resolve the [FocusNode] associated with [nodeId] and call its
  /// `unfocus()` method with the provided [disposition], or use a platform-appropriate mechanism
  /// to remove keyboard or input focus from that node.
  ///
  /// Throws [MissingCapabilityMethodImplementation] if not overridden.
  ///
  /// See also:
  ///  - [FocusNode.unfocus], for the underlying Flutter implementation.
  ///  - [UnfocusDisposition]
  @mustBeOverridden
  void unfocus(
    String nodeId, {
    UnfocusDisposition disposition = UnfocusDisposition.scope,
  }) =>
      throw const MissingCapabilityMethodImplementation(
        "unfocus",
        "FocusCapabilityDelegate",
      );

  /// Moves the focus from the node identified by [nodeId] in the specified [direction].
  ///
  /// [nodeId]: The identifier for the focus node from which to move.
  /// [direction]: The [TraversalDirection] to move focus (e.g., up, down, left, right, next, previous).
  ///
  /// Returns `true` if the focus was successfully moved in the given direction, or `false` if there was
  /// no suitable node to move focus to in that direction.
  ///
  /// Implementations should find the [FocusNode] associated with [nodeId] and call its
  /// `focusInDirection(direction)` method, or use the platform/framework-specific mechanism
  /// to move focus appropriately.
  ///
  /// Throws [MissingCapabilityMethodImplementation] if not overridden.
  ///
  /// See also:
  ///  - [FocusNode.focusInDirection], for the underlying Flutter implementation.
  ///  - [TraversalDirection], for supported directions.
  @mustBeOverridden
  bool focusInDirection(String nodeId, TraversalDirection direction) =>
      throw const MissingCapabilityMethodImplementation(
        "focusInDirection",
        "FocusCapabilityDelegate",
      );

  /// Attaches a [FocusNode] to the delegate, associating it with the provided [nodeId].
  ///
  /// [nodeId]: A unique identifier representing the logical focus node in the UI.
  /// [node]: The [FocusNode] instance to attach and manage.
  ///
  /// Implementations should track the mapping between [nodeId] and [node] so that focus
  /// operations (such as `requestFocus`, `unfocus`, or directional traversal) can be routed
  /// to the proper [FocusNode] instance as needed. This is typically called when a widget
  /// or component creates a focusable element that should participate in focus management.
  ///
  /// If a node with the same [nodeId] is already attached, it may be replaced, or an error
  /// may be thrown depending on implementation.
  ///
  /// Throws [MissingCapabilityMethodImplementation] if not overridden.
  ///
  /// See also:
  ///  - [detachFocusNode] to remove an attached node.
  ///  - [getNode] to retrieve an attached node.
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

  /// Returns the [FocusNode] associated with the provided [key], or `null` if no such node is attached.
  ///
  /// The [key] is typically the `nodeId` used when attaching the node via [attachFocusNode].
  /// Implementations should look up and return the [FocusNode] instance mapped to [key] for
  /// direct imperative focus operations or inspection.
  ///
  /// Returns `null` if [key] is not currently mapped to any attached [FocusNode].
  ///
  /// Throws [MissingCapabilityMethodImplementation] if not overridden.
  ///
  /// See also:
  ///  - [attachFocusNode] to associate a node with an id.
  ///  - [detachFocusNode] to remove an association.
  @mustBeOverridden
  FocusNode? getNode(Object? key) =>
      throw const MissingCapabilityMethodImplementation(
        "getNode",
        "FocusCapabilityDelegate",
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
        "FocusCapabilityDelegate",
      );
}
