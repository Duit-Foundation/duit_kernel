import "dart:async";

import "package:duit_kernel/duit_kernel.dart";

/// [ComponentRegistry] is a low level registry for components.
/// It is supposed to be used in [DuitRegistry] or other registries.
///
/// It provides methods for registering, getting and removing components.
/// It also provides methods for initializing and disposing the registry.
abstract base class ComponentRegistry {
  const ComponentRegistry();

  /// [ComponentRegistry] initialization method
  Future<void> init();

  /// [ComponentRegistry] cleanup method
  void dispose();

  /// Method for processing and registering a component in the registry.
  ///
  /// This method is usually called from [DuitRegistry.registerComponents].
  Future<void> prepareComponent(
    Map<String, dynamic> component,
  );

  /// Method for getting the layout of a component by its tag
  ComponentDescription? getComponentDescription(
    String tag,
  );
}
