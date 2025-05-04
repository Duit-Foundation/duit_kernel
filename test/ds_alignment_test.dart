import 'package:duit_kernel/src/view_attributes/data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    "Alignment parsing",
    () {
      final attrs = DuitDataSource({
        "alignment": "center",
      });

      expect(attrs["alignment"], isA<String>());

      final align = attrs.alignment();
      expect(align, Alignment.center);
      expect(attrs["alignment"], Alignment.center);
    },
  );

  test(
    "Alignment source rewrite",
    () {
      final attrs = DuitDataSource({
        "alignment": "center",
      });

      attrs.alignment();

      expect(attrs["alignment"], isA<Alignment>());

      attrs["alignment"] = "invalid_value";

      expect(attrs["alignment"], isA<String>());

      attrs.alignment();

      expect(attrs["alignment"], isNull);
    },
  );
}
