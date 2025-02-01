import 'dart:async';

import 'package:duit_kernel/duit_kernel.dart';

import 'factory_record.dart';

/// The [DuitRegistry] class is responsible for registering and retrieving
/// model factories, build factories, and attributes factories for custom DUIT elements.
sealed class DuitRegistry {
  static final Map<String, FactoryRecord> _registry = {};

  static final Map<String, ComponentDescription> _componentRegistry = {};

  /// Registers a list of component descriptions.
  static FutureOr<void> registerComponents(List<Map<String, dynamic>> components) async {
    for (var block in components) {
      final description = await ComponentDescription.prepare(block);
      _componentRegistry[description.tag] = description;
    }
  }

  static FutureOr<void> registerComponent(
      Map<String, dynamic> component) async {
    final description = await ComponentDescription.prepare(component);
    _componentRegistry[description.tag] = description;
  }

  /// Returns the component description by the specified tag.
  static ComponentDescription? getComponentDescription(String tag) {
    return _componentRegistry[tag];
  }

  /// Registers a DUIT element with the specified key, model mapper, renderer, and attributes mapper.
  ///
  /// - The [key] is a unique identifier for the DUIT element.
  ///
  /// - The [modelFactory] is a function that maps the DUIT element to a [ElementTreeEntry].
  ///
  /// - The [buildFactory] is a function that returns the [Widget] representation of the [ElementTreeEntry].
  ///
  /// - The [attributesFactory] is a function that maps the attributes from json to [DuitAttributes.
  static void register(
    String key, {
    required ModelFactory modelFactory,
    required BuildFactory buildFactory,
    required AttributesFactory attributesFactory,
  }) {
    _registry[key] = (
      attributesFactory: attributesFactory,
      modelFactory: modelFactory,
      buildFactory: buildFactory,
    );
  }

  /// Returns the model factory registered with the specified [key].
  ///
  /// Returns `null` if the specified [key] is not registered.
  static ModelFactory? getModelFactory(String key) {
    return _registry[key]?.modelFactory;
  }

  /// Returns the build factory registered with the specified [key].
  ///
  /// Returns `null` if the specified [key] is not registered.
  static BuildFactory? getBuildFactory(String key) {
    return _registry[key]?.buildFactory;
  }

  /// Returns the attributes factory registered with the specified [key].
  ///
  /// Returns `null` if the specified [key] is not registered.
  static AttributesFactory? getAttributesFactory(String key) {
    return _registry[key]?.attributesFactory;
  }
}
