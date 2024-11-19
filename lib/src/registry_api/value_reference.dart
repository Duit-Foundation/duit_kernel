///A class representing a data model that
///can be used to merge with a component description
final class ValueReference {
  final String objectKey, attributeKey;
  final Object? defaultValue;

  ValueReference({
    required this.objectKey,
    required this.attributeKey,
    this.defaultValue,
  });

  factory ValueReference.fromJson(Map<String, dynamic> json) {
    return ValueReference(
      objectKey: json['objectKey'],
      attributeKey: json['attributeKey'],
      defaultValue: json['defaultValue'],
    );
  }
}
