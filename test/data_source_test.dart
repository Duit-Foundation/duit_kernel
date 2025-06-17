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

  group("edgeInsets method", () {
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
  });

  group("curve method", () {
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
  });

  group("color conversion methods", () {
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
      expect(
          data.parseColor(key: "color"), const Color.fromRGBO(255, 0, 0, 0.5));
      expect(
          data.parseColor(key: "color2"), const Color.fromRGBO(0, 255, 0, 0.7));
      expect(
          data.parseColor(key: "color3"), const Color.fromRGBO(0, 0, 255, 0.3));
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
  });

  group("duration method", () {
    test("should parse and return duration from int (milliseconds)", () {
      final json = <String, dynamic>{"duration": 1500};
      final data = DuitDataSource(json);
      expect(data.duration(), const Duration(milliseconds: 1500));
      expect(data["duration"], const Duration(milliseconds: 1500));
    });

    test("should return default value if value is null", () {
      final json = <String, dynamic>{};
      final data = DuitDataSource(json);
      expect(data.duration(), Duration.zero);
      expect(data.duration(defaultValue: const Duration(seconds: 2)),
          const Duration(seconds: 2));
      expect(data["duration"], null);
    });

    test("should return instance if value is already a Duration", () {
      final json = <String, dynamic>{"duration": const Duration(seconds: 3)};
      final data = DuitDataSource(json);
      expect(data.duration(), const Duration(seconds: 3));
      expect(data["duration"], const Duration(seconds: 3));
    });
  });

  group("getInt/tryGetInt methods", () {
    test("should parse and return int from num", () {
      final json = <String, dynamic>{"value": 42.7};
      final data = DuitDataSource(json);
      expect(data.getInt(key: "value"), 42);
      expect(data.tryGetInt(key: "value"), 42);
    });

    test("should return default value if value is not num", () {
      final json = <String, dynamic>{"value": "not a number"};
      final data = DuitDataSource(json);
      expect(data.getInt(key: "value", defaultValue: 7), 7);
      expect(data.tryGetInt(key: "value", defaultValue: 8), 8);
    });

    test("should return 0 or null if value and defaultValue are null", () {
      final json = <String, dynamic>{};
      final data = DuitDataSource(json);
      expect(data.getInt(key: "value"), 0);
      expect(data.tryGetInt(key: "value"), null);
    });
  });

  group("getDouble/tryGetDouble methods", () {
    test("should parse and return double from num", () {
      final json = <String, dynamic>{"value": 42};
      final data = DuitDataSource(json);
      expect(data.getDouble(key: "value"), 42.0);
      expect(data.tryGetDouble(key: "value"), 42.0);
    });

    test("should return default value if value is not num", () {
      final json = <String, dynamic>{"value": "not a number"};
      final data = DuitDataSource(json);
      expect(data.getDouble(key: "value", defaultValue: 7.5), 7.5);
      expect(data.tryGetDouble(key: "value", defaultValue: 8.5), 8.5);
    });

    test("should return 0.0 or null if value and defaultValue are null", () {
      final json = <String, dynamic>{};
      final data = DuitDataSource(json);
      expect(data.getDouble(key: "value"), 0.0);
      expect(data.tryGetDouble(key: "value"), null);
    });
  });

  group("getString/tryGetString methods", () {
    test("should return string if value is string", () {
      final json = <String, dynamic>{"value": "hello"};
      final data = DuitDataSource(json);
      expect(data.getString(key: "value"), "hello");
      expect(data.tryGetString("value"), "hello");
    });

    test("should return default value if value is not string", () {
      final json = <String, dynamic>{"value": 123};
      final data = DuitDataSource(json);
      expect(data.getString(key: "value", defaultValue: "default"), "default");
      expect(data.tryGetString("value", defaultValue: "default2"), "default2");
    });

    test(
        "should return empty string or null if value and defaultValue are null",
        () {
      final json = <String, dynamic>{};
      final data = DuitDataSource(json);
      expect(data.getString(key: "value"), "");
      expect(data.tryGetString("value"), null);
    });
  });

  group("getBool/tryGetBool methods", () {
    test("should return bool if value is bool", () {
      final json = <String, dynamic>{"value": true, "value2": false};
      final data = DuitDataSource(json);
      expect(data.getBool("value"), true);
      expect(data.getBool("value2"), false);
      expect(data.tryGetBool("value"), true);
      expect(data.tryGetBool("value2"), false);
    });

    test("should return default value if value is not bool", () {
      final json = <String, dynamic>{"value": "not a bool"};
      final data = DuitDataSource(json);
      expect(data.getBool("value", defaultValue: true), true);
      expect(data.tryGetBool("value", defaultValue: false), false);
    });

    test("should return false or null if value and defaultValue are null", () {
      final json = <String, dynamic>{};
      final data = DuitDataSource(json);
      expect(data.getBool("value"), false);
      expect(data.tryGetBool("value"), null);
    });
  });

  group(
    "textAlign method",
    () {
      test("should parse and return the textAlign", () {
        final json = <String, dynamic>{
          "textAlign": "left",
        };

        final data = DuitDataSource(json);

        expect(data.textAlign(), TextAlign.left);
        expect(data["textAlign"], TextAlign.left);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.textAlign(), TextAlign.start);
        expect(
          data.textAlign(defaultValue: TextAlign.center),
          TextAlign.center,
        );
        expect(data["textAlign"], null);
      });

      test("should return the default value if the value is not a string", () {
        final json = <String, dynamic>{
          "textAlign": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.textAlign(defaultValue: TextAlign.center),
          TextAlign.center,
        );
        expect(data["textAlign"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "textAlign": TextAlign.center,
        };

        final data = DuitDataSource(json);

        expect(data.textAlign(), TextAlign.center);
        expect(data["textAlign"], TextAlign.center);
      });
    },
  );

  group(
    "textOverflow method",
    () {
      test("should parse and return the textOverflow", () {
        final json = <String, dynamic>{
          "textOverflow": "ellipsis",
        };

        final data = DuitDataSource(json);

        expect(data.textOverflow(), TextOverflow.ellipsis);
        expect(data["textOverflow"], TextOverflow.ellipsis);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.textOverflow(), TextOverflow.clip);
        expect(
          data.textOverflow(defaultValue: TextOverflow.ellipsis),
          TextOverflow.ellipsis,
        );
        expect(data["textOverflow"], null);
      });

      test("should return the default value if the value is not a string", () {
        final json = <String, dynamic>{
          "textOverflow": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.textOverflow(defaultValue: TextOverflow.ellipsis),
          TextOverflow.ellipsis,
        );
        expect(data["textOverflow"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "textOverflow": TextOverflow.ellipsis,
        };

        final data = DuitDataSource(json);

        expect(data.textOverflow(), TextOverflow.ellipsis);
        expect(data["textOverflow"], TextOverflow.ellipsis);
      });
    },
  );

  group(
    "textWidthBasis method",
    () {
      test("should parse and return the textWidthBasis", () {
        final json = <String, dynamic>{
          "textWidthBasis": "parent",
        };

        final data = DuitDataSource(json);

        expect(data.textWidthBasis(), TextWidthBasis.parent);
        expect(data["textWidthBasis"], TextWidthBasis.parent);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.textWidthBasis(), TextWidthBasis.parent);
        expect(
          data.textWidthBasis(defaultValue: TextWidthBasis.longestLine),
          TextWidthBasis.longestLine,
        );
        expect(data["textWidthBasis"], null);
      });

      test("should return the default value if the value is not a string", () {
        final json = <String, dynamic>{
          "textWidthBasis": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.textWidthBasis(defaultValue: TextWidthBasis.longestLine),
          TextWidthBasis.longestLine,
        );
        expect(data["textWidthBasis"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "textWidthBasis": TextWidthBasis.longestLine,
        };

        final data = DuitDataSource(json);

        expect(data.textWidthBasis(), TextWidthBasis.longestLine);
        expect(data["textWidthBasis"], TextWidthBasis.longestLine);
      });
    },
  );

  group(
    "textStyle method",
    () {
      test("should parse and return the textStyle from map", () {
        final json = <String, dynamic>{
          "style": {
            "color": "#FF0000",
            "fontSize": 16.0,
            "fontWeight": 700,
          },
        };

        final data = DuitDataSource(json);
        final style = data.textStyle()!;

        expect(style.color, const Color(0xFFFF0000));
        expect(style.fontSize, 16.0);
        expect(style.fontWeight, FontWeight.w700);
        expect(data["style"], style);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);
        const defaultStyle = TextStyle(fontSize: 14.0);

        expect(data.textStyle(), null);
        expect(data.textStyle(defaultValue: defaultStyle), defaultStyle);
        expect(data["style"], null);
      });

      test("should return the default value if the value is not a map", () {
        final json = <String, dynamic>{
          "style": true,
        };

        final data = DuitDataSource(json);
        const defaultStyle = TextStyle(fontSize: 14.0);

        expect(data.textStyle(defaultValue: defaultStyle), defaultStyle);
        expect(data["style"], true);
      });

      test("should return instance if the value is already an instance", () {
        const style = TextStyle(fontSize: 16.0);
        final json = <String, dynamic>{
          "style": style,
        };

        final data = DuitDataSource(json);

        expect(data.textStyle(), style);
        expect(data["style"], style);
      });
    },
  );

  group(
    "offset method",
    () {
      test("should parse and return the offset from map", () {
        final json = <String, dynamic>{
          "offset": {
            "dx": 10.0,
            "dy": 20.0,
          },
        };

        final data = DuitDataSource(json);

        expect(data.offset(), const Offset(10.0, 20.0));
        expect(data["offset"], const Offset(10.0, 20.0));
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);
        const defaultOffset = Offset(5.0, 5.0);

        expect(data.offset(), null);
        expect(data.offset(defaultValue: defaultOffset), defaultOffset);
        expect(data["offset"], null);
      });

      test("should return the default value if the value is not a map", () {
        final json = <String, dynamic>{
          "offset": true,
        };

        final data = DuitDataSource(json);
        const defaultOffset = Offset(5.0, 5.0);

        expect(data.offset(defaultValue: defaultOffset), defaultOffset);
        expect(data["offset"], true);
      });

      test("should return instance if the value is already an instance", () {
        const offset = Offset(10.0, 20.0);
        final json = <String, dynamic>{
          "offset": offset,
        };

        final data = DuitDataSource(json);

        expect(data.offset(), offset);
        expect(data["offset"], offset);
      });
    },
  );

  group(
    "boxShadow method",
    () {
      test("should parse and return the boxShadow from list", () {
        final json = <String, dynamic>{
          "boxShadow": [
            {
              "color": "#FF0000",
              "offset": {"dx": 2.0, "dy": 2.0},
              "blurRadius": 4.0,
              "spreadRadius": 1.0,
            },
            {
              "color": "#0000FF",
              "offset": {"dx": -2.0, "dy": -2.0},
              "blurRadius": 2.0,
              "spreadRadius": 0.0,
            },
          ],
        };

        final data = DuitDataSource(json);
        final shadows = data.boxShadow()!;

        expect(shadows.length, 2);
        expect(shadows[0].color, const Color(0xFFFF0000));
        expect(shadows[0].offset, const Offset(2.0, 2.0));
        expect(shadows[0].blurRadius, 4.0);
        expect(shadows[0].spreadRadius, 1.0);
        expect(shadows[1].color, const Color(0xFF0000FF));
        expect(shadows[1].offset, const Offset(-2.0, -2.0));
        expect(shadows[1].blurRadius, 2.0);
        expect(shadows[1].spreadRadius, 0.0);
        expect(data["boxShadow"], shadows);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};
        const defaultShadows = [
          BoxShadow(
            color: Colors.black,
            offset: Offset(2.0, 2.0),
            blurRadius: 4.0,
          ),
        ];

        final data = DuitDataSource(json);

        expect(data.boxShadow(), null);
        expect(data.boxShadow(defaultValue: defaultShadows), defaultShadows);
        expect(data["boxShadow"], null);
      });

      test("should return the default value if the value is not a list", () {
        final json = <String, dynamic>{
          "boxShadow": true,
        };
        const defaultShadows = [
          BoxShadow(
            color: Colors.black,
            offset: Offset(2.0, 2.0),
            blurRadius: 4.0,
          ),
        ];

        final data = DuitDataSource(json);

        expect(data.boxShadow(defaultValue: defaultShadows), defaultShadows);
        expect(data["boxShadow"], true);
      });

      test("should return instance if the value is already an instance", () {
        const shadows = [
          BoxShadow(
            color: Colors.black,
            offset: Offset(2.0, 2.0),
            blurRadius: 4.0,
          ),
        ];
        final json = <String, dynamic>{
          "boxShadow": shadows,
        };

        final data = DuitDataSource(json);

        expect(data.boxShadow(), shadows);
        expect(data["boxShadow"], shadows);
      });
    },
  );

  group(
    "decoration method",
    () {
      test(
          "should parse and return the decoration from map with all properties",
          () {
        final json = <String, dynamic>{
          "decoration": {
            "color": "#FF0000",
            "borderRadius": 8.0,
            "border": {
              "color": "#000000",
              "width": 2.0,
              "style": "solid",
            },
            "gradient": {
              "colors": ["#FF0000", "#00FF00", "#0000FF"],
              "stops": [0.0, 0.5, 1.0],
              "begin": "centerLeft",
              "end": "centerRight",
              "rotationAngle": 0.5,
            },
            "boxShadow": [
              {
                "color": "#000000",
                "offset": {"dx": 2.0, "dy": 2.0},
                "blurRadius": 4.0,
              },
            ],
          },
        };

        final data = DuitDataSource(json);
        final decoration = data.decoration()!;

        expect(decoration, isA<BoxDecoration>());
        final boxDecoration = decoration as BoxDecoration;

        // Проверяем цвет
        expect(boxDecoration.color, const Color(0xFFFF0000));

        // Проверяем радиус
        expect(boxDecoration.borderRadius, BorderRadius.circular(8.0));

        // Проверяем границу
        expect(boxDecoration.border, isA<Border>());

        // Проверяем градиент
        expect(boxDecoration.gradient, isA<LinearGradient>());
        final gradient = boxDecoration.gradient as LinearGradient;
        expect(gradient.colors, [
          const Color(0xFFFF0000),
          const Color(0xFF00FF00),
          const Color(0xFF0000FF),
        ]);
        expect(gradient.stops, [0.0, 0.5, 1.0]);
        expect(gradient.begin, Alignment.centerLeft);
        expect(gradient.end, Alignment.centerRight);
        expect(gradient.transform, isA<GradientRotation>());
        final transform = gradient.transform as GradientRotation;
        expect(transform, isNotNull);

        // Проверяем тени
        expect(boxDecoration.boxShadow, isNotEmpty);
        expect(boxDecoration.boxShadow![0].color, const Color(0xFF000000));
        expect(boxDecoration.boxShadow![0].offset, const Offset(2.0, 2.0));
        expect(boxDecoration.boxShadow![0].blurRadius, 4.0);

        expect(data["decoration"], decoration);
      });

      test("should parse and return the decoration with minimal properties",
          () {
        final json = <String, dynamic>{
          "decoration": {
            "color": "#FF0000",
            "gradient": {
              "colors": ["#FF0000", "#00FF00"],
            },
          },
        };

        final data = DuitDataSource(json);
        final decoration = data.decoration()!;

        expect(decoration, isA<BoxDecoration>());
        final boxDecoration = decoration as BoxDecoration;

        expect(boxDecoration.color, const Color(0xFFFF0000));
        expect(boxDecoration.gradient, isA<LinearGradient>());
        final gradient = boxDecoration.gradient as LinearGradient;
        expect(gradient.colors, [
          const Color(0xFFFF0000),
          const Color(0xFF00FF00),
        ]);
        expect(gradient.stops, null);
        expect(gradient.begin, Alignment.centerLeft);
        expect(gradient.end, Alignment.centerRight);
        expect(gradient.transform, null);

        expect(data["decoration"], decoration);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};
        const defaultDecoration = BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        );

        final data = DuitDataSource(json);

        expect(data.decoration(), null);
        expect(data.decoration(defaultValue: defaultDecoration),
            defaultDecoration);
        expect(data["decoration"], null);
      });

      test("should return the default value if the value is not a map", () {
        final json = <String, dynamic>{
          "decoration": true,
        };
        const defaultDecoration = BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        );

        final data = DuitDataSource(json);

        expect(data.decoration(defaultValue: defaultDecoration),
            defaultDecoration);
        expect(data["decoration"], true);
      });

      test("should return instance if the value is already an instance", () {
        const decoration = BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        );
        final json = <String, dynamic>{
          "decoration": decoration,
        };

        final data = DuitDataSource(json);

        expect(data.decoration(), decoration);
        expect(data["decoration"], decoration);
      });
    },
  );

  group(
    "textDecoration method",
    () {
      test("should parse and return the textDecoration from string", () {
        final json = <String, dynamic>{
          "decoration": "underline",
        };

        final data = DuitDataSource(json);

        expect(data.textDecoration(), TextDecoration.underline);
        expect(data["decoration"], TextDecoration.underline);
      });

      test("should parse and return the textDecoration from int", () {
        final json = <String, dynamic>{
          "decoration": 1, // TextDecoration.underline
        };

        final data = DuitDataSource(json);

        expect(data.textDecoration(), TextDecoration.underline);
        expect(data["decoration"], TextDecoration.underline);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.textDecoration(), null);
        expect(
          data.textDecoration(defaultValue: TextDecoration.lineThrough),
          TextDecoration.lineThrough,
        );
        expect(data["decoration"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "decoration": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.textDecoration(defaultValue: TextDecoration.lineThrough),
          TextDecoration.lineThrough,
        );
        expect(data["decoration"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "decoration": TextDecoration.underline,
        };

        final data = DuitDataSource(json);

        expect(data.textDecoration(), TextDecoration.underline);
        expect(data["decoration"], TextDecoration.underline);
      });
    },
  );
}
