import 'dart:async';

import 'package:duit_kernel/duit_kernel.dart';
import 'package:duit_kernel/src/registry_api/components/index.dart';
import 'package:duit_kernel/src/registry_api/factory_record.dart';

/// The [DuitRegistry] class is responsible for registering and retrieving
/// model factories, build factories, and attributes factories for custom DUIT elements.
sealed class DuitRegistry {
  static final Map<String, FactoryRecord> _customComponentRegistry = {};
  static DebugLogger _logger = DefaultLogger.instance;
  static ComponentRegistry _componentRegistry = DefaultComponentRegistry();
  static DuitTheme _theme = const DuitTheme({});

  static FutureOr<void> initialize({
    DebugLogger? logger,
    DuitTheme? theme,
    ComponentRegistry? componentRegistry,
  }) async {
    _logger = logger ?? _logger;
    _componentRegistry = componentRegistry ?? _componentRegistry;
    _theme = theme ?? _theme;
    await _componentRegistry.init();
  }

  static DuitTheme get theme => _theme;

  /// Registers a list of component descriptions.
  static FutureOr<void> registerComponents(
    List<Map<String, dynamic>> components,
  ) async {
    try {
      for (var block in components) {
        await _componentRegistry.prepareComponent(block);
      }
      _logger.info(
        "All of ${components.length} components registered successfull",
      );
    } catch (e, s) {
      _logger.error(
        "Components registration failed",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  static FutureOr<void> registerComponent(
    Map<String, dynamic> component,
  ) async {
    try {
      await _componentRegistry.prepareComponent(component);
      _logger.info(
        "Components registered successfully",
      );
    } catch (e, s) {
      _logger.error(
        "Components registration failed",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// Returns the component description by the specified tag.
  static ComponentDescription? getComponentDescription(String tag) {
    final desctiption = _componentRegistry.getComponentDescription(tag);
    if (desctiption != null) {
      return desctiption;
    } else {
      _logger.warn(
        "Not found desctiption for specified tag - $tag",
      );
      return null;
    }
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
  }) {
    _customComponentRegistry[key] = (
      modelFactory: modelFactory,
      buildFactory: buildFactory,
    );

    _logger.info(
      "Custom widget $key registered successfull",
    );
  }

  /// Returns the model factory registered with the specified [tag].
  ///
  /// Returns `null` if the specified [tag] is not registered.
  static ModelFactory? getModelFactory(String tag) {
    final factory = _customComponentRegistry[tag]?.modelFactory;
    if (factory != null) {
      return factory;
    } else {
      _logger.warn(
        "Not found model factory for specified tag - $tag",
      );
      return null;
    }
  }

  /// Returns the build factory registered with the specified [tag].
  ///
  /// Returns `null` if the specified [tag] is not registered.
  static BuildFactory? getBuildFactory(String tag) {
    final factory = _customComponentRegistry[tag]?.buildFactory;
    if (factory != null) {
      return factory;
    } else {
      _logger.warn(
        "Not found build factory for specified tag - $tag",
      );
      return null;
    }
  }
}
