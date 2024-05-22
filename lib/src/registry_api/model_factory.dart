import 'package:duit_kernel/duit_kernel.dart';

/// The `ModelMapper` is a function type that maps a DUIT element to a `DUITElement`.
///
/// The function takes in the following parameters:
/// - [id]: The unique identifier of the DUIT element.
/// - [controlled]: A boolean indicating whether the DUIT element is controlled.
/// - [attributes]: The attributes of the DUIT element.
/// - [controller]: An optional UI element controller.
///
/// It returns a `DUITElement` that represents the mapped DUIT element.
typedef ModelFactory<T extends DuitAttributes> = TreeElement<T> Function(
  String id,
  bool controlled,
  ViewAttribute<T> attributes,
  UIElementController<T>? controller,
);
