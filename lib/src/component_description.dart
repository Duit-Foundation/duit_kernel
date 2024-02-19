import 'package:duit_kernel/src/extensions.dart';

///Description of the component for registering it
///in the [DuitRegistry] under the key corresponding to the [tag] property
final class DuitComponentDescription {
  final String tag;
  final Map<String, dynamic> data;
  final Iterable<String> referencePaths;

  DuitComponentDescription({
    required this.tag,
    required this.data,
    required this.referencePaths,
  });

  static Iterable<String> _extractRefPaths(Map<String, dynamic> json) {
    return json
        .flatMap(breakPointKey: "refs")
        .keys
        .where((key) => key.endsWith("refs"));
  }

  factory DuitComponentDescription.fromJson(Map<String, dynamic> json) {
    assert(
        json['tag'] != null, "Tag must be provided in component description");
    assert(json['layoutRoot'] != null,
        "Layout must be provided in component description");
    final root = json['layoutRoot'];
    return DuitComponentDescription(
      tag: json['tag'],
      data: root,
      referencePaths: _extractRefPaths(root),
    );
  }
}
