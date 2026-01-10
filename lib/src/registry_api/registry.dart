import "dart:async";

import "package:duit_kernel/duit_kernel.dart";
import "package:duit_kernel/src/registry_api/components/index.dart";

/// The [DuitRegistry] class is responsible for registering and retrieving
/// model factories, build factories, and attributes factories for custom DUIT elements.
sealed class DuitRegistry {
  static final Map<String, BuildFactory> _customComponentRegistry = {};
  static final Map<String, Map<String, dynamic>> _fragmentRegistry = {};
  static LoggingCapabilityDelegate _logManager = const LoggingManager();
  static ComponentRegistry _componentRegistry = DefaultComponentRegistry();
  static DuitTheme _theme = const DuitTheme({});

  static FutureOr<void> initialize({
    @Deprecated("Use [LoggingCapabilityDelegate] and [logManager] instead")
    DebugLogger? logger,
    DuitTheme? theme,
    ComponentRegistry? componentRegistry,
    LoggingCapabilityDelegate? logManager,
  }) async {
    _componentRegistry = componentRegistry ?? _componentRegistry;
    _theme = theme ?? _theme;
    _logManager = logManager ?? _logManager;
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
      _logManager.info(
        "All of ${components.length} components registered successfull",
      );
    } catch (e, s) {
      _logManager.error(
        "Components registration failed",
        e,
        s,
      );
      rethrow;
    }
  }

  static FutureOr<void> registerComponent(
    Map<String, dynamic> component,
  ) async {
    try {
      await _componentRegistry.prepareComponent(component);
      _logManager.info(
        "Components registered successfully",
      );
    } catch (e, s) {
      _logManager.error(
        "Components registration failed",
        e,
        s,
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
      _logManager.warning(
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

    _logManager.info(
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
      _logManager.warning(
        "Not found build factory for specified tag - $tag",
      );
      return null;
    }
  }

  static void registerFragment(
    String key,
    Map<String, dynamic> fragment,
  ) {
    _fragmentRegistry[key] = fragment;
  }

  static Map<String, dynamic>? getFragment(String key) {
    final fragment = _fragmentRegistry[key];
    if (fragment != null) {
      return fragment;
    } else {
      _logManager.warning("Not found fragment for specified key - $key");
      return null;
    }
  }
}
