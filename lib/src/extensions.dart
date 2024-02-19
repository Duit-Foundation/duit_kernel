extension MapExtension on Map<String, dynamic> {
  Map<String, T> _listToMap<T>(List<T> list) =>
      list.asMap().map((key, value) => MapEntry(key.toString(), value));

  Map<String, dynamic> flatMap({
    String delimiter = ".",
    int? maxDepth,
    String? breakPointKey,
  }) {
    final result = <String, dynamic>{};

    void step(
      Map<String, dynamic> obj, [
      String? previousKey,
      int currentDepth = 1,
      List<String> excludeKeys = const [],
    ]) {
      obj.forEach((key, value) {
        if (excludeKeys.contains(key)) {
          return;
        }

        final newKey = previousKey != null ? "$previousKey$delimiter$key" : key;

        if (breakPointKey != null && newKey.contains(breakPointKey)) {
          result[newKey] = value;
          return;
        }

        if (maxDepth != null && currentDepth >= maxDepth) {
          result[newKey] = value;
          return;
        }
        if (value is Map<String, dynamic>) {
          return step(value, newKey, ++currentDepth);
        }
        if (value is List) {
          return step(
            _listToMap(value),
            newKey,
            currentDepth + 1,
          );
        }
        result[newKey] = value;
      });
    }

    step(this);

    return result;
  }
}
