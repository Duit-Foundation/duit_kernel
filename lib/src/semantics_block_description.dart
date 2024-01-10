final class SemanticBlockDescription {
  final String id;
  final String tag;
  final Map<String, dynamic> layout;

  SemanticBlockDescription({
    required this.id,
    required this.tag,
    required this.layout,
  });
  
  factory SemanticBlockDescription.fromMap(Map<String, dynamic> json) {
    assert(json['tag'] != null, "Tag must be provided in semantic block description");
    assert(json['layout'] != null, "Layout must be provided in semantic block description");
    return SemanticBlockDescription(
      id: json['id'] ?? "",
      tag: json['tag'],
      layout: json['layout'] ?? {},
    );
  }
}
