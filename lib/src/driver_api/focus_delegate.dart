part of "app_delegate.dart";

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
      throw const MissingMethodImplementation("attachNode", "FocusDelegate");

  @mustBeOverridden
  void detachFocusNode(String nodeId) =>
      throw const MissingMethodImplementation("detachNode", "FocusDelegate");
}
