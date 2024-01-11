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

  void onSemanticsLoaded(List<Map<String, dynamic>> data) {
    for (var block in data) {
      final description = SemanticBlockDescription.fromMap(block);
      _registry[description.tag] = description;
    }
  }
}
