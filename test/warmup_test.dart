import "dart:convert";
import "dart:typed_data";
import "dart:ui";

import "package:duit_kernel/duit_kernel.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter_test/flutter_test.dart";

final propsDataset = <String, dynamic>{
  // Color properties
  "color": "#FF5722",

  // Duration properties
  "duration": 1000,

  // Text alignment and direction
  "textAlign": "center",
  "textDirection": "ltr",
  "textOverflow": "ellipsis",

  // Clipping behavior
  "clipBehavior": "antiAlias",

  // EdgeInsets for padding and margin
  "padding": [16.0, 16.0, 12.0, 12.0],
  "margin": 8.0,

  // Animation curve
  "curve": "easeInOut",

  // Text properties
  "textWidthBasis": "parent",
  "textBaseline": "alphabetic",

  // Offset
  "offset": {
    "dx": 10.0,
    "dy": 5.0,
  },

  // Box shadow
  "boxShadow": [
    {
      "color": "#000000",
      "blurRadius": 4.0,
      "spreadRadius": 2.0,
      "offset": {
        "dx": 2.0,
        "dy": 2.0,
      },
    }
  ],

  // Style properties (complex nested objects)
  "style": {
    "color": "#333333",
    "fontSize": 16.0,
    "fontWeight": 400,
    "fontFamily": "Roboto",
  },

  // Decoration
  "decoration": {
    "color": "#F5F5F5",
    "borderRadius": 8.0,
    "border": {
      "top": {
        "color": "#E0E0E0",
        "width": 1.0,
        "style": "solid",
      },
      "bottom": {
        "color": "#E0E0E0",
        "width": 1.0,
        "style": "solid",
      },
      "left": {
        "color": "#E0E0E0",
        "width": 1.0,
        "style": "solid",
      },
      "right": {
        "color": "#E0E0E0",
        "width": 1.0,
        "style": "solid",
      },
    },
  },

  // Text decoration style
  "decorationStyle": "solid",

  // Font properties
  "fontWeight": 600,
  "fontStyle": "normal",

  // Text span
  "textSpan": {
    "text": "Sample text",
    "style": {
      "color": "#2196F3",
      "fontSize": 14.0,
    },
  },

  // Text height behavior
  "textHeightBehavior": {
    "applyHeightToFirstAscent": true,
    "applyHeightToLastDescent": true,
  },

  // Text scaler
  "textScaler": 1.2,

  // Strut style
  "strutStyle": {
    "fontFamily": "Roboto",
    "fontSize": 16.0,
    "height": 1.5,
  },

  // Leading distribution
  "leadingDistribution": "proportional",

  // Direction and scroll direction
  "direction": "horizontal",
  "scrollDirection": "vertical",
  "mainAxis": "horizontal",

  // Wrap alignment
  "wrapCrossAlignment": "center",
  "wrapAlignment": "center",
  "runAlignment": "start",

  // Box constraints
  "constraints": {
    "minWidth": 0.0,
    "maxWidth": 300.0,
    "minHeight": 0.0,
    "maxHeight": 200.0,
  },

  // Stack and overflow fit
  "stackFit": "loose",
  "overflowBoxFit": "deferToChild",

  // Alignment
  "alignment": "center",
  "alignmentDirectional": "centerStart",
  "persistentFooterAlignment": "centerEnd",

  // Axis alignment
  "mainAxisAlignment": "center",
  "crossAxisAlignment": "center",
  "mainAxisSize": "min",

  // Interaction and material design
  "allowedInteraction": "tapAndSlide",
  "materialTapTargetSize": "padded",

  // Image properties
  "filterQuality": "medium",
  "repeat": "noRepeat",
  "fit": "cover",
  "byteData": [137, 80, 78, 71, 13, 10, 26, 10], // PNG header bytes
  "blendMode": "multiply",
  "tileMode": "repeated",

  // Image filter
  "filter": {
    "type": "blur",
    "sigmaX": 2.0,
    "sigmaY": 2.0,
  },

  // Layout direction
  "verticalDirection": "down",

  // Shape and borders
  "shape": "rectangle",
  "border": {
    "top": {
      "color": "#CCCCCC",
      "width": 1.0,
      "style": "solid",
    },
    "bottom": {
      "color": "#CCCCCC",
      "width": 1.0,
      "style": "solid",
    },
    "left": {
      "color": "#CCCCCC",
      "width": 1.0,
      "style": "solid",
    },
    "right": {
      "color": "#CCCCCC",
      "width": 1.0,
      "style": "solid",
    },
  },

  // Border side
  "side": {
    "color": "#DDDDDD",
    "width": 2.0,
    "style": "solid",
  },
  "borderSide": {
    "color": "#BBBBBB",
    "width": 1.5,
    "style": "solid",
  },

  // Input borders
  "inputBorder": {
    "type": "outline",
    "borderSide": {
      "color": "#2196F3",
      "width": 2.0,
      "style": "solid",
    },
    "gapPadding": 4.0,
    "borderRadius": 8.0,
  },
  "enabledBorder": {
    "type": "underline",
    "borderSide": {
      "color": "#757575",
      "width": 1.0,
      "style": "solid",
    },
  },
  "errorBorder": {
    "type": "outline",
    "borderSide": {
      "color": "#F44336",
      "width": 2.0,
      "style": "solid",
    },
    "borderRadius": 4.0,
  },
  "focusedBorder": {
    "type": "outline",
    "borderSide": {
      "color": "#2196F3",
      "width": 2.0,
      "style": "solid",
    },
    "borderRadius": 8.0,
  },
  "focusedErrorBorder": {
    "type": "outline",
    "borderSide": {
      "color": "#F44336",
      "width": 2.0,
      "style": "solid",
    },
    "borderRadius": 4.0,
  },

  // Keyboard type
  "keyboardType": "text",

  // Border radius
  "borderRadius": 12.0,

  // Input decoration
  "inputDecoration": {
    "hintText": "Enter text here",
    "labelText": "Input Label",
    "border": {
      "type": "outline",
      "borderRadius": 8.0,
    },
  },

  // Visual density
  "visualDensity": {
    "horizontal": 0.0,
    "vertical": 0.0,
  },

  // Keyboard dismiss behavior
  "keyboardDismissBehavior": "onDrag",

  // Scroll physics
  "physics": "alwaysScrollableScrollPhysics",

  // Drag start behavior
  "dragStartBehavior": "start",

  // Hit test behavior
  "hitTestBehavior": "opaque",

  // Animation properties
  "interval": {
    "begin": 0.0,
    "end": 1.0,
  },
  "trigger": "onEnter",
  "method": 2,

  // Collapse mode
  "collapseMode": "parallax",

  // Stretch modes
  "stretchModes": ["zoomBackground"],

  // Execution modifier
  "modifier": {
    "debounce": 300,
  },

  "some": {
    "decoration": "overline",
  },
};

