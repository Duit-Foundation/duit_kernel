import 'dart:async';

import 'package:duit_kernel/duit_kernel.dart';

extension type _ComponentJsonView(Map<String, dynamic> json) {
  bool get controlled => json["controlled"] ?? false;

  Map<String, dynamic> get attributes {
    final hasProperty = json.containsKey("attributes");
    if (hasProperty) {
      return (json["attributes"] as Map).cast<String, dynamic>();
    } else {
      return const <String, dynamic>{};
    }
  }

  Set<RefWithTarget> get refs {
    final attrs = attributes;
    if (attributes.containsKey("refs")) {
      return (attrs["refs"] as Iterable)
          .map(
            (el) => RefWithTarget(
              ref: ValueReference.fromJson(el),
              target: attrs,
            ),
          )
          .toSet();
    } else {
      return const <RefWithTarget>{};
    }
  }
}

/// [ComponentRegistry] is a low level registry for components.
/// It is supposed to be used in [DuitRegistry] or other registries.
///
/// It provides methods for registering, getting and removing components.
/// It also provides methods for initializing and disposing the registry.
abstract base class ComponentRegistry {
  final DebugLogger? logger;

  const ComponentRegistry({
    this.logger,
  });

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

  /// Recursive method for creating [RefWithTarget] from the given object.
  ///
  /// Recursively traverses the given object and its children, collecting refs
  /// in the [container] set.
  ///
  /// If the object or any of its children are controlled widgets, their widget
  /// id is replaced with a new generated one.
  ///
  /// This method is usually called from [prepareComponent].
  FutureOr<void> prepareRefs(
    Map<String, dynamic> obj,
    Set<RefWithTarget> container,
  ) async {
    final view = _ComponentJsonView(obj);
    if (view.controlled) {
      _replaceControlledWidgetId(obj);
    }

    container.addAll(view.refs);

    if (obj['children'] != null) {
      final children = List.from(
        obj['children'],
        growable: false,
      );
      for (final child in children) {
        await prepareRefs(child, container);
      }
    }

    if (obj['child'] != null) {
      await prepareRefs(obj['child'], container);
    }
  }

  void _replaceControlledWidgetId(Map<String, dynamic> map) {
    final type = map["type"];
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final id = "${type}_$timestamp";
    map["id"] = id;
  }
}
