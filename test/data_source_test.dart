import 'package:duit_kernel/duit_kernel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "textDirection",
    () {
      test("should parse and return the textDirection", () {
        final json = <String, dynamic>{
          "textDirection": "ltr",
          "textDirection2": 0,
        };

        final data = DuitDataSource(json);

        expect(data.textDirection(), TextDirection.ltr);
        expect(data.textDirection(key: "textDirection2"), TextDirection.ltr);
        expect(data["textDirection"], TextDirection.ltr);
        expect(data["textDirection2"], TextDirection.ltr);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.textDirection(), null);
        expect(
          data.textDirection(defaultValue: TextDirection.rtl),
          TextDirection.rtl,
        );
        expect(data["textDirection"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "textDirection": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.textDirection(defaultValue: TextDirection.rtl),
          TextDirection.rtl,
        );
        expect(data["textDirection"], true);
      });

      test(
        "should return instance if the value is already an instance",
        () {
          final json = <String, dynamic>{
            "textDirection": TextDirection.ltr,
          };

          final data = DuitDataSource(json);

          expect(data.textDirection(), TextDirection.ltr);
          expect(data["textDirection"], TextDirection.ltr);
        },
      );
    },
  );
  group(
    "textBaseline method",
    () {
      test(
        "should parse and return the textBaseline",
        () {
          final json = <String, dynamic>{
            "textBaseline": "alphabetic",
            "textBaseline2": 0,
          };

          final data = DuitDataSource(json);

          expect(data.textBaseline(), TextBaseline.alphabetic);
          expect(
            data.textBaseline(key: "textBaseline2"),
            TextBaseline.alphabetic,
          );
          expect(data["textBaseline"], TextBaseline.alphabetic);
          expect(data["textBaseline2"], TextBaseline.alphabetic);
        },
      );

      test(
        "should return the default value if the value is null",
        () {
          final json = <String, dynamic>{};

          final data = DuitDataSource(json);

          expect(data.textBaseline(), null);
          expect(
            data.textBaseline(defaultValue: TextBaseline.alphabetic),
            TextBaseline.alphabetic,
          );
          expect(data["textBaseline"], null);
        },
      );

      test(
        "should return the default value if the value is not a string or int",
        () {
          final json = <String, dynamic>{
            "textBaseline": true,
          };

          final data = DuitDataSource(json);

          expect(
            data.textBaseline(defaultValue: TextBaseline.ideographic),
            TextBaseline.ideographic,
          );
          expect(data["textBaseline"], true);
        },
      );

      test(
        "should return instance if the value is already an instance",
        () {
          final json = <String, dynamic>{
            "textBaseline": TextBaseline.alphabetic,
          };

          final data = DuitDataSource(json);

          expect(data.textBaseline(), TextBaseline.alphabetic);
          expect(data["textBaseline"], TextBaseline.alphabetic);
        },
      );
    },
  );
  group(
    "clipBehavior method",
    () {
      test("should parse and return the clipBehavior", () {
        final json = <String, dynamic>{
          "clipBehavior": "antiAlias",
          "clipBehavior2": 0,
        };

        final data = DuitDataSource(json);

        expect(data.clipBehavior(), Clip.antiAlias);
        expect(data.clipBehavior(key: "clipBehavior2"), Clip.hardEdge);
        expect(data["clipBehavior"], Clip.antiAlias);
        expect(data["clipBehavior2"], Clip.hardEdge);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.clipBehavior(), Clip.hardEdge);
        expect(
          data.clipBehavior(defaultValue: Clip.antiAlias),
          Clip.antiAlias,
        );
        expect(data["clipBehavior"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "clipBehavior": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.clipBehavior(defaultValue: Clip.antiAlias),
          Clip.antiAlias,
        );
        expect(data["clipBehavior"], true);
      });

      test(
        "should return instance if the value is already an instance",
        () {
          final json = <String, dynamic>{
            "clipBehavior": Clip.antiAlias,
          };

          final data = DuitDataSource(json);

          expect(data.clipBehavior(), Clip.antiAlias);
          expect(data["clipBehavior"], Clip.antiAlias);
        },
      );
    },
  );
  group(
    "size method",
    () {
      test("should parse and return size from map", () {
        final json = <String, dynamic>{
          "size": {
            "width": 100.0,
            "height": 200.0,
          },
        };

        final data = DuitDataSource(json);

        expect(data.size("size"), const Size(100.0, 200.0));
        expect(data["size"], const Size(100.0, 200.0));
      });

      test("should parse and return size from list", () {
        final json = <String, dynamic>{
          "size": [100.0, 200.0],
        };

        final data = DuitDataSource(json);

        expect(data.size("size"), const Size(100.0, 200.0));
        expect(data["size"], const Size(100.0, 200.0));
      });

      test("should create square size from single number", () {
        final json = <String, dynamic>{
          "size": 100.0,
        };

        final data = DuitDataSource(json);

        expect(data.size("size"), const Size(100.0, 100.0));
        expect(data["size"], const Size(100.0, 100.0));
      });

      test("should return default value if value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.size("size"), Size.zero);
        expect(
          data.size("size", defaultValue: const Size(50.0, 50.0)),
          const Size(50.0, 50.0),
        );
        expect(data["size"], null);
      });

      test("should return instance if value is already an instance", () {
        final json = <String, dynamic>{
          "size": const Size(100.0, 200.0),
        };

        final data = DuitDataSource(json);

        expect(data.size("size"), const Size(100.0, 200.0));
        expect(data["size"], const Size(100.0, 200.0));
      });
    },
  );

  group(
    "edgeInsets method",
    () {
      test("should parse and return edgeInsets from list with 2 values", () {
        final json = <String, dynamic>{
          "padding": [10.0, 20.0],
        };

        final data = DuitDataSource(json);

        expect(
          data.edgeInsets(),
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        );
        expect(
          data["padding"],
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        );
      });

      test("should parse and return edgeInsets from list with 4 values", () {
        final json = <String, dynamic>{
          "padding": [10.0, 20.0, 30.0, 40.0],
        };

        final data = DuitDataSource(json);

        expect(
          data.edgeInsets(),
          const EdgeInsets.only(
            left: 10.0,
            top: 20.0,
            right: 30.0,
            bottom: 40.0,
          ),
        );
        expect(
          data["padding"],
          const EdgeInsets.only(
            left: 10.0,
            top: 20.0,
            right: 30.0,
            bottom: 40.0,
          ),
        );
      });

      test("should create all edgeInsets from single number", () {
        final json = <String, dynamic>{
          "padding": 10.0,
        };

        final data = DuitDataSource(json);

        expect(data.edgeInsets(), const EdgeInsets.all(10.0));
        expect(data["padding"], const EdgeInsets.all(10.0));
      });

      test("should return default value if value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.edgeInsets(), null);
        expect(
          data.edgeInsets(defaultValue: const EdgeInsets.all(10.0)),
          const EdgeInsets.all(10.0),
        );
        expect(data["padding"], null);
      });

      test("should return instance if value is already an instance", () {
        final json = <String, dynamic>{
          "padding": const EdgeInsets.all(10.0),
        };

        final data = DuitDataSource(json);

        expect(data.edgeInsets(), const EdgeInsets.all(10.0));
        expect(data["padding"], const EdgeInsets.all(10.0));
      });
    },
  );

  group(
    "curve method",
    () {
      test("should parse and return curve from string", () {
        final json = <String, dynamic>{
          "curve": "ease",
        };

        final data = DuitDataSource(json);

        expect(data.curve(), Curves.ease);
        expect(data["curve"], Curves.ease);
      });

      test("should parse and return curve from int", () {
        final json = <String, dynamic>{
          "curve": 0,
        };

        final data = DuitDataSource(json);

        expect(data.curve(), Curves.linear);
        expect(data["curve"], Curves.linear);
      });

      test("should return default value if value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.curve(), Curves.linear);
        expect(
          data.curve(defaultValue: Curves.easeInOut),
          Curves.easeInOut,
        );
        expect(data["curve"], null);
      });

      test("should return default value if value is not a string or int", () {
        final json = <String, dynamic>{
          "curve": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.curve(defaultValue: Curves.easeInOut),
          Curves.easeInOut,
        );
        expect(data["curve"], true);
      });

      test("should return instance if value is already an instance", () {
        final json = <String, dynamic>{
          "curve": Curves.easeInOut,
        };

        final data = DuitDataSource(json);

        expect(data.curve(), Curves.easeInOut);
        expect(data["curve"], Curves.easeInOut);
      });
    },
  );

  group(
    "color conversion methods",
    () {
      test("should parse hex color string", () {
        final json = <String, dynamic>{
          "color": "#FF0000",
          "color2": "#00FF00",
        };

        final data = DuitDataSource(json);

        expect(data.parseColor(key: "color"), const Color(0xFFFF0000));
        expect(data.parseColor(key: "color2"), const Color(0xFF00FF00));
      });

      test("should parse color from RGB list", () {
        final json = <String, dynamic>{
          "color": [255, 0, 0],
          "color2": [0, 255, 0],
          "color3": [0, 0, 255],
        };

        final data = DuitDataSource(json);

        expect(data.parseColor(key: "color"), const Color(0xFFFF0000));
        expect(data.parseColor(key: "color2"), const Color(0xFF00FF00));
        expect(data.parseColor(key: "color3"), const Color(0xFF0000FF));
      });

      test("should parse color from RGBA list", () {
        final json = <String, dynamic>{
          "color": [255, 0, 0, 0.5],
          "color2": [0, 255, 0, 0.7],
          "color3": [0, 0, 255, 0.3],
        };

        final data = DuitDataSource(json);
        expect(data.parseColor(key: "color"),
            const Color.fromRGBO(255, 0, 0, 0.5));
        expect(data.parseColor(key: "color2"),
            const Color.fromRGBO(0, 255, 0, 0.7));
        expect(data.parseColor(key: "color3"),
            const Color.fromRGBO(0, 0, 255, 0.3));
      });

      test("should return default value for invalid hex color", () {
        final json = <String, dynamic>{
          "color": "123123",
        };

        final data = DuitDataSource(json);

        expect(data.parseColor(key: "color"), Colors.transparent);
      });

      test("should return default value for invalid RGB list", () {
        final json = <String, dynamic>{
          "color": [255],
          "color2": [255, 0],
          "color3": [255, 0, 0, 0.5, 0],
        };

        final data = DuitDataSource(json);

        expect(data.parseColor(key: "color"), Colors.transparent);
        expect(data.parseColor(key: "color2"), Colors.transparent);
        expect(data.parseColor(key: "color3"), Colors.transparent);
      });

      test("should return default value if value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.parseColor(), Colors.transparent);
        expect(data.parseColor(key: "nonExistentKey"), Colors.transparent);
      });

      test("should return instance if value is already a Color", () {
        final json = <String, dynamic>{
          "color": Colors.red,
        };

        final data = DuitDataSource(json);

        expect(data.parseColor(), Colors.red);
        expect(data["color"], Colors.red);
      });

      test("should handle tryParseColor method", () {
        final json = <String, dynamic>{
          "color": "#FF0000",
          "color2": [255, 0, 0],
          "color3": "invalid",
        };

        final data = DuitDataSource(json);

        expect(data.tryParseColor(key: "color"), const Color(0xFFFF0000));
        expect(data.tryParseColor(key: "color2"), const Color(0xFFFF0000));
        expect(data.tryParseColor(key: "color3"), null);
        expect(data.tryParseColor(key: "color4"), null);
      });
    },
  );
}
