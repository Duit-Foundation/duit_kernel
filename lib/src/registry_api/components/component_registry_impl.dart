import "dart:async";

import "package:duit_kernel/src/misc/index.dart";
import "package:duit_kernel/src/registry_api/components/index.dart";

final class DefaultComponentRegistry extends ComponentRegistry {
  final Map<String, ComponentDescription> _components = {};

  DefaultComponentRegistry();

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
    assert(
      component["tag"] != null,
      "Tag must be provided in component description",
    );
    assert(
      component["layoutRoot"] != null,
      "Layout must be provided in component description",
    );
    final root = component["layoutRoot"];
    final tag = component["tag"];

    // Build patch templates by structural traversal (path-aware)
    final writeOps = _collectWriteOps(root, const <Object>[]);

    _components[tag] = ComponentDescription(
      tag: tag,
      data: root,
      writeOps: writeOps,
    );
  }
}

/// Recursively collects write operations by structural traversal with path tracking.
List<PatchTemplate> _collectWriteOps(
  Map<String, dynamic> obj,
  List<Object> currentPath,
) {
  final out = <PatchTemplate>[];
  // Extract attributes map if present
  final attrs = (obj["attributes"] is Map)
      ? (obj["attributes"] as Map).cast<String, dynamic>()
      : const <String, dynamic>{};

  // Add ops for refs at this node
  if (attrs.containsKey("refs")) {
    final refs = attrs["refs"] as List;
    for (final raw in refs) {
      final vr = ValueReference.fromJson((raw as Map).cast<String, dynamic>());
      out.add(
        PatchTemplate(
          path: <Object>[...currentPath, "attributes", vr.attributeKey],
          sourceKey: vr.objectKey,
          defaultValue: vr.defaultValue,
          semantics: PatchSemantics.replace,
        ),
      );
    }
  }

  // Traverse children arrays
  if (obj["children"] is List) {
    final List children = obj["children"];
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      if (child is Map<String, dynamic>) {
        out.addAll(
          _collectWriteOps(child, <Object>[...currentPath, "children", i]),
        );
      }
    }
  }

  // Traverse single child
  if (obj["child"] is Map<String, dynamic>) {
    out.addAll(
      _collectWriteOps(
        obj["child"] as Map<String, dynamic>,
        <Object>[...currentPath, "child"],
      ),
    );
  }
  return out;
}
