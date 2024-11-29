import 'package:flutter/widgets.dart';

import '../index.dart';

abstract base class ElementTreeEntry<T> {
  /// The type of the DUIT element.
  final String type, id;
  final bool controlled;
  final String? tag;
  abstract UIElementController<T>? viewController;
  abstract ViewAttribute<T>? attributes;

  ElementTreeEntry({
    required this.type,
    required this.id,
    required this.controlled,
    this.tag,
  });

  Widget renderView();
}
