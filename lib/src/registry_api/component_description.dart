/// Description of the component for registering it
/// in the [DuitRegistry] under the key corresponding to the [tag] property
final class DuitComponentDescription {
  final String tag;
  final Map<String, dynamic> data;

  DuitComponentDescription({
    required this.tag,
    required this.data,
  });

  factory DuitComponentDescription.fromJson(Map<String, dynamic> json) {
    assert(
        json['tag'] != null, "Tag must be provided in component description");
    assert(json['layoutRoot'] != null,
        "Layout must be provided in component description");
    final root = json['layoutRoot'];
    return DuitComponentDescription(
      tag: json['tag'],
      data: root,
    );
  }
}
