import 'package:flutter/widgets.dart';

import '../index.dart';

abstract base class TreeElement<T> {
  final String id;

  /// The type of the DUIT element.
  final String type;
  final bool controlled;
  final String? tag;
  abstract UIElementController<T>? viewController;
  abstract ViewAttribute<T>? attributes;

  TreeElement({
    required this.type,
    required this.id,
    this.controlled = false,
    this.tag,
  });

  Widget renderView();
}
