part of "app_delegate.dart";

mixin FocusDelegate {
  @mustBeOverridden
  void requestFocus(String nodeId) => throw UnimplementedError();
  @mustBeOverridden
  bool nextFocus(String nodeId) => throw UnimplementedError();
  @mustBeOverridden
  bool previousFocus(String nodeId) => throw UnimplementedError();
  @mustBeOverridden
  void unfocus(
    String nodeId, {
    UnfocusDisposition disposition = UnfocusDisposition.scope,
  }) =>
      throw UnimplementedError();
  @mustBeOverridden
  bool focusInDirection(String nodeId, TraversalDirection direction) =>
      throw UnimplementedError();
  @mustBeOverridden
  void attachNode(String nodeId, FocusNode node) => throw UnimplementedError();
  @mustBeOverridden
  void detachNode(String nodeId) => throw UnimplementedError();
}

mixin ScriptRunnerDelegate {
  /// Evaluates a script source code.
  @mustBeOverridden
  Future<void> evalScript(String source) => throw UnimplementedError();
}
