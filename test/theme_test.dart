import "package:duit_kernel/duit_kernel.dart";
import "package:duit_kernel/src/ui/theme/preprocessor.dart";
import "package:flutter_test/flutter_test.dart";

import "misc.dart";

void main() {
  group(
    "Theme tests",
    () {
      setUpAll(() async {
        ViewAttribute.attributeParser = TestAttrParser();

        DuitRegistry.configure(
          themeLoader: const StaticThemeLoader(
            {
              "text_1": {
                "type": "Text",
                "data": {
                  "textAlign": "center",
                  "style": {
                    "fontSize": 32.0,
                    "color": "#FF0000",
                  }
                }
              },
              "text_2": {
                "type": "Text",
                "data": {
                  "style": {
                    "fontSize": 12.0,
                    "color": "#DCDCDC",
                  }
                }
              },
            },
          ),
        );

        await DuitRegistry.initTheme();
      });
      test(
        "must apply provided theme for this widget type",
        () {
          final res = ViewAttribute.createAttributes<Map<String, dynamic>>(
            "Text",
            {
              "data": "Hi!",
              "theme": "text_1",
            },
            null,
          );

          expect(res, isNotNull);
          expect(res.payload.containsKey("style"), isTrue);
        },
      );

      test(
        "not must override original values",
        () {
          final res = ViewAttribute.createAttributes<Map<String, dynamic>>(
            "Text",
            {
              "data": "Hi!",
              "theme": "text_1",
              "overrideRule": "themeOverlay",
              "textAlign": "start",
            },
            null,
          );

          expect(res, isNotNull);
          expect(res.payload.containsKey("style"), isTrue);
          expect(res.payload["textAlign"], equals("start"));
        },
      );

      test(
        "must override original values",
        () {
          final res = ViewAttribute.createAttributes<Map<String, dynamic>>(
            "Text",
            {
              "data": "Hi!",
              "theme": "text_1",
              "overrideRule": "themePriority",
              "textAlign": "start",
            },
            null,
          );

          expect(res, isNotNull);
          expect(res.payload.containsKey("style"), isTrue);
          expect(res.payload["textAlign"], equals("center"));
        },
      );
    },
  );

  group(
    "Theme preprocessor tests",
    () {
      test(
        "must throw error for invalid theme",
        () async {
          final preprocessor = ThemePreprocessor();

          expect(
            () => preprocessor.tokenize(
              const {
                "text_1": {
                  "type": "Text",
                  "data": {
                    "data": "Hi!",
                  }
                }
              },
            ),
            throwsA(
              isA<FormatException>(),
            ),
          );
        },
      );
    },
  );
}
