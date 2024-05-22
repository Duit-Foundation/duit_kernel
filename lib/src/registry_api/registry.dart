import 'package:duit_kernel/duit_kernel.dart';

import 'factory_set.dart';

/// The `DUITRegistry` class is responsible for registering and retrieving
/// model mappers, renderers, and attributes mappers for custom DUIT elements.
sealed class DuitRegistry {
  static late final WorkerPool? _workerPool;
  static final Map<String, FactoryRecord> _registry = {};

  static final Map<String, DuitComponentDescription> _componentRegistry = {};

  /// Registers a list of component descriptions.
  static registerComponents(List<Map<String, dynamic>> components) {
    for (var block in components) {
      final description = DuitComponentDescription.fromJson(block);
      _componentRegistry[description.tag] = description;
    }
  }

  /// Returns the component description by the specified tag.
  static DuitComponentDescription? getComponentDescription(String tag) {
    return _componentRegistry[tag];
  }

  /// Registers a DUIT element with the specified key, model mapper, renderer, and attributes mapper.
  ///
  /// The [key] is a unique identifier for the DUIT element.
  /// The [modelMapper] is a function that maps the DUIT element to a `DUITElement`.
  /// The [renderer] is a function that returns the widget representation of the `DUITElement`.
  /// The [attributesMapper] is a function that maps the attributes of the DUIT element to `DUITAttributes`.
  static void register(
    String key,
    ModelFactory modelMapper,
    BuildFactory renderer,
    AttributesFactory attributesMapper,
  ) {
    _registry[key] = (
      attributesFactory: attributesMapper,
      modelFactory: modelMapper,
      buildFactory: renderer,
    );
  }

  /// Returns the model mapper registered with the specified [key].
  ///
  /// Returns `null` if the specified [key] is not registered.
  static ModelFactory? getModelMapper(String key) {
    return _registry[key]?.modelFactory;
  }

  /// Returns the renderer registered with the specified [key].
  ///
  /// Returns `null` if the specified [key] is not registered.
  static BuildFactory? getRenderer(String key) {
    return _registry[key]?.buildFactory;
  }

  /// Returns the attributes mapper registered with the specified [key].
  ///
  /// Returns `null` if the specified [key] is not registered.
  static AttributesFactory? getAttributesMapper(String key) {
    return _registry[key]?.attributesFactory;
  }

  static void registerWorkerPool(WorkerPool workerPool) {
    _workerPool = workerPool;
  }

  static WorkerPool? workerPool() => _workerPool;
}
