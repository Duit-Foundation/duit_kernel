final class SemanticBlockDescription {
  final String id;
  final String tag;
  final Map<String, dynamic> data;

  SemanticBlockDescription({
    required this.id,
    required this.tag,
    required this.data,
  });
  
  factory SemanticBlockDescription.fromMap(Map<String, dynamic> json) {
    assert(json['tag'] != null, "Tag must be provided in semantic block description");
    assert(json['layoutRoot'] != null, "Layout must be provided in semantic block description");
    return SemanticBlockDescription(
      id: json['id'] ?? "",
      tag: json['tag'],
      data: json['layoutRoot'] ?? {},
    );
  }
}
