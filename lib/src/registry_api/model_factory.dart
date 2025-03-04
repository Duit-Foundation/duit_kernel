import 'package:duit_kernel/duit_kernel.dart';

/// The [ModelFactory] is a function type that maps a DUIT element to a [ElementTreeEntry].
///
/// The function takes in the following parameters:
/// - [id]: The unique identifier of the DUIT element.
/// - [controlled]: A boolean indicating whether the DUIT element is controlled.
/// - [attributes]: The attributes of the DUIT element.
/// - [controller]: An optional UI element controller.
///
/// It returns a `DUITElement` that represents the mapped DUIT element.
typedef ModelFactory = ElementTreeEntry Function(
  String id,
  bool controlled,
  ViewAttribute attributes,
  UIElementController? controller, [
  Iterable<ElementTreeEntry> subviews,
]);
