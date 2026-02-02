import "dart:convert";
import "dart:typed_data";
import "dart:ui";

import "package:duit_kernel/duit_kernel.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";

part "lookup.dart";
part "fields.dart";

/// Shortand for the extension type instance methods
typedef _DispatchFn = dynamic Function(
  DuitDataSource self,
  String key,
  Object? target,
  bool warmUp,
);

/// A wrapper for JSON data that provides type-safe access to Dart/Flutter properties.
///
/// This extension type wraps a [Map<String, dynamic>] and provides methods to safely
/// parse and convert JSON values into Dart/Flutter types. It implements [Map<String, dynamic>]
/// to maintain compatibility with JSON operations.
///
/// The extension type provides methods for:
/// - Parsing basic types (int, double, string, bool)
/// - Converting colors from hex strings or RGB arrays
/// - Parsing Dart/Flutter-specific types (Size, EdgeInsets, Alignment, etc.)
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
extension type DuitDataSource(Map<String, dynamic> _json)
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
    final action = _json[key];

    if (action is ServerAction) return action;

    if (action == null) {
      return null;
    }

    if (action is Map<String, dynamic>) {
      return _json[key] = ServerAction.parse(action);
    }

    return null;
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
    final dependsOn = _json["dependsOn"];

    if (dependsOn is List) {
      return dependsOn
          .map((e) => _actionDependency(Map<String, dynamic>.from(e)));
    } else {
      return const <ActionDependency>[];
    }
  }

  //
  @preferInline
  ActionDependency _actionDependency(Map<String, dynamic> dep) {
    final data = DuitDataSource(dep);
    return ActionDependency(
      target: data.getString(key: "target"),
      id: data.getString(key: "id"),
    );
  }

  @preferInline
  HttpActionMetainfo? get meta {
    final metaData = _json["meta"];

    if (metaData == null) {
      return null;
    }
    return HttpActionMetainfo.fromJson(metaData);
  }

  @preferInline
  int get executionType {
    final executionType = _json["executionType"];
    return executionType is int ? executionType : 0;
  }

  @preferInline
  ScriptDefinition get script {
    final Map<String, dynamic> scriptData = _json["script"];
    final data = DuitDataSource(scriptData);
    return ScriptDefinition(
      sourceCode: data.getString(key: "sourceCode"),
      functionName: data.getString(key: "functionName"),
      meta: data["meta"],
    );
  }

  @preferInline
  String? get parentBuilderId {
    final id = _json["parentBuilderId"];
    return id is String ? id : null;
  }

  @preferInline
  Iterable<String>? get affectedProperties {
    final value = _json["affectedProperties"];
    return value is Iterable ? Set<String>.from(value) : null;
  }

  //Reads a value from the JSON map associated with the given [key].
  //
  // If attribute warm up is enabled, it returns the target value if [warmUp] is true.
  // Otherwise, it returns the value from the JSON map.
  //
  // The value is stored back into the JSON map at the given [key].
  //
  // Returns:
  // - The value from the JSON map if attribute warm up is disabled.
  // - The target value if attribute warm up is enabled and [warmUp] is true.
  // - `null` if the value is not found in the JSON map.
  @preferInline
  dynamic _readProp(String key, Object? target, bool warmUp) {
    if (envAttributeWarmUpEnabled) {
      if (warmUp) {
        return target;
      } else {
        return _json[key];
      }
    }
    return _json[key];
  }

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
      if (color.length == 6 || color.length == 7) buffer.write("ff");
      buffer.write(color.replaceFirst("#", ""));
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
    final colorData = color.map((e) => e as num).toList();
    return switch (colorData.length) {
      4 => Color.fromRGBO(
          colorData[0].toInt(),
          colorData[1].toInt(),
          colorData[2].toInt(),
          colorData[3].toDouble(),
        ),
      3 => Color.fromRGBO(
          colorData[0].toInt(),
          colorData[1].toInt(),
          colorData[2].toInt(),
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
    String key = FlutterPropertyKeys.color,
    Color defaultValue = Colors.transparent,
  }) {
    final value = _json[key];

    if (value is Color) return value;

    if (value == null) return defaultValue;

    return _json[key] = switch (value) {
      String() => _colorFromHexString(value) ?? defaultValue,
      List() => _colorFromList(value) ?? defaultValue,
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
  @preferInline
  Color? tryParseColor({
    String key = FlutterPropertyKeys.color,
    Color? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is Color) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _colorFromHexString(value);
          } else {
            return _json[key] = _colorFromHexString(value);
          }
        } else {
          return _json[key] = _colorFromHexString(value);
        }
      case List():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _colorFromList(value);
          } else {
            return _json[key] = _colorFromList(value);
          }
        } else {
          return _json[key] = _colorFromList(value);
        }
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
    String key = FlutterPropertyKeys.duration,
    Duration? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is Duration) return value;

    if (value == null) {
      return defaultValue ?? Duration.zero;
    }

    switch (value) {
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return Duration(milliseconds: value);
          } else {
            return _json[key] = Duration(milliseconds: value);
          }
        } else {
          return _json[key] = Duration(milliseconds: value);
        }
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
    final value = _json[key];
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
    final value = _json[key];
    if (value is num) {
      return value.toInt();
    }
    return defaultValue;
  }

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
    final value = _json[key];
    if (value is num) {
      return value.toDouble();
    }
    return defaultValue ?? 0.0;
  }

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
    final value = _json[key];
    if (value is num) {
      return value.toDouble();
    }
    return defaultValue;
  }

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
    final value = _json[key];
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
    final value = _json[key];
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
    final value = _json[key];
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
    final value = _json[key];
    if (value is bool) {
      return value;
    }
    return defaultValue;
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
    String key = FlutterPropertyKeys.textAlign,
    TextAlign defaultValue = TextAlign.start,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is TextAlign) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _textAlignStringLookupTable[value];
          } else {
            return _json[key] = _textAlignStringLookupTable[value];
          }
        } else {
          return _json[key] = _textAlignStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _textAlignIntLookupTable[value];
          } else {
            return _json[key] = _textAlignIntLookupTable[value];
          }
        } else {
          return _json[key] = _textAlignIntLookupTable[value];
        }
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
    String key = FlutterPropertyKeys.textDirection,
    TextDirection? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is TextDirection) return value;

    if (value == null && defaultValue != null) {
      return defaultValue;
    }

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _textDirectionStringLookupTable[value];
          } else {
            return _json[key] = _textDirectionStringLookupTable[value];
          }
        } else {
          return _json[key] = _textDirectionStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _textDirectionIntLookupTable[value];
          } else {
            return _json[key] = _textDirectionIntLookupTable[value];
          }
        } else {
          return _json[key] = _textDirectionIntLookupTable[value];
        }
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
    String key = FlutterPropertyKeys.textOverflow,
    TextOverflow defaultValue = TextOverflow.clip,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is TextOverflow) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _textOverflowStringLookupTable[value];
          } else {
            return _json[key] = _textOverflowStringLookupTable[value];
          }
        } else {
          return _json[key] = _textOverflowStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _textOverflowIntLookupTable[value];
          } else {
            return _json[key] = _textOverflowIntLookupTable[value];
          }
        } else {
          return _json[key] = _textOverflowIntLookupTable[value];
        }
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
  Clip? clipBehavior({
    String key = FlutterPropertyKeys.clipBehavior,
    Clip defaultValue = Clip.hardEdge,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is Clip) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _clipStringLookupTable[value];
          } else {
            return _json[key] = _clipStringLookupTable[value];
          }
        } else {
          return _json[key] = _clipStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _clipIntLookupTable[value];
          } else {
            return _json[key] = _clipIntLookupTable[value];
          }
        } else {
          return _json[key] = _clipIntLookupTable[value];
        }
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
  Size _sizeFromMap(Map<String, dynamic> map) {
    switch (map) {
      case {
          "width": num width,
          "height": num height,
        }:
        return Size(
          width.toDouble(),
          height.toDouble(),
        );
      case {
          "value": num value,
          "mainAxis": dynamic _,
        }:
        final axis = DuitDataSource(map).axis(key: "mainAxis");

        if (axis == Axis.horizontal) {
          return Size.fromWidth(value.toDouble());
        } else {
          return Size.fromHeight(value.toDouble());
        }
      default:
        return Size.zero;
    }
  }

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
    final value = _json[key];

    if (value is Size) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case Map<String, dynamic>():
        return _json[key] = _sizeFromMap(value);
      case List<num>():
        return _json[key] = _sizeFromList(value);
      case double():
        return _json[key] = Size.square(value);
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
  EdgeInsets _edgeInsetsFromList(List<num> value) {
    return switch (value.length) {
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

  /// Retrieves an [EdgeInsets] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already an [EdgeInsets],
  /// it is returned as is. The value can be provided in several formats:
  /// - A list of 2 or 4 numbers [vertical, horizontal] or [left, top, right, bottom]
  /// - A single number (creates a square padding)
  /// If the value is `null`, returns [defaultValue].
  @preferInline
  EdgeInsets? edgeInsets({
    String key = FlutterPropertyKeys.padding,
    EdgeInsets? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is EdgeInsets) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case List():
        final lst = List<num>.from(value);
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _edgeInsetsFromList(lst);
          } else {
            return _json[key] = _edgeInsetsFromList(lst);
          }
        } else {
          return _json[key] = _edgeInsetsFromList(lst);
        }
      case num():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return EdgeInsets.all(value.toDouble());
          } else {
            return _json[key] = EdgeInsets.all(value.toDouble());
          }
        } else {
          return _json[key] = EdgeInsets.all(value.toDouble());
        }
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
  ///
  @preferInline
  Curve? curve({
    String key = FlutterPropertyKeys.curve,
    Curve defaultValue = Curves.linear,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is Curve) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _curveStringLookupTable[value];
          } else {
            return _json[key] = _curveStringLookupTable[value];
          }
        } else {
          return _json[key] = _curveStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _curveIntLookupTable[value];
          } else {
            return _json[key] = _curveIntLookupTable[value];
          }
        } else {
          return _json[key] = _curveIntLookupTable[value];
        }
      case Map<String, dynamic>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _customCurveFromMap(value);
          } else {
            return _json[key] = _customCurveFromMap(value);
          }
        } else {
          return _json[key] = _customCurveFromMap(value);
        }
      default:
        return defaultValue;
    }
  }

  @preferInline
  static Curve _customCurveFromMap(Map<String, dynamic> value) {
    final source = DuitDataSource(value);
    final type = source.tryGetString("type");

    if (type != null) {
      final parser = _customCurveStringLookupTable[type];
      if (parser != null) {
        return parser(source);
      } else {
        return Curves.linear;
      }
    } else {
      return Curves.linear;
    }
  }

  /// Retrieves a [TextBaseline] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [TextBaseline],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// If the value is `null`, returns [defaultValue].
  ///
  /// Unlike [textBaseline], this method does not store the parsed or existing [TextBaseline] back into the JSON map.
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'textBaseline'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [TextBaseline] if the value is valid or can be converted.
  /// - [defaultValue] if the value is not a valid [TextBaseline] or cannot be converted.
  /// - `null` if both the value and [defaultValue] are null.
  ///
  /// Example:
  ///   tryTextBaseline(key: 'myBaseline', defaultValue: TextBaseline.alphabetic)

  @preferInline
  TextBaseline? textBaseline({
    String key = FlutterPropertyKeys.textBaseline,
    TextBaseline? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is TextBaseline) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _textBaselineStringLookupTable[value];
          } else {
            return _json[key] = _textBaselineStringLookupTable[value];
          }
        } else {
          return _json[key] = _textBaselineStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _textBaselineIntLookupTable[value];
          } else {
            return _json[key] = _textBaselineIntLookupTable[value];
          }
        } else {
          return _json[key] = _textBaselineIntLookupTable[value];
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [TextWidthBasis] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [TextWidthBasis],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// If the value is `null`, returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'textWidthBasis'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to TextWidthBasis.parent.
  ///
  /// Example:
  ///   textWidthBasis(key: 'myBasis', defaultValue: TextWidthBasis.longestLine)
  @preferInline
  TextWidthBasis? textWidthBasis({
    String key = FlutterPropertyKeys.textWidthBasis,
    TextWidthBasis defaultValue = TextWidthBasis.parent,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is TextWidthBasis) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _textWidthBasisStringLookupTable[value];
          } else {
            return _json[key] = _textWidthBasisStringLookupTable[value];
          }
        } else {
          return _json[key] = _textWidthBasisStringLookupTable[value];
        }

      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _textWidthBasisIntLookupTable[value];
          } else {
            return _json[key] = _textWidthBasisIntLookupTable[value];
          }
        } else {
          return _json[key] = _textWidthBasisIntLookupTable[value];
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [TextStyle] value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already a [TextStyle], it returns that value.
  /// If the value is a [Map<String, dynamic>], it attempts to parse it into a [TextStyle].
  /// Otherwise, it returns [defaultValue].
  ///
  /// The parsed or existing [TextStyle] is also stored back into the JSON map at the given [key].
  ///
  /// Returns:
  /// - A [TextStyle] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [TextStyle] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  TextStyle? textStyle({
    String key = FlutterPropertyKeys.style,
    TextStyle? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is TextStyle) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case Map<String, dynamic>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _textStyleFromMap(value);
          } else {
            return _json[key] = _textStyleFromMap(value);
          }
        } else {
          return _json[key] = _textStyleFromMap(value);
        }
      default:
        return defaultValue;
    }
  }

  /// Parses a [TextStyle] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'color': A color value.
  /// - 'fontFamily': A font family string.
  /// - 'fontWeight': A font weight value.
  /// - 'fontSize': A font size value.
  /// - 'fontStyle': A font style value.
  /// - 'overflow': A text overflow value.
  /// - 'textBaseline': A text baseline value.
  /// - 'height': A text height value.
  /// - 'letterSpacing': A letter spacing value.
  /// - 'wordSpacing': A word spacing value.
  /// - 'backgroundColor': A background color value.
  /// - 'decoration': A text decoration value.
  /// - 'decorationColor': A text decoration color value.
  /// - 'decorationStyle': A text decoration style value.
  /// - 'decorationThickness': A text decoration thickness value.
  /// - 'debugLabel': A debug label value.
  /// - 'package': A package value.
  /// - 'leadingDistribution': A leading distribution value.
  @preferInline
  TextStyle _textStyleFromMap(Map<String, dynamic> data) {
    final source = DuitDataSource(data);
    return TextStyle(
      color: source.tryParseColor(key: "color"),
      fontFamily: source.tryGetString("fontFamily"),
      fontWeight: source.fontWeight(),
      fontSize: source.tryGetDouble(key: "fontSize"),
      fontStyle: source.fontStyle(),
      overflow: source.textOverflow(),
      textBaseline: source.textBaseline(),
      height: source.tryGetDouble(key: "height"),
      letterSpacing: source.tryGetDouble(key: "letterSpacing"),
      wordSpacing: source.tryGetDouble(key: "wordSpacing"),
      backgroundColor: source.tryParseColor(key: "backgroundColor"),
      decoration: source.textDecoration(),
      decorationColor: source.tryParseColor(key: "decorationColor"),
      decorationStyle: source.textDecorationStyle(),
      decorationThickness: source.tryGetDouble(key: "decorationThickness"),
      debugLabel: source.tryGetString("debugLabel"),
      package: source.tryGetString("package"),
      leadingDistribution: source.textLeadingDistribution(),
    );
  }

  /// Parses a [Gradient] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'colors': A list of color values.
  /// - 'stops': A list of stop values.
  /// - 'begin': An alignment value.
  /// - 'end': An alignment value.
  @preferInline
  Gradient? _gradientFromMap(Map<String, dynamic>? data) {
    if (data == null) return null;

    final source = DuitDataSource(data);

    final List? colors = source["colors"];
    if (colors == null) return null;

    final dColors = <Color>[];

    for (var color in colors) {
      dColors.add(_parseColor(color) ?? Colors.transparent);
    }

    final angle = source.tryGetDouble(key: "rotationAngle");

    return LinearGradient(
      colors: dColors,
      stops: source["stops"],
      begin:
          source.alignment(key: "begin", defaultValue: Alignment.centerLeft)!,
      end: source.alignment(key: "end", defaultValue: Alignment.centerRight)!,
      transform: angle != null ? GradientRotation(angle) : null,
    );
  }

  /// Parses a [BoxShadow] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'color': A color value.
  /// - 'offset': An offset value.
  /// - 'blurRadius': A blur radius value.
  /// - 'spreadRadius': A spread radius value.
  @preferInline
  BoxShadow _boxShadowFromMap(json) {
    final source = DuitDataSource(json);
    return BoxShadow(
      color: source.parseColor(key: "color"),
      offset: source.offset(defaultValue: Offset.zero)!,
      blurRadius: source.getDouble(key: "blurRadius"),
      spreadRadius: source.getDouble(key: "spreadRadius"),
    );
  }

  /// Parses an [Offset] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'dx': An x-axis offset value.
  /// - 'dy': A y-axis offset value.
  @preferInline
  Offset _offsetFromMap(Map<String, dynamic> map) {
    final source = DuitDataSource(map);
    return Offset(
      source.getDouble(key: "dx"),
      source.getDouble(key: "dy"),
    );
  }

  /// Retrieves an [Offset] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already an [Offset],
  /// it is returned as is. If the value is a [Map<String, dynamic>], it attempts to parse it into an [Offset].
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'offset'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - An [Offset] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [Offset] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  Offset? offset({
    String key = FlutterPropertyKeys.offset,
    Offset? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is Offset) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case Map<String, dynamic>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _offsetFromMap(value);
          } else {
            return _json[key] = _offsetFromMap(value);
          }
        } else {
          return _json[key] = _offsetFromMap(value);
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a list of [BoxShadow] values from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [List<BoxShadow>],
  /// it is returned as is. If the value is a [List], it attempts to parse it into a list of [BoxShadow].
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'boxShadow'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A list of [BoxShadow] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid list of [BoxShadow] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  ///
  @preferInline
  List<BoxShadow>? boxShadow({
    String key = FlutterPropertyKeys.boxShadow,
    List<BoxShadow>? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is List<BoxShadow>) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case List():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return value.map<BoxShadow>(_boxShadowFromMap).toList();
          } else {
            return _json[key] =
                value.map<BoxShadow>(_boxShadowFromMap).toList();
          }
        } else {
          return _json[key] = value.map<BoxShadow>(_boxShadowFromMap).toList();
        }
      default:
        return defaultValue;
    }
  }

  /// Parses a [Decoration] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'color': A color value.
  /// - 'borderRadius': A border radius value.
  /// - 'border': A border value.
  /// - 'gradient': A gradient value.
  /// - 'boxShadow': A list of box shadow values.
  @preferInline
  Decoration _decorationFromMap(Map<String, dynamic> data) {
    final source = DuitDataSource(data);
    return BoxDecoration(
      color: source.tryParseColor(key: "color"),
      borderRadius: source.borderRadius(),
      border: source.border(),
      gradient: _gradientFromMap(source["gradient"]),
      boxShadow: source.boxShadow(),
    );
  }

  /// Retrieves a [Decoration] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [Decoration],
  /// it is returned as is. If the value is a [Map<String, dynamic>], it attempts to parse it into a [Decoration].
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'decoration'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [Decoration] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [Decoration] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  Decoration? decoration({
    String key = FlutterPropertyKeys.decoration,
    Decoration? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is Decoration) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case Map<String, dynamic>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _decorationFromMap(value);
          } else {
            return _json[key] = _decorationFromMap(value);
          }
        } else {
          return _json[key] = _decorationFromMap(value);
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [TextDecoration] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [TextDecoration],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'decoration'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [TextDecoration] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [TextDecoration] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  TextDecoration? textDecoration({
    String key = FlutterPropertyKeys.decoration,
    TextDecoration? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is TextDecoration) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _textDecorationStringLookupTable[value];
          } else {
            return _json[key] = _textDecorationStringLookupTable[value];
          }
        } else {
          return _json[key] = _textDecorationStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _textDecorationIntLookupTable[value];
          } else {
            return _json[key] = _textDecorationIntLookupTable[value];
          }
        } else {
          return _json[key] = _textDecorationIntLookupTable[value];
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [TextDecorationStyle] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [TextDecorationStyle],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'decorationStyle'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [TextDecorationStyle] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [TextDecorationStyle] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  TextDecorationStyle? textDecorationStyle({
    String key = FlutterPropertyKeys.decorationStyle,
    TextDecorationStyle? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is TextDecorationStyle) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _textDecorationStyleIntLookupTable[value];
          } else {
            return _json[key] = _textDecorationStyleIntLookupTable[value];
          }
        } else {
          return _json[key] = _textDecorationStyleIntLookupTable[value];
        }
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _textDecorationStyleStringLookupTable[value];
          } else {
            return _json[key] = _textDecorationStyleStringLookupTable[value];
          }
        } else {
          return _json[key] = _textDecorationStyleStringLookupTable[value];
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [FontWeight] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [FontWeight],
  /// it is returned as is. If the value is an [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'fontWeight'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [FontWeight] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [FontWeight] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  FontWeight? fontWeight({
    String key = FlutterPropertyKeys.fontWeight,
    FontWeight? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is FontWeight) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _fontWeightLookupTable[value];
          } else {
            return _json[key] = _fontWeightLookupTable[value];
          }
        } else {
          return _json[key] = _fontWeightLookupTable[value];
        }
      default:
        return defaultValue;
    }
  }

  @preferInline
  FontStyle? fontStyle({
    String key = FlutterPropertyKeys.fontStyle,
    FontStyle? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    dynamic value;
    if (envAttributeWarmUpEnabled) {
      if (warmUp) {
        value = target;
      } else {
        value = _json[key];
      }
    } else {
      value = _json[key];
    }

    if (value is FontStyle) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _fontStyleStringLookupTable[value];
          } else {
            return _json[key] = _fontStyleStringLookupTable[value];
          }
        } else {
          return _json[key] = _fontStyleStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _fontStyleIntLookupTable[value];
          } else {
            return _json[key] = _fontStyleIntLookupTable[value];
          }
        } else {
          return _json[key] = _fontStyleIntLookupTable[value];
        }
      default:
        return defaultValue;
    }
  }

  /// Parses a [TextSpan] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'text': A text string.
  /// - 'children': A list of text span values.
  /// - 'style': A text style value.
  /// - 'spellOut': A boolean value.
  /// - 'semanticsLabel': A semantics label value.
  @preferInline
  TextSpan _textSpanFromMap(Map<String, dynamic> value) {
    final source = DuitDataSource(value);
    final List? children = value["children"];
    final spanChildren = <InlineSpan>[];

    if (children != null) {
      for (final child in children) {
        spanChildren.add(_textSpanFromMap(child));
      }
    }

    return TextSpan(
      text: source.tryGetString("text"),
      children: spanChildren.isNotEmpty ? spanChildren : null,
      style: source.textStyle(),
      spellOut: source.tryGetBool("spellOut"),
      semanticsLabel: source.tryGetString("semanticsLabel"),
    );
  }

  /// Retrieves a [TextSpan] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [TextSpan],
  /// it is returned as is. If the value is a [Map<String, dynamic>], it attempts to parse it into a [TextSpan].
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'textSpan'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to a default [TextSpan].
  ///
  /// Returns:
  /// - A [TextSpan] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [TextSpan] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  TextSpan textSpan({
    String key = FlutterPropertyKeys.textSpan,
    TextSpan defaultValue = const TextSpan(),
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is TextSpan) {
      return value;
    }

    if (value == null) return defaultValue;

    switch (value) {
      case Map<String, dynamic>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _textSpanFromMap(value);
          } else {
            return _json[key] = _textSpanFromMap(value);
          }
        } else {
          return _json[key] = _textSpanFromMap(value);
        }
      default:
        return defaultValue;
    }
  }

  /// Parses a [TextHeightBehavior] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'applyHeightToFirstAscent': A boolean value.
  /// - 'applyHeightToLastDescent': A boolean value.
  /// - 'leadingDistribution': A leading distribution value.
  @preferInline
  TextHeightBehavior? _textHeightBehaviorFromMap(Map<String, dynamic> data) {
    final source = DuitDataSource(data);
    return TextHeightBehavior(
      applyHeightToFirstAscent: source.getBool(
        "applyHeightToFirstAscent",
        defaultValue: true,
      ),
      applyHeightToLastDescent: source.getBool(
        "applyHeightToLastDescent",
        defaultValue: true,
      ),
      leadingDistribution: source.textLeadingDistribution(
        defaultValue: TextLeadingDistribution.proportional,
      )!,
    );
  }

  /// Retrieves a [TextHeightBehavior] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [TextHeightBehavior],
  /// it is returned as is. If the value is a [Map<String, dynamic>], it attempts to parse it into a [TextHeightBehavior].
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'textHeightBehavior'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [TextHeightBehavior] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [TextHeightBehavior] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  TextHeightBehavior? textHeightBehavior({
    String key = "textHeightBehavior",
    TextHeightBehavior? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is TextHeightBehavior) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case Map<String, dynamic>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _textHeightBehaviorFromMap(value);
          } else {
            return _json[key] = _textHeightBehaviorFromMap(value);
          }
        } else {
          return _json[key] = _textHeightBehaviorFromMap(value);
        }
      default:
        return defaultValue;
    }
  }

  /// Parses a [TextScaler] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'textScaleFactor': A double value.
  @preferInline
  TextScaler _textScalerFromMap(Map<String, dynamic> data) {
    final source = DuitDataSource(data);
    return TextScaler.linear(
      source.getDouble(
        key: "textScaleFactor",
        defaultValue: 1.0,
      ),
    );
  }

  /// Retrieves a [TextScaler] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [TextScaler],
  /// it is returned as is. If the value is a [Map<String, dynamic>], it attempts to parse it into a [TextScaler].
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'textScaler'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to TextScaler.noScaling.
  ///
  /// Returns:
  /// - A [TextScaler] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [TextScaler] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  TextScaler textScaler({
    String key = FlutterPropertyKeys.textScaler,
    TextScaler defaultValue = TextScaler.noScaling,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is TextScaler) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case Map<String, dynamic>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _textScalerFromMap(value);
          } else {
            return _json[key] = _textScalerFromMap(value);
          }
        } else {
          return _json[key] = _textScalerFromMap(value);
        }
      case double():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return TextScaler.linear(value);
          } else {
            return _json[key] = TextScaler.linear(value);
          }
        } else {
          return _json[key] = TextScaler.linear(value);
        }
      default:
        return defaultValue;
    }
  }

  /// Parses a [StrutStyle] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'fontSize': A double value.
  /// - 'height': A double value.
  /// - 'leading': A double value.
  /// - 'fontWeight': A font weight value.
  /// - 'fontFamily': A font family string.
  /// - 'fontStyle': A font style value.
  /// - 'forceStrutHeight': A boolean value.
  /// - 'debugLabel': A debug label value.
  /// - 'leadingDistribution': A leading distribution value.
  @preferInline
  StrutStyle _strutStyleFromMap(Map<String, dynamic> data) {
    final jsosource = DuitDataSource(data);
    return StrutStyle(
      fontSize: jsosource.tryGetDouble(key: "fontSize"),
      height: jsosource.tryGetDouble(key: "height"),
      leading: jsosource.tryGetDouble(key: "leading"),
      fontWeight: jsosource.fontWeight(),
      fontFamily: jsosource.tryGetString("fontFamily"),
      fontStyle: jsosource.fontStyle(),
      forceStrutHeight: jsosource.tryGetBool("forceStrutHeight"),
      debugLabel: jsosource.tryGetString("debugLabel"),
      leadingDistribution: jsosource.textLeadingDistribution(),
    );
  }

  /// Retrieves a [StrutStyle] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [StrutStyle],
  /// it is returned as is. If the value is a [Map<String, dynamic>], it attempts to parse it into a [StrutStyle].
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'strutStyle'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [StrutStyle] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [StrutStyle] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  StrutStyle? strutStyle({
    String key = FlutterPropertyKeys.strutStyle,
    StrutStyle? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is StrutStyle) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case Map<String, dynamic>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _strutStyleFromMap(value);
          } else {
            return _json[key] = _strutStyleFromMap(value);
          }
        } else {
          return _json[key] = _strutStyleFromMap(value);
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [TextLeadingDistribution] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [TextLeadingDistribution],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'leadingDistribution'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [TextLeadingDistribution] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [TextLeadingDistribution] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  TextLeadingDistribution? textLeadingDistribution({
    String key = FlutterPropertyKeys.leadingDistribution,
    TextLeadingDistribution? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is TextLeadingDistribution) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _leadingDistributionStringLookupTable[value];
          } else {
            return _json[key] = _leadingDistributionStringLookupTable[value];
          }
        } else {
          return _json[key] = _leadingDistributionStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _leadingDistributionIntLookupTable[value];
          } else {
            return _json[key] = _leadingDistributionIntLookupTable[value];
          }
        } else {
          return _json[key] = _leadingDistributionIntLookupTable[value];
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves an [Axis] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already an [Axis],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'scrollDirection'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to Axis.vertical.
  ///
  /// Returns:
  /// - An [Axis] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [Axis] or cannot be parsed.
  @preferInline
  Axis axis({
    String key = FlutterPropertyKeys.scrollDirection,
    Axis defaultValue = Axis.vertical,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is Axis) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _axisStringLookupTable[value]!;
          } else {
            return _json[key] = _axisStringLookupTable[value]!;
          }
        } else {
          return _json[key] = _axisStringLookupTable[value]!;
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _axisIntLookupTable[value]!;
          } else {
            return _json[key] = _axisIntLookupTable[value]!;
          }
        } else {
          return _json[key] = _axisIntLookupTable[value]!;
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [WrapCrossAlignment] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [WrapCrossAlignment],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'crossAxisAlignment'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [WrapCrossAlignment] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [WrapCrossAlignment] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  WrapCrossAlignment? wrapCrossAlignment({
    String key = FlutterPropertyKeys.wrapCrossAlignment,
    WrapCrossAlignment? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is WrapCrossAlignment) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _wrapCrossAlignmentStringLookupTable[value];
          } else {
            return _json[key] = _wrapCrossAlignmentStringLookupTable[value];
          }
        } else {
          return _json[key] = _wrapCrossAlignmentStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _wrapCrossAlignmentIntLookupTable[value];
          } else {
            return _json[key] = _wrapCrossAlignmentIntLookupTable[value];
          }
        } else {
          return _json[key] = _wrapCrossAlignmentIntLookupTable[value];
        }
      default:
        return defaultValue;
    }
  }

  @preferInline
  WrapAlignment? wrapAlignment({
    String key = FlutterPropertyKeys.wrapAlignment,
    WrapAlignment? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is WrapAlignment) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _wrapAlignmentStringLookupTable[value];
          } else {
            return _json[key] = _wrapAlignmentStringLookupTable[value];
          }
        } else {
          return _json[key] = _wrapAlignmentStringLookupTable[value];
        }
      case int():
        return _json[key] = _wrapAlignmentIntLookupTable[value];
      default:
        return defaultValue;
    }
  }

  /// Parses a [BoxConstraints] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'minWidth': A double value.
  /// - 'maxWidth': A double value.
  /// - 'minHeight': A double value.
  /// - 'maxHeight': A double value.
  @preferInline
  BoxConstraints _boxConstraintsFromMap(Map<String, dynamic> data) {
    final source = DuitDataSource(data);
    return BoxConstraints(
      minWidth: source.getDouble(
        key: "minWidth",
        defaultValue: 0.0,
      ),
      maxWidth: source.getDouble(
        key: "maxWidth",
        defaultValue: double.infinity,
      ),
      minHeight: source.getDouble(
        key: "minHeight",
        defaultValue: 0.0,
      ),
      maxHeight: source.getDouble(
        key: "maxHeight",
        defaultValue: double.infinity,
      ),
    );
  }

  /// Retrieves a [BoxConstraints] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [BoxConstraints],
  /// it is returned as is. If the value is a [Map<String, dynamic>], it attempts to parse it into a [BoxConstraints].
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'constraints'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [BoxConstraints] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [BoxConstraints] or cannot be parsed.
  @preferInline
  BoxConstraints? boxConstraints({
    String key = FlutterPropertyKeys.constraints,
    BoxConstraints? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is BoxConstraints) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case Map<String, dynamic>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _boxConstraintsFromMap(value);
          } else {
            return _json[key] = _boxConstraintsFromMap(value);
          }
        } else {
          return _json[key] = _boxConstraintsFromMap(value);
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [StackFit] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [StackFit],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'fit'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to StackFit.loose.
  ///
  /// Returns:
  /// - A [StackFit] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [StackFit] or cannot be parsed.
  @preferInline
  StackFit? stackFit({
    String key = FlutterPropertyKeys.stackFit,
    StackFit? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is StackFit) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _stackFitStringLookupTable[value];
          } else {
            return _json[key] = _stackFitStringLookupTable[value];
          }
        } else {
          return _json[key] = _stackFitStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _stackFitIntLookupTable[value];
          } else {
            return _json[key] = _stackFitIntLookupTable[value];
          }
        } else {
          return _json[key] = _stackFitIntLookupTable[value];
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves an [OverflowBoxFit] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already an [OverflowBoxFit],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'fit'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to OverflowBoxFit.max.
  ///
  /// Returns:
  /// - An [OverflowBoxFit] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [OverflowBoxFit] or cannot be parsed.
  @preferInline
  OverflowBoxFit? overflowBoxFit({
    String key = FlutterPropertyKeys.overflowBoxFit,
    OverflowBoxFit defaultValue = OverflowBoxFit.max,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is OverflowBoxFit) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _overflowBoxFitStringLookupTable[value];
          } else {
            return _json[key] = _overflowBoxFitStringLookupTable[value];
          }
        } else {
          return _json[key] = _overflowBoxFitStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _overflowBoxFitIntLookupTable[value];
          } else {
            return _json[key] = _overflowBoxFitIntLookupTable[value];
          }
        } else {
          return _json[key] = _overflowBoxFitIntLookupTable[value];
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves an [Alignment] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already an [Alignment],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'alignment'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - An [Alignment] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [Alignment] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  Alignment? alignment({
    String key = FlutterPropertyKeys.alignment,
    Alignment? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is Alignment) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _alignmentStringLookupTable[value];
          } else {
            return _json[key] = _alignmentStringLookupTable[value];
          }
        } else {
          return _json[key] = _alignmentStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _alignmentIntLookupTable[value];
          } else {
            return _json[key] = _alignmentIntLookupTable[value];
          }
        } else {
          return _json[key] = _alignmentIntLookupTable[value];
        }
      case List<num>() when value.length == 2:
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return Alignment(
              value[0].toDouble(),
              value[1].toDouble(),
            );
          } else {
            return _json[key] = Alignment(
              value[0].toDouble(),
              value[1].toDouble(),
            );
          }
        } else {
          return _json[key] = Alignment(
            value[0].toDouble(),
            value[1].toDouble(),
          );
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves an [AlignmentDirectional] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already an [AlignmentDirectional],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'alignment'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - An [AlignmentDirectional] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [AlignmentDirectional] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  AlignmentDirectional? alignmentDirectional({
    String key = FlutterPropertyKeys.alignmentDirectional,
    AlignmentDirectional? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is AlignmentDirectional) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _alignmentDirectionalStringLookupTable[value];
          } else {
            return _json[key] = _alignmentDirectionalStringLookupTable[value];
          }
        } else {
          return _json[key] = _alignmentDirectionalStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _alignmentDirectionalIntLookupTable[value];
          } else {
            return _json[key] = _alignmentDirectionalIntLookupTable[value];
          }
        } else {
          return _json[key] = _alignmentDirectionalIntLookupTable[value];
        }
      case List<num>() when value.length == 2:
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return AlignmentDirectional(
              value[0].toDouble(),
              value[1].toDouble(),
            );
          } else {
            return _json[key] = AlignmentDirectional(
              value[0].toDouble(),
              value[1].toDouble(),
            );
          }
        } else {
          return _json[key] = AlignmentDirectional(
            value[0].toDouble(),
            value[1].toDouble(),
          );
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [MainAxisAlignment] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [MainAxisAlignment],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'mainAxisAlignment'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [MainAxisAlignment] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [MainAxisAlignment] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  MainAxisAlignment? mainAxisAlignment({
    String key = FlutterPropertyKeys.mainAxisAlignment,
    MainAxisAlignment? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is MainAxisAlignment) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _mainAxisAlignmentStringLookupTable[value];
          } else {
            return _json[key] = _mainAxisAlignmentStringLookupTable[value];
          }
        } else {
          return _json[key] = _mainAxisAlignmentStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _mainAxisAlignmentIntLookupTable[value];
          } else {
            return _json[key] = _mainAxisAlignmentIntLookupTable[value];
          }
        } else {
          return _json[key] = _mainAxisAlignmentIntLookupTable[value];
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [CrossAxisAlignment] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [CrossAxisAlignment],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'crossAxisAlignment'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [CrossAxisAlignment] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [CrossAxisAlignment] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  CrossAxisAlignment? crossAxisAlignment({
    String key = FlutterPropertyKeys.crossAxisAlignment,
    CrossAxisAlignment? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is CrossAxisAlignment) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _crossAxisAlignmentStringLookupTable[value];
          } else {
            return _json[key] = _crossAxisAlignmentStringLookupTable[value];
          }
        } else {
          return _json[key] = _crossAxisAlignmentStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _crossAxisAlignmentIntLookupTable[value];
          } else {
            return _json[key] = _crossAxisAlignmentIntLookupTable[value];
          }
        } else {
          return _json[key] = _crossAxisAlignmentIntLookupTable[value];
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [MainAxisSize] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [MainAxisSize],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'mainAxisSize'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [MainAxisSize] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [MainAxisSize] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  MainAxisSize? mainAxisSize({
    String key = FlutterPropertyKeys.mainAxisSize,
    MainAxisSize? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is MainAxisSize) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _mainAxisSizeStringLookupTable[value];
          } else {
            return _json[key] = _mainAxisSizeStringLookupTable[value];
          }
        } else {
          return _json[key] = _mainAxisSizeStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _mainAxisSizeIntLookupTable[value];
          } else {
            return _json[key] = _mainAxisSizeIntLookupTable[value];
          }
        } else {
          return _json[key] = _mainAxisSizeIntLookupTable[value];
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [SliderInteraction] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [SliderInteraction],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'interaction'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [SliderInteraction] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [SliderInteraction] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  SliderInteraction? sliderInteraction({
    String key = FlutterPropertyKeys.allowedInteraction,
    SliderInteraction? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is SliderInteraction) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _sliderInteractionStringLookupTable[value];
          } else {
            return _json[key] = _sliderInteractionStringLookupTable[value];
          }
        } else {
          return _json[key] = _sliderInteractionStringLookupTable[value];
        }
      case int():
        return _json[key] = _sliderInteractionIntLookupTable[value];
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [MaterialTapTargetSize] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [MaterialTapTargetSize],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'materialTapTargetSize'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [MaterialTapTargetSize] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [MaterialTapTargetSize] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  MaterialTapTargetSize? materialTapTargetSize({
    String key = FlutterPropertyKeys.materialTapTargetSize,
    MaterialTapTargetSize? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is MaterialTapTargetSize) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _materialTapTargetSizeStringLookupTable[value];
          } else {
            return _json[key] = _materialTapTargetSizeStringLookupTable[value];
          }
        } else {
          return _json[key] = _materialTapTargetSizeStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _materialTapTargetSizeIntLookupTable[value];
          } else {
            return _json[key] = _materialTapTargetSizeIntLookupTable[value];
          }
        } else {
          return _json[key] = _materialTapTargetSizeIntLookupTable[value];
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [FilterQuality] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [FilterQuality],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'filterQuality'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to FilterQuality.medium.
  ///
  /// Returns:
  /// - A [FilterQuality] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [FilterQuality] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  FilterQuality filterQuality({
    String key = FlutterPropertyKeys.filterQuality,
    FilterQuality defaultValue = FilterQuality.medium,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is FilterQuality) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _filterQualityStringLookupTable[value]!;
          } else {
            return _json[key] = _filterQualityStringLookupTable[value]!;
          }
        } else {
          return _json[key] = _filterQualityStringLookupTable[value]!;
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _filterQualityIntLookupTable[value]!;
          } else {
            return _json[key] = _filterQualityIntLookupTable[value]!;
          }
        } else {
          return _json[key] = _filterQualityIntLookupTable[value]!;
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves an [ImageRepeat] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already an [ImageRepeat],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'repeat'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to ImageRepeat.noRepeat.
  ///
  /// Returns:
  /// - An [ImageRepeat] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [ImageRepeat] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  ImageRepeat imageRepeat({
    String key = FlutterPropertyKeys.repeat,
    ImageRepeat defaultValue = ImageRepeat.noRepeat,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is ImageRepeat) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _imageRepeatStringLookupTable[value]!;
          } else {
            return _json[key] = _imageRepeatStringLookupTable[value]!;
          }
        } else {
          return _json[key] = _imageRepeatStringLookupTable[value]!;
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _imageRepeatIntLookupTable[value]!;
          } else {
            return _json[key] = _imageRepeatIntLookupTable[value]!;
          }
        } else {
          return _json[key] = _imageRepeatIntLookupTable[value]!;
        }
      default:
        return defaultValue;
    }
  }

  /// Parses a [Uint8List] from a base64 encoded string.
  ///
  /// - [value]: The base64 encoded string.
  /// Returns a [Uint8List] decoded from the string.
  @preferInline
  Uint8List _uint8ListFromString(String value) => base64Decode(value);

  /// Parses a [Uint8List] from a list of integers.
  ///
  /// - [value]: The list of integers.
  /// Returns a [Uint8List] created from the list.
  @preferInline
  Uint8List _uint8ListFromList(List<int> value) => Uint8List.fromList(value);

  /// Retrieves a [Uint8List] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [Uint8List],
  /// it is returned as is. If the value is a [String] or [List<int>], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'byteData'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [Uint8List] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [Uint8List] or cannot be parsed.
  @preferInline
  Uint8List uint8List({
    String key = FlutterPropertyKeys.byteData,
    Uint8List? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is Uint8List) return value;

    if (value == null) {
      return defaultValue ?? Uint8List(0);
    }

    switch (value) {
      case List<int>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _uint8ListFromList(value);
          } else {
            return _json[key] = _uint8ListFromList(value);
          }
        } else {
          return _json[key] = _uint8ListFromList(value);
        }
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _uint8ListFromString(value);
          } else {
            return _json[key] = _uint8ListFromString(value);
          }
        } else {
          return _json[key] = _uint8ListFromString(value);
        }
      default:
        return defaultValue ?? Uint8List(0);
    }
  }

  /// Retrieves a [BoxFit] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [BoxFit],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'fit'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [BoxFit] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [BoxFit] or cannot be parsed.
  @preferInline
  BoxFit? boxFit({
    String key = FlutterPropertyKeys.fit,
    BoxFit? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is BoxFit) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _boxFitStringLookupTable[value];
          } else {
            return _json[key] = _boxFitStringLookupTable[value];
          }
        } else {
          return _json[key] = _boxFitStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _boxFitIntLookupTable[value];
          } else {
            return _json[key] = _boxFitIntLookupTable[value];
          }
        } else {
          return _json[key] = _boxFitIntLookupTable[value];
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [BlendMode] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [BlendMode],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'blendMode'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to BlendMode.srcOver.
  ///
  /// Returns:
  /// - A [BlendMode] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [BlendMode] or cannot be parsed.
  @preferInline
  BlendMode blendMode({
    String key = FlutterPropertyKeys.blendMode,
    BlendMode defaultValue = BlendMode.srcOver,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is BlendMode) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _blendModeStringLookupTable[value]!;
          } else {
            return _json[key] = _blendModeStringLookupTable[value]!;
          }
        } else {
          return _json[key] = _blendModeStringLookupTable[value]!;
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _blendModeIntLookupTable[value]!;
          } else {
            return _json[key] = _blendModeIntLookupTable[value]!;
          }
        } else {
          return _json[key] = _blendModeIntLookupTable[value]!;
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [TileMode] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [TileMode],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'tileMode'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to TileMode.clamp.
  ///
  /// Returns:
  /// - A [TileMode] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [TileMode] or cannot be parsed.
  TileMode tileMode({
    String key = FlutterPropertyKeys.tileMode,
    TileMode defaultValue = TileMode.clamp,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is TileMode) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _tileModeStringLookupTable[value]!;
          } else {
            return _json[key] = _tileModeStringLookupTable[value]!;
          }
        } else {
          return _json[key] = _tileModeStringLookupTable[value]!;
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _tileModeIntLookupTable[value]!;
          } else {
            return _json[key] = _tileModeIntLookupTable[value]!;
          }
        } else {
          return _json[key] = _tileModeIntLookupTable[value]!;
        }
      default:
        return defaultValue;
    }
  }

  /// Creates a blur [ImageFilter] from a map containing blur parameters.
  ///
  /// The map should contain the following keys:
  /// - `sigmaX`: The horizontal blur radius (double)
  /// - `sigmaY`: The vertical blur radius (double)
  /// - `tileMode`: The tile mode for the blur effect (optional)
  ///
  /// - [value]: The map containing blur parameters.
  /// Returns an [ImageFilter] that applies a blur effect.
  @preferInline
  static ImageFilter _blurImageFilterFromMap(Map<String, dynamic> value) {
    final source = DuitDataSource(value);
    return ImageFilter.blur(
      sigmaX: source.getDouble(key: "sigmaX"),
      sigmaY: source.getDouble(key: "sigmaY"),
      tileMode: source.tileMode(),
    );
  }

  /// Creates a dilate [ImageFilter] from a map containing dilate parameters.
  ///
  /// The map should contain the following keys:
  /// - `radiusX`: The horizontal dilation radius (double)
  /// - `radiusY`: The vertical dilation radius (double)
  ///
  /// - [value]: The map containing dilate parameters.
  /// Returns an [ImageFilter] that applies a dilation effect.
  @preferInline
  static ImageFilter _dilateImageFilterFromMap(Map<String, dynamic> value) {
    final source = DuitDataSource(value);
    return ImageFilter.dilate(
      radiusX: source.getDouble(key: "radiusX"),
      radiusY: source.getDouble(key: "radiusY"),
    );
  }

  /// Creates an erode [ImageFilter] from a map containing erode parameters.
  ///
  /// The map should contain the following keys:
  /// - `radiusX`: The horizontal erosion radius (double)
  /// - `radiusY`: The vertical erosion radius (double)
  ///
  /// - [value]: The map containing erode parameters.
  /// Returns an [ImageFilter] that applies an erosion effect.
  @preferInline
  static ImageFilter _erodeImageFilterFromMap(Map<String, dynamic> value) {
    final source = DuitDataSource(value);
    return ImageFilter.erode(
      radiusX: source.getDouble(key: "radiusX"),
      radiusY: source.getDouble(key: "radiusY"),
    );
  }

  /// Creates a matrix [ImageFilter] from a map containing matrix parameters.
  ///
  /// The map should contain the following keys:
  /// - `matrix4`: A 4x4 transformation matrix as a list of 16 doubles
  /// - `filterQuality`: The quality of the filter (optional, defaults to medium)
  ///
  /// - [value]: The map containing matrix parameters.
  /// Returns an [ImageFilter] that applies a matrix transformation.
  @preferInline
  static ImageFilter _matrixImageFilterFromMap(Map<String, dynamic> value) {
    final source = DuitDataSource(value);
    return ImageFilter.matrix(
      Float64List.fromList(value["matrix4"] as List<double>),
      filterQuality: source.filterQuality(defaultValue: FilterQuality.medium),
    );
  }

  /// Creates a compose [ImageFilter] from a map containing compose parameters.
  ///
  /// The map should contain the following keys:
  /// - `outer`: The outer filter to apply
  /// - `inner`: The inner filter to apply
  ///
  /// Both outer and inner filters are parsed using the [imageFilter] method.
  /// If either filter is not provided, a default blur filter is used.
  ///
  /// - [value]: The map containing compose parameters.
  /// Returns an [ImageFilter] that combines two filters.
  @preferInline
  static ImageFilter _composeImageFilterFromMap(Map<String, dynamic> value) {
    final source = DuitDataSource(value);
    return ImageFilter.compose(
      outer: source.imageFilter(defaultValue: ImageFilter.blur())!,
      inner: source.imageFilter(defaultValue: ImageFilter.blur())!,
    );
  }

  /// Creates an [ImageFilter] from a map based on the filter type.
  ///
  /// The map should contain a `type` key that specifies the filter type.
  /// The type can be either a string or integer identifier.
  /// Based on the type, the appropriate filter creation function is called
  /// with the provided map as parameters.
  ///
  /// - [value]: The map containing filter type and parameters.
  /// Returns an [ImageFilter] if the type is valid, otherwise `null`.
  @preferInline
  ImageFilter? _imageFilterFromMap(Map<String, dynamic> value) {
    final fType = value["type"];

    switch (fType) {
      case String():
        return _imageFilterTypeStringLookupTable[fType]?.call(value);
      case int():
        return _imageFilterTypeIntLookupTable[fType]?.call(value);
      default:
        return null;
    }
  }

  /// Retrieves an [ImageFilter] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already an [ImageFilter],
  /// it is returned as is. If the value is a [Map<String, dynamic>], it is parsed using [_imageFilterFromMap].
  /// If the value is `null`, returns [defaultValue].
  ///
  /// The parsed or existing [ImageFilter] is also stored back into the JSON map at the given [key].
  ///
  /// Supported filter types:
  /// - `blur`: Applies a blur effect with sigmaX and sigmaY parameters
  /// - `dilate`: Applies a dilation effect with radiusX and radiusY parameters
  /// - `erode`: Applies an erosion effect with radiusX and radiusY parameters
  /// - `matrix`: Applies a matrix transformation with a 4x4 matrix
  /// - `compose`: Combines two filters (outer and inner)
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'filter'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved.
  ///
  /// Example:
  /// ```dart
  /// // Blur filter
  /// final blurFilter = data.imageFilter(key: 'blurFilter');
  /// // JSON: {"type": "blur", "sigmaX": 5.0, "sigmaY": 5.0}
  ///
  /// // Matrix filter
  /// final matrixFilter = data.imageFilter(key: 'matrixFilter');
  /// // JSON: {"type": "matrix", "matrix4": [1.0, 0.0, 0.0, 0.0, ...]}
  /// ```
  @preferInline
  ImageFilter? imageFilter({
    String key = FlutterPropertyKeys.filter,
    ImageFilter? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is ImageFilter) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case Map<String, dynamic>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _imageFilterFromMap(value);
          } else {
            return _json[key] = _imageFilterFromMap(value);
          }
        } else {
          return _json[key] = _imageFilterFromMap(value);
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [VerticalDirection] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [VerticalDirection],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'verticalDirection'.
  @preferInline
  VerticalDirection verticalDirection({
    String key = FlutterPropertyKeys.verticalDirection,
    Object? target,
    bool warmUp = false,
    VerticalDirection defaultValue = VerticalDirection.down,
  }) {
    final value = _json[key];

    if (value is VerticalDirection) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _verticalDirectionStringLookupTable[value]!;
          } else {
            return _json[key] = _verticalDirectionStringLookupTable[value]!;
          }
        } else {
          return _json[key] = _verticalDirectionStringLookupTable[value]!;
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _verticalDirectionIntLookupTable[value]!;
          } else {
            return _json[key] = _verticalDirectionIntLookupTable[value]!;
          }
        } else {
          return _json[key] = _verticalDirectionIntLookupTable[value]!;
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [BoxShape] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [BoxShape],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'shape'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [BoxShape] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [BoxShape] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  BoxShape? boxShape({
    String key = FlutterPropertyKeys.boxShape,
    BoxShape? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is BoxShape) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _boxShapeStringLookupTable[value]!;
          } else {
            return _json[key] = _boxShapeStringLookupTable[value]!;
          }
        } else {
          return _json[key] = _boxShapeStringLookupTable[value]!;
        }
      case int():
        return _json[key] = _boxShapeIntLookupTable[value]!;
      default:
        return defaultValue;
    }
  }

  /// Parses an [InputDecoration] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'labelText': A string value.
  /// - 'labelStyle': A [TextStyle] value.
  /// - 'floatingLabelStyle': A [TextStyle] value.
  /// - 'helperText': A string value.
  /// - 'helperMaxLines': An integer value.
  /// - 'helperStyle': A [TextStyle] value.
  /// - 'hintText': A string value.
  /// - 'hintStyle': A [TextStyle] value.
  /// - 'hintMaxLines': An integer value.
  /// - 'errorText': A string value.
  /// - 'errorMaxLines': An integer value.
  /// - 'errorStyle': A [TextStyle] value.
  /// - 'enabledBorder': An [InputBorder] value.
  /// - 'border': An [InputBorder] value.
  /// - 'errorBorder': An [InputBorder] value.
  /// - 'focusedBorder': An [InputBorder] value.
  /// - 'focusedErrorBorder': An [InputBorder] value.
  /// - 'enabled': A boolean value.
  /// - 'isCollapsed': A boolean value.
  /// - 'isDense': A boolean value.
  /// - 'suffixText': A string value.
  /// - 'suffixStyle': A [TextStyle] value.
  /// - 'prefixText': A string value.
  /// - 'prefixStyle': A [TextStyle] value.
  /// - 'counterText': A string value.
  /// - 'counterStyle': A [TextStyle] value.
  /// - 'alignLabelWithHint': A boolean value.
  /// - 'filled': A boolean value.
  /// - 'fillColor': A color value.
  /// - 'focusColor': A color value.
  /// - 'hoverColor': A color value.
  /// - 'contentPadding': An [EdgeInsets] value.
  /// - 'prefixIconColor': A color value.
  /// - 'suffixIconColor': A color value.
  ///
  /// - [value]: The JSON map to parse.
  /// Returns an [InputDecoration] created from the map.
  @preferInline
  InputDecoration _inputDecorationFromMap(Map<String, dynamic> value) {
    final source = DuitDataSource(value);
    return InputDecoration(
      labelText: source.tryGetString("labelText"),
      labelStyle: source.textStyle(key: "labelStyle"),
      floatingLabelStyle: source.textStyle(key: "floatingLabelStyle"),
      helperText: source.tryGetString("helperText"),
      helperMaxLines: source.tryGetInt(key: "helperMaxLines"),
      helperStyle: source.textStyle(key: "helperStyle"),
      hintText: source.tryGetString("hintText"),
      hintStyle: source.textStyle(key: "hintStyle"),
      hintMaxLines: source.tryGetInt(key: "hintMaxLines"),
      errorText: source.tryGetString("errorText"),
      errorMaxLines: source.tryGetInt(key: "errorMaxLines"),
      errorStyle: source.textStyle(key: "errorStyle"),
      enabledBorder: source.inputBorder(key: "enabledBorder"),
      border: source.inputBorder(key: "inputBorder"),
      errorBorder: source.inputBorder(key: "errorBorder"),
      focusedBorder: source.inputBorder(key: "focusedBorder"),
      focusedErrorBorder: source.inputBorder(key: "focusedErrorBorder"),
      enabled: source.getBool("enabled", defaultValue: true),
      isCollapsed: source.tryGetBool("isCollapsed"),
      isDense: source.tryGetBool("isDense"),
      suffixText: source.tryGetString("suffixText"),
      suffixStyle: source.textStyle(key: "suffixStyle"),
      prefixText: source.tryGetString("prefixText"),
      prefixStyle: source.textStyle(key: "prefixStyle"),
      counterText: source.tryGetString("counterText"),
      counterStyle: source.textStyle(key: "counterStyle"),
      alignLabelWithHint: source.tryGetBool("alignLabelWithHint"),
      filled: source.tryGetBool("filled"),
      fillColor: source.tryParseColor(key: "fillColor"),
      focusColor: source.tryParseColor(key: "focusColor"),
      hoverColor: source.tryParseColor(key: "hoverColor"),
      contentPadding: source.edgeInsets(key: "contentPadding"),
      prefixIconColor: source.tryParseColor(key: "prefixIconColor"),
      suffixIconColor: source.tryParseColor(key: "suffixIconColor"),
    );
  }

  /// Parses a [BorderSide] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'color': A color value.
  /// - 'width': A double value.
  /// - 'style': A [BorderStyle] value.
  ///
  /// - [value]: The JSON map to parse.
  /// Returns a [BorderSide] created from the map.
  @preferInline
  BorderSide _borderSideFromMap(Map<String, dynamic> value) {
    final source = DuitDataSource(value);
    return BorderSide(
      color: source.parseColor(key: "color"),
      width: source.getDouble(
        key: "width",
        defaultValue: 1.0,
      ),
      style: source.borderStyle(
        key: "style",
        defaultValue: BorderStyle.solid,
      )!,
      strokeAlign: source.getDouble(
        key: "strokeAlign",
        defaultValue: BorderSide.strokeAlignOutside,
      ),
    );
  }

  /// Retrieves a [BorderStyle] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [BorderStyle],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'style'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to BorderStyle.solid.
  ///
  /// Returns:
  /// - A [BorderStyle] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [BorderStyle] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  BorderStyle? borderStyle({
    String key = FlutterPropertyKeys.style,
    BorderStyle? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is BorderStyle) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _borderStyleStringLookupTable[value]!;
          } else {
            return _json[key] = _borderStyleStringLookupTable[value]!;
          }
        } else {
          return _json[key] = _borderStyleStringLookupTable[value]!;
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _borderStyleIntLookupTable[value]!;
          } else {
            return _json[key] = _borderStyleIntLookupTable[value]!;
          }
        } else {
          return _json[key] = _borderStyleIntLookupTable[value]!;
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [BorderSide] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [BorderSide],
  /// it is returned as is. If the value is a [Map<String, dynamic>], it attempts to parse it into a [BorderSide].
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'side'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to BorderSide.none.
  ///
  /// Returns:
  /// - A [BorderSide] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [BorderSide] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  BorderSide borderSide({
    String key = FlutterPropertyKeys.side,
    BorderSide defaultValue = BorderSide.none,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is BorderSide) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case Map<String, dynamic>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _borderSideFromMap(value);
          } else {
            return _json[key] = _borderSideFromMap(value);
          }
        } else {
          return _json[key] = _borderSideFromMap(value);
        }
      default:
        return defaultValue;
    }
  }

  /// Parses an [OutlineInputBorder] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'borderSide': A [BorderSide] value.
  /// - 'gapPadding': A double value.
  /// - 'borderRadius': A double value.
  ///
  /// - [value]: The JSON map to parse.
  /// Returns an [OutlineInputBorder] created from the map.
  @preferInline
  static InputBorder _outlineInputBorderFromMap(Map<String, dynamic> value) {
    final source = DuitDataSource(value);
    return OutlineInputBorder(
      borderSide: source.borderSide(key: "borderSide"),
      gapPadding: source.getDouble(key: "gapPadding", defaultValue: 4.0),
      borderRadius: source.borderRadius(),
    );
  }

  /// Parses an [UnderlineInputBorder] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'borderSide': A [BorderSide] value.
  ///
  /// - [value]: The JSON map to parse.
  @preferInline
  static InputBorder _underlineInputBorderFromMap(Map<String, dynamic> value) {
    final source = DuitDataSource(value);
    return UnderlineInputBorder(
      borderSide: source.borderSide(key: "borderSide"),
      borderRadius: source.borderRadius(),
    );
  }

  /// Parses an [InputBorder] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'type': A string value representing the type of input border.
  /// - 'borderSide': A [BorderSide] value.
  /// - 'gapPadding': A double value.
  /// - 'borderRadius': A double value.
  @preferInline
  InputBorder _inputBorderFromMap(Map<String, dynamic> value) {
    final source = DuitDataSource(value);
    final type = source.getString(key: "type");
    return _inputBorderTypeStringLookupTable[type]?.call(value) ??
        const OutlineInputBorder();
  }

  /// Retrieves an [InputBorder] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already an [InputBorder],
  /// it is returned as is. If the value is a [Map<String, dynamic>], it attempts to parse it into an [InputBorder].
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'border'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - An [InputBorder] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [InputBorder] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  InputBorder? inputBorder({
    String key = FlutterPropertyKeys.inputBorder,
    InputBorder? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is InputBorder) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case Map<String, dynamic>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _inputBorderFromMap(value);
          } else {
            return _json[key] = _inputBorderFromMap(value);
          }
        } else {
          return _json[key] = _inputBorderFromMap(value);
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves an [InputDecoration] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already an [InputDecoration],
  /// it is returned as is. If the value is a [Map<String, dynamic>], it attempts to parse it into an [InputDecoration].
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'decoration'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - An [InputDecoration] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [InputDecoration] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  InputDecoration? inputDecoration({
    String key = FlutterPropertyKeys.inputDecoration,
    InputDecoration? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is InputDecoration) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case Map<String, dynamic>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _inputDecorationFromMap(value);
          } else {
            return _json[key] = _inputDecorationFromMap(value);
          }
        } else {
          return _json[key] = _inputDecorationFromMap(value);
        }
      default:
        return defaultValue;
    }
  }

  @preferInline
  TextInputType? textInputType({
    String key = FlutterPropertyKeys.keyboardType,
    TextInputType? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is TextInputType) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _textInputTypeStringLookupTable[value];
          } else {
            return _json[key] = _textInputTypeStringLookupTable[value];
          }
        } else {
          return _json[key] = _textInputTypeStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _textInputTypeIntLookupTable[value];
          } else {
            return _json[key] = _textInputTypeIntLookupTable[value];
          }
        } else {
          return _json[key] = _textInputTypeIntLookupTable[value];
        }
      default:
        return defaultValue;
    }
  }

  /// Parses a [VisualDensity] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'horizontal': A double value.
  /// - 'vertical': A double value.
  ///
  /// - [value]: The JSON map to parse.
  /// Returns a [VisualDensity] created from the map.
  VisualDensity _visualDensityFromMap(Map<String, dynamic> value) {
    final source = DuitDataSource(value);
    return VisualDensity(
      horizontal: source.getDouble(
        key: "horizontal",
        defaultValue: 0.0,
      ),
      vertical: source.getDouble(
        key: "vertical",
        defaultValue: 0.0,
      ),
    );
  }

  /// Retrieves a [VisualDensity] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [VisualDensity],
  /// it is returned as is. If the value is a [Map<String, dynamic>], it attempts to parse it into a [VisualDensity].
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'visualDensity'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to VisualDensity.normal.
  ///
  /// Returns:
  /// - A [VisualDensity] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [VisualDensity] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  VisualDensity visualDensity({
    String key = FlutterPropertyKeys.visualDensity,
    VisualDensity defaultValue = const VisualDensity(),
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is VisualDensity) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case Map<String, dynamic>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _visualDensityFromMap(value);
          } else {
            return _json[key] = _visualDensityFromMap(value);
          }
        } else {
          return _json[key] = _visualDensityFromMap(value);
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [ScrollViewKeyboardDismissBehavior] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [ScrollViewKeyboardDismissBehavior],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'keyboardDismissBehavior'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to ScrollViewKeyboardDismissBehavior.manual.
  ///
  /// Returns:
  /// - A [ScrollViewKeyboardDismissBehavior] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [ScrollViewKeyboardDismissBehavior] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  ScrollViewKeyboardDismissBehavior keyboardDismissBehavior({
    String key = FlutterPropertyKeys.keyboardDismissBehavior,
    ScrollViewKeyboardDismissBehavior defaultValue =
        ScrollViewKeyboardDismissBehavior.manual,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is ScrollViewKeyboardDismissBehavior) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _keyboardDismissBehaviorStringLookupTable[value]!;
          } else {
            return _json[key] =
                _keyboardDismissBehaviorStringLookupTable[value]!;
          }
        } else {
          return _json[key] = _keyboardDismissBehaviorStringLookupTable[value]!;
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _keyboardDismissBehaviorIntLookupTable[value]!;
          } else {
            return _json[key] = _keyboardDismissBehaviorIntLookupTable[value]!;
          }
        } else {
          return _json[key] = _keyboardDismissBehaviorIntLookupTable[value]!;
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [ScrollPhysics] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [ScrollPhysics],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'physics'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [ScrollPhysics] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [ScrollPhysics] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  ScrollPhysics? scrollPhysics({
    String key = FlutterPropertyKeys.physics,
    ScrollPhysics? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is ScrollPhysics) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _scrollPhysicsStringLookupTable[value];
          } else {
            return _json[key] = _scrollPhysicsStringLookupTable[value];
          }
        } else {
          return _json[key] = _scrollPhysicsStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _scrollPhysicsIntLookupTable[value];
          } else {
            return _json[key] = _scrollPhysicsIntLookupTable[value];
          }
        } else {
          return _json[key] = _scrollPhysicsIntLookupTable[value];
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [DragStartBehavior] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [DragStartBehavior],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'dragStartBehavior'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to DragStartBehavior.start.
  ///
  /// Returns:
  /// - A [DragStartBehavior] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [DragStartBehavior] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  DragStartBehavior dragStartBehavior({
    String key = FlutterPropertyKeys.dragStartBehavior,
    DragStartBehavior defaultValue = DragStartBehavior.start,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is DragStartBehavior) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _dragStartBehaviorStringLookupTable[value]!;
          } else {
            return _json[key] = _dragStartBehaviorStringLookupTable[value]!;
          }
        } else {
          return _json[key] = _dragStartBehaviorStringLookupTable[value]!;
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _dragStartBehaviorIntLookupTable[value]!;
          } else {
            return _json[key] = _dragStartBehaviorIntLookupTable[value]!;
          }
        } else {
          return _json[key] = _dragStartBehaviorIntLookupTable[value]!;
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [HitTestBehavior] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [HitTestBehavior],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'hitTestBehavior'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to HitTestBehavior.deferToChild.
  ///
  /// Returns:
  /// - A [HitTestBehavior] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [HitTestBehavior] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  HitTestBehavior hitTestBehavior({
    String key = FlutterPropertyKeys.hitTestBehavior,
    HitTestBehavior defaultValue = HitTestBehavior.deferToChild,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is HitTestBehavior) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _hitTestBehaviorStringLookupTable[value]!;
          } else {
            return _json[key] = _hitTestBehaviorStringLookupTable[value]!;
          }
        } else {
          return _json[key] = _hitTestBehaviorStringLookupTable[value]!;
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _hitTestBehaviorIntLookupTable[value]!;
          } else {
            return _json[key] = _hitTestBehaviorIntLookupTable[value]!;
          }
        } else {
          return _json[key] = _hitTestBehaviorIntLookupTable[value]!;
        }
      default:
        return defaultValue;
    }
  }

  /// Parses a [RoundedRectangleBorder] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'borderRadius': A double value.
  /// - 'borderSide': A [BorderSide] value.
  ///
  /// - [value]: The JSON map to parse.
  /// Returns a [RoundedRectangleBorder] created from the map.
  @preferInline
  static ShapeBorder _roundedRectangleBorderFromMap(
    Map<String, dynamic> value,
  ) {
    final source = DuitDataSource(value);
    return RoundedRectangleBorder(
      borderRadius: source.borderRadius(),
      side: source.borderSide(key: "borderSide"),
    );
  }

  /// Parses a [CircleBorder] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'borderSide': A [BorderSide] value.
  ///
  /// - [value]: The JSON map to parse.
  @preferInline
  static ShapeBorder _circleBorderFromMap(
    Map<String, dynamic> value,
  ) {
    final source = DuitDataSource(value);
    return CircleBorder(
      side: source.borderSide(key: "borderSide"),
    );
  }

  /// Parses a [StadiumBorder] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'borderSide': A [BorderSide] value.
  ///
  /// - [value]: The JSON map to parse.
  @preferInline
  static ShapeBorder _stadiumBorderFromMap(
    Map<String, dynamic> value,
  ) {
    final source = DuitDataSource(value);
    return StadiumBorder(
      side: source.borderSide(key: "borderSide"),
    );
  }

  /// Parses a [BeveledRectangleBorder] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'borderRadius': A double value.
  /// - 'borderSide': A [BorderSide] value.
  ///
  @preferInline
  static ShapeBorder _beveledRectangleBorderFromMap(
    Map<String, dynamic> value,
  ) {
    final source = DuitDataSource(value);
    return BeveledRectangleBorder(
      borderRadius: source.borderRadius(),
      side: source.borderSide(key: "borderSide"),
    );
  }

  /// Parses a [ContinuousRectangleBorder] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'borderRadius': A double value.
  /// - 'borderSide': A [BorderSide] value.
  ///
  @preferInline
  static ShapeBorder _continuousRectangleBorderFromMap(
    Map<String, dynamic> value,
  ) {
    final source = DuitDataSource(value);
    return ContinuousRectangleBorder(
      borderRadius: source.borderRadius(),
      side: source.borderSide(key: "borderSide"),
    );
  }

  /// Parses a [ShapeBorder] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'type': A string value representing the type of shape border.
  /// - 'borderRadius': A double value.
  /// - 'borderSide': A [BorderSide] value.
  ///
  @preferInline
  static ShapeBorder _shapeBorderFromMap(Map<String, dynamic> value) {
    final json = DuitDataSource(value);
    final type = json.getString(key: "type");
    return _shapeBorderTypeStringLookupTable[type]?.call(value) ??
        const RoundedRectangleBorder();
  }

  /// Retrieves a [ShapeBorder] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [ShapeBorder],
  /// it is returned as is. If the value is a [Map<String, dynamic>], it attempts to parse it into a [ShapeBorder].
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'shape'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [ShapeBorder] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [ShapeBorder] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  ShapeBorder? shapeBorder({
    String key = FlutterPropertyKeys.shape,
    ShapeBorder? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is ShapeBorder) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case Map<String, dynamic>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _shapeBorderFromMap(value);
          } else {
            return _json[key] = _shapeBorderFromMap(value);
          }
        } else {
          return _json[key] = _shapeBorderFromMap(value);
        }
      default:
        return defaultValue;
    }
  }

  /// Parses a [Border] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'borderSide': A [BorderSide] value.
  ///
  /// - [value]: The JSON map to parse.
  @preferInline
  Border _borderFromMap(Map<String, dynamic> value) {
    final data = DuitDataSource(value);
    return Border.fromBorderSide(data.borderSide());
  }

  /// Retrieves a [Border] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [Border],
  /// it is returned as is. If the value is a [Map<String, dynamic>], it attempts to parse it into a [Border].
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'border'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [Border] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [Border] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  Border? border({
    String key = FlutterPropertyKeys.border,
    Border? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is Border) return value;

    switch (value) {
      case Map<String, dynamic>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _borderFromMap(value);
          } else {
            return _json[key] = _borderFromMap(value);
          }
        } else {
          return _json[key] = _borderFromMap(value);
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [BorderRadius] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [BorderRadius],
  /// it is returned as is. If the value is a [Map<String, dynamic>], it attempts to parse it into a [BorderRadius].
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'borderRadius'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to BorderRadius.zero.
  ///
  /// Returns:
  /// - A [BorderRadius] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [BorderRadius] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  BorderRadius borderRadius({
    String key = FlutterPropertyKeys.borderRadius,
    BorderRadius defaultValue = BorderRadius.zero,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is BorderRadius) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case Map<String, dynamic>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _borderRadiusFromMap(value);
          } else {
            return _json[key] = _borderRadiusFromMap(value);
          }
        } else {
          return _json[key] = _borderRadiusFromMap(value);
        }
      case num():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return BorderRadius.circular(value.toDouble());
          } else {
            return _json[key] = BorderRadius.circular(value.toDouble());
          }
        } else {
          return _json[key] = BorderRadius.circular(value.toDouble());
        }
      default:
        return defaultValue;
    }
  }

  @preferInline
  BorderRadius _borderRadiusFromMap(Map<String, dynamic> value) {
    switch (value) {
      case {
          "topLeft": DuitDataSource? topLeft,
          "topRight": DuitDataSource? topRight,
          "bottomLeft": DuitDataSource? bottomLeft,
          "bottomRight": DuitDataSource? bottomRight,
        }:
        return BorderRadius.only(
          topLeft: topLeft != null ? topLeft.radius() : Radius.zero,
          topRight: topRight != null ? topRight.radius() : Radius.zero,
          bottomLeft: bottomLeft != null ? bottomLeft.radius() : Radius.zero,
          bottomRight: bottomRight != null ? bottomRight.radius() : Radius.zero,
        );
      case {
          "top": DuitDataSource? top,
          "bottom": DuitDataSource? bottom,
        }:
        return BorderRadius.vertical(
          top: top != null ? top.radius() : Radius.zero,
          bottom: bottom != null ? bottom.radius() : Radius.zero,
        );
      case {
          "left": DuitDataSource? left,
          "right": DuitDataSource? right,
        }:
        return BorderRadius.horizontal(
          left: left != null ? left.radius() : Radius.zero,
          right: right != null ? right.radius() : Radius.zero,
        );
      case {
          "radius": num? radius,
        }:
        return BorderRadius.all(
          radius != null ? Radius.circular(radius.toDouble()) : Radius.zero,
        );
      default:
        return BorderRadius.zero;
    }
  }

  @preferInline
  Radius radius({
    String key = FlutterPropertyKeys.radius,
    Radius defaultValue = Radius.zero,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is Radius) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case List<num>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return Radius.elliptical(
              value[0].toDouble(),
              value[1].toDouble(),
            );
          } else {
            return _json[key] = Radius.elliptical(
              value[0].toDouble(),
              value[1].toDouble(),
            );
          }
        } else {
          return _json[key] = Radius.elliptical(
            value[0].toDouble(),
            value[1].toDouble(),
          );
        }
      case num():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return Radius.circular(
              value.toDouble(),
            );
          } else {
            return _json[key] = Radius.circular(
              value.toDouble(),
            );
          }
        } else {
          return _json[key] = Radius.circular(
            value.toDouble(),
          );
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [FloatingActionButtonLocation] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [FloatingActionButtonLocation],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'floatingActionButtonLocation'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [FloatingActionButtonLocation] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [FloatingActionButtonLocation] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  FloatingActionButtonLocation? fabLocation({
    String key = FlutterPropertyKeys.floatingActionButtonLocation,
    FloatingActionButtonLocation? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is FloatingActionButtonLocation) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _fabLocationStringLookupTable[value];
          } else {
            return _json[key] = _fabLocationStringLookupTable[value];
          }
        } else {
          return _json[key] = _fabLocationStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _fabLocationIntLookupTable[value];
          } else {
            return _json[key] = _fabLocationIntLookupTable[value];
          }
        } else {
          return _json[key] = _fabLocationIntLookupTable[value];
        }
      default:
        return defaultValue;
    }
  }

  /// A list of widget states in order of priority for resolving widget state properties.
  ///
  /// This list defines the order in which widget states are checked when resolving widget state properties.
  /// The states are ordered from the most specific to the least specific, ensuring that the most relevant
  /// state is used when multiple states are present.
  ///
  static const _statePriority = [
    WidgetState.disabled,
    WidgetState.error,
    WidgetState.selected,
    WidgetState.pressed,
    WidgetState.hovered,
    WidgetState.focused,
    WidgetState.dragged,
  ];

  /// Retrieves a [WidgetStateProperty] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [WidgetStateProperty],
  /// it is returned as is. If the value is a [Map<String, dynamic>], it attempts to parse it into a [WidgetStateProperty].
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [WidgetStateProperty] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [WidgetStateProperty] or cannot be parsed.
  @preferInline
  WidgetStateProperty<T?>? widgetStateProperty<T>({
    required String key,
    WidgetStateProperty<T?>? defaultValue,
  }) {
    final value = _json[key];

    if (value == null) return defaultValue;

    if (value is WidgetStateProperty<T>) {
      return value;
    }

    if (value is Map<String, dynamic>) {
      final data = DuitDataSource(value);
      return WidgetStateProperty.resolveWith(
        (states) => _resolveForState<T>(
          states,
          data,
        ),
      );
    }
    return null;
  }

  /// Resolves a widget state value of type [T] from the given [states] and [data].
  ///
  /// This method iterates through the priority list of widget states and attempts to resolve
  /// the value of type [T] for each state. It returns the first resolved value that is not null.
  ///
  /// - [states]: A set of widget states to check.
  /// - [data]: The data source containing the widget state properties.
  @preferInline
  T? _resolveForState<T>(Set<WidgetState> states, DuitDataSource data) {
    for (final state in _statePriority) {
      if (states.contains(state)) {
        final result = _resolveWidgetStateValue<T>(data, state);
        if (result != null) return result;
      }
    }
    return null;
  }

  /// Resolves a widget state value of type [T] from the given [data] and [state].
  ///
  /// This method attempts to resolve the value of type [T] for the given [state] using the [data] source.
  /// It returns the resolved value if it is not null, otherwise returns null.
  ///
  /// - [data]: The data source containing the widget state properties.
  @preferInline
  T? _resolveWidgetStateValue<T>(DuitDataSource data, WidgetState state) {
    //NOTE: This is a workaround to avoid the type_literal_in_constant_pattern lint error.
    // We use 'ignore: type_literal_in_constant_pattern' because Dart's analyzer warns when matching on
    // a type parameter (e.g., T) in a switch statement using 'case Color:', expecting a constant type literal.
    // However, this pattern is intentional here—we switch on T (the generic type) to delegate resolution
    // to the correct method for that type. Since T is always a type (not a runtime value), ignoring this lint
    // is safe and required for this generic dispatch.
    switch (T) {
      // ignore: type_literal_in_constant_pattern
      case Color:
        return data.parseColor(key: state.name) as T;
      // ignore: type_literal_in_constant_pattern
      case EdgeInsetsGeometry:
        return data.edgeInsets(key: state.name) as T;
      // ignore: type_literal_in_constant_pattern
      case Size:
        return data.size(state.name) as T;
      // ignore: type_literal_in_constant_pattern
      case double:
        return data.tryGetDouble(key: state.name) as T;
      // ignore: type_literal_in_constant_pattern
      case OutlinedBorder:
        return data.shapeBorder(key: state.name) as T;
      // ignore: type_literal_in_constant_pattern
      case TextStyle:
        return data.textStyle(key: state.name) as T;
      // ignore: type_literal_in_constant_pattern
      case BorderSide:
        return data.borderSide(key: state.name) as T;
      default:
        return null;
    }
  }

  /// Parses a [ButtonStyle] from a JSON map.
  ///
  /// The map should contain the following keys:
  /// - 'textStyle': A [TextStyle] value.
  /// - 'backgroundColor': A [Color] value.
  /// - 'foregroundColor': A [Color] value.
  /// - 'overlayColor': A [Color] value.
  /// - 'shadowColor': A [Color] value.
  /// - 'surfaceTintColor': A [Color] value.
  /// - 'elevation': A double value.
  /// - 'padding': A [EdgeInsetsGeometry] value.
  /// - 'minimumSize': A [Size] value.
  /// - 'maximumSize': A [Size] value.
  /// - 'iconColor': A [Color] value.
  /// - 'iconSize': A double value.
  /// - 'side': A [BorderSide] value.
  /// - 'shape': A [OutlinedBorder] value.
  /// - 'visualDensity': A [VisualDensity] value.
  /// - 'tapTargetSize': A [MaterialTapTargetSize] value.
  /// - 'animationDuration': A [Duration] value.
  /// - 'enableFeedback': A boolean value.
  /// - 'alignment': A [AlignmentGeometry] value.
  ///
  /// - [value]: The JSON map to parse.
  /// Returns a [ButtonStyle] created from the map.
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

  /// Retrieves a [ButtonStyle] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [ButtonStyle],
  /// it is returned as is. If the value is a [Map<String, dynamic>], it attempts to parse it into a [ButtonStyle].
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'style'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - A [ButtonStyle] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [ButtonStyle] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  ButtonStyle? buttonStyle({
    String key = "style",
    ButtonStyle? defaultValue,
  }) {
    final value = _json[key];

    if (value is ButtonStyle) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case Map<String, dynamic>():
        return _json[key] = _buttonStyleFromMap(value);
      default:
        return defaultValue;
    }
  }

  /// Returns a list of child objects from the JSON structure by the given key.
  ///
  /// This method looks up the [key] (default is 'childObjects') in the JSON and expects
  /// a list of child objects If such objects are found, they are
  /// added to the internal buffer '_listContentBuffer', and the original key is cleared (json[key] = null).
  /// This prevents the same objects from being added multiple times on repeated calls.
  ///
  /// Returns the accumulated list of child objects
  /// stored in the '_listContentBuffer'. If there are no child objects, returns an empty list.
  @preferInline
  List<Map<String, dynamic>> childObjects({
    String key = "childObjects",
  }) {
    final children = _json[key];
    final List<Map<String, dynamic>> cachedChildren =
        _json["_listContentBuffer"] ?? [];

    if (children != null && children is List) {
      cachedChildren.addAll(children.cast<Map<String, dynamic>>());
      _json[key] = null;
      _json["_listContentBuffer"] = cachedChildren;
    }

    return cachedChildren;
  }

  /// Retrieves a [ThemeOverrideRule] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [ThemeOverrideRule],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'overrideRule'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to ThemeOverrideRule.themeOverlay.
  ///
  /// Returns:
  /// - A [ThemeOverrideRule] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [ThemeOverrideRule] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  ThemeOverrideRule themeOverrideRule({
    String key = FlutterPropertyKeys.overrideRule,
    ThemeOverrideRule defaultValue = ThemeOverrideRule.themeOverlay,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is ThemeOverrideRule) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _themeOverrideRuleStringLookupTable[value] ?? defaultValue;
          } else {
            return _json[key] =
                _themeOverrideRuleStringLookupTable[value] ?? defaultValue;
          }
        } else {
          return _json[key] =
              _themeOverrideRuleStringLookupTable[value] ?? defaultValue;
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _themeOverrideRuleIntLookupTable[value] ?? defaultValue;
          } else {
            return _json[key] =
                _themeOverrideRuleIntLookupTable[value] ?? defaultValue;
          }
        } else {
          return _json[key] =
              _themeOverrideRuleIntLookupTable[value] ?? defaultValue;
        }
      default:
        return defaultValue;
    }
  }

  /// Creates a deep copy of a list of dynamic values.
  ///
  /// This method recursively copies all nested objects, lists, and primitive values
  /// to create a completely independent copy of the original list.
  ///
  /// Returns a new List that is a deep copy of the original list.
  @preferInline
  List<dynamic> _copyList(List<dynamic> source) {
    final result = [];
    for (final item in source) {
      if (item is Map<String, dynamic>) {
        result.add(_copyMap(item));
      } else if (item is List) {
        result.add(_copyList(item));
      } else {
        result.add(item);
      }
    }
    return result;
  }

  /// Creates a deep copy of a map of string keys to dynamic values.
  ///
  /// This method recursively copies all nested objects, lists, and primitive values
  /// to create a completely independent copy of the original map.
  ///
  /// Returns a new Map that is a deep copy of the original map.
  @preferInline
  Map<String, dynamic> _copyMap(Map<String, dynamic> source) {
    final result = <String, dynamic>{};
    for (final entry in source.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is Map<String, dynamic>) {
        result[key] = _copyMap(value);
      } else if (value is List) {
        result[key] = _copyList(value);
      } else {
        result[key] = value;
      }
    }
    return result;
  }

  /// Creates a deep copy of the current JSON data structure.
  ///
  /// This method recursively copies all nested objects, lists, and primitive values
  /// to create a completely independent copy of the original data structure.
  ///
  /// Returns a new Map that is a deep copy of the current json.
  @preferInline
  Map<String, dynamic> deepCopy() => _copyMap(_json);

  /// Retrieves an [AnimationInterval] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already an [AnimationInterval],
  /// it is returned as is. If the value is a [Map<String, dynamic>] or [List<num>], it attempts to parse it into an [AnimationInterval].
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'interval'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to AnimationInterval(0.0, 1.0).
  ///
  /// Returns:
  /// - An [AnimationInterval] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [AnimationInterval] or cannot be parsed.
  @preferInline
  AnimationInterval animationInterval({
    String key = FlutterPropertyKeys.interval,
    AnimationInterval defaultValue = const AnimationInterval(0.0, 1.0),
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is AnimationInterval) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case Map<String, dynamic>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return AnimationInterval(
              value["begin"] ?? 0.0,
              value["end"] ?? 1.0,
            );
          } else {
            return _json[key] = AnimationInterval(
              value["begin"] ?? 0.0,
              value["end"] ?? 1.0,
            );
          }
        } else {
          return _json[key] = AnimationInterval(
            value["begin"] ?? 0.0,
            value["end"] ?? 1.0,
          );
        }
      case List<num>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return AnimationInterval(
              value[0].toDouble(),
              value[1].toDouble(),
            );
          } else {
            return _json[key] = AnimationInterval(
              value[0].toDouble(),
              value[1].toDouble(),
            );
          }
        } else {
          return _json[key] = AnimationInterval(
            value[0].toDouble(),
            value[1].toDouble(),
          );
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves an [AnimationTrigger] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already an [AnimationTrigger],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'trigger'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to AnimationTrigger.onEnter.
  ///
  /// Returns:
  /// - An [AnimationTrigger] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [AnimationTrigger] or cannot be parsed.
  @preferInline
  AnimationTrigger animationTrigger({
    String key = FlutterPropertyKeys.trigger,
    AnimationTrigger defaultValue = AnimationTrigger.onEnter,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is AnimationTrigger) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _animationTriggerStringLookupTable[value]!;
          } else {
            return _json[key] = _animationTriggerStringLookupTable[value]!;
          }
        } else {
          return _json[key] = _animationTriggerStringLookupTable[value]!;
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _animationTriggerIntLookupTable[value]!;
          } else {
            return _json[key] = _animationTriggerIntLookupTable[value]!;
          }
        } else {
          return _json[key] = _animationTriggerIntLookupTable[value]!;
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves an [AnimationMethod] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already an [AnimationMethod],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'method'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to AnimationMethod.forward.
  ///
  /// Returns:
  /// - An [AnimationMethod] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [AnimationMethod] or cannot be parsed.
  @preferInline
  AnimationMethod animationMethod({
    String key = FlutterPropertyKeys.method,
    AnimationMethod defaultValue = AnimationMethod.forward,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is AnimationMethod) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _animationMethodStringLookupTable[value]!;
          } else {
            return _json[key] = _animationMethodStringLookupTable[value]!;
          }
        } else {
          return _json[key] = _animationMethodStringLookupTable[value]!;
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _animationMethodIntLookupTable[value]!;
          } else {
            return _json[key] = _animationMethodIntLookupTable[value]!;
          }
        } else {
          return _json[key] = _animationMethodIntLookupTable[value]!;
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [TweenType] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [TweenType],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'type'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to TweenType.tween.
  ///
  /// Returns:
  /// - A [TweenType] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [TweenType] or cannot be parsed.
  @preferInline
  TweenType tweenType({
    String key = "type",
    TweenType defaultValue = TweenType.tween,
  }) {
    final value = _json[key];

    if (value is TweenType) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        return _json[key] = _tweenTypeStringLookupTable[value]!;
      case int():
        return _json[key] = _tweenTypeIntLookupTable[value]!;
      default:
        return defaultValue;
    }
  }

  /// Retrieves a list of [DuitTweenDescription] values from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [List<Map<String, dynamic>>],
  /// it is returned as is. If the value is a [List<dynamic>], it attempts to parse it into a [List<DuitTweenDescription>].
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'tweenDescriptions'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to [].
  ///
  /// Returns:
  /// - A [List<DuitTweenDescription>] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [List<DuitTweenDescription>] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  List<DuitTweenDescription> tweens({
    String key = "tweenDescriptions",
  }) {
    final value = _json[key];

    if (value is List) {
      final list = <DuitTweenDescription>[];

      for (final tweenDescription in value) {
        if (tweenDescription is DuitTweenDescription) {
          list.add(tweenDescription);
          continue;
        }
        if (tweenDescription is! Map<String, dynamic>) continue;

        final tweenData = DuitDataSource(tweenDescription);
        final tweenType = tweenData.tweenType();

        final tweenObj = switch (tweenType) {
          TweenType.tween => TweenDescription(
              animatedPropKey: tweenData.getString(key: "animatedPropKey"),
              duration: tweenData.duration(),
              begin: tweenData.getDouble(key: "begin"),
              end: tweenData.getDouble(key: "end"),
              curve: tweenData.curve(defaultValue: Curves.linear)!,
              trigger: tweenData.animationTrigger(),
              method: tweenData.animationMethod(),
              reverseOnRepeat: tweenData.getBool("reverseOnRepeat"),
              interval: tweenData.animationInterval(),
            ),
          TweenType.colorTween => ColorTweenDescription(
              animatedPropKey: tweenData.getString(key: "animatedPropKey"),
              duration: tweenData.duration(),
              begin: tweenData.parseColor(key: "begin"),
              end: tweenData.parseColor(key: "end"),
              curve: tweenData.curve(defaultValue: Curves.linear)!,
              trigger: tweenData.animationTrigger(),
              method: tweenData.animationMethod(),
              reverseOnRepeat: tweenData.getBool("reverseOnRepeat"),
              interval: tweenData.animationInterval(),
            ),
          TweenType.textStyleTween => TextStyleTweenDescription(
              animatedPropKey: tweenData.getString(key: "animatedPropKey"),
              duration: tweenData.duration(),
              begin: tweenData.textStyle(
                key: "begin",
                defaultValue: const TextStyle(),
              )!,
              end: tweenData.textStyle(
                key: "end",
                defaultValue: const TextStyle(),
              )!,
              curve: tweenData.curve(defaultValue: Curves.linear)!,
              trigger: tweenData.animationTrigger(),
              method: tweenData.animationMethod(),
              reverseOnRepeat: tweenData.getBool("reverseOnRepeat"),
              interval: tweenData.animationInterval(),
            ),
          TweenType.decorationTween => DecorationTweenDescription(
              animatedPropKey: tweenData.getString(key: "animatedPropKey"),
              duration: tweenData.duration(),
              begin: tweenData.decoration(
                key: "begin",
                defaultValue: const BoxDecoration(),
              )!,
              end: tweenData.decoration(
                key: "end",
                defaultValue: const BoxDecoration(),
              )!,
              curve: tweenData.curve(defaultValue: Curves.linear)!,
              trigger: tweenData.animationTrigger(),
              method: tweenData.animationMethod(),
              reverseOnRepeat: tweenData.getBool("reverseOnRepeat"),
              interval: tweenData.animationInterval(),
            ),
          TweenType.alignmentTween => AlignmentTweenDescription(
              animatedPropKey: tweenData.getString(key: "animatedPropKey"),
              duration: tweenData.duration(),
              begin: tweenData.alignment(
                key: "begin",
                defaultValue: Alignment.center,
              )!,
              end: tweenData.alignment(
                key: "end",
                defaultValue: Alignment.center,
              )!,
              curve: tweenData.curve(defaultValue: Curves.linear)!,
              trigger: tweenData.animationTrigger(),
              method: tweenData.animationMethod(),
              reverseOnRepeat: tweenData.getBool("reverseOnRepeat"),
              interval: tweenData.animationInterval(),
            ),
          TweenType.sizeTween => SizeTweenDescription(
              animatedPropKey: tweenData.getString(key: "animatedPropKey"),
              duration: tweenData.duration(),
              begin: tweenData.size("begin"),
              end: tweenData.size("end"),
              curve: tweenData.curve(defaultValue: Curves.linear)!,
              trigger: tweenData.animationTrigger(),
              method: tweenData.animationMethod(),
              reverseOnRepeat: tweenData.getBool("reverseOnRepeat"),
              interval: tweenData.animationInterval(),
            ),
          TweenType.edgeInsetsTween => EdgeInsetsTweenDescription(
              animatedPropKey: tweenData.getString(key: "animatedPropKey"),
              duration: tweenData.duration(),
              begin: tweenData.edgeInsets(
                key: "begin",
                defaultValue: EdgeInsets.zero,
              )!,
              end: tweenData.edgeInsets(
                key: "end",
                defaultValue: EdgeInsets.zero,
              )!,
              curve: tweenData.curve(defaultValue: Curves.linear)!,
              trigger: tweenData.animationTrigger(),
              method: tweenData.animationMethod(),
              reverseOnRepeat: tweenData.getBool("reverseOnRepeat"),
              interval: tweenData.animationInterval(),
            ),
          TweenType.boxConstraintsTween => BoxConstraintsTweenDescription(
              animatedPropKey: tweenData.getString(key: "animatedPropKey"),
              duration: tweenData.duration(),
              begin: tweenData.boxConstraints(
                key: "begin",
                defaultValue: const BoxConstraints(),
              )!,
              end: tweenData.boxConstraints(
                key: "end",
                defaultValue: const BoxConstraints(),
              )!,
              curve: tweenData.curve(defaultValue: Curves.linear)!,
              trigger: tweenData.animationTrigger(),
              method: tweenData.animationMethod(),
              reverseOnRepeat: tweenData.getBool("reverseOnRepeat"),
              interval: tweenData.animationInterval(),
            ),
          TweenType.borderTween => BorderTweenDescription(
              animatedPropKey: tweenData.getString(key: "animatedPropKey"),
              duration: tweenData.duration(),
              begin:
                  tweenData.border(key: "begin", defaultValue: const Border())!,
              end: tweenData.border(key: "end", defaultValue: const Border())!,
              curve: tweenData.curve(defaultValue: Curves.linear)!,
              trigger: tweenData.animationTrigger(),
              method: tweenData.animationMethod(),
              reverseOnRepeat: tweenData.getBool("reverseOnRepeat"),
              interval: tweenData.animationInterval(),
            ),
          TweenType.group => TweenDescriptionGroup(
              duration: tweenData.duration(),
              groupId: tweenData.getString(key: "groupId"),
              tweens: tweenData.tweens(key: "tweens"),
              method: tweenData.animationMethod(),
              reverseOnRepeat: tweenData.getBool("reverseOnRepeat"),
              trigger: tweenData.animationTrigger(),
            ),
        } as DuitTweenDescription;

        list.add(tweenObj);
      }

      return list;
    }

    return [];
  }

  /// Retrieves a [CollapseMode] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [CollapseMode],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'collapseMode'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to CollapseMode.parallax.
  ///
  /// Returns:
  /// - A [CollapseMode] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [CollapseMode] or cannot be parsed.
  @preferInline
  CollapseMode collapseMode({
    String key = FlutterPropertyKeys.collapseMode,
    CollapseMode defaultValue = CollapseMode.parallax,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is CollapseMode) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _collapseModeStringLookupTable[value]!;
          } else {
            return _json[key] = _collapseModeStringLookupTable[value]!;
          }
        } else {
          return _json[key] = _collapseModeStringLookupTable[value]!;
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _collapseModeIntLookupTable[value]!;
          } else {
            return _json[key] = _collapseModeIntLookupTable[value]!;
          }
        } else {
          return _json[key] = _collapseModeIntLookupTable[value]!;
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a list of [StretchMode] values from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [List<StretchMode>],
  /// it is returned as is. If the value is a [List<String>] or [List<int>], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'stretchMode'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to [StretchMode.zoomBackground].
  ///
  /// Returns:
  /// - A [List<StretchMode>] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [List<StretchMode>] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  List<StretchMode> stretchModes({
    String key = FlutterPropertyKeys.stretchModes,
    List<StretchMode> defaultValue = const [
      StretchMode.zoomBackground,
    ],
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is List<StretchMode>) return value;

    if (value == null) return defaultValue;

    if (value is List<String>) {
      final list = <StretchMode>[];
      for (final item in value) {
        final stretchMode = _stretchModeStringLookupTable[item];
        if (stretchMode != null) {
          list.add(stretchMode);
        }
      }

      if (envAttributeWarmUpEnabled) {
        if (warmUp) {
          return list.isNotEmpty ? list : defaultValue;
        } else {
          return _json[key] = list.isNotEmpty ? list : defaultValue;
        }
      } else {
        return _json[key] = list.isNotEmpty ? list : defaultValue;
      }
    }

    if (value is List<int>) {
      final list = <StretchMode>[];
      for (final item in value) {
        final stretchMode = _stretchModeIntLookupTable[item];
        if (stretchMode != null) {
          list.add(stretchMode);
        }
      }

      if (envAttributeWarmUpEnabled) {
        if (warmUp) {
          return list.isNotEmpty ? list : defaultValue;
        } else {
          return _json[key] = list.isNotEmpty ? list : defaultValue;
        }
      } else {
        return _json[key] = list.isNotEmpty ? list : defaultValue;
      }
    }

    return defaultValue;
  }

  /// Retrieves a [ExecutionModifier] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [ExecutionModifier],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'executionModifier'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to ExecutionModifier.throttle.
  ///
  /// Returns:
  /// - A [ExecutionModifier] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [ExecutionModifier] or cannot be parsed.
  @preferInline
  ExecutionModifier _executionModifier({
    String key = FlutterPropertyKeys.modifier,
    ExecutionModifier defaultValue = ExecutionModifier.debounce,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is ExecutionModifier) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _executionModifierStringLookupTable[value]!;
          } else {
            return _json[key] = _executionModifierStringLookupTable[value]!;
          }
        } else {
          return _json[key] = _executionModifierStringLookupTable[value]!;
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _executionModifierIntLookupTable[value]!;
          } else {
            return _json[key] = _executionModifierIntLookupTable[value]!;
          }
        } else {
          return _json[key] = _executionModifierIntLookupTable[value]!;
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [FocusNode] from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [FocusNode],
  /// it is returned as is. If the value is a `Map<String, dynamic>`, it attempts to construct
  /// a [FocusNode] using the provided map. If the value is `null`, [defaultValue] is returned.
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to [FlutterPropertyKeys.focusNode].
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to `null`.
  /// - [target]: Optional object to override or supplement the lookup.
  /// - [warmUp]: If `true` during attribute warm-up, skips writing back to the JSON.
  ///
  /// Returns:
  /// - A [FocusNode] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [FocusNode] or cannot be parsed.
  @preferInline
  FocusNode? focusNode({
    String key = FlutterPropertyKeys.focusNode,
    FocusNode? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is FocusNode) return value;

    if (value == null) return defaultValue;

    if (value is Map<String, dynamic>) {
      if (envAttributeWarmUpEnabled) {
        if (warmUp) {
          return _focusNodeFromMap(value);
        } else {
          return _json[key] = _focusNodeFromMap(value);
        }
      } else {
        return _json[key] = _focusNodeFromMap(value);
      }
    }
    return defaultValue;
  }

  /// Attempts to construct a [FocusNode] from a [Map<String, dynamic>] representation.
  ///
  /// This utility is used internally to parse a JSON-like map of properties and
  /// build a [FocusNode] using values extracted from the map. It reads recognized focus node
  /// properties such as `"debugLabel"`, `"skipTraversal"`, `"canRequestFocus"`,
  /// `"descendantsAreFocusable"`, and `"descendantsAreTraversable"`, with appropriate
  /// defaults as in the standard [FocusNode] constructor.
  ///
  /// Any property missing from the input [map] will fall back to the corresponding
  /// default value provided by [FocusNode].
  ///
  /// Returns a new [FocusNode] instance with the configured properties,
  /// or (in practice) throws if required types are invalid.
  ///
  /// Example:
  /// ```
  /// final node = _focusNodeFromMap({
  ///   "debugLabel": "Main",
  ///   "skipTraversal": true,
  /// });
  /// ```
  @preferInline
  FocusNode _focusNodeFromMap(Map<String, dynamic> map) {
    final source = DuitDataSource(map);

    return FocusNode(
      debugLabel: source.tryGetString("debugLabel"),
      skipTraversal: source.getBool("skipTraversal"),
      canRequestFocus: source.getBool(
        "canRequestFocus",
        defaultValue: true,
      ),
      descendantsAreFocusable: source.getBool(
        "descendantsAreFocusable",
        defaultValue: true,
      ),
      descendantsAreTraversable: source.getBool(
        "descendantsAreTraversable",
        defaultValue: true,
      ),
    );
  }

  /// Retrieves a [TraversalDirection] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [TraversalDirection],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'traversalDirection'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to `null`.
  /// - [target]: An optional target object to search for the property.
  /// - [warmUp]: Whether to perform a warm-up lookup only (does not cache).
  ///
  /// Returns:
  /// - A [TraversalDirection] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [TraversalDirection] or cannot be parsed.
  @preferInline
  TraversalDirection? traversalDirection({
    String key = FlutterPropertyKeys.traversalDirection,
    TraversalDirection? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is TraversalDirection) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _traversalDirectionStringLookupTable[value];
          } else {
            return _json[key] = _traversalDirectionStringLookupTable[value];
          }
        } else {
          return _json[key] = _traversalDirectionStringLookupTable[value];
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _traversalDirectionIntLookupTable[value];
          } else {
            return _json[key] = _traversalDirectionIntLookupTable[value];
          }
        } else {
          return _json[key] = _traversalDirectionIntLookupTable[value];
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves an [UnfocusDisposition] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already an [UnfocusDisposition],
  /// it is returned as is. If the value is a [String] or [int], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'unfocusDisposition'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to [UnfocusDisposition.scope].
  /// - [target]: An optional target object to search for the property.
  /// - [warmUp]: Whether to perform a warm-up lookup only (does not cache).
  ///
  /// Returns:
  /// - An [UnfocusDisposition] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [UnfocusDisposition] or cannot be parsed.
  @preferInline
  UnfocusDisposition unfocusDisposition({
    String key = FlutterPropertyKeys.unfocusDisposition,
    UnfocusDisposition defaultValue = UnfocusDisposition.scope,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is UnfocusDisposition) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _unfocusDispositionStringLookupTable[value]!;
          } else {
            return _json[key] = _unfocusDispositionStringLookupTable[value]!;
          }
        } else {
          return _json[key] = _unfocusDispositionStringLookupTable[value]!;
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _unfocusDispositionIntLookupTable[value]!;
          } else {
            return _json[key] = _unfocusDispositionIntLookupTable[value]!;
          }
        } else {
          return _json[key] = _unfocusDispositionIntLookupTable[value]!;
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves an [ExecutionOptions] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [ExecutionOptions],
  /// it is returned as is. If the value is a [Map<String, dynamic>], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'options'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - An [ExecutionOptions] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [ExecutionOptions] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  ExecutionOptions _executionOptionsFromMap(Map<String, dynamic> json) {
    final source = DuitDataSource(json);
    return ExecutionOptions(
      modifier: source._executionModifier(),
      duration: source.duration(),
    );
  }

  /// Retrieves an [ExecutionOptions] value from the JSON map for the given [key].
  ///
  /// Looks up the value associated with [key] in the JSON. If the value is already a [ExecutionOptions],
  /// it is returned as is. If the value is a [Map<String, dynamic>], it is converted using the lookup tables.
  /// Otherwise, it returns [defaultValue].
  ///
  /// - [key]: The key to look up in the JSON map. Defaults to 'options'.
  /// - [defaultValue]: The value to return if the key is not found or cannot be resolved. Defaults to null.
  ///
  /// Returns:
  /// - An [ExecutionOptions] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [ExecutionOptions] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  ExecutionOptions? executionOptions({
    String key = "options",
    ExecutionOptions? defaultValue,
  }) {
    final value = _json[key];

    if (value is ExecutionOptions) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case Map<String, dynamic>():
        return _json[key] = _executionOptionsFromMap(value);
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [DateTime] value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already a [DateTime], it returns that value.
  /// If the value is a [String] or [int], it attempts to parse it into a [DateTime].
  /// Otherwise, it returns [defaultValue].
  ///
  /// The parsed or existing [DateTime] is also stored back into the JSON map at the given [key].
  ///
  /// Returns:
  /// - A [DateTime] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [DateTime] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  DateTime? dateTime({
    required String key,
    DateTime? defaultValue,
  }) {
    // Value warm-up ignored
    final value = _readProp(key, null, false);

    if (value is DateTime) return value;

    if (value == null) return defaultValue;

    if (value is String) {
      return _json[key] = DateTime.parse(value);
    }

    if (value is int) {
      return _json[key] = DateTime.fromMillisecondsSinceEpoch(value);
    }

    return defaultValue;
  }

  /// Retrieves a [DatePickerEntryMode] value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already a [DatePickerEntryMode], it returns that value.
  /// If the value is a [String] or [int], it attempts to parse it into a [DatePickerEntryMode].
  /// Otherwise, it returns [defaultValue].
  ///
  /// The parsed or existing [DatePickerEntryMode] is also stored back into the JSON map at the given [key].
  ///
  /// Returns:
  /// - A [DatePickerEntryMode] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [DatePickerEntryMode] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  DatePickerEntryMode datePickerEntryMode({
    required String key,
    DatePickerEntryMode defaultValue = DatePickerEntryMode.calendar,
  }) {
    // Value warm-up ignored
    final value = _readProp(key, null, false);

    if (value is DatePickerEntryMode) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        return _json[key] = _datePickerEntryModeStringLookupTable[value]!;
      case int():
        return _json[key] = _datePickerEntryModeIntLookupTable[value]!;
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [DatePickerMode] value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already a [DatePickerMode], it returns that value.
  /// If the value is a [String] or [int], it attempts to parse it into a [DatePickerMode].
  /// Otherwise, it returns [defaultValue].
  ///
  /// The parsed or existing [DatePickerMode] is also stored back into the JSON map at the given [key].
  ///
  /// Returns:
  /// - A [DatePickerMode] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [DatePickerMode] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  DatePickerMode datePickerMode({
    required String key,
    DatePickerMode defaultValue = DatePickerMode.day,
  }) {
    // Value warm-up ignored
    final value = _readProp(key, null, false);

    if (value is DatePickerMode) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        return _json[key] = _datePickerModeStringLookupTable[value]!;
      case int():
        return _json[key] = _datePickerModeIntLookupTable[value]!;
    }
    return defaultValue;
  }

  /// Retrieves a [Locale] value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already a [Locale], it returns that value.
  /// If the value is a [String], it attempts to parse it into a [Locale].
  /// Otherwise, it returns [defaultValue].
  ///
  /// The parsed or existing [Locale] is also stored back into the JSON map at the given [key].
  ///
  /// Returns:
  /// - A [Locale] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [Locale] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  Locale? locale({
    String key = FlutterPropertyKeys.locale,
    Locale? defaultValue,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, target, warmUp);

    if (value is Locale) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return localeFromString(value);
          } else {
            return _json[key] = localeFromString(value);
          }
        } else {
          return _json[key] = localeFromString(value);
        }
      case Map<String, dynamic>():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _localeFromMap(value);
          } else {
            return _json[key] = _localeFromMap(value);
          }
        } else {
          return _json[key] = _localeFromMap(value);
        }
      default:
        return defaultValue;
    }
  }

  @preferInline
  Locale localeFromString(String value) {
    final tags = value.split("-");
    if (tags.length == 1) {
      return Locale(tags[0]);
    } else {
      return Locale(tags[0], tags[1]);
    }
  }

  @preferInline
  Locale _localeFromMap(Map<String, dynamic> json) {
    final source = DuitDataSource(json);
    return Locale(
      source.getString(key: "languageCode"),
      source.tryGetString("countryCode"),
    );
  }

  /// Retrieves a [TimeOfDay] value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already a [TimeOfDay], it returns that value.
  /// If the value is a [List<num>], it attempts to parse it into a [TimeOfDay].
  /// Otherwise, it returns [defaultValue].
  ///
  /// The parsed or existing [TimeOfDay] is also stored back into the JSON map at the given [key].
  ///
  /// Returns:
  /// - A [TimeOfDay] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [TimeOfDay] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  TimeOfDay? timeOfDay({
    required String key,
    TimeOfDay? defaultValue,
  }) {
    final value = _readProp(key, null, false);

    if (value is TimeOfDay) return value;

    if (value == null) return defaultValue;

    if (value is List<num>) {
      return _json[key] = TimeOfDay(
        hour: value.elementAt(0).toInt(),
        minute: value.elementAt(1).toInt(),
      );
    }

    return defaultValue;
  }

  /// Retrieves a [TimePickerEntryMode] value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already a [TimePickerEntryMode], it returns that value.
  /// If the value is a [String] or [int], it attempts to parse it into a [TimePickerEntryMode].
  /// Otherwise, it returns [defaultValue].
  ///
  /// The parsed or existing [TimePickerEntryMode] is also stored back into the JSON map at the given [key].
  ///
  /// Returns:
  /// - A [TimePickerEntryMode] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [TimePickerEntryMode] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  TimePickerEntryMode timePickerEntryMode({
    required String key,
    TimePickerEntryMode defaultValue = TimePickerEntryMode.dial,
  }) {
    final value = _readProp(key, null, false);
    if (value is TimePickerEntryMode) return value;
    if (value == null) return defaultValue;
    switch (value) {
      case String():
        return _json[key] = _timePickerEntryModeStringLookupTable[value]!;
      case int():
        return _json[key] = _timePickerEntryModeIntLookupTable[value]!;
      default:
        return defaultValue;
    }
  }

  /// Retrieves an [Orientation] value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already an [Orientation], it returns that value.
  /// If the value is a [String] or [int], it attempts to parse it into an [Orientation].
  /// Otherwise, it returns [defaultValue].
  ///
  /// The parsed or existing [Orientation] is also stored back into the JSON map at the given [key].
  ///
  /// Returns:
  /// - An [Orientation] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [Orientation] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  Orientation? orientation({
    String key = FlutterPropertyKeys.orientation,
    Orientation defaultValue = Orientation.portrait,
    Object? target,
    bool warmUp = false,
  }) {
    final value = _readProp(key, null, false);
    if (value is Orientation) return value;

    if (value == null) return defaultValue;

    switch (value) {
      case String():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _orientationStringLookupTable[value]!;
          } else {
            return _json[key] = _orientationStringLookupTable[value]!;
          }
        } else {
          return _json[key] = _orientationStringLookupTable[value]!;
        }
      case int():
        if (envAttributeWarmUpEnabled) {
          if (warmUp) {
            return _orientationIntLookupTable[value]!;
          } else {
            return _json[key] = _orientationIntLookupTable[value]!;
          }
        } else {
          return _json[key] = _orientationIntLookupTable[value]!;
        }
      default:
        return defaultValue;
    }
  }

  /// Retrieves a [FlexFit] value from the JSON map associated with the given [key].
  ///
  /// If the value associated with the [key] is already a [FlexFit], it returns that value.
  /// If the value is a [String] or [int], it attempts to parse it into a [FlexFit].
  /// Otherwise, it returns [defaultValue].
  ///
  /// The parsed or existing [FlexFit] is also stored back into the JSON map at the given [key].
  ///
  /// Returns:
  /// - A [FlexFit] if the value is valid or can be parsed.
  /// - [defaultValue] if the value is not a valid [FlexFit] or cannot be parsed.
  /// - `null` if both the value and [defaultValue] are null.
  @preferInline
  FlexFit? flexFit({
    required String key,
    FlexFit defaultValue = FlexFit.loose,
  }) {
    final value = _readProp(key, null, false);
    if (value is FlexFit) return value;
    if (value == null) return defaultValue;

    switch (value) {
      case String():
        return _json[key] = _flexFitStringLookupTable[value]!;
      case int():
        return _json[key] = _flexFitIntLookupTable[value]!;
      default:
        return defaultValue;
    }
  }

  /// The dispatch map for attribute keys to their corresponding handler functions.
  ///
  /// This map associates each supported [FlutterPropertyKeys] value with a function
  /// that is responsible for parsing, transforming, or resolving the attribute value
  /// for that key. The handler functions are used by the attribute warm-up and
  /// dispatching mechanisms to convert raw JSON or dynamic values into strongly-typed
  /// Dart/Flutter objects as required by the framework.
  ///
  /// Each entry in the map is a key-value pair where:
  /// - The key is a [String] representing a property key (typically from [FlutterPropertyKeys]).
  /// - The value is a function of type [_DispatchFn], which takes the following parameters:
  ///   - `self`: The current [DuitDataSource] instance.
  ///   - `k`: The property key as a [String].
  ///   - `d`: The default value for the property (if any).
  ///   - `t`: The target value to be parsed or transformed.
  ///   - `w`: A [bool] indicating whether attribute warm-up is enabled.
  ///
  /// The handler function returns the parsed or resolved value for the property,
  /// or the original value if no transformation is required.
  ///
  /// This map is central to the attribute dispatching logic, allowing for
  /// extensible and maintainable mapping between property keys and their
  /// resolution logic. It is used internally by method such as [_dispatchCall]
  /// to dynamically resolve property values at runtime.
  ///
  /// Example usage:
  /// ```dart
  /// final result = _dispatchMap['color']!(this, 'color', null, '#FFFFFF', true);
  /// // result is a Color object parsed from the hex string
  /// ```
  static final Map<String, _DispatchFn> _dispatchMap = {
    FlutterPropertyKeys.style: _dispatchStyleKeyEntryCall,
    FlutterPropertyKeys.decoration: _dispatchDecorationKeyEntryCall,
    FlutterPropertyKeys.color: (self, k, t, w) =>
        self.tryParseColor(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.duration: (self, k, t, w) =>
        self.duration(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.textAlign: (self, k, t, w) =>
        self.textAlign(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.textDirection: (self, k, t, w) =>
        self.textDirection(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.textOverflow: (self, k, t, w) =>
        self.textOverflow(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.clipBehavior: (self, k, t, w) =>
        self.clipBehavior(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.padding: (self, k, t, w) =>
        self.edgeInsets(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.margin: (self, k, t, w) =>
        self.edgeInsets(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.curve: (self, k, t, w) =>
        self.curve(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.textWidthBasis: (self, k, t, w) =>
        self.textWidthBasis(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.textBaseline: (self, k, t, w) =>
        self.textBaseline(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.offset: (self, k, t, w) =>
        self.offset(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.boxShadow: (self, k, t, w) =>
        self.boxShadow(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.decorationStyle: (self, k, t, w) =>
        self.textDecorationStyle(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.fontWeight: (self, k, t, w) =>
        self.fontWeight(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.fontStyle: (self, k, t, w) =>
        self.fontStyle(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.textSpan: (self, k, t, w) =>
        self.textSpan(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.textHeightBehavior: (self, k, t, w) =>
        self.textHeightBehavior(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.textScaler: (self, k, t, w) =>
        self.textScaler(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.strutStyle: (self, k, t, w) =>
        self.strutStyle(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.leadingDistribution: (self, k, t, w) =>
        self.textLeadingDistribution(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.direction: (self, k, t, w) =>
        self.axis(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.scrollDirection: (self, k, t, w) =>
        self.axis(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.mainAxis: (self, k, t, w) =>
        self.axis(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.wrapCrossAlignment: (self, k, t, w) =>
        self.wrapCrossAlignment(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.wrapAlignment: (self, k, t, w) =>
        self.wrapAlignment(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.runAlignment: (self, k, t, w) =>
        self.wrapAlignment(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.constraints: (self, k, t, w) =>
        self.boxConstraints(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.stackFit: (self, k, t, w) =>
        self.stackFit(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.overflowBoxFit: (self, k, t, w) =>
        self.overflowBoxFit(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.alignment: (self, k, t, w) =>
        self.alignment(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.alignmentDirectional: (self, k, t, w) =>
        self.alignmentDirectional(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.persistentFooterAlignment: (self, k, t, w) =>
        self.alignmentDirectional(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.mainAxisAlignment: (self, k, t, w) =>
        self.mainAxisAlignment(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.crossAxisAlignment: (self, k, t, w) =>
        self.crossAxisAlignment(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.mainAxisSize: (self, k, t, w) =>
        self.mainAxisSize(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.allowedInteraction: (self, k, t, w) =>
        self.sliderInteraction(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.materialTapTargetSize: (self, k, t, w) =>
        self.materialTapTargetSize(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.filterQuality: (self, k, t, w) =>
        self.filterQuality(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.repeat: (self, k, t, w) =>
        self.imageRepeat(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.fit: (self, k, t, w) =>
        self.boxFit(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.byteData: (self, k, t, w) =>
        self.uint8List(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.blendMode: (self, k, t, w) =>
        self.blendMode(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.tileMode: (self, k, t, w) =>
        self.tileMode(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.filter: (self, k, t, w) =>
        self.imageFilter(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.verticalDirection: (self, k, t, w) =>
        self.verticalDirection(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.shape: (self, k, t, w) =>
        self.boxShape(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.border: (self, k, t, w) =>
        self.border(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.side: (self, k, t, w) =>
        self.borderSide(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.borderSide: (self, k, t, w) =>
        self.borderSide(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.inputBorder: (self, k, t, w) =>
        self.inputBorder(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.enabledBorder: (self, k, t, w) =>
        self.inputBorder(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.errorBorder: (self, k, t, w) =>
        self.inputBorder(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.focusedBorder: (self, k, t, w) =>
        self.inputBorder(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.focusedErrorBorder: (self, k, t, w) =>
        self.inputBorder(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.keyboardType: (self, k, t, w) =>
        self.textInputType(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.borderRadius: (self, k, t, w) =>
        self.borderRadius(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.inputDecoration: (self, k, t, w) =>
        self.inputDecoration(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.visualDensity: (self, k, t, w) =>
        self.visualDensity(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.keyboardDismissBehavior: (self, k, t, w) =>
        self.keyboardDismissBehavior(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.physics: (self, k, t, w) =>
        self.scrollPhysics(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.dragStartBehavior: (self, k, t, w) =>
        self.dragStartBehavior(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.hitTestBehavior: (self, k, t, w) =>
        self.hitTestBehavior(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.interval: (self, k, t, w) =>
        self.animationInterval(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.trigger: (self, k, t, w) =>
        self.animationTrigger(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.method: (self, k, t, w) =>
        self.animationMethod(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.collapseMode: (self, k, t, w) =>
        self.collapseMode(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.stretchModes: (self, k, t, w) =>
        self.stretchModes(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.modifier: (self, k, t, w) =>
        self._executionModifier(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.focusNode: (self, k, t, w) =>
        self.focusNode(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.traversalDirection: (self, k, t, w) =>
        self.traversalDirection(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.unfocusDisposition: (self, k, t, w) =>
        self.unfocusDisposition(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.locale: (self, k, t, w) =>
        self.locale(key: k, target: t, warmUp: w),
    FlutterPropertyKeys.orientation: (self, k, t, w) =>
        self.orientation(key: k, target: t, warmUp: w),
  };

  /// A specialized dispatcher for transforming objects stored under the "style" key
  @preferInline
  static dynamic _dispatchStyleKeyEntryCall(
    DuitDataSource self,
    String key,
    Object? target,
    bool warmUp,
  ) {
    if (target is TextStyle) return target;

    return switch (target) {
      Map<String, dynamic>() => self.textStyle(
          key: key,
          target: target,
          warmUp: warmUp,
        ),
      String() => self.borderStyle(
          key: key,
          target: target,
          warmUp: warmUp,
        ),
      int() => self.borderStyle(
          key: key,
          target: target,
          warmUp: warmUp,
        ),
      _ => null,
    };
  }

  @preferInline
  static dynamic _dispatchDecorationKeyEntryCall(
    DuitDataSource self,
    String key,
    Object? target,
    bool warmUp,
  ) {
    if (target is Decoration) return target;
    if (target is TextDecoration) return target;

    return switch (target) {
      Map<String, dynamic>() => self.decoration(
          key: key,
          target: target,
          warmUp: warmUp,
        ),
      String() => self.textDecoration(
          key: key,
          target: target,
          warmUp: warmUp,
        ),
      int() => self.textDecoration(
          key: key,
          target: target,
          warmUp: warmUp,
        ),
      _ => null,
    };
  }

  @preferInline
  dynamic _dispatchCall(String key, Object? target) {
    final fn = _dispatchMap[key];

    if (fn == null) {
      return target;
    } else {
      return fn.call(this, key, target, true);
    }
  }

  //Proxy for _dispatchCall
  @visibleForTesting
  dynamic dispatchCall(String key, Object? target) =>
      _dispatchCall(key, target);

  static Object? _handleKVPair(Object? key, Object? value) {
    if (FlutterPropertyKeys.values.contains(key)) {
      return DuitDataSource(const <String, dynamic>{})
          ._dispatchCall(key! as String, value);
    } else {
      return value;
    }
  }

  // Returns the json reviver function.
  //
  // If attribute warm up is enabled, it returns the function.
  // Otherwise, it returns null.
  //
  // The json reviver function is used to parse the JSON data to Dart/Flutter types.
  static Object? Function(Object? key, Object? value)? get jsonReviver {
    if (envAttributeWarmUpEnabled) {
      return _handleKVPair;
    } else {
      return null;
    }
  }
}
