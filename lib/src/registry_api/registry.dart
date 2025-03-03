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
  static late final ResourceLoader<DuitTheme> _themeLoader;
  static DuitTheme _theme = const DuitTheme({});

  static void configure({
    DebugLogger? logger,
    ResourceLoader<DuitTheme>? themeLoader,
    ComponentRegistry? componentRegistry,
  }) {
    _logger = logger ?? _logger;
    _componentRegistry = componentRegistry ?? _componentRegistry;

    if (themeLoader != null) {
      _themeLoader = themeLoader;
    }
  }

  static DuitTheme get theme => _theme;

  static Future<void> initTheme() async {
    try {
      _theme = await _themeLoader.load();
    } catch (e, s) {
      _logger.error(
        "Theme initialization failed",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

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
    required AttributesFactory attributesFactory,
  }) {
    _customComponentRegistry[key] = (
      attributesFactory: attributesFactory,
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

  /// Returns the attributes factory registered with the specified [tag].
  ///
  /// Returns `null` if the specified [tag] is not registered.
  static AttributesFactory? getAttributesFactory(String tag) {
    final factory = _customComponentRegistry[tag]?.attributesFactory;
    if (factory != null) {
      return factory;
    } else {
      _logger.warn(
        "Not found attributes factory for specified tag - $tag",
      );
      return null;
    }
  }
}
