/// Notifies the driver about changes in the display state of widgets.
///
/// When the display state of a widget changes, the driver needs to be notified
/// so that it can update the display state of the widget in the UI. This is
/// typically done by calling [notifyWidgetDisplayStateChanged].
///
/// The display state of a widget can be queried using [isWidgetReady].
///
/// See also:
///
/// * [DuitDriver], which is the main interface for interacting with the UI
///   driver.
///
/// * [UIDriver], which is the base class for all UI drivers.
@Deprecated("")
abstract interface class WidgetDisplayStateNotifier {
  /// Notify the driver that the display state of a widget has changed.
  ///
  /// The [viewTag] parameter specifies which widget's display state has changed.
  /// The [state] parameter specifies the new display state of the widget.
  ///
  /// The possible values for [state] are:
  ///
  /// * 0: the widget is not visible
  /// * 1: the widget is visible and displayed
  ///
  /// See also:
  ///
  /// * [DuitDriver], which is the main interface for interacting with the UI
  ///   driver.
  void notifyWidgetDisplayStateChanged(String viewTag, int state);

  /// Check if a widget is ready to be displayed.
  ///
  /// The [viewTag] parameter specifies which widget to check.
  ///
  /// The returned value is true if the widget is ready to be displayed, and false
  /// otherwise.
  ///
  /// See also:
  ///
  /// * [DuitDriver], which is the main interface for interacting with the UI
  ///   driver.
  bool isWidgetReady(String viewTag);
}
