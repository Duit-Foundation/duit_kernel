import 'package:duit_kernel/duit_kernel.dart';
import 'package:flutter/material.dart' show Widget;

/// The `Renderer` is a function type that returns a widget representation of a `DUITElement`.
///
/// The function takes in a single parameter:
/// - [model]: The `DUITElement` to be rendered.
///
/// It returns a `Widget` that represents the rendered `DUITElement`.
typedef BuildFactory = Widget Function(
  ElementTreeEntry model, [
  Iterable<Widget> subviews,
]);
