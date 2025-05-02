import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:duit_kernel/duit_kernel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
Color? _colorFromList(List color) {
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
      List() => _colorFromList(color),
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
    return json[key] = switch (action) {
      ServerAction() => action,
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

  @preferInline
  String? get parentBuilderId {
    final id = json["parentBuilderId"];
    return id is String? ? id : null;
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
    return json["tweenDescriptions"] = switch (value) {
      List<DuitTweenDescription>() => value,
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
  @preferInline
  Color parseColor({
    String key = "color",
    Color defaultValue = Colors.transparent,
  }) {
    final value = json[key];
    if (value is Color) return value;
    final col = _parseColor(value);
    return json[key] = col ?? defaultValue;
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
  @preferInline
  Color? tryParseColor({
    String key = "color",
    Color? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      Color() => value,
      String() || List() => _parseColor(value),
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

    return json[key] = switch (value) {
      Duration() => value,
      num() => Duration(milliseconds: value.toInt()),
      _ => defaultValue ?? Duration.zero,
    };
  }

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
  TextAlign? textAlign({
    String key = "textAlign",
    TextAlign? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      TextAlign() => value,
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
  TextDirection? textDirection({
    String key = "textDirection",
    TextDirection? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      TextDirection() => value,
      "ltr" || 0 => TextDirection.ltr,
      "rtl" || 1 => TextDirection.rtl,
      null => null,
      _ => defaultValue ?? TextDirection.ltr
    };
  }

  @preferInline
  TextOverflow? textOverflow({
    String key = "overflow",
    TextOverflow? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      TextOverflow() => value,
      "clip" || 0 => TextOverflow.clip,
      "ellipsis" || 1 => TextOverflow.ellipsis,
      "fade" || 2 => TextOverflow.fade,
      "visible" || 3 => TextOverflow.visible,
      null => null,
      _ => defaultValue ?? TextOverflow.clip
    };
  }

  @preferInline
  Clip clipBehavior({
    String key = "clipBehavior",
    Clip? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      Clip() => value,
      "hardEdge" || 0 => Clip.hardEdge,
      "antiAlias" || 1 => Clip.antiAlias,
      "antiAliasWithSaveLayer" || 2 => Clip.antiAliasWithSaveLayer,
      "none" || 3 => Clip.none,
      _ => defaultValue ?? Clip.hardEdge
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
  Size _sizeFromList(List list) => Size(
        list[0].toDouble(),
        list[1].toDouble(),
      );

  @preferInline
  Size size(
    String key, {
    Size? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      Size() => value,
      Map<String, dynamic>() => _sizeFromMap(DuitDataSource(value)),
      List() => _sizeFromList(value),
      _ => defaultValue ?? Size.zero,
    };
  }

  @preferInline
  EdgeInsets _edgeInsetsFromList(List value) {
    final list = List.castFrom<dynamic, num>(value);
    return switch (list.length) {
      2 => EdgeInsets.symmetric(
          vertical: value[0].toDouble(),
          horizontal: value[1].toDouble(),
        ),
      4 => EdgeInsets.only(
          left: value[0].toDouble(),
          top: value[1].toDouble(),
          right: value[2].toDouble(),
          bottom: value[3].toDouble(),
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
    return json[key] = switch (value) {
      EdgeInsets() => value,
      num() => EdgeInsets.all(value.toDouble()),
      List() => _edgeInsetsFromList(value),
      _ => defaultValue ?? EdgeInsets.zero,
    };
  }

  @preferInline
  Curve curve({
    String key = "curve",
    Curve? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      Curve() => value,
      "linear" || 0 => Curves.linear,
      "fastEaseInToSlowEaseOut" || 1 => Curves.fastEaseInToSlowEaseOut,
      "bounceIn" || 2 => Curves.bounceIn,
      "bounceInOut" || 3 => Curves.bounceInOut,
      "bounceOut" || 4 => Curves.bounceOut,
      "decelerate" || 5 => Curves.decelerate,
      "ease" || 6 => Curves.ease,
      "easeIn" || 7 => Curves.easeIn,
      "easeInBack" || 8 => Curves.easeInBack,
      "easeInCirc" || 9 => Curves.easeInCirc,
      "easeInSine" || 10 => Curves.easeInSine,
      "easeInCubic" || 11 => Curves.easeInCubic,
      "easeInExpo" || 12 => Curves.easeInExpo,
      "easeInOutCubicEmphasized" || 13 => Curves.easeInOutCubicEmphasized,
      "easeInOutBack" || 14 => Curves.easeInOutBack,
      "easeInOutCirc" || 15 => Curves.easeInOutCirc,
      "easeInOutExpo" || 16 => Curves.easeInOutExpo,
      "easeInOutQuad" || 17 => Curves.easeInOutQuad,
      "easeInOutQuart" || 18 => Curves.easeInOutQuart,
      "easeInOutQuint" || 19 => Curves.easeInOutQuint,
      "easeInOutSine" || 20 => Curves.easeInOutSine,
      "easeInToLinear" || 21 => Curves.easeInToLinear,
      "easeOutSine" || 22 => Curves.easeOutSine,
      "easeOutBack" || 23 => Curves.easeOutBack,
      "easeOutCirc" || 24 => Curves.easeOutCirc,
      "easeOutCubic" || 25 => Curves.easeOutCubic,
      "easeOutExpo" || 26 => Curves.easeOutExpo,
      "easeOutQuad" || 27 => Curves.easeOutQuad,
      "easeOutQuart" || 28 => Curves.easeOutQuart,
      "easeOutQuint" || 29 => Curves.easeOutQuint,
      "linearToEaseOut" || 30 => Curves.linearToEaseOut,
      "slowMiddle" || 31 => Curves.slowMiddle,
      "fastOutSlowIn" || 32 => Curves.fastOutSlowIn,
      "elasticIn" || 33 => Curves.elasticIn,
      "elasticInOut" || 34 => Curves.elasticInOut,
      "elasticOut" || 35 => Curves.elasticOut,
      _ => defaultValue ?? Curves.linear,
    };
  }

  @preferInline
  TextBaseline? textBaseline({
    String key = "textBaseline",
    TextBaseline? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      TextBaseline() => value,
      "alphabetic" || 0 => TextBaseline.alphabetic,
      "ideographic" || 1 => TextBaseline.ideographic,
      _ => defaultValue,
    };
  }

  @preferInline
  TextWidthBasis? textWidthBasis({
    String key = "textWidthBasis",
    TextWidthBasis? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      TextWidthBasis() => value,
      "parent" || 0 => TextWidthBasis.parent,
      "longestLine" || 1 => TextWidthBasis.longestLine,
      _ => defaultValue,
    };
  }

  @preferInline
  TextStyle? textStyle({
    String key = "style",
    TextStyle? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      TextStyle() => value,
      Map<String, dynamic>() => _textStyleFromMap(Map.from(value)),
      _ => defaultValue,
    };
  }

  @preferInline
  TextStyle _textStyleFromMap(Map<String, dynamic> data) {
    final style = DuitDataSource(data);

    return TextStyle(
      color: style.tryParseColor(key: "color"),
      fontFamily: style.tryGetString("fontFamily"),
      fontWeight: style.fontWeight(),
      fontSize: style.tryGetDouble(key: "fontSize"),
      fontStyle: style.fontStyle(),
      letterSpacing: style.tryGetDouble(key: "letterSpacing"),
      wordSpacing: style.tryGetDouble(key: "wordSpacing"),
      backgroundColor: style.tryParseColor(key: "backgroundColor"),
      decoration: style.textDecoration(),
      decorationColor: style.tryParseColor(key: "decorationColor"),
      decorationStyle: style.textDecorationStyle(),
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
      begin: style.alignment(key: "begin", defaultValue: Alignment.centerLeft)
          as Alignment,
      end: style.alignment(key: "end", defaultValue: Alignment.centerRight)
          as Alignment,
      transform: angle != null ? GradientRotation(angle) : null,
    );
  }

  @preferInline
  BoxShadow _boxShadowFromMap(json) {
    final data = DuitDataSource(json);
    return BoxShadow(
      color: data.parseColor(key: "color"),
      offset: data.offset(defaultValue: Offset.zero) as Offset,
      blurRadius: data.getDouble(key: "blurRadius"),
      spreadRadius: data.getDouble(key: "spreadRadius"),
    );
  }

  @preferInline
  Offset? offset({
    String key = "offset",
    Offset? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      Offset() => value,
      Map<String, dynamic>() => Offset(value["dx"] ?? 0, value["dy"] ?? 0),
      _ => defaultValue,
    };
  }

  @preferInline
  List<BoxShadow>? boxShadow({
    String key = "boxShadow",
    List<BoxShadow>? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      List<BoxShadow>() => value,
      List() => value.map<BoxShadow>(_boxShadowFromMap).toList(),
      _ => defaultValue,
    };
  }

  @preferInline
  Decoration _decorationFromMap(Map<String, dynamic> data) {
    final style = DuitDataSource(Map<String, dynamic>.from(data));
    return BoxDecoration(
      color: style.tryParseColor(key: "color"),
      borderRadius: style["borderRadius"] != null
          ? BorderRadius.circular(
              style.getDouble(
                key: "borderRadius",
              ),
            )
          : null,
      border: style["borderRadius"] != null
          ? Border.fromBorderSide(
              style.borderSide(
                key: "border",
              ),
            )
          : null,
      gradient: _gradientFromMap(style["gradient"]),
      boxShadow: style.boxShadow(),
    );
  }

  @preferInline
  Decoration? decoration({
    String key = "decoration",
    Decoration? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      BoxDecoration() => value,
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
    return json[key] = switch (value) {
      TextDecoration() => value,
      "none" || 0 => TextDecoration.none,
      "underline" || 1 => TextDecoration.underline,
      "overline" || 2 => TextDecoration.overline,
      "lineThrough" || 3 => TextDecoration.lineThrough,
      _ => defaultValue,
    };
  }

  @preferInline
  TextDecorationStyle? textDecorationStyle({
    String key = "decorationStyle",
    TextDecorationStyle? defaultValue,
  }) {
    final value = json[key];
    return switch (value) {
      TextDecorationStyle() => value,
      "solid" || 0 => TextDecorationStyle.solid,
      "double" || 1 => TextDecorationStyle.double,
      "dotted" || 2 => TextDecorationStyle.dotted,
      "dashed" || 3 => TextDecorationStyle.dashed,
      "wavy" || 4 => TextDecorationStyle.wavy,
      _ => defaultValue,
    };
  }

  @preferInline
  FontWeight? fontWeight({
    String key = "fontWeight",
    FontWeight? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      FontWeight() => value,
      100 => FontWeight.w100,
      200 => FontWeight.w200,
      300 => FontWeight.w300,
      400 => FontWeight.w400,
      500 => FontWeight.w500,
      600 => FontWeight.w600,
      700 => FontWeight.w700,
      800 => FontWeight.w800,
      900 => FontWeight.w900,
      _ => defaultValue,
    };
  }

  @preferInline
  FontStyle? fontStyle({
    String key = "fontStyle",
    FontStyle? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      FontStyle() => value,
      "normal" || 0 => FontStyle.normal,
      "italic" || 1 => FontStyle.italic,
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
      leadingDistribution: json.textLeadingDistribution(),
    );
  }

  @preferInline
  TextHeightBehavior? textHeightBehavior({
    String key = "textHeightBehavior",
    TextHeightBehavior? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      TextHeightBehavior() => value,
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
    return json[key] = switch (value) {
      TextScaler() => value,
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
  TextLeadingDistribution textLeadingDistribution({
    String key = "leadingDistribution",
    TextLeadingDistribution? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      TextLeadingDistribution() => value,
      "proportional" || 0 => TextLeadingDistribution.proportional,
      "even" || 1 => TextLeadingDistribution.even,
      _ => defaultValue ?? TextLeadingDistribution.proportional
    };
  }

  @preferInline
  Axis axis({
    String key = "scrollDirection",
    Axis? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      Axis() => value,
      "vertical" || 0 => Axis.vertical,
      "horizontal" || 1 => Axis.horizontal,
      _ => defaultValue ?? Axis.vertical,
    };
  }

  @preferInline
  WrapCrossAlignment? wrapCrossAlignment({
    String key = "crossAxisAlignment",
    WrapCrossAlignment? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      WrapCrossAlignment() => value,
      "start" || 0 => WrapCrossAlignment.start,
      "end" || 1 => WrapCrossAlignment.end,
      "center" || 2 => WrapCrossAlignment.center,
      _ => defaultValue ?? WrapCrossAlignment.start,
    };
  }

  @preferInline
  WrapAlignment? wrapAlignment({
    String key = "alignment",
    WrapAlignment? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      WrapAlignment() => value,
      "start" || 0 => WrapAlignment.start,
      "end" || 1 => WrapAlignment.end,
      "center" || 2 => WrapAlignment.center,
      "spaceBetween" || 3 => WrapAlignment.spaceBetween,
      "spaceAround" || 4 => WrapAlignment.spaceAround,
      "spaceEvenly" || 5 => WrapAlignment.spaceEvenly,
      _ => defaultValue ?? WrapAlignment.start,
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
    return json[key] = switch (value) {
      BoxConstraints() => value,
      Map<String, dynamic>() => _boxConstraintsFromMap(value),
      _ => defaultValue ?? const BoxConstraints(),
    };
  }

  StackFit stackFit({
    String key = "fit",
    StackFit? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      StackFit() => value,
      "expand" || 0 => StackFit.expand,
      "passthrough" || 1 => StackFit.passthrough,
      "loose" || 2 => StackFit.loose,
      _ => defaultValue ?? StackFit.loose,
    };
  }

  @preferInline
  OverflowBoxFit overflowBoxFit({
    String key = "fit",
    OverflowBoxFit? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      OverflowBoxFit() => value,
      "max" || 0 => OverflowBoxFit.max,
      "deferToChild" || 1 => OverflowBoxFit.deferToChild,
      _ => defaultValue ?? OverflowBoxFit.max,
    };
  }

  @preferInline
  Alignment? alignment({
    String key = "alignment",
    Alignment? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      Alignment() => value,
      "topCenter" || 0 => Alignment.topCenter,
      "topLeft" || 1 => Alignment.topLeft,
      "topRight" || 2 => Alignment.topRight,
      "centerLeft" || 3 => Alignment.centerLeft,
      "center" || 4 => Alignment.center,
      "centerRight" || 5 => Alignment.centerRight,
      "bottomLeft" || 6 => Alignment.bottomLeft,
      "bottomCenter" || 7 => Alignment.bottomCenter,
      "bottomRight" || 8 => Alignment.bottomRight,
      _ => defaultValue,
    };
  }

  @preferInline
  AlignmentDirectional alignmentDirectional({
    String key = "alignment",
    AlignmentDirectional? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      AlignmentDirectional() => value,
      "topStart" || 0 => AlignmentDirectional.topStart,
      "topEnd" || 1 => AlignmentDirectional.topEnd,
      "centerStart" || 2 => AlignmentDirectional.centerStart,
      "center" || 3 => AlignmentDirectional.center,
      "centerEnd" || 4 => AlignmentDirectional.centerEnd,
      "bottomStart" || 5 => AlignmentDirectional.bottomStart,
      "bottomCenter" || 6 => AlignmentDirectional.bottomCenter,
      "bottomEnd" || 7 => AlignmentDirectional.bottomEnd,
      _ => defaultValue ?? AlignmentDirectional.center,
    };
  }

  @preferInline
  MainAxisAlignment mainAxisAlignment({
    String key = "mainAxisAlignment",
    MainAxisAlignment? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      MainAxisAlignment() => value,
      "start" || 0 => MainAxisAlignment.start,
      "end" || 1 => MainAxisAlignment.end,
      "center" || 2 => MainAxisAlignment.center,
      "spaceBetween" || 3 => MainAxisAlignment.spaceBetween,
      "spaceAround" || 4 => MainAxisAlignment.spaceAround,
      "spaceEvenly" || 5 => MainAxisAlignment.spaceEvenly,
      _ => defaultValue ?? MainAxisAlignment.start,
    };
  }

  @preferInline
  CrossAxisAlignment crossAxisAlignment({
    String key = "crossAxisAlignment",
    CrossAxisAlignment? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      CrossAxisAlignment() => value,
      "start" || 0 => CrossAxisAlignment.start,
      "end" || 1 => CrossAxisAlignment.end,
      "center" || 2 => CrossAxisAlignment.center,
      "stretch" || 3 => CrossAxisAlignment.stretch,
      "baseline" || 4 => CrossAxisAlignment.baseline,
      _ => defaultValue ?? CrossAxisAlignment.center,
    };
  }

  @preferInline
  MainAxisSize mainAxisSize({
    String key = "mainAxisSize",
    MainAxisSize? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      MainAxisSize() => value,
      "min" || 0 => MainAxisSize.min,
      "max" || 1 => MainAxisSize.max,
      _ => defaultValue ?? MainAxisSize.max,
    };
  }

  @preferInline
  SliderInteraction? sliderInteraction({
    String key = "interaction",
    SliderInteraction? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      SliderInteraction() => value,
      "tapOnly" || 0 => SliderInteraction.tapOnly,
      "tapAndSlide" || 1 => SliderInteraction.tapAndSlide,
      "slideOnly" || 2 => SliderInteraction.slideOnly,
      "slideThumb" || 3 => SliderInteraction.slideThumb,
      _ => defaultValue,
    };
  }

  @preferInline
  MaterialTapTargetSize? materialTapTargetSize({
    String key = "materialTapTargetSize",
    MaterialTapTargetSize? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      MaterialTapTargetSize() => value,
      "shrinkWrap" || 0 => MaterialTapTargetSize.shrinkWrap,
      "padded" || 1 => MaterialTapTargetSize.padded,
      _ => defaultValue,
    };
  }

  @preferInline
  FilterQuality filterQuality({
    String key = "filterQuality",
    FilterQuality? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      FilterQuality() => value,
      "none" || 0 => FilterQuality.none,
      "low" || 1 => FilterQuality.low,
      "medium" || 2 => FilterQuality.medium,
      "high" || 3 => FilterQuality.high,
      _ => defaultValue ?? FilterQuality.low,
    };
  }

  @preferInline
  ImageRepeat imageRepeat({
    String key = "repeat",
    ImageRepeat? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      ImageRepeat() => value,
      "repeat" || 0 => ImageRepeat.repeat,
      "repeatX" || 1 => ImageRepeat.repeatX,
      "repeatY" || 2 => ImageRepeat.repeatY,
      "noRepeat" || 3 => ImageRepeat.noRepeat,
      _ => defaultValue ?? ImageRepeat.noRepeat,
    };
  }

  @preferInline
  Uint8List _uint8ListFromString(String value) => base64Decode(value);

  @preferInline
  Uint8List _uint8ListFromList(List value) => Uint8List.fromList(
        List.castFrom<dynamic, int>(value),
      );

  @preferInline
  Uint8List uint8List({
    String key = "byteData",
    Uint8List? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      Uint8List() => value,
      List() => _uint8ListFromList(value),
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
    return json[key] = switch (value) {
      BoxFit() => value,
      "fill" || 0 => BoxFit.fill,
      "contain" || 1 => BoxFit.contain,
      "cover" || 2 => BoxFit.cover,
      "fitHeight" || 3 => BoxFit.fitHeight,
      "fitWidth" || 4 => BoxFit.fitWidth,
      "none" || 5 => BoxFit.none,
      "scaleDown" || 6 => BoxFit.scaleDown,
      _ => defaultValue,
    };
  }

  @preferInline
  BlendMode blendMode({
    String key = "blendMode",
    BlendMode? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      BlendMode() => value,
      "clear" => BlendMode.clear,
      "src" => BlendMode.src,
      "dst" => BlendMode.dst,
      "srcOver" => BlendMode.srcOver,
      "dstOver" => BlendMode.dstOver,
      "srcIn" => BlendMode.srcIn,
      "dstIn" => BlendMode.dstIn,
      "srcOut" => BlendMode.srcOut,
      "dstOut" => BlendMode.dstOut,
      "srcATop" => BlendMode.srcATop,
      "dstATop" => BlendMode.dstATop,
      "xor" => BlendMode.xor,
      "plus" => BlendMode.plus,
      "modulate" => BlendMode.modulate,
      "screen" => BlendMode.screen,
      "overlay" => BlendMode.overlay,
      "darken" => BlendMode.darken,
      "lighten" => BlendMode.lighten,
      "colorDodge" => BlendMode.colorDodge,
      "colorBurn" => BlendMode.colorBurn,
      "hardLight" => BlendMode.hardLight,
      "softLight" => BlendMode.softLight,
      "difference" => BlendMode.difference,
      "exclusion" => BlendMode.exclusion,
      "multiply" => BlendMode.multiply,
      "hue" => BlendMode.hue,
      "saturation" => BlendMode.saturation,
      "color" => BlendMode.color,
      "luminosity" => BlendMode.luminosity,
      _ => defaultValue ?? BlendMode.srcOver,
    };
  }

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
          filterQuality: json.filterQuality(),
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
    return json[key] = switch (value) {
      ImageFilter() => value,
      Map<String, dynamic>() => _imageFilterFromMap(value),
      _ => defaultValue ?? ImageFilter.blur(),
    };
  }

  @preferInline
  VerticalDirection verticalDirection({
    String key = "verticalDirection",
    VerticalDirection? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      VerticalDirection() => value,
      "up" => VerticalDirection.up,
      "down" => VerticalDirection.down,
      _ => defaultValue ?? VerticalDirection.down,
    };
  }

  @preferInline
  BoxShape boxShape({
    String key = "shape",
    BoxShape? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      BoxShape() => value,
      "circle" => BoxShape.circle,
      "rectangle" => BoxShape.rectangle,
      _ => defaultValue ?? BoxShape.rectangle,
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
      style: json.borderStyle(key: "style"),
    );
  }

  @preferInline
  BorderStyle borderStyle({
    String key = "style",
    BorderStyle? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      BorderStyle() => value,
      "solid" || 0 => BorderStyle.solid,
      "none" || 1 => BorderStyle.none,
      _ => defaultValue ?? BorderStyle.solid,
    };
  }

  @preferInline
  BorderSide borderSide({
    String key = "side",
    BorderSide? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      BorderSide() => value,
      Map<String, dynamic>() => _borderSideFromMap(value),
      _ => defaultValue ?? BorderSide.none,
    };
  }

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
    return json[key] = switch (value) {
      InputBorder() => value,
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
    return json[key] = switch (value) {
      InputDecoration() => value,
      Map<String, dynamic>() => _inputDecorationFromMap(value),
      _ => defaultValue,
    };
  }

  @preferInline
  TextInputType textInputType({
    String key = "keyboardType",
    TextInputType? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      TextInputType() => value,
      "text" => TextInputType.text,
      "name" => TextInputType.name,
      "none" => TextInputType.none,
      "url" => TextInputType.url,
      "emailAddress" => TextInputType.emailAddress,
      "datetime" => TextInputType.datetime,
      "streetAddress" => TextInputType.streetAddress,
      "number" => TextInputType.number,
      "phone" => TextInputType.phone,
      "multiline" => TextInputType.multiline,
      _ => defaultValue ?? TextInputType.text,
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
    return json[key] = switch (value) {
      VisualDensity() => value,
      Map<String, dynamic>() => _visualDensityFromMap(value),
      _ => defaultValue ?? const VisualDensity(),
    };
  }

  @preferInline
  ScrollViewKeyboardDismissBehavior keyboardDismissBehavior({
    String key = "keyboardDismissBehavior",
    ScrollViewKeyboardDismissBehavior? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      ScrollViewKeyboardDismissBehavior() => value,
      "manual" => ScrollViewKeyboardDismissBehavior.manual,
      "onDrag" => ScrollViewKeyboardDismissBehavior.onDrag,
      _ => defaultValue ?? ScrollViewKeyboardDismissBehavior.manual,
    };
  }

  @preferInline
  ScrollPhysics scrollPhysics({
    String key = "physics",
    ScrollPhysics? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      ScrollPhysics() => value,
      "alwaysScrollableScrollPhysics" => const AlwaysScrollableScrollPhysics(),
      "bouncingScrollPhysics" => const BouncingScrollPhysics(),
      "clampingScrollPhysics" => const ClampingScrollPhysics(),
      "fixedExtentScrollPhysics" => const FixedExtentScrollPhysics(),
      "neverScrollableScrollPhysics" => const NeverScrollableScrollPhysics(),
      _ => defaultValue ?? const AlwaysScrollableScrollPhysics(),
    };
  }

  @preferInline
  DragStartBehavior dragStartBehavior({
    String key = "dragStartBehavior",
    DragStartBehavior? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      DragStartBehavior() => value,
      "start" => DragStartBehavior.start,
      "down" => DragStartBehavior.down,
      _ => defaultValue ?? DragStartBehavior.start,
    };
  }

  @preferInline
  HitTestBehavior hitTestBehavior({
    String key = "hitTestBehavior",
    HitTestBehavior? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      HitTestBehavior() => value,
      "deferToChild" => HitTestBehavior.deferToChild,
      "opaque" => HitTestBehavior.opaque,
      "translucent" => HitTestBehavior.translucent,
      _ => defaultValue ?? HitTestBehavior.deferToChild,
    };
  }

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
    return json[key] = switch (value) {
      ShapeBorder() => value,
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
    return json[key] = switch (value) {
      Border() => value,
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

  @preferInline
  FloatingActionButtonLocation? fabLocation({
    String key = "floatingActionButtonLocation",
    FloatingActionButtonLocation? defaultValue,
  }) {
    final value = json[key];
    return json[key] = switch (value) {
      FloatingActionButtonLocation() => value,
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
    return json[key] = switch (value) {
      ButtonStyle() => value,
      Map<String, dynamic>() => _buttonStyleFromMap(value),
      _ => null,
    };
  }
}
