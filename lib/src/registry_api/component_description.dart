import 'dart:async';

import 'package:duit_kernel/duit_kernel.dart';

extension type _UiElementJsonView(Map<String, dynamic> json) {
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

/// Description of the component for registering it
/// in the [DuitRegistry] under the key corresponding to the [tag] property
final class ComponentDescription {
  final String tag;
  final Map<String, dynamic> data;
  final Set<RefWithTarget> refs;

  ComponentDescription({
    required this.tag,
    required this.data,
    required this.refs,
  });

  static void _replaceId(Map<String, dynamic> map) {
    final type = map["type"];
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final id = "${type}_$timestamp";
    map["id"] = id;
  }

  static FutureOr<void> _prepareRefs(
    Map<String, dynamic> obj,
    Set<RefWithTarget> container,
  ) async {
    final view = _UiElementJsonView(obj);
    if (view.controlled) {
      _replaceId(obj);
    }

    container.addAll(view.refs);

    
    if (obj['children'] != null) {
      final children = List.from(
        obj['children'],
        growable: false,
      );
      for (final child in children) {
        await _prepareRefs(child, container);
      }
    }

    if (obj['child'] != null) {
      await _prepareRefs(obj['child'], container);
    }
  }

  static FutureOr<ComponentDescription> prepare(
    Map<String, dynamic> json,
  ) async {
    assert(
        json['tag'] != null, "Tag must be provided in component description");
    assert(json['layoutRoot'] != null,
        "Layout must be provided in component description");
    final root = json['layoutRoot'];
    final rf = <RefWithTarget>{};

    await _prepareRefs(root, rf);

    return ComponentDescription(
      tag: json['tag'],
      data: root,
      refs: rf,
    );
  }
}