void main() {
  group(
    "Attribute data warm up tests",
    () {
      group("call dispatching behavior test", () {
        test("should call corect function and return color", () {
          const col = "#DCDCDC";
          final source = DuitDataSource({
            "color": col,
          });

          final target = source.dispatchCall("color", col);

          expect(target, const Color(0xFFDCDCDC));
        });

        test("should return raw value if key is not valid", () {
          final source = DuitDataSource({
            "color": "#DCDCDC",
          });

          expect(
            source.dispatchCall("invalid", source["color"]),
            isA<String>(),
          );
        });
      });

      test("should parse all properties", () {
        final jsonString = jsonEncode(propsDataset);

        final j = jsonDecode(jsonString, reviver: DuitDataSource.jsonReviver);

        expect(j["color"], isA<Color>());
        expect(j["duration"], isA<Duration>());
        expect(j["textAlign"], isA<TextAlign>());
        expect(j["textDirection"], isA<TextDirection>());
        expect(j["textOverflow"], isA<TextOverflow>());
        expect(j["clipBehavior"], isA<Clip>());
        expect(j["padding"], isA<EdgeInsets>());
        expect(j["margin"], isA<EdgeInsets>());
        expect(j["curve"], isA<Curve>());
        expect(j["textWidthBasis"], isA<TextWidthBasis>());
        expect(j["textBaseline"], isA<TextBaseline>());
        expect(j["offset"], isA<Offset>());
        expect(j["boxShadow"], isA<List<BoxShadow>>());
        expect(j["style"], isA<TextStyle>());
        expect(j["decoration"], isA<Decoration>());
        expect(j["decorationStyle"], isA<TextDecorationStyle>());
        expect(j["fontWeight"], isA<FontWeight>());
        expect(j["fontStyle"], isA<FontStyle>());
        expect(j["textSpan"], isA<TextSpan>());
        expect(j["textHeightBehavior"], isA<TextHeightBehavior>());
        expect(j["textScaler"], isA<TextScaler>());
        expect(j["strutStyle"], isA<StrutStyle>());
        expect(j["leadingDistribution"], isA<TextLeadingDistribution>());
        expect(j["direction"], isA<Axis>());
        expect(j["scrollDirection"], isA<Axis>());
        expect(j["mainAxis"], isA<Axis>());
        expect(j["wrapCrossAlignment"], isA<WrapCrossAlignment>());
        expect(j["wrapAlignment"], isA<WrapAlignment>());
        expect(j["runAlignment"], isA<WrapAlignment>());
        expect(j["constraints"], isA<BoxConstraints>());
        expect(j["stackFit"], isA<StackFit>());
        expect(j["overflowBoxFit"], isA<OverflowBoxFit>());
        expect(j["alignment"], isA<Alignment>());
        expect(j["alignmentDirectional"], isA<AlignmentDirectional>());
        expect(j["persistentFooterAlignment"], isA<AlignmentDirectional>());
        expect(j["mainAxisAlignment"], isA<MainAxisAlignment>());
        expect(j["crossAxisAlignment"], isA<CrossAxisAlignment>());
        expect(j["mainAxisSize"], isA<MainAxisSize>());
        expect(j["allowedInteraction"], isA<SliderInteraction>());
        expect(j["materialTapTargetSize"], isA<MaterialTapTargetSize>());
        expect(j["filterQuality"], isA<FilterQuality>());
        expect(j["repeat"], isA<ImageRepeat>());
        expect(j["fit"], isA<BoxFit>());
        expect(j["byteData"], isA<Uint8List>());
        expect(j["blendMode"], isA<BlendMode>());
        expect(j["tileMode"], isA<TileMode>());
        expect(j["filter"], isA<ImageFilter>());
        expect(j["verticalDirection"], isA<VerticalDirection>());
        expect(j["shape"], isA<BoxShape>());
        expect(j["border"], isA<Border>());
        expect(j["side"], isA<BorderSide>());
        expect(j["borderSide"], isA<BorderSide>());
        expect(j["inputBorder"], isA<InputBorder>());
        expect(j["enabledBorder"], isA<InputBorder>());
        expect(j["errorBorder"], isA<InputBorder>());
        expect(j["focusedBorder"], isA<InputBorder>());
        expect(j["focusedErrorBorder"], isA<InputBorder>());
        expect(j["keyboardType"], isA<TextInputType>());
        expect(j["borderRadius"], isA<BorderRadius>());
        expect(j["inputDecoration"], isA<InputDecoration>());
        expect(j["stretchModes"], isA<List<StretchMode>>());
        expect(j["visualDensity"], isA<VisualDensity>());
        expect(j["keyboardDismissBehavior"],
            isA<ScrollViewKeyboardDismissBehavior>());
        expect(j["physics"], isA<ScrollPhysics>());
        expect(j["dragStartBehavior"], isA<DragStartBehavior>());
        expect(j["hitTestBehavior"], isA<HitTestBehavior>());
        expect(j["interval"], isA<AnimationInterval>());
        expect(j["trigger"], isA<AnimationTrigger>());
        expect(j["method"], isA<AnimationMethod>());
        expect(j["collapseMode"], isA<CollapseMode>());
        expect(j["modifier"], isA<ExecutionModifier>());
        expect(j["some"]["decoration"], isA<TextDecoration>());
      });
    },
    skip: !envAttributeWarmUpEnabled,
  );
}
