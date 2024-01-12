class ValueReference {
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