import 'package:duit_kernel/duit_kernel.dart';

/// Description of the component for registering it
/// in the [DuitRegistry] under the key corresponding to the [tag] property
final class DuitComponentDescription {
  final String tag;
  final Map<String, dynamic> data;
  final Set<RefWithTarget> refs;

  DuitComponentDescription({
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

  static void _prepareRefs(
    Map<String, dynamic> obj,
    Set<RefWithTarget> container,
  ) {
    if (obj['controlled'] == true) {
      _replaceId(obj);
    }

    final attributes = obj['attributes'] as Map<String, dynamic>;
    final refs = attributes['refs'];

    if (refs != null) {
      final list = List.from(
        refs,
        growable: false,
      );

      for (final ref in list) {
        final rT = RefWithTarget(
          target: attributes,
          ref: ValueReference.fromJson(ref),
        );
        container.add(rT);
      }
    }

    if (obj['children'] != null) {
      final children = List.from(
        obj['children'],
        growable: false,
      );
      for (final child in children) {
        _prepareRefs(child, container);
      }
    }

    if (obj['child'] != null) {
      _prepareRefs(obj['child'], container);
    }
  }

  factory DuitComponentDescription.fromJson(Map<String, dynamic> json) {
    assert(
        json['tag'] != null, "Tag must be provided in component description");
    assert(json['layoutRoot'] != null,
        "Layout must be provided in component description");
    final root = json['layoutRoot'];
    final rf = <RefWithTarget>{};
    _prepareRefs(root, rf);
    return DuitComponentDescription(
      tag: json['tag'],
      data: root,
      refs: rf,
    );
  }
}
