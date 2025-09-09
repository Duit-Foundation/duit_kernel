import 'package:duit_kernel/duit_kernel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'dart:ui';

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

      test(
          "should parse and return size from map with value and horizontal mainAxis",
          () {
        final json = <String, dynamic>{
          "size": {
            "value": 100.0,
            "mainAxis": "horizontal",
          },
        };

        final data = DuitDataSource(json);

        expect(data.size("size"), const Size.fromWidth(100.0));
        expect(data["size"], const Size.fromWidth(100.0));
      });

      test(
          "should parse and return size from map with value and vertical mainAxis",
          () {
        final json = <String, dynamic>{
          "size": {
            "value": 100.0,
            "mainAxis": "vertical",
          },
        };

        final data = DuitDataSource(json);

        expect(data.size("size"), const Size.fromHeight(100.0));
        expect(data["size"], const Size.fromHeight(100.0));
      });

      test(
          "should parse and return size from map with value and mainAxis as int (horizontal)",
          () {
        final json = <String, dynamic>{
          "size": <String, dynamic>{
            "value": 150.0,
            "mainAxis": 1, // 1 = Axis.horizontal
          },
        };

        final data = DuitDataSource(json);

        expect(data.size("size"), const Size.fromWidth(150.0));
      });

      test(
          "should parse and return size from map with value and mainAxis as int (vertical)",
          () {
        final json = <String, dynamic>{
          "size": <String, dynamic>{
            "value": 120.0,
            "mainAxis": 0, // 0 = Axis.vertical
          },
        };

        final data = DuitDataSource(json);

        expect(data.size("size"), const Size.fromHeight(120.0));
      });

      test("should return Size.zero for unknown map format", () {
        final json = <String, dynamic>{
          "size": {
            "unknown": "value",
          },
        };

        final data = DuitDataSource(json);

        expect(data.size("size"), Size.zero);
        expect(data["size"], Size.zero);
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
        data.curve(defaultValue: Curves.easeIn),
        Curves.easeIn,
      );
      expect(data["curve"], null);
    });

    test("should return default value if value is not a string or int", () {
      final json = <String, dynamic>{
        "curve": true,
      };

      final data = DuitDataSource(json);

      expect(
        data.curve(defaultValue: Curves.easeIn),
        Curves.easeIn,
      );
      expect(data["curve"], true);
    });

    test("should return instance if value is already an instance", () {
      final json = <String, dynamic>{
        "curve": Curves.easeIn,
      };

      final data = DuitDataSource(json);

      expect(data.curve(), Curves.easeIn);
      expect(data["curve"], Curves.easeIn);
    });
  });

  group("color conversion methods", () {
    test("should parse hex color string", () {
      final json = <String, dynamic>{
        "color": "#FF0000",
        "color2": [0, 255, 0],
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
          "textAlign2": 0,
        };

        final data = DuitDataSource(json);

        expect(data.textAlign(), TextAlign.left);
        expect(data["textAlign"], TextAlign.left);
        expect(data.textAlign(key: "textAlign2"), TextAlign.left);
        expect(data["textAlign2"], TextAlign.left);
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
      test("should parse and return the textOverflow from string", () {
        final json = <String, dynamic>{
          "textOverflow": "ellipsis",
          "textOverflow2": "fade",
        };

        final data = DuitDataSource(json);

        expect(data.textOverflow(), TextOverflow.ellipsis);
        expect(data.textOverflow(key: "textOverflow2"), TextOverflow.fade);
        expect(data["textOverflow"], TextOverflow.ellipsis);
        expect(data["textOverflow2"], TextOverflow.fade);
      });

      test("should parse and return the textOverflow from int", () {
        final json = <String, dynamic>{
          "textOverflow": 0,
          "textOverflow2": 1,
          "textOverflow3": 2,
          "textOverflow4": 3,
        };

        final data = DuitDataSource(json);

        expect(data.textOverflow(), TextOverflow.clip);
        expect(data.textOverflow(key: "textOverflow2"), TextOverflow.ellipsis);
        expect(data.textOverflow(key: "textOverflow3"), TextOverflow.fade);
        expect(data.textOverflow(key: "textOverflow4"), TextOverflow.visible);
        expect(data["textOverflow"], TextOverflow.clip);
        expect(data["textOverflow2"], TextOverflow.ellipsis);
        expect(data["textOverflow3"], TextOverflow.fade);
        expect(data["textOverflow4"], TextOverflow.visible);
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

      test(
          "should return the default value if the value is not a string or int",
          () {
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

      test("should handle unknown string values", () {
        final json = <String, dynamic>{
          "textOverflow": "unknownValue",
        };

        final data = DuitDataSource(json);

        expect(data.textOverflow(), null);
        expect(data["textOverflow"], null);
      });

      test("should handle unknown int values", () {
        final json = <String, dynamic>{
          "textOverflow": 999,
        };

        final data = DuitDataSource(json);

        expect(data.textOverflow(), null);
        expect(data["textOverflow"], null);
      });
    },
  );

  group(
    "textWidthBasis method",
    () {
      test("should parse and return the textWidthBasis", () {
        final json = <String, dynamic>{
          "textWidthBasis": "parent",
          "textWidthBasis2": 0,
        };

        final data = DuitDataSource(json);

        expect(data.textWidthBasis(), TextWidthBasis.parent);
        expect(data["textWidthBasis"], TextWidthBasis.parent);
        expect(
            data.textWidthBasis(key: "textWidthBasis2"), TextWidthBasis.parent);
        expect(data["textWidthBasis2"], TextWidthBasis.parent);
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

  group(
    "textDecorationStyle method",
    () {
      test("should parse and return the textDecorationStyle from string", () {
        final json = <String, dynamic>{
          "decorationStyle": "solid",
        };

        final data = DuitDataSource(json);

        expect(data.textDecorationStyle(), TextDecorationStyle.solid);
        expect(data["decorationStyle"], TextDecorationStyle.solid);
      });

      test("should parse and return the textDecorationStyle from int", () {
        final json = <String, dynamic>{
          "decorationStyle": 0, // TextDecorationStyle.solid
        };

        final data = DuitDataSource(json);

        expect(data.textDecorationStyle(), TextDecorationStyle.solid);
        expect(data["decorationStyle"], TextDecorationStyle.solid);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.textDecorationStyle(), null);
        expect(
          data.textDecorationStyle(defaultValue: TextDecorationStyle.dashed),
          TextDecorationStyle.dashed,
        );
        expect(data["decorationStyle"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "decorationStyle": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.textDecorationStyle(defaultValue: TextDecorationStyle.dashed),
          TextDecorationStyle.dashed,
        );
        expect(data["decorationStyle"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "decorationStyle": TextDecorationStyle.dashed,
        };

        final data = DuitDataSource(json);

        expect(data.textDecorationStyle(), TextDecorationStyle.dashed);
        expect(data["decorationStyle"], TextDecorationStyle.dashed);
      });
    },
  );

  group(
    "fontWeight method",
    () {
      test("should parse and return the fontWeight from string", () {
        final json = <String, dynamic>{
          "fontWeight": 700,
        };

        final data = DuitDataSource(json);

        expect(data.fontWeight(), FontWeight.bold);
        expect(data["fontWeight"], FontWeight.bold);
      });

      test("should parse and return the fontWeight from int", () {
        final json = <String, dynamic>{
          "fontWeight": 700, // FontWeight.bold
        };

        final data = DuitDataSource(json);

        expect(data.fontWeight(), FontWeight.bold);
        expect(data["fontWeight"], FontWeight.bold);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.fontWeight(), null);
        expect(
          data.fontWeight(defaultValue: FontWeight.w500),
          FontWeight.w500,
        );
        expect(data["fontWeight"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "fontWeight": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.fontWeight(defaultValue: FontWeight.w500),
          FontWeight.w500,
        );
        expect(data["fontWeight"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "fontWeight": FontWeight.w500,
        };

        final data = DuitDataSource(json);

        expect(data.fontWeight(), FontWeight.w500);
        expect(data["fontWeight"], FontWeight.w500);
      });
    },
  );

  group(
    "fontStyle method",
    () {
      test("should parse and return the fontStyle from string", () {
        final json = <String, dynamic>{
          "fontStyle": "italic",
        };

        final data = DuitDataSource(json);

        expect(data.fontStyle(), FontStyle.italic);
        expect(data["fontStyle"], FontStyle.italic);
      });

      test("should parse and return the fontStyle from int", () {
        final json = <String, dynamic>{
          "fontStyle": 1, // FontStyle.italic
        };

        final data = DuitDataSource(json);

        expect(data.fontStyle(), FontStyle.italic);
        expect(data["fontStyle"], FontStyle.italic);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.fontStyle(), null);
        expect(
          data.fontStyle(defaultValue: FontStyle.italic),
          FontStyle.italic,
        );
        expect(data["fontStyle"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "fontStyle": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.fontStyle(defaultValue: FontStyle.italic),
          FontStyle.italic,
        );
        expect(data["fontStyle"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "fontStyle": FontStyle.italic,
        };

        final data = DuitDataSource(json);

        expect(data.fontStyle(), FontStyle.italic);
        expect(data["fontStyle"], FontStyle.italic);
      });
    },
  );

  group(
    "textSpan method",
    () {
      test("should parse and return the textSpan from map", () {
        final json = <String, dynamic>{
          "textSpan": {
            "text": "Hello",
            "style": {
              "color": "#FF0000",
              "fontSize": 16.0,
            },
            "children": [
              {
                "text": " World",
                "style": {
                  "color": "#0000FF",
                  "fontSize": 14.0,
                },
              },
            ],
          },
        };

        final data = DuitDataSource(json);
        final textSpan = data.textSpan();

        expect(textSpan.text, "Hello");
        expect(textSpan.style!.color, const Color(0xFFFF0000));
        expect(textSpan.style!.fontSize, 16.0);
        expect(textSpan.children!.length, 1);
        expect(data["textSpan"], textSpan);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};
        const defaultTextSpan = TextSpan(
          text: "Default",
          style: TextStyle(fontSize: 14.0),
        );

        final data = DuitDataSource(json);

        expect(data.textSpan(), const TextSpan());
        expect(data.textSpan(defaultValue: defaultTextSpan), defaultTextSpan);
        expect(data["textSpan"], null);
      });

      test("should return the default value if the value is not a map", () {
        final json = <String, dynamic>{
          "textSpan": true,
        };
        const defaultTextSpan = TextSpan(
          text: "Default",
          style: TextStyle(fontSize: 14.0),
        );

        final data = DuitDataSource(json);

        expect(data.textSpan(defaultValue: defaultTextSpan), defaultTextSpan);
        expect(data["textSpan"], true);
      });

      test("should return instance if the value is already an instance", () {
        const textSpan = TextSpan(
          text: "Hello",
          style: TextStyle(fontSize: 16.0),
        );
        final json = <String, dynamic>{
          "textSpan": textSpan,
        };

        final data = DuitDataSource(json);

        expect(data.textSpan(), textSpan);
        expect(data["textSpan"], textSpan);
      });
    },
  );

  group(
    "textHeightBehavior method",
    () {
      test("should parse and return the textHeightBehavior from map", () {
        final json = <String, dynamic>{
          "textHeightBehavior": {
            "leadingDistribution": "even",
            "applyHeightToFirstAscent": true,
            "applyHeightToLastDescent": false,
          },
        };

        final data = DuitDataSource(json);
        final behavior = data.textHeightBehavior()!;

        expect(behavior.leadingDistribution, TextLeadingDistribution.even);
        expect(behavior.applyHeightToFirstAscent, true);
        expect(behavior.applyHeightToLastDescent, false);
        expect(data["textHeightBehavior"], behavior);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};
        const defaultBehavior = TextHeightBehavior(
          leadingDistribution: TextLeadingDistribution.even,
        );

        final data = DuitDataSource(json);

        expect(data.textHeightBehavior(), null);
        expect(data.textHeightBehavior(defaultValue: defaultBehavior),
            defaultBehavior);
        expect(data["textHeightBehavior"], null);
      });

      test("should return the default value if the value is not a map", () {
        final json = <String, dynamic>{
          "textHeightBehavior": true,
        };
        const defaultBehavior = TextHeightBehavior(
          leadingDistribution: TextLeadingDistribution.even,
        );

        final data = DuitDataSource(json);

        expect(data.textHeightBehavior(defaultValue: defaultBehavior),
            defaultBehavior);
        expect(data["textHeightBehavior"], true);
      });

      test("should return instance if the value is already an instance", () {
        const behavior = TextHeightBehavior(
          leadingDistribution: TextLeadingDistribution.even,
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: false,
        );
        final json = <String, dynamic>{
          "textHeightBehavior": behavior,
        };

        final data = DuitDataSource(json);

        expect(data.textHeightBehavior(), behavior);
        expect(data["textHeightBehavior"], behavior);
      });
    },
  );

  group(
    "textScaler method",
    () {
      test("should parse and return the textScaler from map", () {
        final json = <String, dynamic>{
          "textScaler": {
            "textScaleFactor": 1.5,
          },
          "textScaler2": 1.5,
        };

        final data = DuitDataSource(json);
        final scaler = data.textScaler();

        expect(scaler, const TextScaler.linear(1.5));
        expect(data["textScaler"], scaler);
        expect(data.textScaler(key: "textScaler2"), scaler);
        expect(data["textScaler2"], scaler);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};
        const defaultScaler = TextScaler.linear(1.2);

        final data = DuitDataSource(json);

        expect(data.textScaler(), TextScaler.noScaling);
        expect(data.textScaler(defaultValue: defaultScaler), defaultScaler);
        expect(data["textScaler"], null);
      });

      test("should return the default value if the value is not a map", () {
        final json = <String, dynamic>{
          "textScaler": true,
        };
        const defaultScaler = TextScaler.linear(1.2);

        final data = DuitDataSource(json);

        expect(data.textScaler(defaultValue: defaultScaler), defaultScaler);
        expect(data["textScaler"], true);
      });

      test("should return instance if the value is already an instance", () {
        const scaler = TextScaler.linear(1.5);
        final json = <String, dynamic>{
          "textScaler": scaler,
        };

        final data = DuitDataSource(json);

        expect(data.textScaler(), scaler);
        expect(data["textScaler"], scaler);
      });
    },
  );

  group(
    "strutStyle method",
    () {
      test("should parse and return the strutStyle from map", () {
        final json = <String, dynamic>{
          "strutStyle": {
            "fontSize": 16.0,
            "height": 1.5,
            "leading": 0.5,
            "fontWeight": 700,
            "fontStyle": "italic",
            "forceStrutHeight": true,
            "leadingDistribution": "even",
          },
        };

        final data = DuitDataSource(json);
        final style = data.strutStyle()!;

        expect(style.fontSize, 16.0);
        expect(style.height, 1.5);
        expect(style.leading, 0.5);
        expect(style.fontWeight, FontWeight.w700);
        expect(style.fontStyle, FontStyle.italic);
        expect(style.forceStrutHeight, true);
        expect(style.leadingDistribution, TextLeadingDistribution.even);
        expect(data["strutStyle"], style);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};
        const defaultStyle = StrutStyle(fontSize: 14.0);

        final data = DuitDataSource(json);

        expect(data.strutStyle(), null);
        expect(data.strutStyle(defaultValue: defaultStyle), defaultStyle);
        expect(data["strutStyle"], null);
      });

      test("should return the default value if the value is not a map", () {
        final json = <String, dynamic>{
          "strutStyle": true,
        };
        const defaultStyle = StrutStyle(fontSize: 14.0);

        final data = DuitDataSource(json);

        expect(data.strutStyle(defaultValue: defaultStyle), defaultStyle);
        expect(data["strutStyle"], true);
      });

      test("should return instance if the value is already an instance", () {
        const style = StrutStyle(fontSize: 16.0);
        final json = <String, dynamic>{
          "strutStyle": style,
        };

        final data = DuitDataSource(json);

        expect(data.strutStyle(), style);
        expect(data["strutStyle"], style);
      });
    },
  );

  group(
    "textLeadingDistribution method",
    () {
      test("should parse and return the textLeadingDistribution from string",
          () {
        final json = <String, dynamic>{
          "leadingDistribution": "even",
        };

        final data = DuitDataSource(json);

        expect(data.textLeadingDistribution(), TextLeadingDistribution.even);
        expect(data["leadingDistribution"], TextLeadingDistribution.even);
      });

      test("should parse and return the textLeadingDistribution from int", () {
        final json = <String, dynamic>{
          "leadingDistribution": 1,
        };

        final data = DuitDataSource(json);

        expect(data.textLeadingDistribution(), TextLeadingDistribution.even);
        expect(data["leadingDistribution"], TextLeadingDistribution.even);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.textLeadingDistribution(), null);
        expect(
          data.textLeadingDistribution(
              defaultValue: TextLeadingDistribution.even),
          TextLeadingDistribution.even,
        );
        expect(data["leadingDistribution"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "leadingDistribution": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.textLeadingDistribution(
              defaultValue: TextLeadingDistribution.even),
          TextLeadingDistribution.even,
        );
        expect(data["leadingDistribution"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "leadingDistribution": TextLeadingDistribution.even,
        };

        final data = DuitDataSource(json);

        expect(data.textLeadingDistribution(), TextLeadingDistribution.even);
        expect(data["leadingDistribution"], TextLeadingDistribution.even);
      });
    },
  );

  group(
    "axis method",
    () {
      test("should parse and return the axis from string", () {
        final json = <String, dynamic>{
          "scrollDirection": "horizontal",
        };

        final data = DuitDataSource(json);

        expect(data.axis(), Axis.horizontal);
        expect(data["scrollDirection"], Axis.horizontal);
      });

      test("should parse and return the axis from int", () {
        final json = <String, dynamic>{
          "scrollDirection": 1,
        };

        final data = DuitDataSource(json);

        expect(data.axis(), Axis.horizontal);
        expect(data["scrollDirection"], Axis.horizontal);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.axis(), Axis.vertical);
        expect(
          data.axis(defaultValue: Axis.vertical),
          Axis.vertical,
        );
        expect(data["scrollDirection"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "scrollDirection": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.axis(defaultValue: Axis.vertical),
          Axis.vertical,
        );
        expect(data["scrollDirection"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "scrollDirection": Axis.vertical,
        };

        final data = DuitDataSource(json);

        expect(data.axis(), Axis.vertical);
        expect(data["scrollDirection"], Axis.vertical);
      });
    },
  );

  group(
    "wrapCrossAlignment method",
    () {
      test("should parse and return the wrapCrossAlignment from string", () {
        final json = <String, dynamic>{
          "crossAxisAlignment": "start",
          "crossAxisAlignment2": 0,
        };

        final data = DuitDataSource(json);

        expect(data.wrapCrossAlignment(), WrapCrossAlignment.start);
        expect(data["crossAxisAlignment"], WrapCrossAlignment.start);
        expect(data.wrapCrossAlignment(key: "crossAxisAlignment2"),
            WrapCrossAlignment.start);
        expect(data["crossAxisAlignment2"], WrapCrossAlignment.start);
      });

      test("should parse and return the wrapCrossAlignment from int", () {
        final json = <String, dynamic>{
          "crossAxisAlignment": 0, // WrapCrossAlignment.start
        };

        final data = DuitDataSource(json);

        expect(data.wrapCrossAlignment(), WrapCrossAlignment.start);
        expect(data["crossAxisAlignment"], WrapCrossAlignment.start);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.wrapCrossAlignment(), null);
        expect(
          data.wrapCrossAlignment(defaultValue: WrapCrossAlignment.center),
          WrapCrossAlignment.center,
        );
        expect(data["crossAxisAlignment"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "crossAxisAlignment": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.wrapCrossAlignment(defaultValue: WrapCrossAlignment.center),
          WrapCrossAlignment.center,
        );
        expect(data["crossAxisAlignment"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "crossAxisAlignment": WrapCrossAlignment.center,
        };

        final data = DuitDataSource(json);

        expect(data.wrapCrossAlignment(), WrapCrossAlignment.center);
        expect(data["crossAxisAlignment"], WrapCrossAlignment.center);
      });
    },
  );

  group(
    "wrapAlignment method",
    () {
      test("should parse and return the wrapAlignment from string", () {
        final json = <String, dynamic>{
          "alignment": "start",
        };

        final data = DuitDataSource(json);

        expect(data.wrapAlignment(), WrapAlignment.start);
        expect(data["alignment"], WrapAlignment.start);
      });

      test("should parse and return the wrapAlignment from int", () {
        final json = <String, dynamic>{
          "alignment": 0, // WrapAlignment.start
        };

        final data = DuitDataSource(json);

        expect(data.wrapAlignment(), WrapAlignment.start);
        expect(data["alignment"], WrapAlignment.start);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.wrapAlignment(), null);
        expect(
          data.wrapAlignment(defaultValue: WrapAlignment.center),
          WrapAlignment.center,
        );
        expect(data["alignment"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "alignment": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.wrapAlignment(defaultValue: WrapAlignment.center),
          WrapAlignment.center,
        );
        expect(data["alignment"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "alignment": WrapAlignment.center,
        };

        final data = DuitDataSource(json);

        expect(data.wrapAlignment(), WrapAlignment.center);
        expect(data["alignment"], WrapAlignment.center);
      });
    },
  );

  group(
    "boxConstraints method",
    () {
      test("should parse and return the boxConstraints from map", () {
        final json = <String, dynamic>{
          "constraints": {
            "minWidth": 100.0,
            "maxWidth": 200.0,
            "minHeight": 150.0,
            "maxHeight": 250.0,
          },
        };

        final data = DuitDataSource(json);
        final constraints = data.boxConstraints()!;

        expect(constraints.minWidth, 100.0);
        expect(constraints.maxWidth, 200.0);
        expect(constraints.minHeight, 150.0);
        expect(constraints.maxHeight, 250.0);
        expect(data["constraints"], constraints);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};
        const defaultConstraints = BoxConstraints(
          minWidth: 50.0,
          maxWidth: 100.0,
          minHeight: 50.0,
          maxHeight: 100.0,
        );

        final data = DuitDataSource(json);

        expect(data.boxConstraints(), null);
        expect(data.boxConstraints(defaultValue: defaultConstraints),
            defaultConstraints);
        expect(data["constraints"], null);
      });

      test("should return the default value if the value is not a map", () {
        final json = <String, dynamic>{
          "constraints": true,
        };
        const defaultConstraints = BoxConstraints(
          minWidth: 50.0,
          maxWidth: 100.0,
          minHeight: 50.0,
          maxHeight: 100.0,
        );

        final data = DuitDataSource(json);

        expect(data.boxConstraints(defaultValue: defaultConstraints),
            defaultConstraints);
        expect(data["constraints"], true);
      });

      test("should return instance if the value is already an instance", () {
        const constraints = BoxConstraints(
          minWidth: 100.0,
          maxWidth: 200.0,
          minHeight: 150.0,
          maxHeight: 250.0,
        );
        final json = <String, dynamic>{
          "constraints": constraints,
        };

        final data = DuitDataSource(json);

        expect(data.boxConstraints(), constraints);
        expect(data["constraints"], constraints);
      });
    },
  );

  group(
    "stackFit method",
    () {
      test("should parse and return the stackFit from string", () {
        final json = <String, dynamic>{
          "fit": "loose",
        };

        final data = DuitDataSource(json);

        expect(data.stackFit(), StackFit.loose);
        expect(data["fit"], StackFit.loose);
      });

      test("should parse and return the stackFit from int", () {
        final json = <String, dynamic>{
          "fit": 0, // StackFit.loose
        };

        final data = DuitDataSource(json);

        expect(data.stackFit(), StackFit.expand);
        expect(data["fit"], StackFit.expand);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.stackFit(), null);
        expect(
          data.stackFit(defaultValue: StackFit.expand),
          StackFit.expand,
        );
        expect(data["fit"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "fit": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.stackFit(defaultValue: StackFit.expand),
          StackFit.expand,
        );
        expect(data["fit"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "fit": StackFit.expand,
        };

        final data = DuitDataSource(json);

        expect(data.stackFit(), StackFit.expand);
        expect(data["fit"], StackFit.expand);
      });
    },
  );

  group(
    "overflowBoxFit method",
    () {
      test("should parse and return the overflowBoxFit from string", () {
        final json = <String, dynamic>{
          "fit": "max",
        };

        final data = DuitDataSource(json);

        expect(data.overflowBoxFit(), OverflowBoxFit.max);
        expect(data["fit"], OverflowBoxFit.max);
      });

      test("should parse and return the overflowBoxFit from int", () {
        final json = <String, dynamic>{
          "fit": 0, // OverflowBoxFit.max
        };

        final data = DuitDataSource(json);

        expect(data.overflowBoxFit(), OverflowBoxFit.max);
        expect(data["fit"], OverflowBoxFit.max);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.overflowBoxFit(), OverflowBoxFit.max);
        expect(
          data.overflowBoxFit(defaultValue: OverflowBoxFit.deferToChild),
          OverflowBoxFit.deferToChild,
        );
        expect(data["fit"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "fit": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.overflowBoxFit(defaultValue: OverflowBoxFit.deferToChild),
          OverflowBoxFit.deferToChild,
        );
        expect(data["fit"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "fit": OverflowBoxFit.deferToChild,
        };

        final data = DuitDataSource(json);

        expect(data.overflowBoxFit(), OverflowBoxFit.deferToChild);
        expect(data["fit"], OverflowBoxFit.deferToChild);
      });
    },
  );

  group(
    "alignment method",
    () {
      test("should parse and return the alignment from map", () {
        final json = <String, dynamic>{
          "alignment": [0.5, 0.5],
          "alignment2": 1,
        };

        final data = DuitDataSource(json);
        final alignment = data.alignment()!;

        expect(alignment, const Alignment(0.5, 0.5));
        expect(data["alignment"], const Alignment(0.5, 0.5));
        expect(data.alignment(key: "alignment2"), Alignment.topLeft);
        expect(data["alignment2"], Alignment.topLeft);
      });

      test("should parse and return the alignment from string", () {
        final json = <String, dynamic>{
          "alignment": "center",
        };

        final data = DuitDataSource(json);

        expect(data.alignment(), Alignment.center);
        expect(data["alignment"], Alignment.center);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};
        const defaultAlignment = Alignment.topLeft;

        final data = DuitDataSource(json);

        expect(data.alignment(), null);
        expect(
            data.alignment(defaultValue: defaultAlignment), defaultAlignment);
        expect(data["alignment"], null);
      });

      test(
          "should return the default value if the value is not a map or string",
          () {
        final json = <String, dynamic>{
          "alignment": true,
        };
        const defaultAlignment = Alignment.topLeft;

        final data = DuitDataSource(json);

        expect(
            data.alignment(defaultValue: defaultAlignment), defaultAlignment);
        expect(data["alignment"], true);
      });

      test("should return instance if the value is already an instance", () {
        const alignment = Alignment.topRight;
        final json = <String, dynamic>{
          "alignment": alignment,
        };

        final data = DuitDataSource(json);

        expect(data.alignment(), alignment);
        expect(data["alignment"], alignment);
      });
    },
  );

  group(
    "alignmentDirectional method",
    () {
      test("should parse and return the alignmentDirectional from map", () {
        final json = <String, dynamic>{
          "alignment": [0.5, 0.5],
          "alignment2": 1,
        };

        final data = DuitDataSource(json);
        final alignment = data.alignmentDirectional()!;

        expect(alignment, const AlignmentDirectional(0.5, 0.5));
        expect(data["alignment"], const AlignmentDirectional(0.5, 0.5));
        expect(data.alignmentDirectional(key: "alignment2"),
            AlignmentDirectional.topCenter);
        expect(data["alignment2"], AlignmentDirectional.topCenter);
      });

      test("should parse and return the alignmentDirectional from string", () {
        final json = <String, dynamic>{
          "alignment": "center",
        };

        final data = DuitDataSource(json);

        expect(data.alignmentDirectional(), AlignmentDirectional.center);
        expect(data["alignment"], AlignmentDirectional.center);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};
        const defaultAlignment = AlignmentDirectional.topStart;

        final data = DuitDataSource(json);

        expect(data.alignmentDirectional(), null);
        expect(data.alignmentDirectional(defaultValue: defaultAlignment),
            defaultAlignment);
        expect(data["alignment"], null);
      });

      test(
          "should return the default value if the value is not a map or string",
          () {
        final json = <String, dynamic>{
          "alignment": true,
        };
        const defaultAlignment = AlignmentDirectional.topStart;

        final data = DuitDataSource(json);

        expect(data.alignmentDirectional(defaultValue: defaultAlignment),
            defaultAlignment);
        expect(data["alignment"], true);
      });

      test("should return instance if the value is already an instance", () {
        const alignment = AlignmentDirectional.topEnd;
        final json = <String, dynamic>{
          "alignment": alignment,
        };

        final data = DuitDataSource(json);

        expect(data.alignmentDirectional(), alignment);
        expect(data["alignment"], alignment);
      });
    },
  );

  group(
    "mainAxisAlignment method",
    () {
      test("should parse and return the mainAxisAlignment from string", () {
        final json = <String, dynamic>{
          "mainAxisAlignment": "start",
        };

        final data = DuitDataSource(json);

        expect(data.mainAxisAlignment(), MainAxisAlignment.start);
        expect(data["mainAxisAlignment"], MainAxisAlignment.start);
      });

      test("should parse and return the mainAxisAlignment from int", () {
        final json = <String, dynamic>{
          "mainAxisAlignment": 0, // MainAxisAlignment.start
        };

        final data = DuitDataSource(json);

        expect(data.mainAxisAlignment(), MainAxisAlignment.start);
        expect(data["mainAxisAlignment"], MainAxisAlignment.start);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.mainAxisAlignment(), null);
        expect(
          data.mainAxisAlignment(defaultValue: MainAxisAlignment.center),
          MainAxisAlignment.center,
        );
        expect(data["mainAxisAlignment"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "mainAxisAlignment": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.mainAxisAlignment(defaultValue: MainAxisAlignment.center),
          MainAxisAlignment.center,
        );
        expect(data["mainAxisAlignment"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "mainAxisAlignment": MainAxisAlignment.center,
        };

        final data = DuitDataSource(json);

        expect(data.mainAxisAlignment(), MainAxisAlignment.center);
        expect(data["mainAxisAlignment"], MainAxisAlignment.center);
      });
    },
  );

  group(
    "crossAxisAlignment method",
    () {
      test("should parse and return the crossAxisAlignment from string", () {
        final json = <String, dynamic>{
          "crossAxisAlignment": "start",
        };

        final data = DuitDataSource(json);

        expect(data.crossAxisAlignment(), CrossAxisAlignment.start);
        expect(data["crossAxisAlignment"], CrossAxisAlignment.start);
      });

      test("should parse and return the crossAxisAlignment from int", () {
        final json = <String, dynamic>{
          "crossAxisAlignment": 0, // CrossAxisAlignment.start
        };

        final data = DuitDataSource(json);

        expect(data.crossAxisAlignment(), CrossAxisAlignment.start);
        expect(data["crossAxisAlignment"], CrossAxisAlignment.start);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.crossAxisAlignment(), null);
        expect(
          data.crossAxisAlignment(defaultValue: CrossAxisAlignment.center),
          CrossAxisAlignment.center,
        );
        expect(data["crossAxisAlignment"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "crossAxisAlignment": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.crossAxisAlignment(defaultValue: CrossAxisAlignment.center),
          CrossAxisAlignment.center,
        );
        expect(data["crossAxisAlignment"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "crossAxisAlignment": CrossAxisAlignment.center,
        };

        final data = DuitDataSource(json);

        expect(data.crossAxisAlignment(), CrossAxisAlignment.center);
        expect(data["crossAxisAlignment"], CrossAxisAlignment.center);
      });
    },
  );

  group(
    "mainAxisSize method",
    () {
      test("should parse and return the mainAxisSize from string", () {
        final json = <String, dynamic>{
          "mainAxisSize": "min",
        };

        final data = DuitDataSource(json);

        expect(data.mainAxisSize(), MainAxisSize.min);
        expect(data["mainAxisSize"], MainAxisSize.min);
      });

      test("should parse and return the mainAxisSize from int", () {
        final json = <String, dynamic>{
          "mainAxisSize": 0, // MainAxisSize.min
        };

        final data = DuitDataSource(json);

        expect(data.mainAxisSize(), MainAxisSize.min);
        expect(data["mainAxisSize"], MainAxisSize.min);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.mainAxisSize(), null);
        expect(
          data.mainAxisSize(defaultValue: MainAxisSize.max),
          MainAxisSize.max,
        );
        expect(data["mainAxisSize"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "mainAxisSize": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.mainAxisSize(defaultValue: MainAxisSize.max),
          MainAxisSize.max,
        );
        expect(data["mainAxisSize"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "mainAxisSize": MainAxisSize.max,
        };

        final data = DuitDataSource(json);

        expect(data.mainAxisSize(), MainAxisSize.max);
        expect(data["mainAxisSize"], MainAxisSize.max);
      });
    },
  );

  group(
    "sliderInteraction method",
    () {
      test("should parse and return the sliderInteraction from string", () {
        final json = <String, dynamic>{
          "interaction": "tapOnly",
        };

        final data = DuitDataSource(json);

        expect(data.sliderInteraction(), SliderInteraction.tapOnly);
        expect(data["interaction"], SliderInteraction.tapOnly);
      });

      test("should parse and return the sliderInteraction from int", () {
        final json = <String, dynamic>{
          "interaction": 0, // SliderInteraction.tapOnly
        };

        final data = DuitDataSource(json);

        expect(data.sliderInteraction(), SliderInteraction.tapOnly);
        expect(data["interaction"], SliderInteraction.tapOnly);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.sliderInteraction(), null);
        expect(
          data.sliderInteraction(defaultValue: SliderInteraction.slideOnly),
          SliderInteraction.slideOnly,
        );
        expect(data["interaction"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "interaction": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.sliderInteraction(defaultValue: SliderInteraction.slideOnly),
          SliderInteraction.slideOnly,
        );
        expect(data["interaction"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "interaction": SliderInteraction.slideOnly,
        };

        final data = DuitDataSource(json);

        expect(data.sliderInteraction(), SliderInteraction.slideOnly);
        expect(data["interaction"], SliderInteraction.slideOnly);
      });
    },
  );

  group(
    "materialTapTargetSize method",
    () {
      test("should parse and return the materialTapTargetSize from string", () {
        final json = <String, dynamic>{
          "materialTapTargetSize": "shrinkWrap",
        };

        final data = DuitDataSource(json);

        expect(data.materialTapTargetSize(), MaterialTapTargetSize.shrinkWrap);
        expect(data["materialTapTargetSize"], MaterialTapTargetSize.shrinkWrap);
      });

      test("should parse and return the materialTapTargetSize from int", () {
        final json = <String, dynamic>{
          "materialTapTargetSize": 0, // MaterialTapTargetSize.shrinkWrap
        };

        final data = DuitDataSource(json);

        expect(data.materialTapTargetSize(), MaterialTapTargetSize.shrinkWrap);
        expect(data["materialTapTargetSize"], MaterialTapTargetSize.shrinkWrap);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.materialTapTargetSize(), null);
        expect(
          data.materialTapTargetSize(
              defaultValue: MaterialTapTargetSize.padded),
          MaterialTapTargetSize.padded,
        );
        expect(data["materialTapTargetSize"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "materialTapTargetSize": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.materialTapTargetSize(
              defaultValue: MaterialTapTargetSize.padded),
          MaterialTapTargetSize.padded,
        );
        expect(data["materialTapTargetSize"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "materialTapTargetSize": MaterialTapTargetSize.padded,
        };

        final data = DuitDataSource(json);

        expect(data.materialTapTargetSize(), MaterialTapTargetSize.padded);
        expect(data["materialTapTargetSize"], MaterialTapTargetSize.padded);
      });
    },
  );

  group(
    "filterQuality method",
    () {
      test("should parse and return the filterQuality from string", () {
        final json = <String, dynamic>{
          "filterQuality": "high",
        };

        final data = DuitDataSource(json);

        expect(data.filterQuality(), FilterQuality.high);
        expect(data["filterQuality"], FilterQuality.high);
      });

      test("should parse and return the filterQuality from int", () {
        final json = <String, dynamic>{
          "filterQuality": 0, // FilterQuality.none
        };

        final data = DuitDataSource(json);

        expect(data.filterQuality(), FilterQuality.none);
        expect(data["filterQuality"], FilterQuality.none);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.filterQuality(), FilterQuality.medium);
        expect(
          data.filterQuality(defaultValue: FilterQuality.low),
          FilterQuality.low,
        );
        expect(data["filterQuality"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "filterQuality": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.filterQuality(defaultValue: FilterQuality.low),
          FilterQuality.low,
        );
        expect(data["filterQuality"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "filterQuality": FilterQuality.high,
        };

        final data = DuitDataSource(json);

        expect(data.filterQuality(), FilterQuality.high);
        expect(data["filterQuality"], FilterQuality.high);
      });
    },
  );

  group(
    "imageRepeat method",
    () {
      test("should parse and return the imageRepeat from string", () {
        final json = <String, dynamic>{
          "repeat": "repeat",
        };

        final data = DuitDataSource(json);

        expect(data.imageRepeat(), ImageRepeat.repeat);
        expect(data["repeat"], ImageRepeat.repeat);
      });

      test("should parse and return the imageRepeat from int", () {
        final json = <String, dynamic>{
          "repeat": 0, // ImageRepeat.repeat
        };

        final data = DuitDataSource(json);

        expect(data.imageRepeat(), ImageRepeat.repeat);
        expect(data["repeat"], ImageRepeat.repeat);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.imageRepeat(), ImageRepeat.noRepeat);
        expect(
          data.imageRepeat(defaultValue: ImageRepeat.repeat),
          ImageRepeat.repeat,
        );
        expect(data["repeat"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "repeat": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.imageRepeat(defaultValue: ImageRepeat.repeat),
          ImageRepeat.repeat,
        );
        expect(data["repeat"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "repeat": ImageRepeat.repeat,
        };

        final data = DuitDataSource(json);

        expect(data.imageRepeat(), ImageRepeat.repeat);
        expect(data["repeat"], ImageRepeat.repeat);
      });
    },
  );

  group(
    "uint8List method",
    () {
      test("should parse and return the uint8List from list", () {
        final json = <String, dynamic>{
          "byteData": [1, 2, 3, 4, 5],
          "byteData2": "dGVzdA==", //test string
        };

        final data = DuitDataSource(json);
        final result = data.uint8List();

        expect(result, Uint8List.fromList([1, 2, 3, 4, 5]));
        expect(data["byteData"], Uint8List.fromList([1, 2, 3, 4, 5]));
        expect(data.uint8List(key: "byteData2"),
            Uint8List.fromList([116, 101, 115, 116]));
        expect(data["byteData2"], Uint8List.fromList([116, 101, 115, 116]));
      });

      test("should return empty list if the value is null", () {
        final json = <String, dynamic>{};
        final defaultList = Uint8List.fromList([0, 0, 0]);

        final data = DuitDataSource(json);

        expect(data.uint8List(), Uint8List(0));
        expect(data.uint8List(defaultValue: defaultList), defaultList);
        expect(data["byteData"], null);
      });

      test("should return the default value if the value is not a list", () {
        final json = <String, dynamic>{
          "byteData": true,
        };
        final defaultList = Uint8List.fromList([0, 0, 0]);

        final data = DuitDataSource(json);

        expect(data.uint8List(defaultValue: defaultList), defaultList);
        expect(data["byteData"], true);
      });

      test("should return instance if the value is already an instance", () {
        final list = Uint8List.fromList([1, 2, 3]);
        final json = <String, dynamic>{
          "byteData": list,
        };

        final data = DuitDataSource(json);

        expect(data.uint8List(), list);
        expect(data["byteData"], list);
        expect(data.uint8List(key: "byteData2", defaultValue: list), list);
      });
    },
  );

  group(
    "boxFit method",
    () {
      test("should parse and return the boxFit from string", () {
        final json = <String, dynamic>{
          "fit": "cover",
        };

        final data = DuitDataSource(json);

        expect(data.boxFit(), BoxFit.cover);
        expect(data["fit"], BoxFit.cover);
      });

      test("should parse and return the boxFit from int", () {
        final json = <String, dynamic>{
          "fit": 0, // BoxFit.fill
        };

        final data = DuitDataSource(json);

        expect(data.boxFit(), BoxFit.fill);
        expect(data["fit"], BoxFit.fill);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.boxFit(), null);
        expect(
          data.boxFit(defaultValue: BoxFit.contain),
          BoxFit.contain,
        );
        expect(data["fit"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "fit": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.boxFit(defaultValue: BoxFit.contain),
          BoxFit.contain,
        );
        expect(data["fit"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "fit": BoxFit.cover,
        };

        final data = DuitDataSource(json);

        expect(data.boxFit(), BoxFit.cover);
        expect(data["fit"], BoxFit.cover);
      });
    },
  );

  group(
    "blendMode method",
    () {
      test("should parse and return the blendMode from string", () {
        final json = <String, dynamic>{
          "blendMode": "srcOver",
        };

        final data = DuitDataSource(json);

        expect(data.blendMode(), BlendMode.srcOver);
        expect(data["blendMode"], BlendMode.srcOver);
      });

      test("should parse and return the blendMode from int", () {
        final json = <String, dynamic>{
          "blendMode": 0, // BlendMode.clear
        };

        final data = DuitDataSource(json);

        expect(data.blendMode(), BlendMode.clear);
        expect(data["blendMode"], BlendMode.clear);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.blendMode(), BlendMode.srcOver);
        expect(
          data.blendMode(defaultValue: BlendMode.clear),
          BlendMode.clear,
        );
        expect(data["blendMode"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "blendMode": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.blendMode(defaultValue: BlendMode.clear),
          BlendMode.clear,
        );
        expect(data["blendMode"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "blendMode": BlendMode.srcOver,
        };

        final data = DuitDataSource(json);

        expect(data.blendMode(), BlendMode.srcOver);
        expect(data["blendMode"], BlendMode.srcOver);
      });
    },
  );

  group(
    "tileMode method",
    () {
      test("should parse and return the tileMode from string", () {
        final json = <String, dynamic>{
          "tileMode": "clamp",
        };

        final data = DuitDataSource(json);

        expect(data.tileMode(), TileMode.clamp);
        expect(data["tileMode"], TileMode.clamp);
      });

      test("should parse and return the tileMode from int", () {
        final json = <String, dynamic>{
          "tileMode": 0, // TileMode.clamp
        };

        final data = DuitDataSource(json);

        expect(data.tileMode(), TileMode.clamp);
        expect(data["tileMode"], TileMode.clamp);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.tileMode(), TileMode.clamp);
        expect(
          data.tileMode(defaultValue: TileMode.repeated),
          TileMode.repeated,
        );
        expect(data["tileMode"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "tileMode": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.tileMode(defaultValue: TileMode.repeated),
          TileMode.repeated,
        );
        expect(data["tileMode"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "tileMode": TileMode.mirror,
        };

        final data = DuitDataSource(json);

        expect(data.tileMode(), TileMode.mirror);
        expect(data["tileMode"], TileMode.mirror);
      });
    },
  );

  group(
    "verticalDirection method",
    () {
      test("should parse and return the verticalDirection from string", () {
        final json = <String, dynamic>{
          "verticalDirection": "up",
        };

        final data = DuitDataSource(json);

        expect(data.verticalDirection(), VerticalDirection.up);
        expect(data["verticalDirection"], VerticalDirection.up);
      });

      test("should parse and return the verticalDirection from int", () {
        final json = <String, dynamic>{
          "verticalDirection": 0, // VerticalDirection.up
        };

        final data = DuitDataSource(json);

        expect(data.verticalDirection(), VerticalDirection.up);
        expect(data["verticalDirection"], VerticalDirection.up);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.verticalDirection(), VerticalDirection.down);
        expect(
          data.verticalDirection(defaultValue: VerticalDirection.up),
          VerticalDirection.up,
        );
        expect(data["verticalDirection"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "verticalDirection": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.verticalDirection(defaultValue: VerticalDirection.up),
          VerticalDirection.up,
        );
        expect(data["verticalDirection"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "verticalDirection": VerticalDirection.up,
        };

        final data = DuitDataSource(json);

        expect(data.verticalDirection(), VerticalDirection.up);
        expect(data["verticalDirection"], VerticalDirection.up);
      });
    },
  );

  group(
    "boxShape method",
    () {
      test("should parse and return the boxShape from string", () {
        final json = <String, dynamic>{
          "shape": "circle",
        };

        final data = DuitDataSource(json);

        expect(data.boxShape(), BoxShape.circle);
        expect(data["shape"], BoxShape.circle);
      });

      test("should parse and return the boxShape from int", () {
        final json = <String, dynamic>{
          "shape": 0, // BoxShape.rectangle
        };

        final data = DuitDataSource(json);

        expect(data.boxShape(), BoxShape.circle);
        expect(data["shape"], BoxShape.circle);
      });

      test("should return null if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.boxShape(), null);
        expect(
          data.boxShape(defaultValue: BoxShape.circle),
          BoxShape.circle,
        );
        expect(data["shape"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "shape": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.boxShape(defaultValue: BoxShape.circle),
          BoxShape.circle,
        );
        expect(data["shape"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "shape": BoxShape.circle,
        };

        final data = DuitDataSource(json);

        expect(data.boxShape(), BoxShape.circle);
        expect(data["shape"], BoxShape.circle);
      });
    },
  );

  group(
    "borderStyle method",
    () {
      test("should parse and return the borderStyle from string", () {
        final json = <String, dynamic>{
          "style": "solid",
        };

        final data = DuitDataSource(json);

        expect(data.borderStyle(), BorderStyle.solid);
        expect(data["style"], BorderStyle.solid);
      });

      test("should parse and return the borderStyle from int", () {
        final json = <String, dynamic>{
          "style": 0, // BorderStyle.solid
        };

        final data = DuitDataSource(json);

        expect(data.borderStyle(), BorderStyle.solid);
        expect(data["style"], BorderStyle.solid);
      });

      test("should return null if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.borderStyle(), null);
        expect(
          data.borderStyle(defaultValue: BorderStyle.none),
          BorderStyle.none,
        );
        expect(data["style"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "style": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.borderStyle(defaultValue: BorderStyle.none),
          BorderStyle.none,
        );
        expect(data["style"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "style": BorderStyle.none,
        };

        final data = DuitDataSource(json);

        expect(data.borderStyle(), BorderStyle.none);
        expect(data["style"], BorderStyle.none);
      });
    },
  );

  group(
    "borderSide method",
    () {
      test("should parse and return the borderSide from map", () {
        final json = <String, dynamic>{
          "side": {
            "color": "#000000",
            "width": 2.0,
            "style": "solid",
          },
        };

        final data = DuitDataSource(json);
        final border = data.borderSide();

        expect(border.color, const Color.fromRGBO(0, 0, 0, 1));
        expect(border.width, 2.0);
        expect(border.style, BorderStyle.solid);
        expect(data["side"], border);
      });

      test("should return null if the value is null", () {
        final json = <String, dynamic>{};
        const defaultBorder = BorderSide(
          color: Colors.black,
          width: 1.0,
          style: BorderStyle.solid,
        );

        final data = DuitDataSource(json);

        expect(data.borderSide(), BorderSide.none);
        expect(data.borderSide(defaultValue: defaultBorder), defaultBorder);
        expect(data["side"], null);
      });

      test("should return the default value if the value is not a map", () {
        final json = <String, dynamic>{
          "side": true,
        };
        const defaultBorder = BorderSide(
          color: Colors.black,
          width: 1.0,
          style: BorderStyle.solid,
        );

        final data = DuitDataSource(json);

        expect(data.borderSide(defaultValue: defaultBorder), defaultBorder);
        expect(data["side"], true);
      });

      test("should return instance if the value is already an instance", () {
        const border = BorderSide(
          color: Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
        );
        final json = <String, dynamic>{
          "side": border,
        };

        final data = DuitDataSource(json);

        expect(
          data.borderSide(),
          const BorderSide(
            color: Colors.red,
            width: 2.0,
            style: BorderStyle.solid,
          ),
        );
        expect(
          data["side"],
          const BorderSide(
            color: Colors.red,
            width: 2.0,
            style: BorderStyle.solid,
          ),
        );
      });
    },
  );

  group(
    "inputBorder method",
    () {
      test("should parse and return the inputBorder from string", () {
        final json = <String, dynamic>{
          "border": {
            "type": "outline",
            "borderSide": {
              "color": "#000000",
              "width": 2.0,
              "style": "solid",
            },
            "gapPadding": 4.0,
            "borderRadius": 4.0,
          },
          "border2": {
            "type": "underline",
            "borderSide": {
              "color": "#000000",
              "width": 2.0,
              "style": "solid",
            },
          },
        };

        final data = DuitDataSource(json);

        final border = data.inputBorder() as OutlineInputBorder;
        expect(border, isA<OutlineInputBorder>());
        expect(border.borderSide.color, const Color.fromRGBO(0, 0, 0, 1));
        expect(border.borderSide.width, 2.0);
        expect(border.borderSide.style, BorderStyle.solid);
        expect(border.gapPadding, 4.0);
        expect(border.borderRadius, BorderRadius.circular(4.0));
        final cachedBorder = data["border"] as OutlineInputBorder;
        expect(cachedBorder, isA<OutlineInputBorder>());
        expect(cachedBorder.borderSide.color, const Color.fromRGBO(0, 0, 0, 1));
        expect(cachedBorder.borderSide.width, 2.0);
        expect(cachedBorder.borderSide.style, BorderStyle.solid);
        expect(cachedBorder.gapPadding, 4.0);
        expect(cachedBorder.borderRadius, BorderRadius.circular(4.0));
        final underlineBorder =
            data.inputBorder(key: "border2") as UnderlineInputBorder;
        expect(underlineBorder, isA<UnderlineInputBorder>());
        expect(
            underlineBorder.borderSide.color, const Color.fromRGBO(0, 0, 0, 1));
        expect(underlineBorder.borderSide.width, 2.0);
        expect(underlineBorder.borderSide.style, BorderStyle.solid);
        final cachedUnderlineBorder = data["border2"] as UnderlineInputBorder;
        expect(cachedUnderlineBorder, isA<UnderlineInputBorder>());
        expect(cachedUnderlineBorder.borderSide.color,
            const Color.fromRGBO(0, 0, 0, 1));
        expect(cachedUnderlineBorder.borderSide.width, 2.0);
        expect(cachedUnderlineBorder.borderSide.style, BorderStyle.solid);
      });

      test("should return null if the value is null", () {
        final json = <String, dynamic>{};
        const defaultBorder = UnderlineInputBorder();

        final data = DuitDataSource(json);

        expect(data.inputBorder(), null);
        expect(data.inputBorder(defaultValue: defaultBorder), defaultBorder);
        expect(data["border"], null);
      });

      test("should return the default value if the value is not a string", () {
        final json = <String, dynamic>{
          "border": true,
        };
        const defaultBorder = UnderlineInputBorder();

        final data = DuitDataSource(json);

        expect(data.inputBorder(defaultValue: defaultBorder), defaultBorder);
        expect(data["border"], true);
      });

      test("should return instance if the value is already an instance", () {
        const border = OutlineInputBorder();
        final json = <String, dynamic>{
          "border": border,
        };

        final data = DuitDataSource(json);

        expect(data.inputBorder(), border);
        expect(data["border"], border);
      });
    },
  );

  group(
    "inputDecoration method",
    () {
      test("should parse and return the inputDecoration from map", () {
        final json = <String, dynamic>{
          "decoration": {
            "labelText": "Label",
            "hintText": "Hint",
            "errorText": "Error",
          },
        };

        final data = DuitDataSource(json);
        final decoration = data.inputDecoration()!;

        expect(decoration.labelText, "Label");
        expect(decoration.hintText, "Hint");
        expect(decoration.errorText, "Error");
        expect(data["decoration"], decoration);
      });

      test("should return null if the value is null", () {
        final json = <String, dynamic>{};
        const defaultDecoration = InputDecoration(
          labelText: "Default",
        );

        final data = DuitDataSource(json);

        expect(data.inputDecoration(), null);
        expect(data.inputDecoration(defaultValue: defaultDecoration),
            defaultDecoration);
        expect(data["decoration"], null);
      });

      test("should return the default value if the value is not a map", () {
        final json = <String, dynamic>{
          "decoration": true,
        };
        const defaultDecoration = InputDecoration(
          labelText: "Default",
        );

        final data = DuitDataSource(json);

        expect(data.inputDecoration(defaultValue: defaultDecoration),
            defaultDecoration);
        expect(data["decoration"], true);
      });

      test("should return instance if the value is already an instance", () {
        const decoration = InputDecoration(
          labelText: "Label",
        );
        final json = <String, dynamic>{
          "decoration": decoration,
        };

        final data = DuitDataSource(json);

        expect(data.inputDecoration(), decoration);
        expect(data["decoration"], decoration);
      });
    },
  );

  group(
    "textInputType method",
    () {
      test("should parse and return the textInputType from string", () {
        final json = <String, dynamic>{
          "keyboardType": "text",
        };

        final data = DuitDataSource(json);

        expect(data.textInputType(), TextInputType.text);
        expect(data["keyboardType"], TextInputType.text);
      });

      test("should parse and return the textInputType from int", () {
        final json = <String, dynamic>{
          "keyboardType": 0, // TextInputType.text
        };

        final data = DuitDataSource(json);

        expect(data.textInputType(), TextInputType.text);
        expect(data["keyboardType"], TextInputType.text);
      });

      test("should return null if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.textInputType(), null);
        expect(
          data.textInputType(defaultValue: TextInputType.number),
          TextInputType.number,
        );
        expect(data["keyboardType"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "keyboardType": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.textInputType(defaultValue: TextInputType.number),
          TextInputType.number,
        );
        expect(data["keyboardType"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "keyboardType": TextInputType.number,
        };

        final data = DuitDataSource(json);

        expect(data.textInputType(), TextInputType.number);
        expect(data["keyboardType"], TextInputType.number);
      });
    },
  );

  group(
    "visualDensity method",
    () {
      test("should parse and return the visualDensity from map", () {
        final json = <String, dynamic>{
          "visualDensity": {
            "horizontal": 4.0,
            "vertical": 4.0,
          },
        };

        final data = DuitDataSource(json);
        final density = data.visualDensity();

        expect(density.horizontal, 4.0);
        expect(density.vertical, 4.0);
        expect(data["visualDensity"], density);
      });

      test("should return null if the value is null", () {
        final json = <String, dynamic>{};
        const defaultDensity = VisualDensity(
          horizontal: 4.0,
          vertical: 4.0,
        );

        final data = DuitDataSource(json);

        expect(
            data.visualDensity(),
            const VisualDensity(
              horizontal: 0.0,
              vertical: 0.0,
            ));
        expect(
            data.visualDensity(defaultValue: defaultDensity), defaultDensity);
        expect(data["visualDensity"], null);
      });

      test("should return the default value if the value is not a map", () {
        final json = <String, dynamic>{
          "visualDensity": true,
        };
        const defaultDensity = VisualDensity(
          horizontal: 4.0,
          vertical: 4.0,
        );

        final data = DuitDataSource(json);

        expect(
            data.visualDensity(defaultValue: defaultDensity), defaultDensity);
        expect(data["visualDensity"], true);
      });

      test("should return instance if the value is already an instance", () {
        const density = VisualDensity(
          horizontal: 4.0,
          vertical: 4.0,
        );
        final json = <String, dynamic>{
          "visualDensity": density,
        };

        final data = DuitDataSource(json);

        expect(data.visualDensity(),
            const VisualDensity(horizontal: 4.0, vertical: 4.0));
        expect(data["visualDensity"],
            const VisualDensity(horizontal: 4.0, vertical: 4.0));
      });
    },
  );

  group(
    "keyboardDismissBehavior method",
    () {
      test("should parse and return the keyboardDismissBehavior from string",
          () {
        final json = <String, dynamic>{
          "keyboardDismissBehavior": "onDrag",
        };

        final data = DuitDataSource(json);

        expect(data.keyboardDismissBehavior(),
            ScrollViewKeyboardDismissBehavior.onDrag);
        expect(data["keyboardDismissBehavior"],
            ScrollViewKeyboardDismissBehavior.onDrag);
      });

      test("should parse and return the keyboardDismissBehavior from int", () {
        final json = <String, dynamic>{
          "keyboardDismissBehavior":
              0, // ScrollViewKeyboardDismissBehavior.manual
        };

        final data = DuitDataSource(json);

        expect(data.keyboardDismissBehavior(),
            ScrollViewKeyboardDismissBehavior.manual);
        expect(data["keyboardDismissBehavior"],
            ScrollViewKeyboardDismissBehavior.manual);
      });

      test("should return null if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.keyboardDismissBehavior(),
            ScrollViewKeyboardDismissBehavior.manual);
        expect(
          data.keyboardDismissBehavior(
              defaultValue: ScrollViewKeyboardDismissBehavior.onDrag),
          ScrollViewKeyboardDismissBehavior.onDrag,
        );
        expect(data["keyboardDismissBehavior"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "keyboardDismissBehavior": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.keyboardDismissBehavior(
              defaultValue: ScrollViewKeyboardDismissBehavior.onDrag),
          ScrollViewKeyboardDismissBehavior.onDrag,
        );
        expect(data["keyboardDismissBehavior"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "keyboardDismissBehavior": ScrollViewKeyboardDismissBehavior.onDrag,
        };

        final data = DuitDataSource(json);

        expect(data.keyboardDismissBehavior(),
            ScrollViewKeyboardDismissBehavior.onDrag);
        expect(data["keyboardDismissBehavior"],
            ScrollViewKeyboardDismissBehavior.onDrag);
      });
    },
  );

  group(
    "scrollPhysics method",
    () {
      test("should parse and return the scrollPhysics", () {
        final json = <String, dynamic>{
          "physics": "alwaysScrollableScrollPhysics",
          "physics2": 0,
        };

        final data = DuitDataSource(json);

        expect(data.scrollPhysics(), isA<AlwaysScrollableScrollPhysics>());
        expect(data.scrollPhysics(key: "physics2"),
            isA<AlwaysScrollableScrollPhysics>());
        expect(data["physics"], isA<AlwaysScrollableScrollPhysics>());
        expect(data["physics2"], isA<AlwaysScrollableScrollPhysics>());
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);
        const defaultPhysics = BouncingScrollPhysics();

        expect(data.scrollPhysics(), null);
        expect(
          data.scrollPhysics(defaultValue: defaultPhysics),
          defaultPhysics,
        );
        expect(data["physics"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "physics": true,
        };

        final data = DuitDataSource(json);
        const defaultPhysics = ClampingScrollPhysics();

        expect(
          data.scrollPhysics(defaultValue: defaultPhysics),
          defaultPhysics,
        );
        expect(data["physics"], true);
      });

      test("should return instance if the value is already an instance", () {
        const physics = NeverScrollableScrollPhysics();
        final json = <String, dynamic>{
          "physics": physics,
        };

        final data = DuitDataSource(json);

        expect(data.scrollPhysics(), physics);
        expect(data["physics"], physics);
      });
    },
  );

  group(
    "dragStartBehavior method",
    () {
      test("should parse and return the dragStartBehavior", () {
        final json = <String, dynamic>{
          "dragStartBehavior": "start",
          "dragStartBehavior2": 0,
        };

        final data = DuitDataSource(json);

        expect(data.dragStartBehavior(), DragStartBehavior.start);
        expect(data.dragStartBehavior(key: "dragStartBehavior2"),
            DragStartBehavior.start);
        expect(data["dragStartBehavior"], DragStartBehavior.start);
        expect(data["dragStartBehavior2"], DragStartBehavior.start);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.dragStartBehavior(), DragStartBehavior.start);
        expect(
          data.dragStartBehavior(defaultValue: DragStartBehavior.down),
          DragStartBehavior.down,
        );
        expect(data["dragStartBehavior"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "dragStartBehavior": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.dragStartBehavior(defaultValue: DragStartBehavior.down),
          DragStartBehavior.down,
        );
        expect(data["dragStartBehavior"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "dragStartBehavior": DragStartBehavior.down,
        };

        final data = DuitDataSource(json);

        expect(data.dragStartBehavior(), DragStartBehavior.down);
        expect(data["dragStartBehavior"], DragStartBehavior.down);
      });
    },
  );

  group(
    "hitTestBehavior method",
    () {
      test("should parse and return the hitTestBehavior", () {
        final json = <String, dynamic>{
          "hitTestBehavior": "deferToChild",
          "hitTestBehavior2": 0,
        };

        final data = DuitDataSource(json);

        expect(data.hitTestBehavior(), HitTestBehavior.deferToChild);
        expect(data.hitTestBehavior(key: "hitTestBehavior2"),
            HitTestBehavior.deferToChild);
        expect(data["hitTestBehavior"], HitTestBehavior.deferToChild);
        expect(data["hitTestBehavior2"], HitTestBehavior.deferToChild);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.hitTestBehavior(), HitTestBehavior.deferToChild);
        expect(
          data.hitTestBehavior(defaultValue: HitTestBehavior.opaque),
          HitTestBehavior.opaque,
        );
        expect(data["hitTestBehavior"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "hitTestBehavior": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.hitTestBehavior(defaultValue: HitTestBehavior.translucent),
          HitTestBehavior.translucent,
        );
        expect(data["hitTestBehavior"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "hitTestBehavior": HitTestBehavior.opaque,
        };

        final data = DuitDataSource(json);

        expect(data.hitTestBehavior(), HitTestBehavior.opaque);
        expect(data["hitTestBehavior"], HitTestBehavior.opaque);
      });
    },
  );

  group(
    "shapeBorder method",
    () {
      test("should parse and return RoundedRectangleBorder", () {
        final json = <String, dynamic>{
          "shape": {
            "type": "RoundedRectangleBorder",
            "borderRadius": 10.0,
            "borderSide": {
              "color": "#FF0000",
              "width": 2.0,
            },
          },
          "shape2": {
            "type": "StadiumBorder",
            "borderSide": {
              "color": "#FF0000",
              "width": 2.0,
            },
          },
          "shape3": {
            "type": "BeveledRectangleBorder",
            "borderRadius": 10.0,
            "borderSide": {
              "color": "#FF0000",
              "width": 2.0,
            },
          },
          "shape4": {
            "type": "ContinuousRectangleBorder",
            "borderRadius": 10.0,
            "borderSide": {
              "color": "#FF0000",
              "width": 2.0,
            },
          },
        };

        final data = DuitDataSource(json);
        final shape = data.shapeBorder() as RoundedRectangleBorder;

        expect(shape, isA<RoundedRectangleBorder>());
        expect(shape.borderRadius, BorderRadius.circular(10.0));
        expect(shape.side.color, const Color(0xFFFF0000));
        expect(shape.side.width, 2.0);
        expect(data.shapeBorder(key: "shape2"), isA<StadiumBorder>());
        expect(data.shapeBorder(key: "shape3"), isA<BeveledRectangleBorder>());
        expect(
            data.shapeBorder(key: "shape4"), isA<ContinuousRectangleBorder>());
      });

      test("should parse and return CircleBorder", () {
        final json = <String, dynamic>{
          "shape": {
            "type": "CircleBorder",
            "borderSide": {
              "color": "#FF0000",
              "width": 2.0,
            },
          },
        };

        final data = DuitDataSource(json);
        final shape = data.shapeBorder() as CircleBorder;

        expect(shape, isA<CircleBorder>());
        expect(shape.side.color, const Color(0xFFFF0000));
        expect(shape.side.width, 2.0);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};
        const defaultShape = RoundedRectangleBorder();

        final data = DuitDataSource(json);

        expect(data.shapeBorder(), null);
        expect(data.shapeBorder(defaultValue: defaultShape), defaultShape);
        expect(data["shape"], null);
      });

      test("should return instance if the value is already an instance", () {
        const shape = RoundedRectangleBorder();
        final json = <String, dynamic>{
          "shape": shape,
        };

        final data = DuitDataSource(json);

        expect(data.shapeBorder(), shape);
        expect(data["shape"], shape);
      });
    },
  );

  group(
    "border method",
    () {
      test("should parse and return Border", () {
        final json = <String, dynamic>{
          "shape": <String, dynamic>{
            "side": <String, dynamic>{
              "color": "#FF0000",
              "width": 2.0,
              "style": "solid",
            },
          }
        };

        final data = DuitDataSource(json);
        final border = data.border()!;

        expect(border, isA<Border>());
        expect(border.top.width, 2.0);
        expect(border.top.style, BorderStyle.solid);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};
        final defaultBorder = Border.all();

        final data = DuitDataSource(json);

        expect(data.border(), null);
        expect(data.border(defaultValue: defaultBorder), defaultBorder);
        expect(data["shape"], null);
      });

      test("should return instance if the value is already an instance", () {
        final border = Border.all();
        final json = <String, dynamic>{
          "shape": border,
        };

        final data = DuitDataSource(json);

        expect(data.border(), border);
        expect(data["shape"], border);
      });
    },
  );

  group(
    "borderRadius method",
    () {
      test("should parse and return BorderRadius with only corners", () {
        final json = <String, dynamic>{
          "borderRadius": <String, dynamic>{
            "topLeft": <String, dynamic>{
              "radius": 10.0,
            },
            "topRight": <String, dynamic>{
              "radius": 20.0,
            },
            "bottomLeft": <String, dynamic>{
              "radius": 30.0,
            },
            "bottomRight": <String, dynamic>{
              "radius": 40.0,
            },
          },
        };

        final data = DuitDataSource(json);
        final borderRadius = data.borderRadius();

        expect(borderRadius, isA<BorderRadius>());
        expect(borderRadius.topLeft, const Radius.circular(10.0));
        expect(borderRadius.topRight, const Radius.circular(20.0));
        expect(borderRadius.bottomLeft, const Radius.circular(30.0));
        expect(borderRadius.bottomRight, const Radius.circular(40.0));
      });

      test("should parse and return BorderRadius with vertical", () {
        final json = <String, dynamic>{
          "borderRadius": <String, dynamic>{
            "top": <String, dynamic>{
              "radius": 15.0,
            },
            "bottom": <String, dynamic>{
              "radius": 25.0,
            },
          },
        };

        final data = DuitDataSource(json);
        final borderRadius = data.borderRadius();

        expect(borderRadius, isA<BorderRadius>());
        expect(borderRadius.topLeft, const Radius.circular(15.0));
        expect(borderRadius.topRight, const Radius.circular(15.0));
        expect(borderRadius.bottomLeft, const Radius.circular(25.0));
        expect(borderRadius.bottomRight, const Radius.circular(25.0));
      });

      test("should parse and return BorderRadius with horizontal", () {
        final json = <String, dynamic>{
          "borderRadius": <String, dynamic>{
            "left": <String, dynamic>{
              "radius": 12.0,
            },
            "right": <String, dynamic>{
              "radius": 18.0,
            },
          },
        };

        final data = DuitDataSource(json);
        final borderRadius = data.borderRadius();

        expect(borderRadius, isA<BorderRadius>());
        expect(borderRadius.topLeft, const Radius.circular(12.0));
        expect(borderRadius.topRight, const Radius.circular(18.0));
        expect(borderRadius.bottomLeft, const Radius.circular(12.0));
        expect(borderRadius.bottomRight, const Radius.circular(18.0));
      });

      test("should parse and return BorderRadius with all radius", () {
        final json = <String, dynamic>{
          "borderRadius": <String, dynamic>{
            "radius": <String, dynamic>{
              "radius": 8.0,
            },
          },
        };

        final data = DuitDataSource(json);
        final borderRadius = data.borderRadius();

        expect(borderRadius, isA<BorderRadius>());
        expect(borderRadius.topLeft, const Radius.circular(8.0));
        expect(borderRadius.topRight, const Radius.circular(8.0));
        expect(borderRadius.bottomLeft, const Radius.circular(8.0));
        expect(borderRadius.bottomRight, const Radius.circular(8.0));
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};
        final defaultBorderRadius = BorderRadius.circular(10.0);

        final data = DuitDataSource(json);

        expect(data.borderRadius(), BorderRadius.zero);
        expect(data.borderRadius(defaultValue: defaultBorderRadius),
            defaultBorderRadius);
        expect(data["borderRadius"], null);
      });

      test("should return instance if the value is already an instance", () {
        final borderRadius = BorderRadius.circular(10.0);
        final json = <String, dynamic>{
          "borderRadius": borderRadius,
        };

        final data = DuitDataSource(json);

        expect(data.borderRadius(), borderRadius);
        expect(data["borderRadius"], borderRadius);
      });

      test("should return default value for invalid data", () {
        final json = <String, dynamic>{
          "borderRadius": "invalid",
        };
        final defaultBorderRadius = BorderRadius.circular(5.0);

        final data = DuitDataSource(json);

        expect(data.borderRadius(), BorderRadius.zero);
        expect(data.borderRadius(defaultValue: defaultBorderRadius),
            defaultBorderRadius);
      });
    },
  );

  group(
    "radius method",
    () {
      test("should parse and return Radius circular from number", () {
        final json = <String, dynamic>{
          "radius": 15.0,
        };

        final data = DuitDataSource(json);
        final radius = data.radius();

        expect(radius, isA<Radius>());
        expect(radius, const Radius.circular(15.0));
      });

      test("should parse and return Radius circular from int", () {
        final json = <String, dynamic>{
          "radius": 10,
        };

        final data = DuitDataSource(json);
        final radius = data.radius();

        expect(radius, isA<Radius>());
        expect(radius, const Radius.circular(10.0));
      });

      test("should parse and return Radius elliptical from list", () {
        final json = <String, dynamic>{
          "radius": [12.0, 8.0],
        };

        final data = DuitDataSource(json);
        final radius = data.radius();

        expect(radius, isA<Radius>());
        expect(radius, const Radius.elliptical(12.0, 8.0));
      });

      test("should parse and return Radius elliptical from int list", () {
        final json = <String, dynamic>{
          "radius": [20, 15],
        };

        final data = DuitDataSource(json);
        final radius = data.radius();

        expect(radius, isA<Radius>());
        expect(radius, const Radius.elliptical(20.0, 15.0));
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};
        final defaultRadius = const Radius.circular(5.0);

        final data = DuitDataSource(json);

        expect(data.radius(), Radius.zero);
        expect(data.radius(defaultValue: defaultRadius), defaultRadius);
        expect(data["radius"], null);
      });

      test("should return instance if the value is already an instance", () {
        const radius = Radius.circular(7.0);
        final json = <String, dynamic>{
          "radius": radius,
        };

        final data = DuitDataSource(json);

        expect(data.radius(), radius);
        expect(data["radius"], radius);
      });

      test("should return default value for invalid data", () {
        final json = <String, dynamic>{
          "radius": "invalid",
        };
        const defaultRadius = Radius.circular(3.0);

        final data = DuitDataSource(json);

        expect(data.radius(), Radius.zero);
        expect(data.radius(defaultValue: defaultRadius), defaultRadius);
      });

      test("should return default value for empty list", () {
        final json = <String, dynamic>{
          "radius": [],
        };
        const defaultRadius = Radius.circular(4.0);

        final data = DuitDataSource(json);

        expect(data.radius(), Radius.zero);
        expect(data.radius(defaultValue: defaultRadius), defaultRadius);
      });

      test("should work with custom key", () {
        final json = <String, dynamic>{
          "customRadius": 25.0,
        };

        final data = DuitDataSource(json);
        final radius = data.radius(key: "customRadius");

        expect(radius, const Radius.circular(25.0));
      });
    },
  );

  group(
    "fabLocation method",
    () {
      test("should parse and return the fabLocation", () {
        final json = <String, dynamic>{
          "floatingActionButtonLocation": "centerDocked",
          "floatingActionButtonLocation2": 0,
        };

        final data = DuitDataSource(json);

        expect(data.fabLocation(), FloatingActionButtonLocation.centerDocked);
        expect(data.fabLocation(key: "floatingActionButtonLocation2"),
            FloatingActionButtonLocation.centerDocked);
        expect(data["floatingActionButtonLocation"],
            FloatingActionButtonLocation.centerDocked);
        expect(data["floatingActionButtonLocation2"],
            FloatingActionButtonLocation.centerDocked);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};

        final data = DuitDataSource(json);

        expect(data.fabLocation(), null);
        expect(
          data.fabLocation(defaultValue: FloatingActionButtonLocation.endFloat),
          FloatingActionButtonLocation.endFloat,
        );
        expect(data["floatingActionButtonLocation"], null);
      });

      test(
          "should return the default value if the value is not a string or int",
          () {
        final json = <String, dynamic>{
          "floatingActionButtonLocation": true,
        };

        final data = DuitDataSource(json);

        expect(
          data.fabLocation(defaultValue: FloatingActionButtonLocation.endFloat),
          FloatingActionButtonLocation.endFloat,
        );
        expect(data["floatingActionButtonLocation"], true);
      });

      test("should return instance if the value is already an instance", () {
        final json = <String, dynamic>{
          "floatingActionButtonLocation": FloatingActionButtonLocation.endFloat,
        };

        final data = DuitDataSource(json);

        expect(data.fabLocation(), FloatingActionButtonLocation.endFloat);
        expect(data["floatingActionButtonLocation"],
            FloatingActionButtonLocation.endFloat);
      });
    },
  );

  group(
    "buttonStyle method",
    () {
      test("should parse and return ButtonStyle", () {
        final json = <String, dynamic>{
          "style": {
            "backgroundColor": "#FF0000",
            "foregroundColor": "#00FF00",
            "overlayColor": "#0000FF",
            "shadowColor": "#FFFFFF",
            "elevation": 2.0,
            "padding": [10.0, 20.0, 10.0, 20.0],
            "minimumSize": [100.0, 50.0],
            "maximumSize": [200.0, 100.0],
            "iconColor": "#FF00FF",
            "iconSize": 24.0,
            "side": {
              "color": "#FF0000",
              "width": 2.0,
              "style": "solid",
            },
            "shape": {
              "type": "RoundedRectangleBorder",
              "borderRadius": 10.0,
            },
            "visualDensity": {
              "horizontal": 0.0,
              "vertical": 0.0,
            },
            "tapTargetSize": "padded",
            "animationDuration": 200,
            "enableFeedback": true,
            "alignment": "center",
          },
        };

        final data = DuitDataSource(json);
        final style = data.buttonStyle()!;

        expect(style, isA<ButtonStyle>());
        expect(style.visualDensity, const VisualDensity());
        expect(style.tapTargetSize, MaterialTapTargetSize.padded);
        expect(style.animationDuration, const Duration(milliseconds: 200));
        expect(style.enableFeedback, true);
        expect(style.alignment, Alignment.center);
      });

      test("should return the default value if the value is null", () {
        final json = <String, dynamic>{};
        const defaultStyle = ButtonStyle();

        final data = DuitDataSource(json);

        expect(data.buttonStyle(), null);
        expect(data.buttonStyle(defaultValue: defaultStyle), defaultStyle);
        expect(data["style"], null);
      });

      test("should return instance if the value is already an instance", () {
        const style = ButtonStyle();
        final json = <String, dynamic>{
          "style": style,
        };

        final data = DuitDataSource(json);

        expect(data.buttonStyle(), style);
        expect(data["style"], style);
      });
    },
  );

  group("childObjects method", () {
    test("should return empty list if no childObjects present", () {
      final json = <String, dynamic>{};
      final data = DuitDataSource(json);
      expect(data.childObjects(), isEmpty);
    });

    test("should return child objects from the list and clear the key", () {
      final children = [
        {"id": 1, "name": "child1"},
        {"id": 2, "name": "child2"},
      ];
      final json = <String, dynamic>{
        "childObjects": List<Map<String, dynamic>>.from(children),
      };
      final data = DuitDataSource(json);
      final result = data.childObjects();
      expect(result, equals(children));
      expect(json["childObjects"], isNull);
      expect(json["_listContentBuffer"], equals(children));
    });

    test("should accumulate child objects on multiple calls", () {
      final children1 = [
        {"id": 1, "name": "child1"},
      ];
      final children2 = [
        {"id": 2, "name": "child2"},
      ];
      final json = <String, dynamic>{
        "childObjects": List<Map<String, dynamic>>.from(children1),
      };
      final data = DuitDataSource(json);
      data.childObjects();
      // Add more children and call again
      json["childObjects"] = List<Map<String, dynamic>>.from(children2);
      final result = data.childObjects();
      expect(result, equals([...children1, ...children2]));
      expect(json["childObjects"], isNull);
      expect(json["_listContentBuffer"], equals([...children1, ...children2]));
    });

    test("should ignore non-list values for childObjects", () {
      final json = <String, dynamic>{
        "childObjects": "not a list",
      };
      final data = DuitDataSource(json);
      final result = data.childObjects();
      expect(result, isEmpty);
      expect(json["childObjects"], "not a list");
      expect(json["_listContentBuffer"], null);
    });

    test("should use custom key for childObjects", () {
      final children = [
        {"id": 1, "name": "child1"},
      ];
      final json = <String, dynamic>{
        "customKey": List<Map<String, dynamic>>.from(children),
      };
      final data = DuitDataSource(json);
      final result = data.childObjects(key: "customKey");
      expect(result, equals(children));
      expect(json["customKey"], isNull);
      expect(json["_listContentBuffer"], equals(children));
    });

    test("should handle empty list for childObjects", () {
      final json = <String, dynamic>{
        "childObjects": <Map<String, dynamic>>[],
      };
      final data = DuitDataSource(json);
      final result = data.childObjects();
      expect(result, isEmpty);
      expect(json["childObjects"], isNull);
      expect(json["_listContentBuffer"], isEmpty);
    });
  });

  group("themeOverrideRule method", () {
    test("should parse and return themeOverrideRule from string", () {
      final json = <String, dynamic>{
        "overrideRule": "themeOverlay",
        "overrideRule2": "themePriority",
      };

      final data = DuitDataSource(json);

      expect(data.themeOverrideRule(), ThemeOverrideRule.themeOverlay);
      expect(data.themeOverrideRule(key: "overrideRule2"),
          ThemeOverrideRule.themePriority);
      expect(data["overrideRule"], ThemeOverrideRule.themeOverlay);
      expect(data["overrideRule2"], ThemeOverrideRule.themePriority);
    });

    test("should parse and return themeOverrideRule from int", () {
      final json = <String, dynamic>{
        "overrideRule": 0,
        "overrideRule2": 1,
      };

      final data = DuitDataSource(json);

      expect(data.themeOverrideRule(), ThemeOverrideRule.themeOverlay);
      expect(data.themeOverrideRule(key: "overrideRule2"),
          ThemeOverrideRule.themePriority);
      expect(data["overrideRule"], ThemeOverrideRule.themeOverlay);
      expect(data["overrideRule2"], ThemeOverrideRule.themePriority);
    });

    test("should return the default value if the value is null", () {
      final json = <String, dynamic>{};

      final data = DuitDataSource(json);

      expect(data.themeOverrideRule(), ThemeOverrideRule.themeOverlay);
      expect(
        data.themeOverrideRule(defaultValue: ThemeOverrideRule.themePriority),
        ThemeOverrideRule.themePriority,
      );
      expect(data["overrideRule"], null);
    });

    test("should return the default value if the value is not a string or int",
        () {
      final json = <String, dynamic>{
        "overrideRule": true,
      };

      final data = DuitDataSource(json);

      expect(
        data.themeOverrideRule(defaultValue: ThemeOverrideRule.themePriority),
        ThemeOverrideRule.themePriority,
      );
      expect(data["overrideRule"], true);
    });

    test("should return instance if the value is already an instance", () {
      final json = <String, dynamic>{
        "overrideRule": ThemeOverrideRule.themePriority,
      };

      final data = DuitDataSource(json);

      expect(data.themeOverrideRule(), ThemeOverrideRule.themePriority);
      expect(data["overrideRule"], ThemeOverrideRule.themePriority);
    });

    test("should handle unknown string values", () {
      final json = <String, dynamic>{
        "overrideRule": "unknownValue",
      };

      final data = DuitDataSource(json);

      expect(data.themeOverrideRule(), ThemeOverrideRule.themeOverlay);
      expect(data["overrideRule"], ThemeOverrideRule.themeOverlay);
    });

    test("should handle unknown int values", () {
      final json = <String, dynamic>{
        "overrideRule": 999,
      };

      final data = DuitDataSource(json);

      expect(data.themeOverrideRule(), ThemeOverrideRule.themeOverlay);
      expect(data["overrideRule"], ThemeOverrideRule.themeOverlay);
    });
  });

  group("deepCopy method", () {
    test("should create a deep copy of simple values", () {
      final json = <String, dynamic>{
        "string": "test",
        "int": 42,
        "double": 3.14,
        "bool": true,
        "null": null,
      };

      final data = DuitDataSource(json);
      final copy = data.deepCopy();

      expect(copy, isA<Map<String, dynamic>>());
      expect(copy, isNot(same(json)));
      expect(copy["string"], equals("test"));
      expect(copy["int"], equals(42));
      expect(copy["double"], equals(3.14));
      expect(copy["bool"], equals(true));
      expect(copy["null"], isNull);
    });

    test("should create a deep copy of nested maps", () {
      final nestedMap = <String, dynamic>{
        "inner": "value",
        "number": 123,
      };
      final json = <String, dynamic>{
        "outer": nestedMap,
      };

      final data = DuitDataSource(json);
      final copy = data.deepCopy();

      expect(copy["outer"], isA<Map<String, dynamic>>());
      expect(copy["outer"], isNot(same(nestedMap)));
      expect(copy["outer"]["inner"], equals("value"));
      expect(copy["outer"]["number"], equals(123));
    });

    test("should create a deep copy of lists", () {
      final list = [1, 2, 3];
      final json = <String, dynamic>{
        "numbers": list,
      };

      final data = DuitDataSource(json);
      final copy = data.deepCopy();

      expect(copy["numbers"], isA<List>());
      expect(copy["numbers"], isNot(same(list)));
      expect(copy["numbers"], equals([1, 2, 3]));
    });

    test("should create a deep copy of nested lists", () {
      final nestedList = [
        [1, 2],
        [3, 4],
      ];
      final json = <String, dynamic>{
        "matrix": nestedList,
      };

      final data = DuitDataSource(json);
      final copy = data.deepCopy();

      expect(copy["matrix"], isA<List>());
      expect(copy["matrix"], isNot(same(nestedList)));
      expect(copy["matrix"][0], isA<List>());
      expect(copy["matrix"][0], isNot(same(nestedList[0])));
      expect(
          copy["matrix"],
          equals([
            [1, 2],
            [3, 4]
          ]));
    });

    test("should create a deep copy of complex nested structures", () {
      final complexStructure = <String, dynamic>{
        "users": [
          {
            "name": "John",
            "age": 30,
            "hobbies": ["reading", "gaming"],
            "address": {
              "street": "123 Main St",
              "city": "New York",
            },
          },
          {
            "name": "Jane",
            "age": 25,
            "hobbies": ["painting"],
            "address": {
              "street": "456 Oak Ave",
              "city": "Los Angeles",
            },
          },
        ],
        "settings": {
          "theme": "dark",
          "notifications": true,
          "preferences": [1, 2, 3],
        },
      };

      final data = DuitDataSource(complexStructure);
      final copy = data.deepCopy();

      expect(copy, isNot(same(complexStructure)));
      expect(copy["users"], isNot(same(complexStructure["users"])));
      expect(copy["users"][0], isNot(same(complexStructure["users"][0])));
      expect(copy["users"][0]["hobbies"],
          isNot(same(complexStructure["users"][0]["hobbies"])));
      expect(copy["users"][0]["address"],
          isNot(same(complexStructure["users"][0]["address"])));
      expect(copy["settings"], isNot(same(complexStructure["settings"])));
      expect(copy["settings"]["preferences"],
          isNot(same(complexStructure["settings"]["preferences"])));

      // Verify the content is identical
      expect(copy, equals(complexStructure));
    });

    test("should handle empty structures", () {
      final emptyJson = <String, dynamic>{};
      final data = DuitDataSource(emptyJson);
      final copy = data.deepCopy();

      expect(copy, isA<Map<String, dynamic>>());
      expect(copy, isEmpty);
      expect(copy, isNot(same(emptyJson)));
    });

    test("should handle structures with empty lists and maps", () {
      final json = <String, dynamic>{
        "emptyList": <dynamic>[],
        "emptyMap": <String, dynamic>{},
        "nestedEmpty": {
          "list": <dynamic>[],
          "map": <String, dynamic>{},
        },
      };

      final data = DuitDataSource(json);
      final copy = data.deepCopy();

      expect(copy["emptyList"], isA<List>());
      expect(copy["emptyList"], isEmpty);
      expect(copy["emptyMap"], isA<Map<String, dynamic>>());
      expect(copy["emptyMap"], isEmpty);
      expect(copy["nestedEmpty"]["list"], isA<List>());
      expect(copy["nestedEmpty"]["list"], isEmpty);
      expect(copy["nestedEmpty"]["map"], isA<Map<String, dynamic>>());
      expect(copy["nestedEmpty"]["map"], isEmpty);
    });

    test("should not affect the original data when modifying the copy", () {
      final original = <String, dynamic>{
        "nested": {
          "value": "original",
          "list": [1, 2, 3],
        },
      };

      final data = DuitDataSource(original);
      final copy = data.deepCopy();

      // Modify the copy
      copy["nested"]["value"] = "modified";
      copy["nested"]["list"].add(4);

      // Original should remain unchanged
      expect(original["nested"]["value"], equals("original"));
      expect(original["nested"]["list"], equals([1, 2, 3]));
      expect(data["nested"]["value"], equals("original"));
      expect(data["nested"]["list"], equals([1, 2, 3]));

      // Copy should reflect changes
      expect(copy["nested"]["value"], equals("modified"));
      expect(copy["nested"]["list"], equals([1, 2, 3, 4]));
    });
  });

  group("imageFilter method", () {
    test("should parse and return blur ImageFilter from string type", () {
      final json = <String, dynamic>{
        "filter": {
          "type": "blur",
          "sigmaX": 5.0,
          "sigmaY": 3.0,
          "tileMode": "clamp",
        },
      };

      final data = DuitDataSource(json);
      final filter = data.imageFilter();

      expect(filter, isA<ImageFilter>());
      expect(data["filter"], filter);
    });

    test("should parse and return blur ImageFilter from int type", () {
      final json = <String, dynamic>{
        "filter": <String, dynamic>{
          "type": 0,
          "sigmaX": 2.0,
          "sigmaY": 2.0,
          "tileMode": 0,
        },
      };

      final data = DuitDataSource(json);
      final filter = data.imageFilter();

      expect(filter, isA<ImageFilter>());
      expect(data["filter"], filter);
    });

    test("should parse and return dilate ImageFilter", () {
      final json = <String, dynamic>{
        "filter": <String, dynamic>{
          "type": "dilate",
          "radiusX": 3.0,
          "radiusY": 4.0,
        },
      };

      final data = DuitDataSource(json);
      final filter = data.imageFilter();

      expect(filter, isA<ImageFilter>());
      expect(data["filter"], filter);
    });

    test("should parse and return erode ImageFilter", () {
      final json = <String, dynamic>{
        "filter": <String, dynamic>{
          "type": "erode",
          "radiusX": 1.5,
          "radiusY": 2.5,
        },
      };

      final data = DuitDataSource(json);
      final filter = data.imageFilter();

      expect(filter, isA<ImageFilter>());
      expect(data["filter"], filter);
    });

    test("should parse and return matrix ImageFilter", () {
      final json = <String, dynamic>{
        "filter": <String, dynamic>{
          "type": "matrix",
          "matrix4": [
            1.0,
            0.0,
            0.0,
            0.0,
            0.0,
            1.0,
            0.0,
            0.0,
            0.0,
            0.0,
            1.0,
            0.0,
            0.0,
            0.0,
            0.0,
            1.0
          ],
          "filterQuality": "high",
        },
      };

      final data = DuitDataSource(json);
      final filter = data.imageFilter()!;

      expect(filter, isA<ImageFilter>());
      expect(data["filter"], filter);
    });

    test("should parse and return compose ImageFilter", () {
      final json = <String, dynamic>{
        "filter": <String, dynamic>{
          "type": "compose",
          "outer": {
            "type": "blur",
            "sigmaX": 2.0,
            "sigmaY": 2.0,
          },
          "inner": {
            "type": "dilate",
            "radiusX": 1.0,
            "radiusY": 1.0,
          },
        },
      };

      final data = DuitDataSource(json);
      final filter = data.imageFilter()!;

      expect(filter, isA<ImageFilter>());
      expect(data["filter"], filter);
    });

    test("should return the default value if the value is null", () {
      final json = <String, dynamic>{};

      final data = DuitDataSource(json);

      expect(data.imageFilter(defaultValue: ImageFilter.blur()),
          ImageFilter.blur());
      expect(data["filter"], null);
    });

    test("should return the default value if the value is not a map", () {
      final json = <String, dynamic>{
        "filter": "not a map",
      };

      final data = DuitDataSource(json);

      expect(data.imageFilter(), isNull);
      expect(data["filter"], "not a map");
    });

    test("should return instance if the value is already an instance", () {
      final filter = ImageFilter.blur();
      final json = <String, dynamic>{
        "filter": filter,
      };

      final data = DuitDataSource(json);

      expect(data.imageFilter(), filter);
      expect(data["filter"], filter);
    });

    test("should handle null type values", () {
      final json = <String, dynamic>{
        "filter": {
          "type": null,
          "sigmaX": 1.0,
        },
      };

      final data = DuitDataSource(json);
      final filter = data.imageFilter();

      expect(filter, isNull);
      expect(data["filter"], isNull);
    });

    test("should use custom key for imageFilter", () {
      final json = <String, dynamic>{
        "customFilter": {
          "type": "blur",
          "sigmaX": 3.0,
          "sigmaY": 3.0,
        },
      };

      final data = DuitDataSource(json);
      final filter = data.imageFilter(key: "customFilter")!;

      expect(filter, isA<ImageFilter>());
      expect(data["customFilter"], filter);
    });

    test("should handle missing parameters in blur filter", () {
      final json = <String, dynamic>{
        "filter": {
          "type": "blur",
        },
      };

      final data = DuitDataSource(json);
      final filter = data.imageFilter()!;

      expect(filter, isA<ImageFilter>());
      expect(data["filter"], filter);
    });

    test("should handle missing parameters in dilate filter", () {
      final json = <String, dynamic>{
        "filter": {
          "type": "dilate",
        },
      };

      final data = DuitDataSource(json);
      final filter = data.imageFilter()!;

      expect(filter, isA<ImageFilter>());
      expect(data["filter"], filter);
    });

    test("should handle missing parameters in erode filter", () {
      final json = <String, dynamic>{
        "filter": {
          "type": "erode",
        },
      };

      final data = DuitDataSource(json);
      final filter = data.imageFilter()!;

      expect(filter, isA<ImageFilter>());
      expect(data["filter"], filter);
    });

    test("should handle missing parameters in matrix filter", () {
      final json = <String, dynamic>{
        "filter": {
          "type": "matrix",
          "matrix4": [
            1.0,
            0.0,
            0.0,
            0.0,
            0.0,
            1.0,
            0.0,
            0.0,
            0.0,
            0.0,
            1.0,
            0.0,
            0.0,
            0.0,
            0.0,
            1.0
          ],
        },
      };

      final data = DuitDataSource(json);
      final filter = data.imageFilter()!;

      expect(filter, isA<ImageFilter>());
      expect(data["filter"], filter);
    });

    test("should handle missing parameters in compose filter", () {
      final json = <String, dynamic>{
        "filter": {
          "type": "compose",
        },
      };

      final data = DuitDataSource(json);
      final filter = data.imageFilter()!;

      expect(filter, isA<ImageFilter>());
      expect(data["filter"], filter);
    });

    test("should handle nested compose filters", () {
      final json = <String, dynamic>{
        "filter": {
          "type": "compose",
          "outer": {
            "type": "compose",
            "outer": {
              "type": "blur",
              "sigmaX": 1.0,
            },
            "inner": {
              "type": "dilate",
              "radiusX": 1.0,
            },
          },
          "inner": {
            "type": "erode",
            "radiusX": 1.0,
          },
        },
      };

      final data = DuitDataSource(json);
      final filter = data.imageFilter()!;

      expect(filter, isA<ImageFilter>());
      expect(data["filter"], filter);
    });
  });

  group("collapseMode method", () {
    test("should parse and return the collapseMode from string", () {
      final json = <String, dynamic>{
        "collapseMode": "parallax",
        "collapseMode2": "pin",
      };

      final data = DuitDataSource(json);

      expect(data.collapseMode(), CollapseMode.parallax);
      expect(data.collapseMode(key: "collapseMode2"), CollapseMode.pin);
      expect(data["collapseMode"], CollapseMode.parallax);
      expect(data["collapseMode2"], CollapseMode.pin);
    });

    test("should parse and return the collapseMode from int", () {
      final json = <String, dynamic>{
        "collapseMode": 0, // parallax
        "collapseMode2": 1, // pin
      };

      final data = DuitDataSource(json);

      expect(data.collapseMode(), CollapseMode.parallax);
      expect(data.collapseMode(key: "collapseMode2"), CollapseMode.pin);
      expect(data["collapseMode"], CollapseMode.parallax);
      expect(data["collapseMode2"], CollapseMode.pin);
    });

    test("should return the default value if the value is null", () {
      final json = <String, dynamic>{};

      final data = DuitDataSource(json);

      expect(data.collapseMode(), CollapseMode.parallax);
      expect(
        data.collapseMode(defaultValue: CollapseMode.pin),
        CollapseMode.pin,
      );
      expect(data["collapseMode"], null);
    });

    test("should return the default value if the value is not a string or int",
        () {
      final json = <String, dynamic>{
        "collapseMode": true,
      };

      final data = DuitDataSource(json);

      expect(
        data.collapseMode(defaultValue: CollapseMode.pin),
        CollapseMode.pin,
      );
      expect(data["collapseMode"], true);
    });

    test("should return instance if the value is already an instance", () {
      final json = <String, dynamic>{
        "collapseMode": CollapseMode.parallax,
      };

      final data = DuitDataSource(json);

      expect(data.collapseMode(), CollapseMode.parallax);
      expect(data["collapseMode"], CollapseMode.parallax);
    });

    test("should use custom key for collapseMode", () {
      final json = <String, dynamic>{
        "customCollapseMode": "pin",
      };

      final data = DuitDataSource(json);

      expect(data.collapseMode(key: "customCollapseMode"), CollapseMode.pin);
      expect(data["customCollapseMode"], CollapseMode.pin);
    });
  });

  group("stretchModes method", () {
    test("should parse and return the stretchModes from list of strings", () {
      final json = <String, dynamic>{
        "stretchModes": ["zoomBackground", "blurBackground"],
        "stretchMode2": ["fadeTitle"],
      };

      final data = DuitDataSource(json);

      expect(
        data.stretchModes(),
        [StretchMode.zoomBackground, StretchMode.blurBackground],
      );
      expect(
        data.stretchModes(key: "stretchMode2"),
        [StretchMode.fadeTitle],
      );
      expect(
        data["stretchModes"],
        [StretchMode.zoomBackground, StretchMode.blurBackground],
      );
      expect(
        data["stretchMode2"],
        [StretchMode.fadeTitle],
      );
    });

    test("should parse and return the stretchModes from list of ints", () {
      final json = <String, dynamic>{
        "stretchModes": [0, 1], // zoomBackground, blurBackground
        "stretchMode2": [2], // fadeTitle
      };

      final data = DuitDataSource(json);

      expect(data.stretchModes(),
          [StretchMode.zoomBackground, StretchMode.blurBackground]);
      expect(data.stretchModes(key: "stretchMode2"), [StretchMode.fadeTitle]);
      expect(data["stretchModes"],
          [StretchMode.zoomBackground, StretchMode.blurBackground]);
      expect(data["stretchMode2"], [StretchMode.fadeTitle]);
    });

    test("should return the default value if the value is null", () {
      final json = <String, dynamic>{};

      final data = DuitDataSource(json);

      expect(data.stretchModes(), [StretchMode.zoomBackground]);
      expect(
        data.stretchModes(defaultValue: [StretchMode.fadeTitle]),
        [StretchMode.fadeTitle],
      );
      expect(data["stretchMode"], null);
    });

    test("should return the default value if the value is not a list", () {
      final json = <String, dynamic>{
        "stretchModes": "not a list",
      };

      final data = DuitDataSource(json);

      expect(
        data.stretchModes(defaultValue: [StretchMode.fadeTitle]),
        [StretchMode.fadeTitle],
      );
      expect(data["stretchModes"], "not a list");
    });

    test("should return instance if the value is already an instance", () {
      final stretchModes = [
        StretchMode.zoomBackground,
        StretchMode.blurBackground
      ];
      final json = <String, dynamic>{
        "stretchModes": stretchModes,
      };

      final data = DuitDataSource(json);

      expect(data.stretchModes(), stretchModes);
      expect(data["stretchModes"], stretchModes);
    });

    test("should use custom key for stretchModes", () {
      final json = <String, dynamic>{
        "customStretchMode": ["zoomBackground", "fadeTitle"],
      };

      final data = DuitDataSource(json);

      expect(data.stretchModes(key: "customStretchMode"),
          [StretchMode.zoomBackground, StretchMode.fadeTitle]);
      expect(data["customStretchMode"],
          [StretchMode.zoomBackground, StretchMode.fadeTitle]);
    });

    test("should handle empty list of strings", () {
      final json = <String, dynamic>{
        "stretchModes": <String>[],
      };

      final data = DuitDataSource(json);

      expect(data.stretchModes(), [StretchMode.zoomBackground]);
      expect(data["stretchModes"], [StretchMode.zoomBackground]);
    });

    test("should handle empty list of ints", () {
      final json = <String, dynamic>{
        "stretchModes": <int>[],
      };

      final data = DuitDataSource(json);

      expect(data.stretchModes(), [StretchMode.zoomBackground]);
      expect(data["stretchModes"], [StretchMode.zoomBackground]);
    });

    test("should handle mixed valid and invalid string values", () {
      final json = <String, dynamic>{
        "stretchModes": ["zoomBackground", "invalidMode", "blurBackground"],
      };

      final data = DuitDataSource(json);

      expect(data.stretchModes(),
          [StretchMode.zoomBackground, StretchMode.blurBackground]);
      expect(data["stretchModes"],
          [StretchMode.zoomBackground, StretchMode.blurBackground]);
    });

    test("should handle mixed valid and invalid int values", () {
      final json = <String, dynamic>{
        "stretchModes": [
          0,
          999,
          1
        ], // 0=zoomBackground, 999=invalid, 1=blurBackground
      };

      final data = DuitDataSource(json);

      expect(data.stretchModes(),
          [StretchMode.zoomBackground, StretchMode.blurBackground]);
      expect(data["stretchModes"],
          [StretchMode.zoomBackground, StretchMode.blurBackground]);
    });
  });

  group("DuitDataSource action/meta methods", () {
    test("getAction should parse TransportAction from map", () {
      final json = <String, dynamic>{
        "action": {
          "event": "testEvent",
          "executionType": 0,
          "dependsOn": [
            {"target": "t1", "id": "id1"}
          ],
          "meta": {"method": "POST"}
        }
      };
      ServerAction.setActionParser(const DefaultActionParser());
      final data = DuitDataSource(json);
      final action = data.getAction("action");
      expect(action, isA<TransportAction>());
      expect(action!.eventName, "testEvent");
      expect(action.executionType, 0);
      expect(action.dependsOn.length, 1);
      expect(action.dependsOn.first.target, "t1");
      expect(action.dependsOn.first.id, "id1");
      expect((action as TransportAction).meta!.method, "POST");
    });

    test("getAction should parse LocalAction from map", () {
      // Настроим парсеры для корректной работы
      ServerAction.setActionParser(const DefaultActionParser());
      ServerEvent.eventParser = const DefaultEventParser();

      final json = <String, dynamic>{
        "action": {
          "event": "local_exec",
          "executionType": 1,
          "payload": {
            "type": "update",
            "updates": {"key": "value"}
          }
        }
      };
      final data = DuitDataSource(json);
      final action = data.getAction("action");
      expect(action, isA<LocalAction>());
      expect(action!.eventName, "local_exec");
      expect(action.executionType, 1);
      expect((action as LocalAction).event, isA<UpdateEvent>());
    });

    test("getAction should parse ScriptAction from map", () {
      final json = <String, dynamic>{
        "action": {
          "event": "script",
          "executionType": 2,
          "dependsOn": [
            {"target": "t1", "id": "id1"}
          ],
          "script": {
            "sourceCode": "print('hi')",
            "functionName": "main",
            "meta": {"info": "metaInfo"}
          }
        }
      };
      ServerAction.setActionParser(const DefaultActionParser());
      final data = DuitDataSource(json);
      final action = data.getAction("action");
      expect(action, isA<ScriptAction>());
      expect(action!.eventName, "script");
      expect(action.executionType, 2);
      expect(action.dependsOn.length, 1);
      expect(action.dependsOn.first.target, "t1");
      expect(action.dependsOn.first.id, "id1");
      expect((action as ScriptAction).script.sourceCode, "print('hi')");
      expect((action).script.functionName, "main");
      expect((action).script.meta, {"info": "metaInfo"});
    });

    test("getAction should parse UnknownAction for invalid executionType", () {
      final json = <String, dynamic>{
        "action": {"event": "unknown", "executionType": 999}
      };
      ServerAction.setActionParser(const DefaultActionParser());
      final data = DuitDataSource(json);
      final action = data.getAction("action");
      expect(action, isA<UnknownAction>());
      expect(action!.eventName, "unknown");
      expect(action.executionType, -1);
    });

    test("getAction should return existing ServerAction instance", () {
      final existingAction = TransportAction(
        eventName: "existing",
        dependsOn: [],
        meta: HttpActionMetainfo(method: "GET"),
      );
      final json = <String, dynamic>{"action": existingAction};
      final data = DuitDataSource(json);
      final action = data.getAction("action");
      expect(action, same(existingAction));
      expect(action!.eventName, "existing");
      expect(action.executionType, 0);
    });

    test("getAction should return null if not present", () {
      final data = DuitDataSource({});
      expect(data.getAction("action"), isNull);
    });

    test("getAction should return null for invalid action data", () {
      final json = <String, dynamic>{"action": "not a map"};
      final data = DuitDataSource(json);
      expect(data.getAction("action"), isNull);
    });

    test("getActionDependencies should parse dependencies", () {
      final json = <String, dynamic>{
        "dependsOn": [
          {"target": "t1", "id": "id1"},
          {"target": "t2", "id": "id2"}
        ]
      };
      final data = DuitDataSource(json);
      final deps = data.getActionDependencies().toList();
      expect(deps.length, 2);
      expect(deps[0].target, "t1");
      expect(deps[0].id, "id1");
      expect(deps[1].target, "t2");
      expect(deps[1].id, "id2");
    });

    test("getActionDependencies should return empty list if not present", () {
      final data = DuitDataSource({});
      final deps = data.getActionDependencies();
      expect(deps, isEmpty);
    });

    test("getActionDependencies should return empty list for invalid data", () {
      final json = <String, dynamic>{"dependsOn": "not a list"};
      final data = DuitDataSource(json);
      final deps = data.getActionDependencies();
      expect(deps, isEmpty);
    });

    test("meta should parse HttpActionMetainfo from map", () {
      final json = <String, dynamic>{
        "meta": {"method": "POST"}
      };
      final data = DuitDataSource(json);
      expect(data.meta, isA<HttpActionMetainfo>());
      expect(data.meta!.method, "POST");
    });

    test("meta should return null if not present", () {
      final data = DuitDataSource({});
      expect(data.meta, isNull);
    });

    test("executionType should return int if present", () {
      final data = DuitDataSource({"executionType": 2});
      expect(data.executionType, 2);
    });

    test("executionType should return 0 if not present or not int", () {
      expect(DuitDataSource({}).executionType, 0);
      expect(DuitDataSource({"executionType": "str"}).executionType, 0);
    });

    test("script should parse ScriptDefinition from map", () {
      final json = <String, dynamic>{
        "script": {
          "sourceCode": "print('hi')",
          "functionName": "main",
          "meta": {"info": "metaInfo"}
        }
      };
      final data = DuitDataSource(json);
      final script = data.script;
      expect(script, isA<ScriptDefinition>());
      expect(script.sourceCode, "print('hi')");
      expect(script.functionName, "main");
      expect(script.meta, {"info": "metaInfo"});
    });

    test("parentBuilderId should return string if present", () {
      final data = DuitDataSource({"parentBuilderId": "pid123"});
      expect(data.parentBuilderId, "pid123");
    });

    test("parentBuilderId should return null if not present or not string", () {
      expect(DuitDataSource({}).parentBuilderId, isNull);
      expect(DuitDataSource({"parentBuilderId": 123}).parentBuilderId, isNull);
    });

    test("affectedProperties should return set of strings if present", () {
      final data = DuitDataSource({
        "affectedProperties": ["a", "b", "c"]
      });
      expect(data.affectedProperties, isA<Set<String>>());
      expect(data.affectedProperties, containsAll(["a", "b", "c"]));
    });

    test("affectedProperties should return null if not present or not iterable",
        () {
      expect(DuitDataSource({}).affectedProperties, isNull);
      expect(DuitDataSource({"affectedProperties": 123}).affectedProperties,
          isNull);
    });
  });

  group("DuitDataSource tweens method", () {
    test("tweens should parse basic tween from map", () {
      final json = <String, dynamic>{
        "tweenDescriptions": [
          {
            "type": "tween",
            "animatedPropKey": "opacity",
            "duration": 500,
            "begin": 0.0,
            "end": 1.0,
            "curve": "easeIn",
            "trigger": 0, // onEnter
            "method": 0, // forward
            "reverseOnRepeat": false,
            "interval": {"begin": 0.0, "end": 1.0}
          }
        ]
      };
      final data = DuitDataSource(json);
      final tweens = data.tweens();

      expect(tweens.length, 1);
      expect(tweens.first, isA<TweenDescription>());
      final tween = tweens.first as TweenDescription;
      expect(tween.animatedPropKey, "opacity");
      expect(tween.duration, const Duration(milliseconds: 500));
      expect(tween.begin, 0.0);
      expect(tween.end, 1.0);
      expect(tween.curve, Curves.easeIn);
      expect(tween.trigger, AnimationTrigger.onEnter);
      expect(tween.method, AnimationMethod.forward);
      expect(tween.reverseOnRepeat, false);
      expect(tween.interval, isA<AnimationInterval>());
    });

    test("tweens should parse colorTween from map", () {
      final json = <String, dynamic>{
        "tweenDescriptions": [
          {
            "type": "colorTween",
            "animatedPropKey": "backgroundColor",
            "duration": 300,
            "begin": "#FF0000",
            "end": "#0000FF",
            "curve": "easeIn",
            "trigger": 1, // onAction
            "method": 1, // repeat
            "reverseOnRepeat": true
          }
        ]
      };
      final data = DuitDataSource(json);
      final tweens = data.tweens();

      expect(tweens.length, 1);
      expect(tweens.first, isA<ColorTweenDescription>());
      final tween = tweens.first as ColorTweenDescription;
      expect(tween.animatedPropKey, "backgroundColor");
      expect(tween.duration, const Duration(milliseconds: 300));
      expect(tween.begin, const Color(0xFFFF0000)); // #FF0000
      expect(tween.end, const Color(0xFF0000FF)); // #0000FF
      expect(tween.curve, Curves.easeIn);
      expect(tween.trigger, AnimationTrigger.onAction);
      expect(tween.method, AnimationMethod.repeat);
      expect(tween.reverseOnRepeat, true);
    });

    test("tweens should parse textStyleTween from map", () {
      final json = <String, dynamic>{
        "tweenDescriptions": [
          {
            "type": "textStyleTween",
            "animatedPropKey": "textStyle",
            "duration": 400,
            "begin": {"fontSize": 14, "color": "#000000"},
            "end": {"fontSize": 18, "color": "#FF0000", "fontWeight": 700},
            "curve": "easeIn",
            "trigger": 0, // onEnter
            "method": 0, // forward
            "reverseOnRepeat": false
          }
        ]
      };
      final data = DuitDataSource(json);
      final tweens = data.tweens();

      expect(tweens.length, 1);
      expect(tweens.first, isA<TextStyleTweenDescription>());
      final tween = tweens.first as TextStyleTweenDescription;
      expect(tween.animatedPropKey, "textStyle");
      expect(tween.duration, const Duration(milliseconds: 400));
      expect(tween.begin.fontSize, 14);
      expect(tween.begin.color, const Color(0xFF000000)); // #000000
      expect(tween.end.fontSize, 18);
      expect(tween.end.color, const Color(0xFFFF0000)); // #FF0000
      expect(tween.end.fontWeight, FontWeight.bold);
    });

    test("tweens should parse decorationTween from map", () {
      final json = <String, dynamic>{
        "tweenDescriptions": [
          {
            "type": "decorationTween",
            "animatedPropKey": "decoration",
            "duration": 600,
            "begin": {"color": "#FFFFFF", "borderRadius": 8},
            "end": {
              "color": "#0000FF",
              "borderRadius": 20,
              "boxShadow": [
                {"color": "#000000", "blurRadius": 10}
              ]
            },
            "curve": "easeIn",
            "trigger": 0, // onEnter
            "method": 0, // forward
            "reverseOnRepeat": true
          }
        ]
      };
      final data = DuitDataSource(json);
      final tweens = data.tweens();

      expect(tweens.length, 1);
      expect(tweens.first, isA<DecorationTweenDescription>());
      final tween = tweens.first as DecorationTweenDescription;
      expect(tween.animatedPropKey, "decoration");
      expect(tween.duration, const Duration(milliseconds: 600));
      expect((tween.begin as BoxDecoration).color,
          const Color(0xFFFFFFFF)); // #FFFFFF
      expect((tween.end as BoxDecoration).color,
          const Color(0xFF0000FF)); // #0000FF
    });

    test("tweens should parse alignmentTween from map", () {
      final json = <String, dynamic>{
        "tweenDescriptions": [
          {
            "type": "alignmentTween",
            "animatedPropKey": "alignment",
            "duration": 500,
            "begin": "topLeft",
            "end": "bottomRight",
            "curve": "easeIn",
            "trigger": 0, // onEnter
            "method": 0, // forward
            "reverseOnRepeat": true
          }
        ]
      };
      final data = DuitDataSource(json);
      final tweens = data.tweens();

      expect(tweens.length, 1);
      expect(tweens.first, isA<AlignmentTweenDescription>());
      final tween = tweens.first as AlignmentTweenDescription;
      expect(tween.animatedPropKey, "alignment");
      expect(tween.duration, const Duration(milliseconds: 500));
      expect(tween.begin, Alignment.topLeft);
      expect(tween.end, Alignment.bottomRight);
    });

    test("tweens should parse sizeTween from map", () {
      final json = <String, dynamic>{
        "tweenDescriptions": [
          {
            "type": "sizeTween",
            "animatedPropKey": "size",
            "duration": 500,
            "begin": {"width": 100, "height": 50},
            "end": {"width": 200, "height": 100},
            "curve": "easeIn",
            "trigger": 0, // onEnter
            "method": 0, // forward
            "reverseOnRepeat": true
          }
        ]
      };
      final data = DuitDataSource(json);
      final tweens = data.tweens();

      expect(tweens.length, 1);
      expect(tweens.first, isA<SizeTweenDescription>());
      final tween = tweens.first as SizeTweenDescription;
      expect(tween.animatedPropKey, "size");
      expect(tween.duration, const Duration(milliseconds: 500));
      expect(tween.begin, const Size(100, 50));
      expect(tween.end, const Size(200, 100));
    });

    test("tweens should parse edgeInsetsTween from map", () {
      final json = <String, dynamic>{
        "tweenDescriptions": [
          {
            "type": "edgeInsetsTween",
            "animatedPropKey": "padding",
            "duration": 300,
            "begin": [8, 8, 8, 8],
            "end": [16, 16, 16, 16],
            "curve": "easeIn",
            "trigger": 1, // onAction
            "method": 0, // forward
            "reverseOnRepeat": true
          }
        ]
      };
      final data = DuitDataSource(json);
      final tweens = data.tweens();

      expect(tweens.length, 1);
      expect(tweens.first, isA<EdgeInsetsTweenDescription>());
      final tween = tweens.first as EdgeInsetsTweenDescription;
      expect(tween.animatedPropKey, "padding");
      expect(tween.duration, const Duration(milliseconds: 300));
      expect(tween.begin, const EdgeInsets.all(8));
      expect(tween.end, const EdgeInsets.all(16));
    });

    test("tweens should parse boxConstraintsTween from map", () {
      final json = <String, dynamic>{
        "tweenDescriptions": [
          {
            "type": "boxConstraintsTween",
            "animatedPropKey": "constraints",
            "duration": 400,
            "begin": {"minWidth": 100, "minHeight": 50},
            "end": {"minWidth": 200, "minHeight": 100},
            "curve": "easeIn",
            "trigger": 0, // onEnter
            "method": 0, // forward
            "reverseOnRepeat": false
          }
        ]
      };
      final data = DuitDataSource(json);
      final tweens = data.tweens();

      expect(tweens.length, 1);
      expect(tweens.first, isA<BoxConstraintsTweenDescription>());
      final tween = tweens.first as BoxConstraintsTweenDescription;
      expect(tween.animatedPropKey, "constraints");
      expect(tween.duration, const Duration(milliseconds: 400));
      expect(tween.begin.minWidth, 100);
      expect(tween.begin.minHeight, 50);
      expect(tween.end.minWidth, 200);
      expect(tween.end.minHeight, 100);
    });

    test("tweens should parse borderTween from map", () {
      final json = <String, dynamic>{
        "tweenDescriptions": [
          {
            "type": "borderTween",
            "animatedPropKey": "border",
            "duration": 300,
            "begin": <String, dynamic>{
              "side": {
                "color": "#808080",
                "width": 1,
                "style": "solid",
              },
            },
            "end": <String, dynamic>{
              "side": {
                "color": "#0000FF",
                "width": 3,
                "style": "solid",
              },
            },
            "curve": "easeIn",
            "trigger": 1, // onAction
            "method": 0, // forward
            "reverseOnRepeat": false
          }
        ]
      };
      final data = DuitDataSource(json);
      final tweens = data.tweens();

      expect(tweens.first, isA<BorderTweenDescription>());
      final tween = tweens.first as BorderTweenDescription;
      expect(tween.animatedPropKey, "border");
      expect(tween.duration, const Duration(milliseconds: 300));
      expect(tween.begin.top.width, 1);
      expect(tween.end.top.color, const Color(0xFF0000FF)); // #0000FF
      expect(tween.end.top.width, 3);
    });

    test("tweens should parse group from map", () {
      final json = <String, dynamic>{
        "tweenDescriptions": [
          {
            "type": "group",
            "groupId": "fade_and_scale",
            "duration": 800,
            "tweens": [
              {
                "type": "tween",
                "animatedPropKey": "opacity",
                "duration": 800,
                "begin": 0.0,
                "end": 1.0,
                "curve": "easeIn",
                "trigger": 0, // onEnter
                "method": 0, // forward
                "reverseOnRepeat": false
              },
              {
                "type": "tween",
                "animatedPropKey": "scale",
                "duration": 800,
                "begin": 0.5,
                "end": 1.0,
                "curve": "easeIn",
                "trigger": 0, // onEnter
                "method": 0, // forward
                "reverseOnRepeat": false
              }
            ],
            "method": 0, // forward
            "reverseOnRepeat": false,
            "trigger": 0 // onEnter
          }
        ]
      };
      final data = DuitDataSource(json);
      final tweens = data.tweens();

      expect(tweens.length, 1);
      expect(tweens.first, isA<TweenDescriptionGroup>());
      final group = tweens.first as TweenDescriptionGroup;
      expect(group.groupId, "fade_and_scale");
      expect(group.duration, const Duration(milliseconds: 800));
      expect(group.tweens.length, 2);
      expect(group.method, AnimationMethod.forward);
      expect(group.reverseOnRepeat, false);
      expect(group.trigger, AnimationTrigger.onEnter);

      final firstTween = group.tweens.first as TweenDescription;
      expect(firstTween.animatedPropKey, "opacity");
      expect(firstTween.begin, 0.0);
      expect(firstTween.end, 1.0);

      final secondTween = group.tweens.elementAt(1) as TweenDescription;
      expect(secondTween.animatedPropKey, "scale");
      expect(secondTween.begin, 0.5);
      expect(secondTween.end, 1.0);
    });

    test("tweens should return empty list when key is not present", () {
      final data = DuitDataSource({});
      final tweens = data.tweens();
      expect(tweens, isEmpty);
    });

    test(
        "tweens should return empty list when value is not List<Map<String, dynamic>>",
        () {
      final json = <String, dynamic>{"tweenDescriptions": "not a list"};
      final data = DuitDataSource(json);
      final tweens = data.tweens();
      expect(tweens, isEmpty);
    });

    test("tweens should handle multiple tween types in one list", () {
      final json = <String, dynamic>{
        "tweenDescriptions": [
          {
            "type": "tween",
            "animatedPropKey": "opacity",
            "duration": 500,
            "begin": 0.0,
            "end": 1.0,
            "curve": "easeIn",
            "trigger": 0, // onEnter
            "method": 0, // forward
            "reverseOnRepeat": false
          },
          {
            "type": "colorTween",
            "animatedPropKey": "backgroundColor",
            "duration": 300,
            "begin": "#FF0000",
            "end": "#0000FF",
            "curve": "easeIn",
            "trigger": 1, // onAction
            "method": 1, // repeat
            "reverseOnRepeat": true
          }
        ]
      };
      final data = DuitDataSource(json);
      final tweens = data.tweens();

      expect(tweens.length, 2);
      expect(tweens.first, isA<TweenDescription>());
      expect(tweens.last, isA<ColorTweenDescription>());
    });

    test("tweens should use default values when optional fields are missing",
        () {
      final json = <String, dynamic>{
        "tweenDescriptions": [
          {
            "type": "tween",
            "animatedPropKey": "opacity",
            "duration": 500,
            "begin": 0.0,
            "end": 1.0
            // Missing curve, trigger, method, reverseOnRepeat - should use defaults
          }
        ]
      };
      final data = DuitDataSource(json);
      final tweens = data.tweens();

      expect(tweens.length, 1);
      final tween = tweens.first as TweenDescription;
      expect(tween.curve, Curves.linear); // Default curve
      expect(tween.trigger, AnimationTrigger.onEnter); // Default trigger
      expect(tween.method, AnimationMethod.forward); // Default method
      expect(tween.reverseOnRepeat, false); // Default reverseOnRepeat
    });
  });

  group("animationInterval method", () {
    test("should return default if value is null", () {
      final data = DuitDataSource({});
      expect(
        data.animationInterval(),
        const AnimationInterval(0.0, 1.0),
      );
    });

    test("should return value if already AnimationInterval", () {
      const interval = AnimationInterval(0.2, 0.8);
      final data = DuitDataSource({"interval": interval});
      expect(data.animationInterval(), interval);
    });

    test("should parse from Map", () {
      final data = DuitDataSource({
        "interval": {"begin": 0.3, "end": 0.7}
      });
      final result = data.animationInterval();
      expect(result, isA<AnimationInterval>());
      expect(result.begin, 0.3);
      expect(result.end, 0.7);
    });

    test("should parse from List", () {
      final data = DuitDataSource({
        "interval": [0.1, 0.9]
      });
      final result = data.animationInterval();
      expect(result, isA<AnimationInterval>());
      expect(result.begin, 0.1);
      expect(result.end, 0.9);
    });

    test("should return default for unsupported type", () {
      final data = DuitDataSource({"interval": "not valid"});
      expect(
        data.animationInterval(),
        const AnimationInterval(0.0, 1.0),
      );
    });

    test("should use custom key and defaultValue", () {
      final data = DuitDataSource({"custom": null});
      expect(
        data.animationInterval(
            key: "custom", defaultValue: const AnimationInterval(0.5, 0.6)),
        const AnimationInterval(0.5, 0.6),
      );
    });
  });

  group("animationTrigger method", () {
    test("should return default if value is null", () {
      final data = DuitDataSource({});
      expect(data.animationTrigger(), AnimationTrigger.onEnter);
    });

    test("should return value if already AnimationTrigger", () {
      const trigger = AnimationTrigger.onAction;
      final data = DuitDataSource({"trigger": trigger});
      expect(data.animationTrigger(), trigger);
    });

    test("should parse from String", () {
      final data = DuitDataSource({"trigger": "onAction"});
      expect(data.animationTrigger(), AnimationTrigger.onAction);
    });

    test("should parse from int", () {
      final data = DuitDataSource({"trigger": 1});
      expect(data.animationTrigger(), AnimationTrigger.onAction);
    });

    test("should return default for unsupported type", () {
      final data = DuitDataSource({"trigger": true});
      expect(data.animationTrigger(), AnimationTrigger.onEnter);
    });

    test("should use custom key and defaultValue", () {
      final data = DuitDataSource({"custom": null});
      expect(
        data.animationTrigger(
            key: "custom", defaultValue: AnimationTrigger.onAction),
        AnimationTrigger.onAction,
      );
    });
  });

  group("animationMethod method", () {
    test("should return default if value is null", () {
      final data = DuitDataSource({});
      expect(data.animationMethod(), AnimationMethod.forward);
    });

    test("should return value if already AnimationMethod", () {
      const method = AnimationMethod.repeat;
      final data = DuitDataSource({"method": method});
      expect(data.animationMethod(), method);
    });

    test("should parse from String", () {
      final data = DuitDataSource({"method": "reverse"});
      expect(data.animationMethod(), AnimationMethod.reverse);
    });

    test("should parse from int", () {
      final data = DuitDataSource({"method": 3});
      expect(data.animationMethod(), AnimationMethod.toggle);
    });

    test("should return default for unsupported type", () {
      final data = DuitDataSource({"method": true});
      expect(data.animationMethod(), AnimationMethod.forward);
    });

    test("should use custom key and defaultValue", () {
      final data = DuitDataSource({"custom": null});
      expect(
        data.animationMethod(
            key: "custom", defaultValue: AnimationMethod.toggle),
        AnimationMethod.toggle,
      );
    });
  });

  group("tweenType method", () {
    test("should return default if value is null", () {
      final data = DuitDataSource({});
      expect(data.tweenType(), TweenType.tween);
    });

    test("should return value if already TweenType", () {
      const type = TweenType.colorTween;
      final data = DuitDataSource({"type": type});
      expect(data.tweenType(), type);
    });

    test("should parse from String", () {
      final data = DuitDataSource({"type": "textStyleTween"});
      expect(data.tweenType(), TweenType.textStyleTween);
    });

    test("should parse from int", () {
      final data = DuitDataSource({"type": 7});
      expect(data.tweenType(), TweenType.boxConstraintsTween);
    });

    test("should return default for unsupported type", () {
      final data = DuitDataSource({"type": true});
      expect(data.tweenType(), TweenType.tween);
    });

    test("should use custom key and defaultValue", () {
      final data = DuitDataSource({"custom": null});
      expect(
        data.tweenType(key: "custom", defaultValue: TweenType.group),
        TweenType.group,
      );
    });
  });

  group("widgetStateProperty method", () {
    test("should resolve Color for pressed and fallback to hovered", () {
      final data = DuitDataSource({
        "colorProp": <String, dynamic>{
          "pressed": "#FF0000",
          "hovered": "#00FF00",
        }
      });
      final prop = data.widgetStateProperty<Color>(key: "colorProp");
      expect(prop!.resolve({WidgetState.pressed}), const Color(0xFFFF0000));
      expect(prop.resolve({WidgetState.hovered}), const Color(0xFF00FF00));
      expect(prop.resolve({WidgetState.focused}), Colors.transparent);
    });

    test("should resolve EdgeInsetsGeometry for selected", () {
      final data = DuitDataSource({
        "paddingProp": <String, dynamic>{
          "selected": [
            10,
            20,
            30,
            40,
          ]
        }
      });
      final prop =
          data.widgetStateProperty<EdgeInsetsGeometry>(key: "paddingProp");
      expect(prop!.resolve({WidgetState.selected}),
          const EdgeInsets.fromLTRB(10, 20, 30, 40));
    });

    test("should resolve Size for error", () {
      final data = DuitDataSource({
        "sizeProp": <String, dynamic>{
          "error": {"width": 42, "height": 24}
        }
      });
      final prop = data.widgetStateProperty<Size>(key: "sizeProp");
      expect(prop!.resolve({WidgetState.error}), const Size(42, 24));
    });

    test("should resolve double for disabled", () {
      final data = DuitDataSource({
        "doubleProp": <String, dynamic>{"disabled": 3.14}
      });
      final prop = data.widgetStateProperty<double>(key: "doubleProp");
      expect(prop!.resolve({WidgetState.disabled}), 3.14);
    });

    test("should resolve OutlinedBorder for focused", () {
      final data = DuitDataSource({
        "borderProp": <String, dynamic>{
          "focused": <String, dynamic>{
            "type": "RoundedRectangleBorder",
            "borderRadius": 8
          }
        }
      });
      final prop = data.widgetStateProperty<OutlinedBorder>(key: "borderProp");
      final border = prop!.resolve({WidgetState.focused});
      expect(border, isA<RoundedRectangleBorder>());
      expect((border as RoundedRectangleBorder).borderRadius,
          BorderRadius.circular(8));
    });

    test("should resolve TextStyle for dragged", () {
      final data = DuitDataSource({
        "textStyleProp": <String, dynamic>{
          "dragged": <String, dynamic>{"fontSize": 18, "color": "#123456"}
        }
      });
      final prop = data.widgetStateProperty<TextStyle>(key: "textStyleProp");
      final style = prop!.resolve({WidgetState.dragged});
      expect(style, isA<TextStyle>());
      expect(style!.fontSize, 18);
      expect(style.color, const Color(0xFF123456));
    });

    test("should resolve BorderSide for hovered", () {
      final data = DuitDataSource({
        "sideProp": <String, dynamic>{
          "hovered": <String, dynamic>{"color": "#ABCDEF", "width": 2.0}
        }
      });
      final prop = data.widgetStateProperty<BorderSide>(key: "sideProp");
      final side = prop!.resolve({WidgetState.hovered});
      expect(side, isA<BorderSide>());
      expect(side!.color, const Color(0xFFABCDEF));
      expect(side.width, 2.0);
    });

    test("should return null if no state matches", () {
      final data = DuitDataSource({
        "colorProp": <String, dynamic>{"pressed": "#FF0000"}
      });
      final prop = data.widgetStateProperty<Color>(key: "colorProp");
      expect(prop!.resolve({WidgetState.focused}), Colors.transparent);
    });
  });

  group("executionOptions method", () {
    test(
        "should parse and return ExecutionOptions from Map with throttle modifier",
        () {
      final json = <String, dynamic>{
        "options": <String, dynamic>{
          "modifier": "throttle",
          "duration": 1000,
        },
      };

      final data = DuitDataSource(json);
      final result = data.executionOptions();

      expect(result, isA<ExecutionOptions>());
      expect(result!.modifier, ExecutionModifier.throttle);
      expect(result.duration, const Duration(milliseconds: 1000));
      expect(data["options"], isA<ExecutionOptions>());
    });

    test("should parse and return ExecutionOptions with debounce modifier", () {
      final json = <String, dynamic>{
        "options": <String, dynamic>{
          "modifier": "debounce",
          "duration": 500,
        },
      };

      final data = DuitDataSource(json);
      final result = data.executionOptions();

      expect(result, isA<ExecutionOptions>());
      expect(result!.modifier, ExecutionModifier.debounce);
      expect(result.duration, const Duration(milliseconds: 500));
      expect(data["options"], isA<ExecutionOptions>());
    });

    test("should parse and return ExecutionOptions with int modifier values",
        () {
      final json = <String, dynamic>{
        "options": <String, dynamic>{
          "modifier": 0, // throttle
          "duration": 750,
        },
      };

      final data = DuitDataSource(json);
      final result = data.executionOptions();

      expect(result, isA<ExecutionOptions>());
      expect(result!.modifier, ExecutionModifier.throttle);
      expect(result.duration, const Duration(milliseconds: 750));
      expect(data["options"], isA<ExecutionOptions>());
    });

    test("should return the default value if the value is null", () {
      final json = <String, dynamic>{};

      final data = DuitDataSource(json);

      expect(data.executionOptions(), null);
      expect(
        data.executionOptions(
          defaultValue: const ExecutionOptions(
            modifier: ExecutionModifier.throttle,
            duration: Duration(milliseconds: 1000),
          ),
        ),
        isA<ExecutionOptions>(),
      );
      expect(data["options"], null);
    });

    test("should return the default value if the value is not a Map", () {
      final json = <String, dynamic>{
        "options": "invalid",
      };

      final data = DuitDataSource(json);

      expect(data.executionOptions(), null);
      expect(
        data.executionOptions(
          defaultValue: const ExecutionOptions(
            modifier: ExecutionModifier.debounce,
            duration: Duration(milliseconds: 500),
          ),
        ),
        isA<ExecutionOptions>(),
      );
      expect(data["options"], "invalid");
    });

    test("should return instance if the value is already an instance", () {
      const existingOptions = ExecutionOptions(
        modifier: ExecutionModifier.throttle,
        duration: Duration(milliseconds: 1000),
      );

      final json = <String, dynamic>{
        "options": existingOptions,
      };

      final data = DuitDataSource(json);
      final result = data.executionOptions();

      expect(result, existingOptions);
      expect(data["options"], existingOptions);
    });

    test("should use custom key parameter", () {
      final json = <String, dynamic>{
        "customKey": <String, dynamic>{
          "modifier": "debounce",
          "duration": 300,
        },
      };

      final data = DuitDataSource(json);
      final result = data.executionOptions(key: "customKey");

      expect(result, isA<ExecutionOptions>());
      expect(result!.modifier, ExecutionModifier.debounce);
      expect(result.duration, const Duration(milliseconds: 300));
      expect(data["customKey"], isA<ExecutionOptions>());
    });

    test("should handle invalid modifier values with error", () {
      final json = <String, dynamic>{
        "options": <String, dynamic>{
          "modifier": "invalid_modifier",
          "duration": 1000,
        },
      };

      final data = DuitDataSource(json);

      expect(
        () => data.executionOptions(),
        throwsA(isA<Error>()),
      );
    });
  });
}
