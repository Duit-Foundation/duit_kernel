import 'dart:async';

import 'package:duit_kernel/duit_kernel.dart';
import 'package:duit_kernel/src/registry_api/components/index.dart';

final class DefaultComponentRegistry extends ComponentRegistry {
  final Map<String, ComponentDescription> _components = {};

  DefaultComponentRegistry({
    DebugLogger? logger,
  }) : super(
          logger: logger,
        );

  @override
  Future<void> init() async {
    //TODO: implement if needed
  }

  @override
  void dispose() {
    _components.clear();
  }

  @override
  ComponentDescription? getComponentDescription(String tag) {
    return _components[tag];
  }

  @override
  Future<void> prepareComponent(Map<String, dynamic> component) async {
    assert(component['tag'] != null,
        "Tag must be provided in component description");
    assert(component['layoutRoot'] != null,
        "Layout must be provided in component description");
    final root = component['layoutRoot'];
    final tag = component['tag'];

    final rf = <RefWithTarget>{};
    await prepareRefs(root, rf);

    _components[tag] = ComponentDescription(
      tag: tag,
      data: root,
      refs: rf,
    );
  }
}
