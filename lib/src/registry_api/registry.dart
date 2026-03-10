import "dart:async";

import "package:duit_kernel/duit_kernel.dart";
import "package:duit_kernel/src/registry_api/components/index.dart";
import "package:meta/meta.dart";

const _messageExternalLibrarySupportNotEnabled =
    "External library support is not enabled";

/// The [DuitRegistry] class is responsible for registering and retrieving
/// model factories, build factories, and attributes factories for custom DUIT elements.
sealed class DuitRegistry {
  static final Map<String, BuildFactory> _customComponentRegistry = {};
  static final Map<String, Map<String, dynamic>> _fragmentRegistry = {};
  static ComponentRegistry _componentRegistry = DefaultComponentRegistry();
  static DuitTheme _theme = const DuitTheme({});
  static late LoggingCapabilityDelegate _logManager;
  static late final Map<String, LibraryDescriptor> _libraries;
  static late final Map<String, LibraryDescriptor> _reverseIndex;

  static FutureOr<void> initialize({
    @Deprecated("Will be removed in the next major release.")
    DebugLogger? logger,
    DuitTheme? theme,
    ComponentRegistry? componentRegistry,
    LoggingCapabilityDelegate? logManager,
  }) async {
    _componentRegistry = componentRegistry ?? _componentRegistry;
    _theme = theme ?? _theme;
    _logManager = logManager ?? const LoggingManager();
    await _componentRegistry.init();

    if (enableExternalLibrarySupport) {
      _libraries = {};
      _reverseIndex = {};
    }
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
      _logManager.logInfo(
        "All of ${components.length} components registered successfull",
      );
    } catch (e, s) {
      _logManager.logError(
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
      _logManager.logInfo(
        "Components registered successfully",
      );
    } catch (e, s) {
      _logManager.logError(
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
      _logManager.logWarning(
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

    _logManager.logInfo(
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
      _logManager.logWarning(
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
      _logManager.logWarning("Not found fragment for specified key - $key");
      return null;
    }
  }

  /// Registers a custom factory for deserializing enum [T] from raw JSON values.
  ///
  /// Use this when [DuitDataSource.toEnum] needs to parse a custom enum type
  /// that has no built-in support (e.g. enums with non-standard string
  /// representations). The [toEnum] factory receives the raw value (typically
  /// [String] or [int]) and must return an instance of [T].
  ///
  /// Call this at app startup before any UI that parses the enum type.
  /// Logs a success message via the configured [LoggingCapabilityDelegate].
  @preferInline
  static void registerCustomEnumFactory<T extends Enum>(
    ToEnumFactory<T> toEnum,
  ) {
    DuitDataSource.registerCustomEnumFactory(toEnum);
    _logManager.logInfo("Custom enum factory for $T registered successfully");
  }

  /// Registers a custom factory for deserializing class [T] from JSON.
  ///
  /// Use this when [DuitDataSource.toClass] needs to parse a custom object type
  /// that has no built-in support. The [toClass] factory receives the raw value
  /// (e.g. [Map] for nested objects) and must return an instance of [T].
  ///
  /// Call this at app startup before any UI that parses the object type.
  /// Logs a success message via the configured [LoggingCapabilityDelegate].
  @preferInline
  static void registerCustomObjectFactory<T extends Object>(
    ToClassFactory<T> toClass,
  ) {
    DuitDataSource.registerCustomObjectFactory(toClass);
    _logManager.logInfo("Custom object factory for $T registered successfully");
  }

  /// Loads an external [LibraryDescriptor] into the registry.
  ///
  /// The [library] argument must be a compile-time constant (`@mustBeConst`).
  /// After loading, every [WidgetDescriptor] declared in
  /// [LibraryDescriptor.descriptors] is indexed in the internal reverse-lookup
  /// map so that [getDescriptor] and [hasDescriptor] can resolve widget types
  /// at O(1) cost.
  ///
  /// Loading the same library name twice is a no-op (an error is logged and
  /// the call returns immediately).  Similarly, if a widget type key from the
  /// new library already exists in the reverse index (registered by a
  /// previously loaded library), an error is logged and that descriptor is
  /// skipped.
  ///
  /// Example:
  /// ```dart
  /// DuitRegistry.loadLibrary(const MyWidgetLibrary());
  /// ```
  @experimental
  static void loadLibrary(@mustBeConst LibraryDescriptor library) {
    if (enableExternalLibrarySupport) {
      if (_libraries.containsKey(library.name)) {
        _logManager.logError("Library ${library.name} already loaded");
        return;
      }
      _libraries[library.name] = library;
      for (final key in library.descriptors.keys) {
        _reverseIndex[key] = library;
      }
    } else {
      _logManager.logCritical(_messageExternalLibrarySupportNotEnabled);
      throw UnsupportedError(_messageExternalLibrarySupportNotEnabled);
    }
  }

  /// Returns the [WidgetDescriptor] for [name] from the loaded external
  /// libraries, or `null` if no descriptor with that widget type has been
  /// registered.
  ///
  /// Uses the internal reverse-index built by [loadLibrary] for O(1) lookup.
  @experimental
  @preferInline
  static WidgetDescriptor? getDescriptor(String name) {
    if (enableExternalLibrarySupport) {
      return _reverseIndex[name]?.getDescriptor(name);
    } else {
      _logManager.logCritical(_messageExternalLibrarySupportNotEnabled);
      throw UnsupportedError(_messageExternalLibrarySupportNotEnabled);
    }
  }

  /// Returns `true` if an external library loaded via [loadLibrary] contains a
  /// [WidgetDescriptor] whose type equals [name].
  @experimental
  @preferInline
  static bool hasDescriptor(String name) {
    if (enableExternalLibrarySupport) {
      return _reverseIndex[name]?.hasDescriptor(name) ?? false;
    } else {
      _logManager.logCritical(_messageExternalLibrarySupportNotEnabled);
      throw UnsupportedError(_messageExternalLibrarySupportNotEnabled);
    }
  }
}
