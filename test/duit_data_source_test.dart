import 'package:duit_kernel/duit_kernel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("FontWeight", () {
    final attrs = DuitDataSource({
      "fontWeight": 700,
    });

    expect(attrs.fontWeight(), FontWeight.w700);

    attrs["fontWeight"] = 400;

    expect(attrs.fontWeight(), FontWeight.w400);
  });
  test(
    "Align test",
    () {
      final attrs = DuitDataSource({
        "alignment": "center",
        "widthFactor": 0.5,
      });

      expect(attrs["alignment"], isA<String>());

      final align = attrs.alignment(),
          factor = attrs.tryGetDouble(
            key: "widthFactor",
          );
      expect(align, Alignment.center);
      expect(factor, 0.5);
      expect(attrs["alignment"], Alignment.center);

      final idAlign = identityHashCode(align);

      final upd = <String, dynamic>{
        "widthFactor": 0.5,
      };

      attrs.addAll(upd);

      final align2 = attrs.alignment();
      expect(identityHashCode(align2), idAlign);

      final defaultValue = attrs.alignment(
        key: "alignment_invalid",
        defaultValue: Alignment.topLeft,
      );

      expect(defaultValue, Alignment.topLeft);

      final defaultValueNull = attrs.alignment(
        key: "alignment_invalid_2",
      );

      expect(defaultValueNull, isNull);
    },
  );

  test('Size test', () {
    final json = {
      "min": {
        "width": 10,
        "height": 20,
      },
      "max": [
        10,
        20,
      ],
      "value": const Size(
        200,
        200,
      ),
    };

    final source = DuitDataSource(json);

    final size1 = source.size("min");
    final size2 = source.size("max");
    final size3 = source.size(
      "size",
      defaultValue: const Size(100, 100),
    );
    final size4 = source.size("value");

    expect(size1, const Size(10, 20));
    expect(size2, const Size(10, 20));
    expect(size3, const Size(100, 100));
    expect(size4, const Size(200, 200));
  });

  test(
    "EdgeInsets test",
    () {
      final json = {
        "all": 12.0,
        "symmetric": [12.0, 12.0],
        "only": [
          12.0,
          12.0,
          12.0,
          12.0,
        ],
      };

      final source = DuitDataSource(json);

      final padding1 = source.edgeInsets(key: "all");
      final padding2 = source.edgeInsets(key: "symmetric");
      final padding3 = source.edgeInsets(key: "only");

      expect(
        padding1,
        const EdgeInsets.all(12.0),
      );
      expect(
        padding2,
        const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 12.0,
        ),
      );
      expect(
        padding3,
        const EdgeInsets.only(
          left: 12.0,
          top: 12.0,
          right: 12.0,
          bottom: 12.0,
        ),
      );
    },
  );
}
