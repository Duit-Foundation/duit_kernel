import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:duit_kernel/duit_kernel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

part 'lookup.dart';

/// Converts a given hex color string to a [Color].
///
/// The provided [color] must be a valid hex color string, optionally prefixed with a '#'.
/// If the [color] is `null`, or if it's not a valid hex color string, this function returns `null`.
/// The hex color string can be 6 or 7 characters long. If the length is 6, the opacity is assumed to be 0xFF.
/// If the length is 7, the first character is assumed to be the opacity, and the remaining 6 characters are the color.
@preferInline
Color? _colorFromHexString(String color) {
  final isHexColor = color.startsWith("#");
  if (isHexColor) {
    final buffer = StringBuffer();
    if (color.length == 6 || color.length == 7) buffer.write('ff');
    buffer.write(color.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
  return null;
}

/// Converts a list of 3 or 4 elements to a [Color].
///
/// The list must contain 3 or 4 elements, each of which must be a valid
/// [int] value between 0 and 255. If the list has 3 elements, the opacity
/// is assumed to be 1.0. If the list has 4 elements, the first element is
/// assumed to be the opacity, and the remaining 3 elements are the color.
///
/// If the list is `null`, or if it does not contain exactly 3 or 4 elements,
/// or if any of the elements are not valid integers between 0 and 255, this
/// function returns `null`.
@preferInline
Color? _colorFromList(List<num> color) {
  return switch (color.length) {
    4 => Color.fromRGBO(
        color[0].toInt(),
        color[1].toInt(),
        color[2].toInt(),
        color[3].toDouble(),
      ),
    3 => Color.fromRGBO(
        color[0].toInt(),
        color[1].toInt(),
        color[2].toInt(),
        1.0,
      ),
    _ => null,
  };
}

/// Converts a JSON value to a [Color].
///
/// The JSON value must be either a string (which is interpreted as a
/// hexadecimal color string) or a list of 3 or 4 elements (which is
/// interpreted as a color with optional opacity).
///
/// If the JSON value is not a valid color (i.e. it is not a string or a list
/// of 3 or 4 elements), this function returns `null`.
@preferInline
Color? _parseColor(color) => switch (color) {
      String() => _colorFromHexString(color),
      List<num>() => _colorFromList(color),
      _ => null,
    };

extension type DuitDataSource(Map<String, dynamic> json)
    implements Map<String, dynamic> {
  /// Retrieves a [ServerAction] from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already a [ServerAction], it returns that action.
  /// If the value is a [Map<String, dynamic>], it attempts to parse it into a [ServerAction].
  /// Otherwise, it returns `null`.
  ///
  /// The parsed or existing [ServerAction] is also stored back into the JSON map at the given [key].
  ///
  /// Returns:
  /// - A [ServerAction] if the value is valid or can be parsed.
  /// - `null` if the value is not a valid [ServerAction] or cannot be parsed.
  @preferInline
  ServerAction? getAction(String key) {
    final action = json[key];

    if (action is ServerAction) return action;

    return json[key] = switch (action) {
      Map<String, dynamic>() => ServerAction.parse(action),
      _ => null
    };
  }

  /// Retrieves a list of action dependencies from the JSON map.
  ///
  /// This method checks if the JSON map contains a "dependsOn" key, which is
  /// expected to be a non-empty list. If present, it converts each element
  /// of the list into an `ActionDependency` using `ActionDependency.fromJson`.
  /// If the key is absent or the list is empty, it returns an empty iterable.
  ///
  /// Returns:
  /// - A non-empty `Iterable<ActionDependency>` if "dependsOn" exists and is valid.
  /// - An empty iterable if "dependsOn" does not exist or is empty.

  @preferInline
  Iterable<ActionDependency> getActionDependencies() {
    Iterable<ActionDependency> deps;
    final hasProperty = json.containsKey("dependsOn");
    if (hasProperty &&
        json["dependsOn"] is List &&
        json["dependsOn"].isNotEmpty) {
      deps = (json["dependsOn"] as List).map(
        (el) => ActionDependency.fromJson(el),
      );
    } else {
      deps = const [];
    }

    return deps;
  }

  @preferInline
  Map<String, dynamic> _map(Map value) => Map<String, dynamic>.from(value);

  /// A protection mechanism that allows checking the presence of a key in a [Map<String, dynamic>],
  /// which prevents further calls to "heavy" data parsing functions
  ///
  /// Returns `this` if the JSON map contains the given [key], otherwise returns `null`.
  @preferInline
  DuitDataSource? nullProtect(String key) =>
      json.containsKey(key) ? this : null;

  @preferInline
  String? get parentBuilderId {
    final id = json["parentBuilderId"];
    return id is String ? id : null;
  }

  @preferInline
  Iterable<String>? get affectedProperties {
    if (json.containsKey("affectedProperties")) {
      return Set.from(json["affectedProperties"]);
    } else {
      return null;
    }
  }

  @preferInline
  List<DuitTweenDescription> getTweens() {
    final value = json["tweenDescriptions"];
    if (value is List<DuitTweenDescription>) return value;

    return json["tweenDescriptions"] = switch (value) {
      List() => value
          .map<DuitTweenDescription>((v) => DuitTweenDescription.fromJson(v))
          .toList(),
      _ => <DuitTweenDescription>[],
    };
  }

  /// Retrieves a color value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already a [Color], it returns that color.
  /// If the value is a [String], it attempts to parse it into a [Color].
  /// If the value is a [List], it attempts to parse it into a [Color].
  /// Otherwise, it returns [defaultValue].
  ///
  /// The parsed or existing [Color] is also stored back into the JSON map at the given [key].
  ///
  /// Returns:
  /// - A [Color] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [Color] or cannot be parsed.
  Color parseColor({
    String key = "color",
    Color defaultValue = Colors.transparent,
  }) {
    final value = json[key];

    if (value is Color) return value;

    return json[key] = switch (value) {
      String() => _colorFromHexString(value) ?? defaultValue,
      List<num>() => _colorFromList(value) ?? defaultValue,
      _ => defaultValue,
    };
  }

  /// Retrieves a color value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already a [Color], it returns that color.
  /// If the value is a [String], it attempts to parse it into a [Color].
  /// If the value is a [List], it attempts to parse it into a [Color].
  /// Otherwise, it returns [defaultValue].
  ///
  /// Unlike [parseColor], this method does not store the parsed or existing [Color] back into the JSON map.
  ///
  /// Returns:
  /// - A [Color] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [Color] or cannot be parsed.
  Color? tryParseColor({
    String key = "color",
    Color? defaultValue,
  }) {
    final value = json[key];

    if (value is Color) return value;

    return json[key] = switch (value) {
      String() => _colorFromHexString(value),
      List<num>() => _colorFromList(value),
      _ => defaultValue,
    };
  }

  /// Retrieves a duration value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already a [Duration], it returns that duration.
  /// If the value is a [num], it attempts to parse it into a [Duration].
  /// Otherwise, it returns [defaultValue].
  ///
  /// The parsed or existing [Duration] is also stored back into the JSON map at the given [key].
  ///
  /// Returns:
  /// - A [Duration] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [Duration] or cannot be parsed.
  @preferInline
  Duration duration({
    String key = "duration",
    Duration? defaultValue,
  }) {
    final value = json[key];

    if (value is Duration) return value;

    return json[key] = switch (value) {
      int() => Duration(milliseconds: value),
      _ => defaultValue ?? Duration.zero,
    };
  }

  /// Retrieves an [int] value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already an [int], it returns that value.
  /// If the value is a [num], it attempts to parse it into an [int].
  /// Otherwise, it returns [defaultValue].
  ///
  /// The parsed or existing [int] is also stored back into the JSON map at the given [key].
  ///
  /// Returns:
  /// - An [int] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [int] or cannot be parsed.
  @preferInline
  int getInt({
    required String key,
    int? defaultValue,
  }) {
    final value = json[key];
    if (value is num) {
      return value.toInt();
    }
    return defaultValue ?? 0;
  }

  /// Retrieves an [int] value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already an [int], it returns that value.
  /// If the value is a [num], it attempts to parse it into an [int].
  /// Otherwise, it returns [defaultValue].
  ///
  /// Unlike [getInt], this method does not store the parsed or existing [int] back into the JSON map.
  ///
  /// Returns:
  /// - An [int] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [int] or cannot be parsed.
  @preferInline
  int? tryGetInt({
    required String key,
    int? defaultValue,
  }) {
    final value = json[key];
    if (value is num) {
      return value.toInt();
    }
    return defaultValue;
  }

  @preferInline
  double getDouble({
    required String key,
    double? defaultValue,
  }) {
    final value = json[key];
    if (value is num) {
      return value.toDouble();
    }
    return defaultValue ?? 0.0;
  }

  @preferInline
  double? tryGetDouble({
    required String key,
    double? defaultValue,
  }) {
    final value = json[key];
    if (value is num) {
      return value.toDouble();
    }
    return defaultValue;
  }

  @preferInline
  String getString({
    required String key,
    String? defaultValue,
  }) {
    final value = json[key];
    if (value is String) {
      return value;
    }
    return defaultValue ?? "";
  }

  @preferInline
  String? tryGetString(
    String key, {
    String? defaultValue,
  }) {
    final value = json[key];
    if (value is String) {
      return value;
    }
    return defaultValue;
  }

  ///Returns a boolean value for the given key.
  ///Defaults to **false** if the value is not a boolean or not set.
  @preferInline
  bool getBool(
    String key, {
    bool? defaultValue,
  }) {
    final value = json[key];
    if (value is bool) {
      return value;
    }
    return defaultValue ?? false;
  }

  @preferInline
  bool? tryGetBool(
    String key, {
    bool? defaultValue,
  }) {
    final value = json[key];
    if (value is bool) {
      return value;
    }
    return defaultValue;
  }

  @preferInline
  TextAlign? textAlignPrevVersion({
    String key = "textAlign",
    TextAlign? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      "left" || 0 => TextAlign.left,
      "right" || 1 => TextAlign.right,
      "center" || 2 => TextAlign.center,
      "justify" || 3 => TextAlign.justify,
      "start" || 4 => TextAlign.start,
      "end" || 5 => TextAlign.end,
      _ => defaultValue
    };
  }

  @pragma("vm:never-inline")
  TextAlign? textAlignPrevVersion2({
    String key = "textAlign",
    TextAlign? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      "left" || 0 => TextAlign.left,
      "right" || 1 => TextAlign.right,
      "center" || 2 => TextAlign.center,
      "justify" || 3 => TextAlign.justify,
      "start" || 4 => TextAlign.start,
      "end" || 5 => TextAlign.end,
      _ => defaultValue
    };
  }

  @preferInline
  TextAlign? textAlign({
    String key = "textAlign",
    TextAlign? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      TextAlign() => value,
      String() => _textAlignStringLookupTable[value],
      int() => _textAlignIntLookupTable[value],
      _ => defaultValue
    };
  }

  @preferInline
  TextAlign? textAlignExpanded({
    String key = "textAlign",
    TextAlign? defaultValue,
  }) {
    final value = json[key];

    if (value is TextAlign) {
      return value;
    }

    if (value == null) {
      return json[key] = defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _textAlignStringLookupTable[value];
      case int():
        return json[key] = _textAlignIntLookupTable[value];
    }

    return json[key] = defaultValue;
  }

  @preferInline
  TextDirection? textDirection({
    String key = "textDirection",
    TextDirection? defaultValue,
  }) {
    final value = json[key];

    if (value is TextDirection) return value;

    return json[key] = switch (value) {
      String() => _textDirectionStringLookupTable[value],
      int() => _textDirectionIntLookupTable[value],
      _ => defaultValue ?? TextDirection.ltr
    };
  }

  @preferInline
  TextOverflow? textOverflow({
    String key = "overflow",
    TextOverflow? defaultValue,
  }) {
    final value = json[key];

    if (value is TextOverflow) return value;

    return json[key] = switch (value) {
      String() => _textOverflowStringLookupTable[value] ?? defaultValue,
      int() => _textOverflowIntLookupTable[value] ?? defaultValue,
      _ => defaultValue,
    };
  }

  @preferInline
  Clip clipBehavior({
    String key = "clipBehavior",
    Clip defaultValue = Clip.hardEdge,
  }) {
    final value = json[key];

    if (value is Clip) return value;

    return json[key] = switch (value) {
      String() => _clipStringLookupTable[value] ?? defaultValue,
      int() => _clipIntLookupTable[value] ?? defaultValue,
      _ => defaultValue,
    };
  }

  @preferInline
  Size _sizeFromMap(DuitDataSource map) => Size(
        map.getDouble(
          key: "width",
          defaultValue: double.infinity,
        ),
        map.getDouble(
          key: "height",
          defaultValue: double.infinity,
        ),
      );

  @preferInline
  Size _sizeFromList(List<num> list) => Size(
        list[0].toDouble(),
        list[1].toDouble(),
      );

  @preferInline
  Size size(
    String key, {
    Size? defaultValue,
  }) {
    final value = json[key];

    if (value is Size) return value;

    return json[key] = switch (value) {
      Map<String, dynamic>() => _sizeFromMap(DuitDataSource(value)),
      List<num>() => _sizeFromList(value),
      double() => Size.square(value),
      _ => defaultValue ?? Size.zero,
    };
  }

  @preferInline
  EdgeInsets _edgeInsetsFromList(List<double> value) {
    return switch (value.length) {
      2 => EdgeInsets.symmetric(
          vertical: value[0],
          horizontal: value[1],
        ),
      4 => EdgeInsets.only(
          left: value[0],
          top: value[1],
          right: value[2],
          bottom: value[3],
        ),
      _ => EdgeInsets.zero
    };
  }

  @preferInline
  EdgeInsets edgeInsets({
    String key = "padding",
    EdgeInsets? defaultValue,
  }) {
    final value = json[key];

    if (value is EdgeInsets) return value;

    return json[key] = switch (value) {
      num() => EdgeInsets.all(value.toDouble()),
      List<double>() => _edgeInsetsFromList(value),
      _ => defaultValue ?? EdgeInsets.zero,
    };
  }

  @preferInline
  Curve curve({
    String key = "curve",
    Curve defaultValue = Curves.linear,
  }) {
    final value = json[key];

    if (value is Curve) return value;

    return json[key] = switch (value) {
      String() => _curveStringLookupTable[value] ?? defaultValue,
      int() => _curveIntLookupTable[value] ?? defaultValue,
      _ => defaultValue,
    };
  }

  @preferInline
  TextBaseline? textBaseline({
    String key = "textBaseline",
    TextBaseline? defaultValue,
  }) {
    final value = json[key];

    if (value is TextBaseline) return value;

    return json[key] = switch (value) {
      String() => _textBaselineStringLookupTable[value],
      int() => _textBaselineIntLookupTable[value],
      _ => defaultValue,
    };
  }

  @preferInline
  TextWidthBasis? textWidthBasis({
    String key = "textWidthBasis",
    TextWidthBasis? defaultValue,
  }) {
    final value = json[key];

    if (value is TextWidthBasis) return value;

    return json[key] = switch (value) {
      String() => _textWidthBasisStringLookupTable[value],
      int() => _textWidthBasisIntLookupTable[value],
      _ => defaultValue,
    };
  }

  @preferInline
  TextStyle? textStyle({
    String key = "style",
    TextStyle? defaultValue,
  }) {
    final value = json[key];

    if (value is TextStyle) return value;

    return json[key] = switch (value) {
      Map<String, dynamic>() => _textStyleFromMap(_map(value)),
      _ => defaultValue,
    };
  }

  @preferInline
  TextStyle _textStyleFromMap(Map<String, dynamic> data) {
    final value = DuitDataSource(data);
    return TextStyle(
      color: value.tryParseColor(key: "color"),
      fontFamily: value.tryGetString("fontFamily"),
      fontWeight: value.fontWeight(),
      fontSize: value.tryGetDouble(key: "fontSize"),
      fontStyle: value.fontStyle(),
      overflow: value.textOverflow(),
      textBaseline: value.textBaseline(),
      height: value.tryGetDouble(key: "height"),
      letterSpacing: value.tryGetDouble(key: "letterSpacing"),
      wordSpacing: value.tryGetDouble(key: "wordSpacing"),
      backgroundColor: value.tryParseColor(key: "backgroundColor"),
      decoration: value.textDecoration(),
      decorationColor: value.tryParseColor(key: "decorationColor"),
      decorationStyle: value.textDecorationStyle(),
      decorationThickness: value.tryGetDouble(key: "decorationThickness"),
      debugLabel: value.tryGetString("debugLabel"),
      package: value.tryGetString("package"),
      leadingDistribution: value.textLeadingDistribution(),
    );
  }

  @preferInline
  List<T> getList<T>(dynamic value) =>
      value is List ? List.castFrom<dynamic, T>(value) : const [];

  @preferInline
  Gradient? _gradientFromMap(Map<String, dynamic>? data) {
    if (data == null) return null;

    final style = DuitDataSource(data);

    final List? colors = style["colors"];
    if (colors == null) return null;

    final List<Color> dColors = [];

    for (var color in colors) {
      dColors.add(_parseColor(color) ?? Colors.transparent);
    }

    final angle = style.tryGetDouble(key: "rotationAngle");

    return LinearGradient(
      colors: dColors,
      stops: style["stops"],
      begin: style.alignment(key: "begin", defaultValue: Alignment.centerLeft)!,
      end: style.alignment(key: "end", defaultValue: Alignment.centerRight)!,
      transform: angle != null ? GradientRotation(angle) : null,
    );
  }

  @preferInline
  BoxShadow _boxShadowFromMap(json) {
    final data = DuitDataSource(_map(json));
    return BoxShadow(
      color: data.parseColor(key: "color"),
      offset: data.offset(defaultValue: Offset.zero)!,
      blurRadius: data.getDouble(key: "blurRadius"),
      spreadRadius: data.getDouble(key: "spreadRadius"),
    );
  }

  @preferInline
  Offset _offsetFromMap(Map<String, dynamic> map) {
    final json = DuitDataSource(map);
    return Offset(
      json.getDouble(key: "dx"),
      json.getDouble(key: "dy"),
    );
  }

  @preferInline
  Offset? offset({
    String key = "offset",
    Offset? defaultValue,
  }) {
    final value = json[key];

    if (value is Offset) return value;

    return json[key] = switch (value) {
      Map<String, dynamic>() => _offsetFromMap(value),
      _ => defaultValue,
    };
  }

  @preferInline
  List<BoxShadow>? boxShadow({
    String key = "boxShadow",
    List<BoxShadow>? defaultValue,
  }) {
    final value = json[key];

    if (value is List<BoxShadow>) return value;

    return json[key] = switch (value) {
      List() => value.map<BoxShadow>(_boxShadowFromMap).toList(),
      _ => defaultValue,
    };
  }

  @preferInline
  Decoration _decorationFromMap(Map<String, dynamic> data) {
    final value = DuitDataSource(Map<String, dynamic>.from(data));
    return BoxDecoration(
      color: value.tryParseColor(key: "color"),
      borderRadius: value["borderRadius"] != null
          ? BorderRadius.circular(
              value.getDouble(
                key: "borderRadius",
              ),
            )
          : null,
      border: value["borderRadius"] != null
          ? Border.fromBorderSide(
              value.borderSide(
                key: "border",
              ),
            )
          : null,
      gradient: _gradientFromMap(value["gradient"]),
      boxShadow: value.boxShadow(),
    );
  }

  @preferInline
  Decoration? decoration({
    String key = "decoration",
    Decoration? defaultValue,
  }) {
    final value = json[key];

    if (value is Decoration) return value;

    return json[key] = switch (value) {
      Map<String, dynamic>() => _decorationFromMap(value),
      _ => defaultValue,
    };
  }

  @preferInline
  TextDecoration? textDecoration({
    String key = "decoration",
    TextDecoration? defaultValue,
  }) {
    final value = json[key];

    if (value is TextDecoration) return value;

    return json[key] = switch (value) {
      String() => _textDecorationStringLookupTable[value],
      int() => _textDecorationIntLookupTable[value],
      _ => defaultValue,
    };
  }

  @preferInline
  TextDecorationStyle? textDecorationStyle({
    String key = "decorationStyle",
    TextDecorationStyle? defaultValue,
  }) {
    final value = json[key];

    if (value is TextDecorationStyle) return value;

    return switch (value) {
      int() => _textDecorationStyleIntLookupTable[value],
      String() => _textDecorationStyleStringLookupTable[value],
      _ => defaultValue,
    };
  }

  @preferInline
  FontWeight? fontWeight({
    String key = "fontWeight",
    FontWeight? defaultValue,
  }) {
    final value = json[key];

    if (value is FontWeight) return value;

    return json[key] = switch (value) {
      int() => _fontWeightLookupTable[value],
      _ => defaultValue,
    };
  }

  @preferInline
  FontStyle? fontStyle({
    String key = "fontStyle",
    FontStyle? defaultValue,
  }) {
    final value = json[key];

    if (value is FontStyle) return value;

    return json[key] = switch (value) {
      String() => _fontStyleStringLookupTable[value],
      int() => _fontStyleIntLookupTable[value],
      _ => defaultValue,
    };
  }

  @preferInline
  TextSpan textSpan({
    String key = "textSpan",
    TextSpan? defaultValue,
  }) {
    final value = json[key];

    if (value is TextSpan) {
      return value;
    }

    final children = value['children'];

    final spanChildren = <InlineSpan>[];

    if (children != null) {
      for (final child in children) {
        spanChildren.add(
          DuitDataSource(child).textSpan(),
        );
      }
    }

    final span = DuitDataSource(value);

    return json[key] = TextSpan(
      text: span.tryGetString("text"),
      children: spanChildren.isNotEmpty ? spanChildren : null,
      style: span.textStyle(),
      spellOut: span.tryGetBool("spellOut"),
      semanticsLabel: span.tryGetString("semanticsLabel"),
    );
  }

  @preferInline
  TextHeightBehavior? _parseTextHeightBehavior(Map<String, dynamic> data) {
    final json = DuitDataSource(data);
    return TextHeightBehavior(
      applyHeightToFirstAscent: json.getBool(
        "applyHeightToFirstAscent",
        defaultValue: true,
      ),
      applyHeightToLastDescent: json.getBool(
        "applyHeightToLastDescent",
        defaultValue: true,
      ),
      leadingDistribution: json.textLeadingDistribution(
        defaultValue: TextLeadingDistribution.proportional,
      )!,
    );
  }

  @preferInline
  TextHeightBehavior? textHeightBehavior({
    String key = "textHeightBehavior",
    TextHeightBehavior? defaultValue,
  }) {
    final value = json[key];

    if (value is TextHeightBehavior) return value;

    return json[key] = switch (value) {
      Map<String, dynamic>() => _parseTextHeightBehavior(value),
      _ => defaultValue,
    };
  }

  @preferInline
  TextScaler _textScalerFromMap(Map<String, dynamic> data) {
    final json = DuitDataSource(data);
    return TextScaler.linear(
      json.getDouble(
        key: "textScaleFactor",
        defaultValue: 1,
      ),
    );
  }

  @preferInline
  TextScaler textScaler({
    String key = "textScaler",
    TextScaler? defaultValue,
  }) {
    final value = json[key];

    if (value is TextScaler) return value;

    return json[key] = switch (value) {
      Map<String, dynamic>() => _textScalerFromMap(value),
      double() => TextScaler.linear(value),
      _ => defaultValue ?? TextScaler.noScaling,
    };
  }

  @preferInline
  StrutStyle _strutStyleFromMap(Map<String, dynamic> data) {
    final json = DuitDataSource(data);
    return StrutStyle(
      fontSize: json.tryGetDouble(key: "fontSize"),
      height: json.tryGetDouble(key: "height"),
      leading: json.tryGetDouble(key: "leading"),
      fontWeight: json.fontWeight(),
      fontFamily: json.tryGetString("fontFamily"),
      fontStyle: json.fontStyle(),
      forceStrutHeight: json.tryGetBool("forceStrutHeight"),
      debugLabel: json.tryGetString("debugLabel"),
    );
  }

  @preferInline
  StrutStyle? strutStyle({
    String key = "strutStyle",
    StrutStyle? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      StrutStyle() => value,
      Map<String, dynamic>() => _strutStyleFromMap(value),
      _ => defaultValue,
    };
  }

  @preferInline
  TextLeadingDistribution? textLeadingDistribution({
    String key = "leadingDistribution",
    TextLeadingDistribution? defaultValue,
  }) {
    final value = json[key];

    if (value is TextLeadingDistribution) return value;

    return json[key] = switch (value) {
      String() => _leadingDistributionStringLookupTable[value],
      int() => _leadingDistributionIntLookupTable[value],
      _ => defaultValue,
    };
  }

  @preferInline
  Axis axis({
    String key = "scrollDirection",
    Axis defaultValue = Axis.vertical,
  }) {
    final value = json[key];

    if (value is Axis) return value;

    return json[key] = switch (value) {
      String() => _axisStringLookupTable[value] ?? defaultValue,
      int() => _axisIntLookupTable[value] ?? defaultValue,
      _ => defaultValue,
    };
  }

  @preferInline
  WrapCrossAlignment? wrapCrossAlignment({
    String key = "crossAxisAlignment",
    WrapCrossAlignment? defaultValue,
  }) {
    final value = json[key];

    if (value is WrapCrossAlignment) return value;

    return json[key] = switch (value) {
      String() => _wrapCrossAlignmentStringLookupTable[value],
      int() => _wrapCrossAlignmentIntLookupTable[value],
      _ => defaultValue,
    };
  }

  @preferInline
  WrapAlignment? wrapAlignment({
    String key = "alignment",
    WrapAlignment? defaultValue,
  }) {
    final value = json[key];

    if (value is WrapAlignment) return value;

    return json[key] = switch (value) {
      String() => _wrapAlignmentStringLookupTable[value],
      int() => _wrapAlignmentIntLookupTable[value],
      _ => defaultValue,
    };
  }

  @preferInline
  BoxConstraints _boxConstraintsFromMap(Map<String, dynamic> data) {
    final json = DuitDataSource(data);
    return BoxConstraints(
      minWidth: json.getDouble(
        key: "minWidth",
        defaultValue: 0.0,
      ),
      maxWidth: json.getDouble(
        key: "maxWidth",
        defaultValue: double.infinity,
      ),
      minHeight: json.getDouble(
        key: "minHeight",
        defaultValue: 0.0,
      ),
      maxHeight: json.getDouble(
        key: "maxHeight",
        defaultValue: double.infinity,
      ),
    );
  }

  @preferInline
  BoxConstraints boxConstraints({
    String key = "constraints",
    BoxConstraints? defaultValue,
  }) {
    final value = json[key];

    if (value is BoxConstraints) return value;

    return json[key] = switch (value) {
      Map<String, dynamic>() => _boxConstraintsFromMap(value),
      _ => defaultValue ?? const BoxConstraints(),
    };
  }

  @preferInline
  StackFit? stackFit({
    String key = "fit",
    StackFit? defaultValue,
  }) {
    final value = json[key];

    if (value is StackFit) return value;

    return json[key] = switch (value) {
      String() => _stackFitStringLookupTable[value],
      int() => _stackFitIntLookupTable[value],
      _ => defaultValue,
    };
  }

  @preferInline
  OverflowBoxFit overflowBoxFit({
    String key = "fit",
    OverflowBoxFit defaultValue = OverflowBoxFit.max,
  }) {
    final value = json[key];

    if (value is OverflowBoxFit) return value;

    return json[key] = switch (value) {
      String() => _overflowBoxFitStringLookupTable[value] ?? defaultValue,
      int() => _overflowBoxFitIntLookupTable[value] ?? defaultValue,
      _ => defaultValue,
    };
  }

  @preferInline
  Alignment? alignment({
    String key = "alignment",
    Alignment? defaultValue,
  }) {
    final value = json[key];

    if (value is Alignment) return value;

    //TODO: Alignment(x,y) as [double, double]
    return json[key] = switch (value) {
      String() => _alignmentStringLookupTable[value],
      int() => _alignmentIntLookupTable[value],
      _ => defaultValue,
    };
  }

  @preferInline
  AlignmentDirectional? alignmentDirectional({
    String key = "alignment",
    AlignmentDirectional? defaultValue,
  }) {
    final value = json[key];

    if (value is AlignmentDirectional) return value;

    //TODO: AlignmentDirectional(start,y) as [double, double]
    return json[key] = switch (value) {
      String() => _alignmentDirectionalStringLookupTable[value],
      int() => _alignmentDirectionalIntLookupTable[value],
      _ => defaultValue,
    };
  }

  @preferInline
  MainAxisAlignment mainAxisAlignment({
    String key = "mainAxisAlignment",
    MainAxisAlignment defaultValue = MainAxisAlignment.start,
  }) {
    final value = json[key];

    if (value is MainAxisAlignment) return value;

    return json[key] = switch (value) {
      String() => _mainAxisAlignmentStringLookupTable[value] ?? defaultValue,
      int() => _mainAxisAlignmentIntLookupTable[value] ?? defaultValue,
      _ => defaultValue,
    };
  }

  @preferInline
  CrossAxisAlignment crossAxisAlignment({
    String key = "crossAxisAlignment",
    CrossAxisAlignment defaultValue = CrossAxisAlignment.start,
  }) {
    final value = json[key];

    if (value is CrossAxisAlignment) return value;

    return json[key] = switch (value) {
      String() => _crossAxisAlignmentStringLookupTable[value] ?? defaultValue,
      int() => _crossAxisAlignmentIntLookupTable[value] ?? defaultValue,
      _ => defaultValue,
    };
  }

  @preferInline
  MainAxisSize mainAxisSize({
    String key = "mainAxisSize",
    MainAxisSize defaultValue = MainAxisSize.max,
  }) {
    final value = json[key];

    if (value is MainAxisSize) return value;

    return json[key] = switch (value) {
      String() => _mainAxisSizeStringLookupTable[value] ?? defaultValue,
      int() => _mainAxisSizeIntLookupTable[value] ?? defaultValue,
      _ => defaultValue,
    };
  }

  @preferInline
  SliderInteraction? sliderInteraction({
    String key = "interaction",
    SliderInteraction? defaultValue,
  }) {
    final value = json[key];

    if (value is SliderInteraction) return value;

    return json[key] = switch (value) {
      String() => _sliderInteractionStringLookupTable[value],
      int() => _sliderInteractionIntLookupTable[value],
      _ => defaultValue,
    };
  }

  @preferInline
  MaterialTapTargetSize? materialTapTargetSize({
    String key = "materialTapTargetSize",
    MaterialTapTargetSize? defaultValue,
  }) {
    final value = json[key];

    if (value is MaterialTapTargetSize) return value;

    return json[key] = switch (value) {
      String() => _materialTapTargetSizeStringLookupTable[value],
      int() => _materialTapTargetSizeIntLookupTable[value],
      _ => defaultValue,
    };
  }

  @preferInline
  FilterQuality filterQuality({
    String key = "filterQuality",
    FilterQuality defaultValue = FilterQuality.low,
  }) {
    final value = json[key];

    if (value is FilterQuality) return value;

    return json[key] = switch (value) {
      String() => _filterQualityStringLookupTable[value] ?? defaultValue,
      int() => _filterQualityIntLookupTable[value] ?? defaultValue,
      _ => defaultValue,
    };
  }

  @preferInline
  ImageRepeat imageRepeat({
    String key = "repeat",
    ImageRepeat defaultValue = ImageRepeat.noRepeat,
  }) {
    final value = json[key];

    if (value is ImageRepeat) return value;

    return json[key] = switch (value) {
      String() => _imageRepeatStringLookupTable[value] ?? defaultValue,
      int() => _imageRepeatIntLookupTable[value] ?? defaultValue,
      _ => defaultValue,
    };
  }

  @preferInline
  Uint8List _uint8ListFromString(String value) => base64Decode(value);

  @preferInline
  Uint8List _uint8ListFromList(List<int> value) => Uint8List.fromList(value);

  @preferInline
  Uint8List uint8List({
    String key = "byteData",
    Uint8List? defaultValue,
  }) {
    final value = json[key];

    if (value is Uint8List) return value;

    return json[key] = switch (value) {
      List<int>() => _uint8ListFromList(value),
      String() => _uint8ListFromString(value),
      _ => defaultValue ?? Uint8List(0),
    };
  }

  @preferInline
  BoxFit? boxFit({
    String key = "fit",
    BoxFit? defaultValue,
  }) {
    final value = json[key];

    if (value is BoxFit) return value;

    return json[key] = switch (value) {
      String() => _boxFitStringLookupTable[value],
      int() => _boxFitIntLookupTable[value],
      _ => defaultValue,
    };
  }

  @preferInline
  BlendMode blendMode({
    String key = "blendMode",
    BlendMode defaultValue = BlendMode.srcOver,
  }) {
    final value = json[key];

    if (value is BlendMode) return value;

    return json[key] = switch (value) {
      String() => _blendModeStringLookupTable[value] ?? defaultValue,
      _ => defaultValue,
    };
  }

  //TODO: needs work
  @preferInline
  ImageFilter _imageFilterFromMap(Map<String, dynamic> value) {
    final json = DuitDataSource(value);
    final fType = json["type"];
    return switch (fType) {
      "blur" || 0 => ImageFilter.blur(
          sigmaX: json.getDouble(key: "sigmaX"),
          sigmaY: json.getDouble(key: "sigmaY"),
          tileMode: value["tileMode"] != null
              ? TileMode.values.byName(value["tileMode"])
              : TileMode.clamp,
        ),
      "compose" || 1 => () {
          final outerFilter =
              value.containsKey("outer") ? value["outer"] : const {};
          final innerFilter =
              value.containsKey("inner") ? value["inner"] : const {};

          return ImageFilter.compose(
            outer: DuitDataSource(outerFilter).imageFilter(),
            inner: DuitDataSource(innerFilter).imageFilter(),
          );
        }(),
      "dilate" || 2 => ImageFilter.dilate(
          radiusX: json.getDouble(key: "radiusX"),
          radiusY: json.getDouble(key: "radiusY"),
        ),
      "erode" || 3 => ImageFilter.erode(
          radiusX: json.getDouble(key: "radiusX"),
          radiusY: json.getDouble(key: "radiusY"),
        ),
      "matrix" || 4 => ImageFilter.matrix(
          Float64List.fromList(value["matrix4"] as List<double>),
          filterQuality:
              json.filterQuality(defaultValue: FilterQuality.medium)!,
        ),
      Object() || null || String() => ImageFilter.blur(),
    };
  }

  @preferInline
  ImageFilter imageFilter({
    String key = "filter",
    ImageFilter? defaultValue,
  }) {
    final value = json[key];

    if (value is ImageFilter) return value;

    return json[key] = switch (value) {
      Map<String, dynamic>() => _imageFilterFromMap(value),
      _ => defaultValue ?? ImageFilter.blur(),
    };
  }

  @preferInline
  VerticalDirection verticalDirection({
    String key = "verticalDirection",
    VerticalDirection defaultValue = VerticalDirection.down,
  }) {
    final value = json[key];

    if (value is VerticalDirection) return value;

    return json[key] = switch (value) {
      String() => _verticalDirectionStringLookupTable[value] ?? defaultValue,
      int() => _verticalDirectionIntLookupTable[value] ?? defaultValue,
      _ => defaultValue,
    };
  }

  @preferInline
  BoxShape? boxShape({
    String key = "shape",
    BoxShape? defaultValue,
  }) {
    final value = json[key];

    if (value is BoxShape) return value;

    return json[key] = switch (value) {
      String() => _boxShapeStringLookupTable[value],
      int() => _boxShapeIntLookupTable[value],
      _ => defaultValue,
    };
  }

  @preferInline
  InputDecoration _inputDecorationFromMap(Map<String, dynamic> value) {
    final json = DuitDataSource(value);
    return InputDecoration(
      labelText: json.tryGetString("labelText"),
      labelStyle: json.textStyle(key: "labelStyle"),
      floatingLabelStyle: json.textStyle(key: "floatingLabelStyle"),
      helperText: json.tryGetString("helperText"),
      helperMaxLines: json.tryGetInt(key: "helperMaxLines"),
      helperStyle: json.textStyle(key: "helperStyle"),
      hintText: json.tryGetString("hintText"),
      hintStyle: json.textStyle(key: "hintStyle"),
      hintMaxLines: json.tryGetInt(key: "hintMaxLines"),
      errorText: json.tryGetString("errorText"),
      errorMaxLines: json.tryGetInt(key: "errorMaxLines"),
      errorStyle: json.textStyle(key: "errorStyle"),
      enabledBorder: json.inputBorder(key: "enabledBorder"),
      border: json.inputBorder(key: "border"),
      errorBorder: json.inputBorder(key: "errorBorder"),
      focusedBorder: json.inputBorder(key: "focusedBorder"),
      focusedErrorBorder: json.inputBorder(key: "focusedErrorBorder"),
      enabled: json.getBool("enabled", defaultValue: true),
      isCollapsed: json.tryGetBool("isCollapsed"),
      isDense: json.tryGetBool("isDense"),
      suffixText: json.tryGetString("suffixText"),
      suffixStyle: json.textStyle(key: "suffixStyle"),
      prefixText: json.tryGetString("prefixText"),
      prefixStyle: json.textStyle(key: "prefixStyle"),
      counterText: json.tryGetString("counterText"),
      counterStyle: json.textStyle(key: "counterStyle"),
      alignLabelWithHint: json.tryGetBool("alignLabelWithHint"),
      filled: json.tryGetBool("filled"),
      fillColor: json.tryParseColor(key: "fillColor"),
      focusColor: json.tryParseColor(key: "focusColor"),
      hoverColor: json.tryParseColor(key: "hoverColor"),
      contentPadding: json.edgeInsets(key: "contentPadding"),
      prefixIconColor: json.tryParseColor(key: "prefixIconColor"),
      suffixIconColor: json.tryParseColor(key: "suffixIconColor"),
    );
  }

  @preferInline
  BorderSide _borderSideFromMap(Map<String, dynamic> value) {
    final json = DuitDataSource(value);
    return BorderSide(
      color: json.parseColor(key: "color"),
      width: json.getDouble(
        key: "width",
        defaultValue: 1.0,
      ),
      style: json.borderStyle(
        key: "style",
        defaultValue: BorderStyle.solid,
      )!,
    );
  }

  @preferInline
  BorderStyle? borderStyle({
    String key = "style",
    BorderStyle? defaultValue,
  }) {
    final value = json[key];

    if (value is BorderStyle) return value;

    return json[key] = switch (value) {
      String() => _borderStyleStringLookupTable[value],
      int() => _borderStyleIntLookupTable[value],
      _ => defaultValue,
    };
  }

  @preferInline
  BorderSide borderSide({
    String key = "side",
    BorderSide? defaultValue,
  }) {
    final value = json[key];

    if (value is BorderSide) return value;

    return json[key] = switch (value) {
      Map<String, dynamic>() => _borderSideFromMap(value),
      _ => defaultValue ?? BorderSide.none,
    };
  }

  //TODO: needs work
  @preferInline
  InputBorder _inputBorderFromMap(Map<String, dynamic> value) {
    final json = DuitDataSource(value);
    final type = json.getString(key: "type");
    return switch (type) {
      "outline" => OutlineInputBorder(
          borderSide: json.borderSide(key: "borderSide"),
          gapPadding: json.getDouble(key: "gapPadding", defaultValue: 4.0),
          borderRadius: BorderRadius.circular(
            json.getDouble(
              key: "borderRadius",
              defaultValue: 4.0,
            ),
          ),
        ),
      "underline" => UnderlineInputBorder(
          borderSide: json.borderSide(key: "borderSide"),
        ),
      _ => const OutlineInputBorder(),
    };
  }

  @preferInline
  InputBorder? inputBorder({
    String key = "border",
    InputBorder? defaultValue,
  }) {
    final value = json[key];

    if (value is InputBorder) return value;

    return json[key] = switch (value) {
      Map<String, dynamic>() => _inputBorderFromMap(value),
      _ => defaultValue,
    };
  }

  @preferInline
  InputDecoration? inputDecoration({
    String key = "decoration",
    InputDecoration? defaultValue,
  }) {
    final value = json[key];

    if (value is InputDecoration) return value;

    return json[key] = switch (value) {
      Map<String, dynamic>() => _inputDecorationFromMap(value),
      _ => defaultValue,
    };
  }

  @preferInline
  TextInputType? textInputType({
    String key = "keyboardType",
    TextInputType? defaultValue,
  }) {
    final value = json[key];

    if (value is TextInputType) return value;

    return json[key] = switch (value) {
      String() => _textInputTypeStringLookupTable[value],
      int() => _textInputTypeIntLookupTable[value],
      _ => defaultValue,
    };
  }

  VisualDensity _visualDensityFromMap(Map<String, dynamic> value) {
    final json = DuitDataSource(value);
    return VisualDensity(
      horizontal: json.getDouble(
        key: "horizontal",
        defaultValue: 0.0,
      ),
      vertical: json.getDouble(
        key: "vertical",
        defaultValue: 0.0,
      ),
    );
  }

  @preferInline
  VisualDensity visualDensity({
    String key = "visualDensity",
    VisualDensity? defaultValue,
  }) {
    final value = json[key];

    if (value is VisualDensity) return value;

    return json[key] = switch (value) {
      Map<String, dynamic>() => _visualDensityFromMap(value),
      _ => defaultValue ?? const VisualDensity(),
    };
  }

  @preferInline
  ScrollViewKeyboardDismissBehavior keyboardDismissBehavior({
    String key = "keyboardDismissBehavior",
    ScrollViewKeyboardDismissBehavior defaultValue =
        ScrollViewKeyboardDismissBehavior.manual,
  }) {
    final value = json[key];

    if (value is ScrollViewKeyboardDismissBehavior) return value;

    return json[key] = switch (value) {
      String() =>
        _keyboardDismissBehaviorStringLookupTable[value] ?? defaultValue,
      int() => _keyboardDismissBehaviorIntLookupTable[value] ?? defaultValue,
      _ => defaultValue,
    };
  }

  @preferInline
  ScrollPhysics? scrollPhysics({
    String key = "physics",
    ScrollPhysics? defaultValue,
  }) {
    final value = json[key];

    if (value is ScrollPhysics) return value;

    return json[key] = switch (value) {
      String() => _scrollPhysicsStringLookupTable[value],
      int() => _scrollPhysicsIntLookupTable[value],
      _ => defaultValue,
    };
  }

  @preferInline
  DragStartBehavior dragStartBehavior({
    String key = "dragStartBehavior",
    DragStartBehavior defaultValue = DragStartBehavior.start,
  }) {
    final value = json[key];

    if (value is DragStartBehavior) return value;

    return json[key] = switch (value) {
      String() => _dragStartBehaviorStringLookupTable[value] ?? defaultValue,
      int() => _dragStartBehaviorIntLookupTable[value] ?? defaultValue,
      _ => defaultValue,
    };
  }

  @preferInline
  HitTestBehavior hitTestBehavior({
    String key = "hitTestBehavior",
    HitTestBehavior defaultValue = HitTestBehavior.deferToChild,
  }) {
    final value = json[key];

    if (value is HitTestBehavior) return value;

    return json[key] = switch (value) {
      String() => _hitTestBehaviorStringLookupTable[value] ?? defaultValue,
      int() => _hitTestBehaviorIntLookupTable[value] ?? defaultValue,
      _ => defaultValue,
    };
  }

  //TODO: needs work
  @preferInline
  ShapeBorder _shapeBorderFromMap(Map<String, dynamic> value) {
    final json = DuitDataSource(value);
    final type = json.getString(key: "type");
    return switch (type) {
      "RoundedRectangleBorder" => RoundedRectangleBorder(
          borderRadius: json["borderRadius"] != null
              ? BorderRadius.circular(
                  json.getDouble(
                    key: "borderRadius",
                  ),
                )
              : BorderRadius.zero,
          side: json.borderSide(key: "borderSide"),
        ),
      "CircleBorder" => CircleBorder(
          side: json.borderSide(key: "borderSide"),
        ),
      "StadiumBorder" => StadiumBorder(
          side: json.borderSide(key: "borderSide"),
        ),
      "BeveledRectangleBorder" => BeveledRectangleBorder(
          borderRadius: json["borderRadius"] != null
              ? BorderRadius.circular(
                  json.getDouble(
                    key: "borderRadius",
                  ),
                )
              : BorderRadius.zero,
          side: json.borderSide(key: "borderSide"),
        ),
      "ContinuousRectangleBorder" => ContinuousRectangleBorder(
          borderRadius: json["borderRadius"] != null
              ? BorderRadius.circular(
                  json.getDouble(
                    key: "borderRadius",
                  ),
                )
              : BorderRadius.zero,
          side: json.borderSide(key: "borderSide"),
        ),
      _ => const RoundedRectangleBorder(),
    };
  }

  @preferInline
  ShapeBorder? shapeBorder({
    String key = "shape",
    ShapeBorder? defaultValue,
  }) {
    final value = json[key];

    if (value is ShapeBorder) return value;

    return json[key] = switch (value) {
      Map<String, dynamic>() => _shapeBorderFromMap(value),
      _ => defaultValue,
    };
  }

  @preferInline
  Border _borderFromMap(Map<String, dynamic> value) {
    final data = DuitDataSource(value);
    return Border.fromBorderSide(data.borderSide());
  }

  @preferInline
  Border? border({
    String key = "shape",
    Border? defaultValue,
  }) {
    final value = json[key];

    if (value is Border) return value;

    return json[key] = switch (value) {
      Map<String, dynamic>() => _borderFromMap(value),
      _ => defaultValue,
    };
  }

  @preferInline
  BorderRadius borderRadius({
    String key = "borderRadius",
    BorderRadius? defaultValue,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(json['topLeft']?['radius'] ?? 0.0),
      topRight: Radius.circular(json['topRight']?['radius'] ?? 0.0),
      bottomLeft: Radius.circular(json['bottomLeft']?['radius'] ?? 0.0),
      bottomRight: Radius.circular(json['bottomRight']?['radius'] ?? 0.0),
    );
  }

  //TODO: NEEEEEEDS WOOOOORK
  @preferInline
  FloatingActionButtonLocation? fabLocation({
    String key = "floatingActionButtonLocation",
    FloatingActionButtonLocation? defaultValue,
  }) {
    final value = json[key];

    if (value is FloatingActionButtonLocation) return value;

    return json[key] = switch (value) {
      "centerDocked" || 0 => FloatingActionButtonLocation.centerDocked,
      "centerFloat" || 1 => FloatingActionButtonLocation.centerFloat,
      "centerTop" || 2 => FloatingActionButtonLocation.centerTop,
      "endDocked" || 3 => FloatingActionButtonLocation.endDocked,
      "endFloat" || 4 => FloatingActionButtonLocation.endFloat,
      "endTop" || 5 => FloatingActionButtonLocation.endTop,
      "startDocked" || 6 => FloatingActionButtonLocation.startDocked,
      "startFloat" || 7 => FloatingActionButtonLocation.startFloat,
      "startTop" || 8 => FloatingActionButtonLocation.startTop,
      "miniCenterDocked" || 9 => FloatingActionButtonLocation.miniCenterDocked,
      "miniCenterFloat" || 10 => FloatingActionButtonLocation.miniCenterFloat,
      "miniCenterTop" || 11 => FloatingActionButtonLocation.miniCenterTop,
      "miniEndDocked" || 12 => FloatingActionButtonLocation.miniEndDocked,
      "miniEndFloat" || 13 => FloatingActionButtonLocation.miniEndFloat,
      "miniEndTop" || 14 => FloatingActionButtonLocation.miniEndTop,
      "miniStartDocked" || 15 => FloatingActionButtonLocation.miniStartDocked,
      "miniStartFloat" || 16 => FloatingActionButtonLocation.miniStartFloat,
      "miniStartTop" || 17 => FloatingActionButtonLocation.miniStartTop,
      _ => null,
    };
  }

  @preferInline
  WidgetStateProperty<T?>? widgetStateProperty<T>({
    required String key,
    WidgetStateProperty<T?>? defaultValue,
  }) {
    final value = json[key];

    if (value == null) {
      return defaultValue;
    }

    if (value is WidgetStateProperty<T>) {
      return value;
    }

    if (value is Map<String, dynamic>) {
      final data = DuitDataSource(value);
      return WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.disabled)) {
            return switch (T) {
              Color => data.tryParseColor(
                  key: WidgetState.disabled.name,
                ),
              EdgeInsetsGeometry => data.edgeInsets(
                  key: WidgetState.disabled.name,
                ),
              Size => data.size(
                  WidgetState.disabled.name,
                ),
              double => data.tryGetDouble(
                  key: WidgetState.disabled.name,
                ),
              OutlinedBorder => data.shapeBorder(
                  key: WidgetState.disabled.name,
                ),
              TextStyle => data.textStyle(
                  key: WidgetState.disabled.name,
                ),
              BorderSide => data.borderSide(
                  key: WidgetState.disabled.name,
                ),
              _ => null,
            } as T?;
          }

          if (states.contains(WidgetState.selected)) {
            return switch (T) {
              Color => data.tryParseColor(
                  key: WidgetState.selected.name,
                ),
              EdgeInsetsGeometry => data.edgeInsets(
                  key: WidgetState.selected.name,
                ),
              Size => data.size(
                  WidgetState.selected.name,
                ),
              double => data.tryGetDouble(
                  key: WidgetState.selected.name,
                ),
              OutlinedBorder => data.shapeBorder(
                  key: WidgetState.selected.name,
                ),
              TextStyle => data.textStyle(
                  key: WidgetState.selected.name,
                ),
              BorderSide => data.borderSide(
                  key: WidgetState.selected.name,
                ),
              _ => null,
            } as T?;
          }

          if (states.contains(WidgetState.error)) {
            return switch (T) {
              Color => data.tryParseColor(
                  key: WidgetState.error.name,
                ),
              EdgeInsetsGeometry => data.edgeInsets(
                  key: WidgetState.error.name,
                ),
              Size => data.size(
                  WidgetState.error.name,
                ),
              double => data.tryGetDouble(
                  key: WidgetState.error.name,
                ),
              OutlinedBorder => data.shapeBorder(
                  key: WidgetState.error.name,
                ),
              TextStyle => data.textStyle(
                  key: WidgetState.error.name,
                ),
              BorderSide => data.borderSide(
                  key: WidgetState.error.name,
                ),
              _ => null,
            } as T?;
          }

          if (states.contains(WidgetState.pressed)) {
            return switch (T) {
              Color => data.tryParseColor(
                  key: WidgetState.pressed.name,
                ),
              EdgeInsetsGeometry => data.edgeInsets(
                  key: WidgetState.pressed.name,
                ),
              Size => data.size(
                  WidgetState.pressed.name,
                ),
              double => data.tryGetDouble(
                  key: WidgetState.pressed.name,
                ),
              OutlinedBorder => data.shapeBorder(
                  key: WidgetState.pressed.name,
                ),
              TextStyle => data.textStyle(
                  key: WidgetState.pressed.name,
                ),
              BorderSide => data.borderSide(
                  key: WidgetState.pressed.name,
                ),
              _ => null,
            } as T?;
          }

          if (states.contains(WidgetState.hovered)) {
            return switch (T) {
              Color => data.tryParseColor(
                  key: WidgetState.hovered.name,
                ),
              EdgeInsetsGeometry => data.edgeInsets(
                  key: WidgetState.hovered.name,
                ),
              Size => data.size(
                  WidgetState.hovered.name,
                ),
              double => data.tryGetDouble(
                  key: WidgetState.hovered.name,
                ),
              OutlinedBorder => data.shapeBorder(
                  key: WidgetState.hovered.name,
                ),
              TextStyle => data.textStyle(
                  key: WidgetState.hovered.name,
                ),
              BorderSide => data.borderSide(
                  key: WidgetState.hovered.name,
                ),
              _ => null,
            } as T?;
          }

          if (states.contains(WidgetState.focused)) {
            return switch (T) {
              Color => data.tryParseColor(
                  key: WidgetState.focused.name,
                ),
              EdgeInsetsGeometry => data.edgeInsets(
                  key: WidgetState.focused.name,
                ),
              Size => data.size(
                  WidgetState.focused.name,
                ),
              double => data.tryGetDouble(
                  key: WidgetState.focused.name,
                ),
              OutlinedBorder => data.shapeBorder(
                  key: WidgetState.focused.name,
                ),
              TextStyle => data.textStyle(
                  key: WidgetState.focused.name,
                ),
              BorderSide => data.borderSide(
                  key: WidgetState.focused.name,
                ),
              _ => null,
            } as T?;
          }

          if (states.contains(WidgetState.dragged)) {
            return switch (T) {
              Color => data.tryParseColor(
                  key: WidgetState.dragged.name,
                ),
              EdgeInsetsGeometry => data.edgeInsets(
                  key: WidgetState.dragged.name,
                ),
              Size => data.size(
                  WidgetState.dragged.name,
                ),
              double => data.tryGetDouble(
                  key: WidgetState.dragged.name,
                ),
              OutlinedBorder => data.shapeBorder(
                  key: WidgetState.dragged.name,
                ),
              TextStyle => data.textStyle(
                  key: WidgetState.dragged.name,
                ),
              BorderSide => data.borderSide(
                  key: WidgetState.dragged.name,
                ),
              _ => null,
            } as T?;
          }

          return null;
        },
      );
    } else {
      return null;
    }
  }

  @preferInline
  ButtonStyle _buttonStyleFromMap(Map<String, dynamic> value) {
    final json = DuitDataSource(value);
    return ButtonStyle(
      textStyle: json.widgetStateProperty<TextStyle>(key: "textStyle"),
      backgroundColor: json.widgetStateProperty<Color>(key: "backgroundColor"),
      foregroundColor: json.widgetStateProperty<Color>(key: "foregroundColor"),
      overlayColor: json.widgetStateProperty<Color>(key: "overlayColor"),
      shadowColor: json.widgetStateProperty<Color>(key: "shadowColor"),
      surfaceTintColor:
          json.widgetStateProperty<Color>(key: "surfaceTintColor"),
      elevation: json.widgetStateProperty<double>(key: "elevation"),
      padding: json.widgetStateProperty<EdgeInsetsGeometry>(key: "padding"),
      minimumSize: json.widgetStateProperty<Size>(key: "minimumSize"),
      maximumSize: json.widgetStateProperty<Size>(key: "maximumSize"),
      iconColor: json.widgetStateProperty<Color>(key: "iconColor"),
      iconSize: json.widgetStateProperty<double>(key: "iconSize"),
      side: json.widgetStateProperty<BorderSide>(key: "side"),
      shape: json.widgetStateProperty<OutlinedBorder>(key: "shape"),
      visualDensity: json.visualDensity(key: "visualDensity"),
      tapTargetSize: json.materialTapTargetSize(key: "tapTargetSize"),
      animationDuration: json.duration(key: "animationDuration"),
      enableFeedback: json.tryGetBool("enableFeedback"),
      alignment: json.alignment(key: "alignment"),
    );
  }

  @preferInline
  ButtonStyle? buttonStyle({
    String key = "style",
    ButtonStyle? defaultValue,
  }) {
    final value = json[key];

    if (value is ButtonStyle) return value;

    return json[key] = switch (value) {
      Map<String, dynamic>() => _buttonStyleFromMap(value),
      _ => defaultValue,
    };
  }
}
