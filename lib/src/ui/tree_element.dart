import 'package:flutter/widgets.dart';

import '../index.dart';

abstract base class TreeElement<T> {
  /// The type of the DUIT element.
  final String type, id;
  final bool controlled;
  final String? tag;
  abstract UIElementController<T>? viewController;
  abstract ViewAttribute<T>? attributes;

  TreeElement({
    required this.type,
    required this.id,
    required this.controlled,
    this.tag,
  });

  Widget renderView();
}
