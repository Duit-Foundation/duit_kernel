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

/// A wrapper for JSON data that provides type-safe access to Flutter properties.
///
/// This extension type wraps a [Map<String, dynamic>] and provides methods to safely
/// parse and convert JSON values into Flutter types. It implements [Map<String, dynamic>]
/// to maintain compatibility with JSON operations.
///
/// The extension type provides methods for:
/// - Parsing basic types (int, double, string, bool)
/// - Converting colors from hex strings or RGB arrays
/// - Parsing Flutter-specific types (Size, EdgeInsets, Alignment, etc.)
/// - Handling enums through string or integer lookups
/// - Managing widget states and properties
///
/// Example usage:
/// ```dart
/// final data = DuitDataSource({
///   'color': '#FF0000',
///   'size': {'width': 100, 'height': 100},
///   'padding': [10, 20, 10, 20],
/// });
///
/// final color = data.parseColor(); // Returns Color(0xFFFF0000)
/// final size = data.size('size'); // Returns Size(100, 100)
/// final padding = data.edgeInsets(); // Returns EdgeInsets(10, 20, 10, 20)
/// ```
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

  /// Converts a [Map] to a [Map<String, dynamic>].
  ///
  /// This is a helper method used internally to ensure type safety when working with JSON data.
  ///
  /// - [value]: The map to convert.
  /// Returns a new [Map<String, dynamic>] containing the same key-value pairs as the input map.
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

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _colorFromHexString(value);
      case List<num>():
        return json[key] = _colorFromList(value);
      default:
        return defaultValue;
    }
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

    if (value == null) {
      return defaultValue ?? Duration.zero;
    }

    switch (value) {
      case int():
        return json[key] = Duration(milliseconds: value);
      default:
        return defaultValue ?? Duration.zero;
    }
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
  /// - 0 if both the value and [defaultValue] are null.
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
  /// - `null` if both the value and [defaultValue] are null.
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

  /// Retrieves a [double] value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already a [double], it returns that value.
  /// If the value is a [num], it attempts to parse it into a [double].
  /// Otherwise, it returns [defaultValue].
  ///
  /// The parsed or existing [double] is also stored back into the JSON map at the given [key].
  ///
  /// Returns:
  /// - A [double] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [double] or cannot be parsed.
  /// - 0.0 if both the value and [defaultValue] are null.
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

  /// Retrieves a [double] value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already a [double], it returns that value.
  /// If the value is a [num], it attempts to parse it into a [double].
  /// Otherwise, it returns [defaultValue].
  ///
  /// Unlike [getDouble], this method does not store the parsed or existing [double] back into the JSON map.
  ///
  /// Returns:
  /// - A [double] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [double] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
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

  /// Retrieves a [String] value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already a [String], it returns that value.
  /// Otherwise, it returns [defaultValue].
  ///
  /// The parsed or existing [String] is also stored back into the JSON map at the given [key].
  ///
  /// Returns:
  /// - A [String] if the value is valid.
  /// - [defaultValue] if the value is not a valid [String].
  /// - Empty string ("") if both the value and [defaultValue] are null.
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

  /// Retrieves a [String] value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already a [String], it returns that value.
  /// Otherwise, it returns [defaultValue].
  ///
  /// Unlike [getString], this method does not store the parsed or existing [String] back into the JSON map.
  ///
  /// Returns:
  /// - A [String] if the value is valid.
  /// - [defaultValue] if the value is not a valid [String].
  /// - `null` if both the value and [defaultValue] are null.
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

  /// Retrieves a [bool] value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already a [bool], it returns that value.
  /// Otherwise, it returns [defaultValue].
  ///
  /// The parsed or existing [bool] is also stored back into the JSON map at the given [key].
  ///
  /// Returns:
  /// - A [bool] if the value is valid.
  /// - [defaultValue] if the value is not a valid [bool].
  /// - false if both the value and [defaultValue] are null.
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

  /// Retrieves a [bool] value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already a [bool], it returns that value.
  /// Otherwise, it returns [defaultValue].
  ///
  /// Unlike [getBool], this method does not store the parsed or existing [bool] back into the JSON map.
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
  TextAlign? textAlignxx({
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

  /// Retrieves a [TextAlign] value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already a [TextAlign], it returns that value.
  /// If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// The parsed or existing [TextAlign] is also stored back into the JSON map at the given [key].
  ///
  /// Returns:
  /// - A [TextAlign] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [TextAlign] or cannot be parsed.
  /// - `null` if the value is `null` and [defaultValue] is provided.
  @preferInline
  TextAlign? textAlign({
    String key = "textAlign",
    TextAlign defaultValue = TextAlign.start,
  }) {
    final value = json[key];

    if (value is TextAlign) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _textAlignStringLookupTable[value] ?? defaultValue;
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [TextDirection] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [TextDirection],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// If the value is `null` and [defaultValue] is provided, [defaultValue] is returned.
  /// Otherwise, returns `defaultValue` if the value cannot be resolved.
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'textDirection'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved.
  ///
  /// Example:
  ///   textDirection(key: 'myDirection', defaultValue: TextDirection.ltr)
  @preferInline
  TextDirection? textDirection({
    String key = "textDirection",
    TextDirection? defaultValue,
  }) {
    final value = json[key];

    if (value is TextDirection) return value;

    if (value == null && defaultValue != null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _textDirectionStringLookupTable[value];
      case int():
        return json[key] = _textDirectionIntLookupTable[value];
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [TextOverflow] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [TextOverflow],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// If the value is `null` and [defaultValue] is provided, [defaultValue] is returned.
  /// Otherwise, returns `null` if the value cannot be resolved.
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'overflow'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved.
  ///
  /// Example:
  ///   textOverflow(key: 'myOverflow', defaultValue: TextOverflow.ellipsis)
  @preferInline
  TextOverflow? textOverflow({
    String key = "textOverflow",
    TextOverflow defaultValue = TextOverflow.clip,
  }) {
    final value = json[key];

    if (value is TextOverflow) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] =
            _textOverflowStringLookupTable[value] ?? defaultValue;
      case int():
        return json[key] = _textOverflowIntLookupTable[value] ?? defaultValue;
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [Clip] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [Clip],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// If the value is `null`, returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'clipBehavior'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved.
  ///   Defaults to [Clip.hardEdge].
  ///
  /// Example:
  ///   clipBehavior(key: 'myClip', defaultValue: Clip.antiAlias)
  @preferInline
  Clip clipBehavior({
    String key = "clipBehavior",
    Clip defaultValue = Clip.hardEdge,
  }) {
    final value = json[key];

    if (value is Clip) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _clipStringLookupTable[value] ?? defaultValue;
      case int():
        return json[key] = _clipIntLookupTable[value] ?? defaultValue;
      default:
        return defaultValue;
    }
  }

  /// Creates a [Size] object from a map containing width and height values.
  ///
  /// The map should contain 'width' and 'height' keys with numeric values.
  /// If a value is not provided, it defaults to [double.infinity].
  ///
  /// - [map]: The map containing width and height values.
  /// Returns a [Size] object with the specified dimensions.
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

  /// Creates a [Size] object from a list of numeric values.
  ///
  /// The list should contain exactly 2 elements representing width and height.
  ///
  /// - [list]: A list containing width and height values.
  /// Returns a [Size] object with the specified dimensions.
  @preferInline
  Size _sizeFromList(List<num> list) => Size(
        list[0].toDouble(),
        list[1].toDouble(),
      );

  /// Retrieves a [Size] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [Size],
  /// it is returned as is. The value can be provided in several formats:
  /// - A map with 'width' and 'height' keys
  /// - A list of two numbers [width, height]
  /// - A single number (creates a square size)
  /// If the value is `null`, returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved.
  ///   Defaults to [Size.zero].
  ///
  /// Example:
  ///   size('dimensions', defaultValue: Size(100, 100))
  @preferInline
  Size size(
    String key, {
    Size defaultValue = Size.zero,
  }) {
    final value = json[key];

    if (value is Size) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case Map<String, dynamic>():
        return json[key] = _sizeFromMap(DuitDataSource(value));
      case List<num>():
        return json[key] = _sizeFromList(value);
      case double():
        return json[key] = Size.square(value);
      default:
        return defaultValue;
    }
  }

  /// Creates an [EdgeInsets] object from a list of double values.
  ///
  /// The list should contain either 2 or 4 elements representing vertical and horizontal padding
  /// or left, top, right, and bottom padding.
  ///
  /// - [value]: A list containing padding values.
  /// Returns an [EdgeInsets] object with the specified padding.
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

  /// Retrieves an [EdgeInsets] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already an [EdgeInsets],
  /// it is returned as is. The value can be provided in several formats:
  /// - A list of 2 or 4 numbers [vertical, horizontal] or [left, top, right, bottom]
  /// - A single number (creates a square padding)
  /// If the value is `null`, returns [defaultValue].
  @preferInline
  EdgeInsets? edgeInsets({
    String key = "padding",
    EdgeInsets? defaultValue,
  }) {
    final value = json[key];

    if (value is EdgeInsets) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case List<double>():
        return json[key] = _edgeInsetsFromList(value);
      case num():
        return json[key] = EdgeInsets.all(value.toDouble());
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [Curve] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [Curve],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// If the value is `null`, returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'curve'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to Curves.linear.
  ///
  /// Example:
  ///   curve(key: 'myCurve', defaultValue: Curves.ease)

  @preferInline
  Curve? curve({
    String key = "curve",
    Curve defaultValue = Curves.linear,
  }) {
    final value = json[key];

    if (value is Curve) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _curveStringLookupTable[value];
      case int():
        return json[key] = _curveIntLookupTable[value];
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [TextBaseline] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [TextBaseline],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// If the value is `null`, returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'textBaseline'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to TextBaseline.alphabetic.
  ///
  /// Example:
  ///   textBaseline(key: 'myBaseline', defaultValue: TextBaseline.ideographic)
  @preferInline
  TextBaseline? textBaseline({
    String key = "textBaseline",
    TextBaseline? defaultValue,
  }) {
    final value = json[key];

    if (value is TextBaseline) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _textBaselineStringLookupTable[value];
      case int():
        return json[key] = _textBaselineIntLookupTable[value];
      default:
        return defaultValue;
    }
  }

  @preferInline
  TextWidthBasis? textWidthBasis({
    String key = "textWidthBasis",
    TextWidthBasis defaultValue = TextWidthBasis.parent,
  }) {
    final value = json[key];

    if (value is TextWidthBasis) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] =
            _textWidthBasisStringLookupTable[value] ?? defaultValue;
      case int():
        return json[key] = _textWidthBasisIntLookupTable[value] ?? defaultValue;
      default:
        return defaultValue;
    }
  }

  @preferInline
  TextStyle? textStyle({
    String key = "style",
    TextStyle? defaultValue,
  }) {
    final value = json[key];

    if (value is TextStyle) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case Map<String, dynamic>():
        return json[key] = _textStyleFromMap(_map(value));
      default:
        return defaultValue;
    }
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

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case Map<String, dynamic>():
        return json[key] = _offsetFromMap(value);
      default:
        return defaultValue;
    }
  }

  @preferInline
  List<BoxShadow>? boxShadow({
    String key = "boxShadow",
    List<BoxShadow>? defaultValue,
  }) {
    final value = json[key];

    if (value is List<BoxShadow>) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case List():
        return json[key] = value.map<BoxShadow>(_boxShadowFromMap).toList();
      default:
        return defaultValue;
    }
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

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case Map<String, dynamic>():
        return json[key] = _decorationFromMap(value);
      default:
        return defaultValue;
    }
  }

  @preferInline
  TextDecoration? textDecoration({
    String key = "decoration",
    TextDecoration? defaultValue,
  }) {
    final value = json[key];

    if (value is TextDecoration) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _textDecorationStringLookupTable[value];
      case int():
        return json[key] = _textDecorationIntLookupTable[value];
      default:
        return defaultValue;
    }
  }

  @preferInline
  TextDecorationStyle? textDecorationStyle({
    String key = "decorationStyle",
    TextDecorationStyle? defaultValue,
  }) {
    final value = json[key];

    if (value is TextDecorationStyle) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case int():
        return json[key] = _textDecorationStyleIntLookupTable[value];
      case String():
        return json[key] = _textDecorationStyleStringLookupTable[value];
      default:
        return defaultValue;
    }
  }

  @preferInline
  FontWeight? fontWeight({
    String key = "fontWeight",
    FontWeight? defaultValue,
  }) {
    final value = json[key];

    if (value is FontWeight) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case int():
        return json[key] = _fontWeightLookupTable[value];
      default:
        return defaultValue;
    }
  }

  @preferInline
  FontStyle? fontStyle({
    String key = "fontStyle",
    FontStyle? defaultValue,
  }) {
    final value = json[key];

    if (value is FontStyle) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _fontStyleStringLookupTable[value];
      case int():
        return json[key] = _fontStyleIntLookupTable[value];
      default:
        return defaultValue;
    }
  }

  @preferInline
  TextSpan _textSpanFromMap(Map<String, dynamic> value) {
    final span = DuitDataSource(value);
    final List? children = value['children'];
    final spanChildren = <InlineSpan>[];

    if (children != null) {
      for (final child in children) {
        spanChildren.add(DuitDataSource(child).textSpan());
      }
    }

    return TextSpan(
      text: span.tryGetString("text"),
      children: spanChildren.isNotEmpty ? spanChildren : null,
      style: span.textStyle(),
      spellOut: span.tryGetBool("spellOut"),
      semanticsLabel: span.tryGetString("semanticsLabel"),
    );
  }

  @preferInline
  TextSpan textSpan({
    String key = "textSpan",
    TextSpan defaultValue = const TextSpan(),
  }) {
    final value = json[key];

    if (value is TextSpan) {
      return value;
    }

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case Map<String, dynamic>():
        return json[key] = _textSpanFromMap(value);
      default:
        return defaultValue;
    }
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

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case Map<String, dynamic>():
        return json[key] = _parseTextHeightBehavior(value);
      default:
        return defaultValue;
    }
  }

  @preferInline
  TextScaler _textScalerFromMap(Map<String, dynamic> data) {
    final json = DuitDataSource(data);
    return TextScaler.linear(
      json.getDouble(
        key: "textScaleFactor",
        defaultValue: 1.0,
      ),
    );
  }

  @preferInline
  TextScaler textScaler({
    String key = "textScaler",
    TextScaler defaultValue = TextScaler.noScaling,
  }) {
    final value = json[key];

    if (value is TextScaler) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case Map<String, dynamic>():
        return json[key] = _textScalerFromMap(value);
      case double():
        return json[key] = TextScaler.linear(value);
      default:
        return defaultValue;
    }
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
      leadingDistribution: json.textLeadingDistribution(),
    );
  }

  @preferInline
  StrutStyle? strutStyle({
    String key = "strutStyle",
    StrutStyle? defaultValue,
  }) {
    final value = json[key];

    if (value is StrutStyle) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case Map<String, dynamic>():
        return json[key] = _strutStyleFromMap(value);
      default:
        return defaultValue;
    }
  }

  @preferInline
  TextLeadingDistribution? textLeadingDistribution({
    String key = "leadingDistribution",
    TextLeadingDistribution? defaultValue,
  }) {
    final value = json[key];

    if (value is TextLeadingDistribution) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _leadingDistributionStringLookupTable[value];
      case int():
        return json[key] = _leadingDistributionIntLookupTable[value];
      default:
        return defaultValue;
    }
  }

  @preferInline
  Axis axis({
    String key = "scrollDirection",
    Axis defaultValue = Axis.vertical,
  }) {
    final value = json[key];

    if (value is Axis) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _axisStringLookupTable[value] ?? defaultValue;
      case int():
        return json[key] = _axisIntLookupTable[value] ?? defaultValue;
      default:
        return defaultValue;
    }
  }

  @preferInline
  WrapCrossAlignment? wrapCrossAlignment({
    String key = "crossAxisAlignment",
    WrapCrossAlignment? defaultValue,
  }) {
    final value = json[key];

    if (value is WrapCrossAlignment) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _wrapCrossAlignmentStringLookupTable[value];
      case int():
        return json[key] = _wrapCrossAlignmentIntLookupTable[value];
      default:
        return defaultValue;
    }
  }

  @preferInline
  WrapAlignment? wrapAlignment({
    String key = "alignment",
    WrapAlignment? defaultValue,
  }) {
    final value = json[key];

    if (value is WrapAlignment) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _wrapAlignmentStringLookupTable[value];
      case int():
        return json[key] = _wrapAlignmentIntLookupTable[value];
      default:
        return defaultValue;
    }
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
  BoxConstraints? boxConstraints({
    String key = "constraints",
    BoxConstraints? defaultValue,
  }) {
    final value = json[key];

    if (value is BoxConstraints) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case Map<String, dynamic>():
        return json[key] = _boxConstraintsFromMap(value);
      default:
        return defaultValue;
    }
  }

  @preferInline
  StackFit? stackFit({
    String key = "fit",
    StackFit? defaultValue,
  }) {
    final value = json[key];

    if (value is StackFit) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _stackFitStringLookupTable[value];
      case int():
        return json[key] = _stackFitIntLookupTable[value];
      default:
        return defaultValue;
    }
  }

  @preferInline
  OverflowBoxFit? overflowBoxFit({
    String key = "fit",
    OverflowBoxFit defaultValue = OverflowBoxFit.max,
  }) {
    final value = json[key];

    if (value is OverflowBoxFit) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _overflowBoxFitStringLookupTable[value];
      case int():
        return json[key] = _overflowBoxFitIntLookupTable[value];
      default:
        return defaultValue;
    }
  }

  @preferInline
  Alignment? alignment({
    String key = "alignment",
    Alignment? defaultValue,
  }) {
    final value = json[key];

    if (value is Alignment) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _alignmentStringLookupTable[value];
      case int():
        return json[key] = _alignmentIntLookupTable[value];
      case List<num>() when value.length == 2:
        return json[key] = Alignment(
          value[0].toDouble(),
          value[1].toDouble(),
        );
      default:
        return defaultValue;
    }
  }

  @preferInline
  AlignmentDirectional? alignmentDirectional({
    String key = "alignment",
    AlignmentDirectional? defaultValue,
  }) {
    final value = json[key];

    if (value is AlignmentDirectional) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _alignmentDirectionalStringLookupTable[value];
      case int():
        return json[key] = _alignmentDirectionalIntLookupTable[value];
      case List<num>() when value.length == 2:
        return json[key] = AlignmentDirectional(
          value[0].toDouble(),
          value[1].toDouble(),
        );
      default:
        return defaultValue;
    }
  }

  @preferInline
  MainAxisAlignment? mainAxisAlignment({
    String key = "mainAxisAlignment",
    MainAxisAlignment? defaultValue,
  }) {
    final value = json[key];

    if (value is MainAxisAlignment) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _mainAxisAlignmentStringLookupTable[value];
      case int():
        return json[key] = _mainAxisAlignmentIntLookupTable[value];
      default:
        return defaultValue;
    }
  }

  @preferInline
  CrossAxisAlignment? crossAxisAlignment({
    String key = "crossAxisAlignment",
    CrossAxisAlignment? defaultValue,
  }) {
    final value = json[key];

    if (value is CrossAxisAlignment) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _crossAxisAlignmentStringLookupTable[value];
      case int():
        return json[key] = _crossAxisAlignmentIntLookupTable[value];
      default:
        return defaultValue;
    }
  }

  @preferInline
  MainAxisSize? mainAxisSize({
    String key = "mainAxisSize",
    MainAxisSize? defaultValue,
  }) {
    final value = json[key];

    if (value is MainAxisSize) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _mainAxisSizeStringLookupTable[value];
      case int():
        return json[key] = _mainAxisSizeIntLookupTable[value];
      default:
        return defaultValue;
    }
  }

  @preferInline
  SliderInteraction? sliderInteraction({
    String key = "interaction",
    SliderInteraction? defaultValue,
  }) {
    final value = json[key];

    if (value is SliderInteraction) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _sliderInteractionStringLookupTable[value];
      case int():
        return json[key] = _sliderInteractionIntLookupTable[value];
      default:
        return defaultValue;
    }
  }

  @preferInline
  MaterialTapTargetSize? materialTapTargetSize({
    String key = "materialTapTargetSize",
    MaterialTapTargetSize? defaultValue,
  }) {
    final value = json[key];

    if (value is MaterialTapTargetSize) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _materialTapTargetSizeStringLookupTable[value];
      case int():
        return json[key] = _materialTapTargetSizeIntLookupTable[value];
      default:
        return defaultValue;
    }
  }

  @preferInline
  FilterQuality filterQuality({
    String key = "filterQuality",
    FilterQuality defaultValue = FilterQuality.medium,
  }) {
    final value = json[key];

    if (value is FilterQuality) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] =
            _filterQualityStringLookupTable[value] ?? defaultValue;
      case int():
        return json[key] = _filterQualityIntLookupTable[value] ?? defaultValue;
      default:
        return defaultValue;
    }
  }

  @preferInline
  ImageRepeat imageRepeat({
    String key = "repeat",
    ImageRepeat defaultValue = ImageRepeat.noRepeat,
  }) {
    final value = json[key];

    if (value is ImageRepeat) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _imageRepeatStringLookupTable[value] ?? defaultValue;
      case int():
        return json[key] = _imageRepeatIntLookupTable[value] ?? defaultValue;
      default:
        return defaultValue;
    }
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

    if (value == null) {
      return defaultValue ?? Uint8List(0);
    }

    switch (value) {
      case List<int>():
        return json[key] = _uint8ListFromList(value);
      case String():
        return json[key] = _uint8ListFromString(value);
      default:
        return defaultValue ?? Uint8List(0);
    }
  }

  @preferInline
  BoxFit? boxFit({
    String key = "fit",
    BoxFit? defaultValue,
  }) {
    final value = json[key];

    if (value is BoxFit) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _boxFitStringLookupTable[value];
      case int():
        return json[key] = _boxFitIntLookupTable[value];
      default:
        return defaultValue;
    }
  }

  @preferInline
  BlendMode blendMode({
    String key = "blendMode",
    BlendMode defaultValue = BlendMode.srcOver,
  }) {
    final value = json[key];

    if (value is BlendMode) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _blendModeStringLookupTable[value] ?? defaultValue;
      case int():
        return json[key] = _blendModeIntLookupTable[value] ?? defaultValue;
      default:
        return defaultValue;
    }
  }

  TileMode tileMode({
    String key = "tileMode",
    TileMode defaultValue = TileMode.clamp,
  }) {
    final value = json[key];

    if (value is TileMode) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _tileModeStringLookupTable[value] ?? defaultValue;
      case int():
        return json[key] = _tileModeIntLookupTable[value] ?? defaultValue;
      default:
        return defaultValue;
    }
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
          tileMode: json.tileMode(),
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

  //TODO: add test
  @preferInline
  ImageFilter imageFilter({
    String key = "filter",
    ImageFilter? defaultValue,
  }) {
    final value = json[key];

    if (value is ImageFilter) return value;

    if (value == null) {
      return defaultValue ?? ImageFilter.blur();
    }

    switch (value) {
      case Map<String, dynamic>():
        return json[key] = _imageFilterFromMap(value);
      default:
        return defaultValue ?? ImageFilter.blur();
    }
  }

  @preferInline
  VerticalDirection verticalDirection({
    String key = "verticalDirection",
    VerticalDirection defaultValue = VerticalDirection.down,
  }) {
    final value = json[key];

    if (value is VerticalDirection) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] =
            _verticalDirectionStringLookupTable[value] ?? defaultValue;
      case int():
        return json[key] =
            _verticalDirectionIntLookupTable[value] ?? defaultValue;
      default:
        return defaultValue;
    }
  }

  @preferInline
  BoxShape? boxShape({
    String key = "shape",
    BoxShape? defaultValue,
  }) {
    final value = json[key];

    if (value is BoxShape) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _boxShapeStringLookupTable[value] ?? defaultValue;
      case int():
        return json[key] = _boxShapeIntLookupTable[value] ?? defaultValue;
      default:
        return defaultValue;
    }
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

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _borderStyleStringLookupTable[value];
      case int():
        return json[key] = _borderStyleIntLookupTable[value];
      default:
        return defaultValue;
    }
  }

  @preferInline
  BorderSide borderSide({
    String key = "side",
    BorderSide defaultValue = BorderSide.none,
  }) {
    final value = json[key];

    if (value is BorderSide) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case Map<String, dynamic>():
        return json[key] = _borderSideFromMap(value);
      default:
        return defaultValue;
    }
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

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case Map<String, dynamic>():
        return json[key] = _inputBorderFromMap(value);
      default:
        return defaultValue;
    }
  }

  @preferInline
  InputDecoration? inputDecoration({
    String key = "decoration",
    InputDecoration? defaultValue,
  }) {
    final value = json[key];

    if (value is InputDecoration) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case Map<String, dynamic>():
        return json[key] = _inputDecorationFromMap(value);
      default:
        return defaultValue;
    }
  }

  @preferInline
  TextInputType? textInputType({
    String key = "keyboardType",
    TextInputType? defaultValue,
  }) {
    final value = json[key];

    if (value is TextInputType) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _textInputTypeStringLookupTable[value];
      case int():
        return json[key] = _textInputTypeIntLookupTable[value];
      default:
        return defaultValue;
    }
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
    VisualDensity defaultValue = const VisualDensity(),
  }) {
    final value = json[key];

    if (value is VisualDensity) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case Map<String, dynamic>():
        return json[key] = _visualDensityFromMap(value);
      default:
        return defaultValue;
    }
  }

  @preferInline
  ScrollViewKeyboardDismissBehavior keyboardDismissBehavior({
    String key = "keyboardDismissBehavior",
    ScrollViewKeyboardDismissBehavior defaultValue =
        ScrollViewKeyboardDismissBehavior.manual,
  }) {
    final value = json[key];

    if (value is ScrollViewKeyboardDismissBehavior) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] =
            _keyboardDismissBehaviorStringLookupTable[value] ?? defaultValue;
      case int():
        return json[key] =
            _keyboardDismissBehaviorIntLookupTable[value] ?? defaultValue;
      default:
        return defaultValue;
    }
  }

  @preferInline
  ScrollPhysics? scrollPhysics({
    String key = "physics",
    ScrollPhysics? defaultValue,
  }) {
    final value = json[key];

    if (value is ScrollPhysics) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _scrollPhysicsStringLookupTable[value];
      case int():
        return json[key] = _scrollPhysicsIntLookupTable[value];
      default:
        return defaultValue;
    }
  }

  @preferInline
  DragStartBehavior dragStartBehavior({
    String key = "dragStartBehavior",
    DragStartBehavior defaultValue = DragStartBehavior.start,
  }) {
    final value = json[key];

    if (value is DragStartBehavior) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] =
            _dragStartBehaviorStringLookupTable[value] ?? defaultValue;
      case int():
        return json[key] =
            _dragStartBehaviorIntLookupTable[value] ?? defaultValue;
      default:
        return defaultValue;
    }
  }

  @preferInline
  HitTestBehavior hitTestBehavior({
    String key = "hitTestBehavior",
    HitTestBehavior defaultValue = HitTestBehavior.deferToChild,
  }) {
    final value = json[key];

    if (value is HitTestBehavior) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] =
            _hitTestBehaviorStringLookupTable[value] ?? defaultValue;
      case int():
        return json[key] =
            _hitTestBehaviorIntLookupTable[value] ?? defaultValue;
      default:
        return defaultValue;
    }
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

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case Map<String, dynamic>():
        return json[key] = _shapeBorderFromMap(value);
      default:
        return defaultValue;
    }
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

    switch (value) {
      case Map<String, dynamic>():
        return json[key] = _borderFromMap(value);
      default:
        return defaultValue;
    }
  }

  @preferInline
  BorderRadius borderRadius({
    String key = "borderRadius",
    BorderRadius defaultValue = BorderRadius.zero,
  }) {
    final value = json[key];

    if (value is BorderRadius) return value;

    if (value == null) {
      return defaultValue;
    }

    return BorderRadius.only(
      topLeft: Radius.circular(value['topLeft']?['radius'] ?? 0.0),
      topRight: Radius.circular(value['topRight']?['radius'] ?? 0.0),
      bottomLeft: Radius.circular(value['bottomLeft']?['radius'] ?? 0.0),
      bottomRight: Radius.circular(value['bottomRight']?['radius'] ?? 0.0),
    );
  }

  @preferInline
  FloatingActionButtonLocation? fabLocation({
    String key = "floatingActionButtonLocation",
    FloatingActionButtonLocation? defaultValue,
  }) {
    final value = json[key];

    if (value is FloatingActionButtonLocation) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        return json[key] = _fabLocationStringLookupTable[value];
      case int():
        return json[key] = _fabLocationIntLookupTable[value];
      default:
        return defaultValue;
    }
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
    final data = DuitDataSource(value);
    return ButtonStyle(
      textStyle: data.widgetStateProperty<TextStyle>(key: "textStyle"),
      backgroundColor: data.widgetStateProperty<Color>(key: "backgroundColor"),
      foregroundColor: data.widgetStateProperty<Color>(key: "foregroundColor"),
      overlayColor: data.widgetStateProperty<Color>(key: "overlayColor"),
      shadowColor: data.widgetStateProperty<Color>(key: "shadowColor"),
      surfaceTintColor:
          data.widgetStateProperty<Color>(key: "surfaceTintColor"),
      elevation: data.widgetStateProperty<double>(key: "elevation"),
      padding: data.widgetStateProperty<EdgeInsetsGeometry>(key: "padding"),
      minimumSize: data.widgetStateProperty<Size>(key: "minimumSize"),
      maximumSize: data.widgetStateProperty<Size>(key: "maximumSize"),
      iconColor: data.widgetStateProperty<Color>(key: "iconColor"),
      iconSize: data.widgetStateProperty<double>(key: "iconSize"),
      side: data.widgetStateProperty<BorderSide>(key: "side"),
      shape: data.widgetStateProperty<OutlinedBorder>(key: "shape"),
      visualDensity: data.visualDensity(key: "visualDensity"),
      tapTargetSize: data.materialTapTargetSize(key: "tapTargetSize"),
      animationDuration: data.duration(key: "animationDuration"),
      enableFeedback: data.tryGetBool("enableFeedback"),
      alignment: data.alignment(key: "alignment"),
    );
  }

  @preferInline
  ButtonStyle? buttonStyle({
    String key = "style",
    ButtonStyle? defaultValue,
  }) {
    final value = json[key];

    if (value is ButtonStyle) return value;

    if (value == null) {
      return defaultValue;
    }

    switch (value) {
      case Map<String, dynamic>():
        return json[key] = _buttonStyleFromMap(value);
      default:
        return defaultValue;
    }
  }

  // @preferInline
  // List<Map<String, dynamic>> get childObjects {
  //   final value = json["_childObjects"];
  //   if (value is List<Map<String, dynamic>>) return value;

  //   return const <Map<String, dynamic>>[];
  // }

  // @preferInline
  // set childObjects(List<Map<String, dynamic>> value) {
  //   final List? list = json["_childObjects"];

  //   if (list == null) {
  //     json["_childObjects"] = [...value];
  //   } else {
  //     list.addAll(value);
  //   }
  // }
}
