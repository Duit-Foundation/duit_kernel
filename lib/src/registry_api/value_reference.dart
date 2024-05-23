///A class representing a data model that
///can be used to merge with a component description
final class ValueReference {
  String objectKey, attributeKey;

  ValueReference({
    required this.objectKey,
    required this.attributeKey,
  });

  factory ValueReference.fromJson(Map<String, dynamic> json) {
    return ValueReference(
      objectKey: json['objectKey'],
      attributeKey: json['attributeKey'],
    );
  }
}
