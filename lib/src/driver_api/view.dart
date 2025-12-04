import "package:duit_kernel/duit_kernel.dart";
import "package:flutter/widgets.dart" show Widget;

/// The `DuitView` class is an abstract interface that defines the methods a Duit view must implement.
/// It provides a way to render a Duit model to a Flutter widget.
///
/// The methods of the `DuitView` class are:
/// - `prepareModel`: Prepares the Duit model for rendering.
/// - `build`: Builds the Flutter widget from the prepared Duit model.
/// - `getElementTree`: Returns the Duit element tree for the view.
abstract interface class DuitView {
  Future<void> prepareModel(
    Map<String, dynamic> json,
    UIDriver driver,
  );

  Widget build([String tag = ""]);

  @Deprecated(
    "The method is not used and will be removed in the next major release",
  )
  ElementTree getElementTree([String tag = ""]);
}
