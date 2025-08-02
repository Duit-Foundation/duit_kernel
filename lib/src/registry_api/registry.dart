import 'dart:async';

import 'package:duit_kernel/duit_kernel.dart';
import 'package:duit_kernel/src/registry_api/components/index.dart';

/// The [DuitRegistry] class is responsible for registering and retrieving
/// model factories, build factories, and attributes factories for custom DUIT elements.
sealed class DuitRegistry {
  static final Map<String, BuildFactory> _customComponentRegistry = {};
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

  /// Registers a build factory for a custom Duit element.
  static void register(
    String key, {
    required BuildFactory buildFactory,
  }) {
    _customComponentRegistry[key] = buildFactory;

    _logger.info(
      "Custom widget $key registered successfull",
    );
  }

  /// Returns the build factory registered with the specified [tag].
  ///
  /// Returns `null` if the specified [tag] is not registered.
  static BuildFactory? getBuildFactory(String tag) {
    final factory = _customComponentRegistry[tag];
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
