import 'package:duit_kernel/duit_kernel.dart';
import 'package:flutter/widgets.dart';

/// An abstract base class representing an entry in the DUIT element tree.
///
/// The `ElementTreeEntry` class serves as the foundational class for elements within
/// the DUIT element tree structure. It maintains essential properties such as the type,
/// ID, and control state of the element, as well as optional attributes and a view controller
/// for managing UI state and interactions.
///
/// Type parameter:
/// - [T]: The type of the data associated with the `UIElementController` and `ViewAttribute`.
///
/// Properties:
/// - [type]: A string representing the type of the DUIT element.
/// - [id]: A unique identifier for the DUIT element.
/// - [controlled]: A boolean indicating whether the DUIT element is controlled.
/// - [tag]: An optional tag for the DUIT element, which can be used for additional identification.
/// - [viewController]: An optional UI element controller for handling UI-specific logic.
/// - [attributes]: Optional view attributes associated with the DUIT element.
///
/// Methods:
/// - [renderView]: Abstract method that must be implemented to render the element as a widget.
abstract base class ElementTreeEntry {
  /// The type of the DUIT element.
  final String type, id;
  final bool controlled;
  final String? tag;
  abstract UIElementController? viewController;
  abstract ViewAttribute? attributes;

  ElementTreeEntry({
    required this.type,
    required this.id,
    required this.controlled,
    this.tag,
  });

  Widget renderView();
}
