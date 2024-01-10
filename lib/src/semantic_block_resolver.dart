import 'dart:async';

import 'semantics_block_description.dart';

abstract base class SemanticBlockResolver {
  final Map<String, SemanticBlockDescription> _registry = {};

  Future<void> loadSemanticBlocksDescriptions();

  SemanticBlockDescription getDescription(String tag) {
    if (!_registry.containsKey(tag)) {
      throw Exception("Tag $tag not found in registry");
    }

    return _registry[tag]!;
  }

  FutureOr<Map<String, dynamic>> merge(
    Map<String, dynamic>? layout,
    Map<String, dynamic>? attributes,
  ) {
    assert(layout != null, "Layout must be provided for merge");
    assert(attributes != null, "Attributes must be provided for merge");

    final layoutType = layout!["type"];
    final widgetAttributes = attributes!["data"];
    final attributeType = widgetAttributes["type"];

    if (layoutType != attributeType) {
      throw Exception("Types must be the same for merge");
    }

    layout["attributes"] = widgetAttributes;

    final Map<String, dynamic>? layoutChild = layout["child"];
    final List<Map<String, dynamic>>? layoutChildrenList = layout["children"];
    final Map<String, dynamic>? childAttributes = attributes["child"];
    final List<Map<String, dynamic>>? childrenAttributesList =
        attributes["children"];

    if (layoutChild != null) {
      merge(layoutChild, childAttributes);
    }

    if (layoutChildrenList != null) {
      for (var i = 0; i < layoutChildrenList.length; i++) {
        merge(layoutChildrenList[i], childrenAttributesList![i]);
      }
    }

    return layout;
  }

  void onSemanticsLoaded(List<Map<String, dynamic>> data) {
    for (var block in data) {
      final description = SemanticBlockDescription.fromMap(block);
      _registry[description.tag] = description;
    }
  }
}
