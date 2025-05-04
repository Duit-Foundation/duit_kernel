import 'package:duit_kernel/src/view_attributes/data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    "Color parsing",
    () {
      final attrs = DuitDataSource({
        "color": "#DCDCDC",
        "colorInst": Colors.amber,
        "colList": [
          255,
          0,
          0,
        ],
        "colList2": [
          255,
          0,
          0,
          0.0,
        ],
      });

      final color = attrs.parseColor();
      final defaultColorValue = attrs.parseColor(
        key: "color1",
        defaultValue: Colors.black,
      );
      final defaultColorValue2 = attrs.parseColor(
        key: "color2",
      );
      final nullableColor = attrs.tryParseColor(key: "color3");

      final listColor = attrs.parseColor(key: "colList");
      final listColor2 = attrs.parseColor(key: "colList2");
      final inst = attrs.parseColor(key: "colorInst");

      expect(color, const Color(0xffdcdcdc));
      expect(defaultColorValue, const Color(0xff000000));
      expect(defaultColorValue2, Colors.transparent);
      expect(nullableColor, isNull);
      expect(listColor, const Color(0xffff0000));
      expect(listColor.opacity, 1.0);
      expect(listColor2.opacity, 0);
      expect(inst, Colors.amber);
    },
  );

  test(
    "Color source rewrite",
    () {
      final attrs = DuitDataSource({
        "color": "#DCDCDC",
      });

      expect(attrs["color"], isA<String>());

      attrs.parseColor();

      expect(attrs["color"], isA<Color>());

      attrs["color"] = [255, 0, 0];

      expect(attrs["color"], isA<List>());

      attrs.parseColor();

      expect(attrs["color"], isA<Color>());
    },
  );
}
