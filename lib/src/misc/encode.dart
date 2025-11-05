import "dart:convert" as conv;

import "package:duit_kernel/duit_kernel.dart";
import "package:flutter/material.dart";

/// Converts any object to a JSON string representation with custom encoding support.
///
/// This function provides a comprehensive JSON serialization mechanism that extends
/// the standard `jsonEncode` functionality with custom encoding for Flutter-specific
/// objects and Duit framework types. It handles both simple serializable objects
/// and complex Flutter widgets, styles, and properties that require special encoding.
///
/// The function uses a two-tier approach:
/// 1. **Direct serialization**: For objects that implement custom serialization
///    (like `TextInputType` with `toJson()` method)
/// 2. **Custom encoding**: For Flutter objects that need special handling through
///    the `toEncodable` callback
///
/// **Supported Flutter/Duit types:**
/// - `Duration` → milliseconds as integer
/// - `Size` → [width, height] as list of doubles
/// - `EdgeInsets` → [left, top, right, bottom] as list of doubles
/// - `TextStyle` → map with non-null properties
/// - `Color` → hex string with alpha channel
/// - `LinearGradient` → map with colors, stops, begin, end, and transform
/// - `BoxShadow` → map with color, offset, blurRadius, spreadRadius
/// - `Offset` → map with dx, dy coordinates
/// - `BoxDecoration` → map with color, borderRadius, border, gradient, boxShadow
/// - `BorderRadius` → circular radius as double
/// - `Border` → map with side properties
/// - `InputBorder` → map with type, borderSide, and optional properties
/// - `InputDecoration` → map with all non-null decoration properties
/// - `VisualDensity` → map with horizontal and vertical values
/// - `ScrollPhysics` → runtime type name as string
/// - `ShapeBorder` → map with type, side, and borderRadius
/// - `WidgetStateProperty` → map with resolved state values
/// - `ButtonStyle` → map with all non-null style properties
/// - `AnimationInterval` → map with begin and end values
/// - `DuitTweenDescription` → JSON representation via toJson()
/// - `Curve` → predefined string mapping
///
/// **Parameters:**
/// - [object]: The object to encode. Can be any type including null.
///
/// **Returns:**
/// A JSON string representation of the object. For unsupported types,
/// falls back to the object's `toString()` method.
///
/// **Throws:**
/// - `JsonUnsupportedObjectError`: When the object cannot be serialized
///   and doesn't have a meaningful `toString()` representation
///
/// **Example usage:**
///
/// ```dart
/// // Simple object
/// String json = duitJsonEncode({'key': 'value'});
/// // Result: '{"key":"value"}'
///
/// // Flutter Color
/// String colorJson = duitJsonEncode(Colors.blue);
/// // Result: '"#FF2196F3"'
///
/// // TextStyle
/// String styleJson = duitJsonEncode(TextStyle(
///   color: Colors.red,
///   fontSize: 16.0,
///   fontWeight: FontWeight.bold,
/// ));
/// // Result: '{"color":"#FFFF0000","fontSize":16.0,"fontWeight":700}'
///
/// // Duration
/// String durationJson = duitJsonEncode(Duration(seconds: 5));
/// // Result: '5000'
///
/// // Complex widget state property
/// String stateJson = duitJsonEncode(WidgetStateProperty.resolve({
///   WidgetState.pressed: Colors.red,
///   WidgetState.hovered: Colors.blue,
/// }));
/// // Result: '{"pressed":"#FFFF0000","hovered":"#FF0000FF"}'
/// ```
String duitJsonEncode(Object? object) {
  return switch (object) {
    //Add serializable values here to provide custom encoding
    TextInputType() => object.toJson()["name"] ?? "text",
    //Rest types are encoded using the default jsonEncode
    _ => conv.jsonEncode(
        object,
        toEncodable: (nonEncodable) {
          return switch (nonEncodable) {
            Duration() => _encodeDuration(nonEncodable),
            Size() => _encodeSize(nonEncodable),
            EdgeInsets() => _encodeEdgeInsets(nonEncodable),
            DuitTweenDescription() => _encodeTweenDescription(nonEncodable),
            TextStyle() => _encodeTextStyle(nonEncodable),
            Color() => _encodeColor(nonEncodable),
            LinearGradient() => _encodeGradient(nonEncodable),
            BoxShadow() => _encodeBoxShadow(nonEncodable),
            Offset() => _encodeOffset(nonEncodable),
            BoxDecoration() => _encodeDecoration(nonEncodable),
            BorderRadius() => _encodeRadius(nonEncodable),
            Border() => _encodeBorder(nonEncodable),
            BorderSide() => _encodeBorderSide(nonEncodable),
            InputBorder() => _encodeInputBorder(nonEncodable),
            InputDecoration() => _encodeInputDecoration(nonEncodable),
            VisualDensity() => _encodeVisualDensity(nonEncodable),
            ScrollPhysics() => _encodeScrollPhysics(nonEncodable),
            ShapeBorder() => _encodeShapeBorder(nonEncodable),
            WidgetStateProperty() => _encodeWidgetStateProperty(nonEncodable),
            ButtonStyle() => _encodeButtonStyle(nonEncodable),
            AnimationInterval() => _encodeAnimationInterval(nonEncodable),
            Curve() => _encodeCurve(nonEncodable),
            _ => nonEncodable.toString(), //fallback to toString
          };
        },
      ),
  };
}

/// Encodes a [Duration] object to milliseconds as an integer.
@preferInline
int _encodeDuration(Duration duration) => duration.inMilliseconds;

/// Encodes a [Size] object to a list of doubles [width, height].
@preferInline
List<double> _encodeSize(Size size) => [size.width, size.height];

/// Encodes [EdgeInsets] to a list of doubles [left, top, right, bottom].
@preferInline
List<double> _encodeEdgeInsets(EdgeInsets edgeInsets) => [
      edgeInsets.left,
      edgeInsets.top,
      edgeInsets.right,
      edgeInsets.bottom,
    ];

/// Encodes a [TextStyle] object to a map containing only non-null properties.
@preferInline
Map _encodeTextStyle(TextStyle textStyle) => {
      if (textStyle.color != null) "color": textStyle.color,
      if (textStyle.fontFamily != null) "fontFamily": textStyle.fontFamily,
      if (textStyle.fontWeight != null)
        "fontWeight": textStyle.fontWeight!.value,
      if (textStyle.fontSize != null) "fontSize": textStyle.fontSize,
      if (textStyle.fontStyle != null) "fontStyle": textStyle.fontStyle,
      if (textStyle.overflow != null) "overflow": textStyle.overflow,
      if (textStyle.textBaseline != null)
        "textBaseline": textStyle.textBaseline,
      if (textStyle.height != null) "height": textStyle.height,
      if (textStyle.letterSpacing != null)
        "letterSpacing": textStyle.letterSpacing,
      if (textStyle.wordSpacing != null) "wordSpacing": textStyle.wordSpacing,
      if (textStyle.backgroundColor != null)
        "backgroundColor": textStyle.backgroundColor,
      if (textStyle.decoration != null) "decoration": textStyle.decoration,
      if (textStyle.decorationColor != null)
        "decorationColor": textStyle.decorationColor,
      if (textStyle.decorationStyle != null)
        "decorationStyle": textStyle.decorationStyle,
      if (textStyle.decorationThickness != null)
        "decorationThickness": textStyle.decorationThickness,
      if (textStyle.debugLabel != null) "debugLabel": textStyle.debugLabel,
      if (textStyle.leadingDistribution != null)
        "leadingDistribution": textStyle.leadingDistribution,
    };

//TODO: Remove deprecated_member_use when v3.24.x is no longer supported
/// Encodes a [Color] object to a hex string with alpha channel.
@preferInline
String _encodeColor(Color color) =>
    // ignore: deprecated_member_use
    "#${color.value.toRadixString(16).padLeft(8, '0')}";

/// Encodes a [LinearGradient] object to a map with colors, stops, begin, end, and transform.
@preferInline
Map _encodeGradient(LinearGradient gradient) => {
      "colors": gradient.colors,
      "stops": gradient.stops,
      "begin": gradient.begin,
      "end": gradient.end,
      if (gradient.transform != null)
        "transform": gradient.transform is GradientRotation
            ? (gradient.transform! as GradientRotation).radians
            : gradient.transform.toString(),
    };

/// Encodes a [BoxShadow] object to a map with color, offset, blurRadius, and spreadRadius.
@preferInline
Map _encodeBoxShadow(BoxShadow boxShadow) => {
      "color": boxShadow.color,
      "offset": boxShadow.offset,
      "blurRadius": boxShadow.blurRadius,
      "spreadRadius": boxShadow.spreadRadius,
    };

/// Encodes an [Offset] object to a map with dx and dy coordinates.
@preferInline
Map _encodeOffset(Offset offset) => {
      "dx": offset.dx,
      "dy": offset.dy,
    };

/// Encodes a [BoxDecoration] object to a map with non-null decoration properties.
@preferInline
Map _encodeDecoration(BoxDecoration decoration) => {
      if (decoration.color != null) "color": decoration.color,
      if (decoration.borderRadius != null)
        "borderRadius": decoration.borderRadius,
      if (decoration.border != null) "border": decoration.border,
      if (decoration.gradient != null) "gradient": decoration.gradient,
      if (decoration.boxShadow != null) "boxShadow": decoration.boxShadow,
    };

/// Encodes a [Border] object to a map with side properties.
@preferInline
Map _encodeBorder(Border border) => {
      "side": {
        "color": border.top.color,
        "width": border.top.width,
        "style": border.top.style,
      },
    };

/// Encodes an [InputBorder] object to a map with type, borderSide, and optional properties.
Map _encodeInputBorder(InputBorder inputBorder) => {
      "type": switch (inputBorder) {
        OutlineInputBorder() => "outline",
        UnderlineInputBorder() => "underline",
        _ => "outline",
      },
      "borderSide": {
        "color": inputBorder.borderSide.color,
        "width": inputBorder.borderSide.width,
        "style": inputBorder.borderSide.style,
      },
      if (inputBorder is OutlineInputBorder) ...{
        "gapPadding": inputBorder.gapPadding,
        "borderRadius": inputBorder.borderRadius,
      },
    };

/// Encodes an [InputDecoration] object to a map with all non-null decoration properties.
@preferInline
Map _encodeInputDecoration(InputDecoration inputDecoration) => {
      if (inputDecoration.labelText != null)
        "labelText": inputDecoration.labelText,
      if (inputDecoration.labelStyle != null)
        "labelStyle": inputDecoration.labelStyle,
      if (inputDecoration.floatingLabelStyle != null)
        "floatingLabelStyle": inputDecoration.floatingLabelStyle,
      if (inputDecoration.helperText != null)
        "helperText": inputDecoration.helperText,
      if (inputDecoration.helperMaxLines != null)
        "helperMaxLines": inputDecoration.helperMaxLines,
      if (inputDecoration.helperStyle != null)
        "helperStyle": inputDecoration.helperStyle,
      if (inputDecoration.hintText != null)
        "hintText": inputDecoration.hintText,
      if (inputDecoration.hintStyle != null)
        "hintStyle": inputDecoration.hintStyle,
      if (inputDecoration.hintMaxLines != null)
        "hintMaxLines": inputDecoration.hintMaxLines,
      if (inputDecoration.errorText != null)
        "errorText": inputDecoration.errorText,
      if (inputDecoration.errorMaxLines != null)
        "errorMaxLines": inputDecoration.errorMaxLines,
      if (inputDecoration.errorStyle != null)
        "errorStyle": inputDecoration.errorStyle,
      if (inputDecoration.enabledBorder != null)
        "enabledBorder": inputDecoration.enabledBorder,
      if (inputDecoration.border != null) "border": inputDecoration.border,
      if (inputDecoration.errorBorder != null)
        "errorBorder": inputDecoration.errorBorder,
      if (inputDecoration.focusedBorder != null)
        "focusedBorder": inputDecoration.focusedBorder,
      if (inputDecoration.focusedErrorBorder != null)
        "focusedErrorBorder": inputDecoration.focusedErrorBorder,
      "enabled": inputDecoration.enabled,
      if (inputDecoration.isCollapsed != null)
        "isCollapsed": inputDecoration.isCollapsed,
      if (inputDecoration.isDense != null) "isDense": inputDecoration.isDense,
      if (inputDecoration.contentPadding != null)
        "contentPadding": inputDecoration.contentPadding,
      if (inputDecoration.prefixIcon != null)
        "prefixIcon": inputDecoration.prefixIcon,
      if (inputDecoration.prefixIconColor != null)
        "prefixIconColor": inputDecoration.prefixIconColor,
      if (inputDecoration.suffixIcon != null)
        "suffixIcon": inputDecoration.suffixIcon,
      if (inputDecoration.suffixIconColor != null)
        "suffixIconColor": inputDecoration.suffixIconColor,
    };

/// Encodes a [VisualDensity] object to a map with horizontal and vertical values.
@preferInline
Map _encodeVisualDensity(VisualDensity visualDensity) => {
      "horizontal": visualDensity.horizontal,
      "vertical": visualDensity.vertical,
    };

/// Encodes a [ScrollPhysics] object to its runtime type name as a string.
@preferInline
String _encodeScrollPhysics(ScrollPhysics scrollPhysics) =>
    scrollPhysics.runtimeType.toString();

/// Extracts the side property from a [ShapeBorder] object.
@preferInline
BorderSide? _getSide(ShapeBorder shapeBorder) => switch (shapeBorder) {
      RoundedRectangleBorder() => shapeBorder.side,
      BeveledRectangleBorder() => shapeBorder.side,
      ContinuousRectangleBorder() => shapeBorder.side,
      StadiumBorder() => shapeBorder.side,
      CircleBorder() => shapeBorder.side,
      _ => null,
    };

/// Extracts the border radius from a [ShapeBorder] object.
@preferInline
BorderRadius? _getBorderRadius(ShapeBorder shapeBorder) =>
    switch (shapeBorder) {
      RoundedRectangleBorder() => shapeBorder.borderRadius.resolve(null),
      BeveledRectangleBorder() => shapeBorder.borderRadius.resolve(null),
      ContinuousRectangleBorder() => shapeBorder.borderRadius.resolve(null),
      _ => null,
    };

/// Encodes a [BorderSide] object to a map with color, width, and style.
@preferInline
Map _encodeBorderSide(BorderSide borderSide) => {
      "color": borderSide.color,
      "width": borderSide.width,
      "style": borderSide.style,
    };

/// Encodes a [ShapeBorder] object to a map with type, side, and borderRadius.
@preferInline
Map _encodeShapeBorder(ShapeBorder shapeBorder) {
  final radius = _getBorderRadius(shapeBorder);
  final side = _getSide(shapeBorder);

  return {
    "type": shapeBorder.runtimeType.toString(),
    if (side != null) "side": side,
    if (radius != null) "borderRadius": radius,
  };
}

/// Encodes a [Radius] object to a [double] value.
///
/// Since this project always uses [Radius.circular], both x and y values
/// are identical. Therefore, using radius.x is equivalent to radius.y
/// and provides the circular radius value.
@preferInline
double _encodeRadius(BorderRadius radius) => radius.bottomLeft.x;

/// Encodes a [WidgetStateProperty] object to a map with resolved state values.
@preferInline
Map _encodeWidgetStateProperty(WidgetStateProperty widgetStateProperty) {
  final disabled = widgetStateProperty.resolve({WidgetState.disabled});
  final error = widgetStateProperty.resolve({WidgetState.error});
  final selected = widgetStateProperty.resolve({WidgetState.selected});
  final pressed = widgetStateProperty.resolve({WidgetState.pressed});
  final hovered = widgetStateProperty.resolve({WidgetState.hovered});
  final focused = widgetStateProperty.resolve({WidgetState.focused});
  final dragged = widgetStateProperty.resolve({WidgetState.dragged});
  return {
    if (disabled != null) "disabled": disabled,
    if (error != null) "error": error,
    if (selected != null) "selected": selected,
    if (pressed != null) "pressed": pressed,
    if (hovered != null) "hovered": hovered,
    if (focused != null) "focused": focused,
    if (dragged != null) "dragged": dragged,
  };
}

/// Encodes a [ButtonStyle] object to a map with all non-null style properties.
@preferInline
Map _encodeButtonStyle(ButtonStyle buttonStyle) => {
      if (buttonStyle.textStyle != null) "textStyle": buttonStyle.textStyle,
      if (buttonStyle.backgroundColor != null)
        "backgroundColor": buttonStyle.backgroundColor,
      if (buttonStyle.foregroundColor != null)
        "foregroundColor": buttonStyle.foregroundColor,
      if (buttonStyle.overlayColor != null)
        "overlayColor": buttonStyle.overlayColor,
      if (buttonStyle.shadowColor != null)
        "shadowColor": buttonStyle.shadowColor,
      if (buttonStyle.surfaceTintColor != null)
        "surfaceTintColor": buttonStyle.surfaceTintColor,
      if (buttonStyle.elevation != null) "elevation": buttonStyle.elevation,
      if (buttonStyle.padding != null) "padding": buttonStyle.padding,
      if (buttonStyle.minimumSize != null)
        "minimumSize": buttonStyle.minimumSize,
      if (buttonStyle.maximumSize != null)
        "maximumSize": buttonStyle.maximumSize,
      if (buttonStyle.iconColor != null) "iconColor": buttonStyle.iconColor,
      if (buttonStyle.iconSize != null) "iconSize": buttonStyle.iconSize,
      if (buttonStyle.side != null) "side": buttonStyle.side,
      if (buttonStyle.shape != null) "shape": buttonStyle.shape,
      if (buttonStyle.visualDensity != null)
        "visualDensity": buttonStyle.visualDensity,
      if (buttonStyle.tapTargetSize != null)
        "tapTargetSize": buttonStyle.tapTargetSize,
      if (buttonStyle.animationDuration != null)
        "animationDuration": buttonStyle.animationDuration,
      if (buttonStyle.enableFeedback != null)
        "enableFeedback": buttonStyle.enableFeedback,
      if (buttonStyle.alignment != null) "alignment": buttonStyle.alignment,
    };

/// Encodes an [AnimationInterval] object to a map with begin and end values.
@preferInline
Map _encodeAnimationInterval(AnimationInterval animationInterval) => {
      "begin": animationInterval.begin,
      "end": animationInterval.end,
    };

/// Encodes a [DuitTweenDescription] object using its toJson() method.
@preferInline
Map _encodeTweenDescription(DuitTweenDescription tweenDescription) =>
    tweenDescription.toJson();

/// Maps Flutter [Curve] objects to their string representations.
const _curveToStringMap = <Curve, String>{
  Curves.linear: "linear",
  Curves.fastEaseInToSlowEaseOut: "fastEaseInToSlowEaseOut",
  Curves.bounceIn: "bounceIn",
  Curves.bounceInOut: "bounceInOut",
  Curves.bounceOut: "bounceOut",
  Curves.decelerate: "decelerate",
  Curves.ease: "ease",
  Curves.easeIn: "easeIn",
  Curves.easeInBack: "easeInBack",
  Curves.easeInCirc: "easeInCirc",
  Curves.easeInSine: "easeInSine",
  Curves.easeInCubic: "easeInCubic",
  Curves.easeInExpo: "easeInExpo",
  Curves.easeInOutCubicEmphasized: "easeInOutCubicEmphasized",
  Curves.easeInOutBack: "easeInOutBack",
  Curves.easeInOutCirc: "easeInOutCirc",
  Curves.easeInOutExpo: "easeInOutExpo",
  Curves.easeInOutQuad: "easeInOutQuad",
  Curves.easeInOutQuart: "easeInOutQuart",
  Curves.easeInOutQuint: "easeInOutQuint",
  Curves.easeInOutSine: "easeInOutSine",
  Curves.easeInToLinear: "easeInToLinear",
  Curves.easeOutSine: "easeOutSine",
  Curves.easeOutBack: "easeOutBack",
  Curves.easeOutCirc: "easeOutCirc",
  Curves.easeOutCubic: "easeOutCubic",
  Curves.easeOutExpo: "easeOutExpo",
  Curves.easeOutQuad: "easeOutQuad",
  Curves.easeOutQuart: "easeOutQuart",
  Curves.easeOutQuint: "easeOutQuint",
  Curves.linearToEaseOut: "linearToEaseOut",
  Curves.slowMiddle: "slowMiddle",
  Curves.fastOutSlowIn: "fastOutSlowIn",
  Curves.elasticIn: "elasticIn",
  Curves.elasticInOut: "elasticInOut",
  Curves.elasticOut: "elasticOut",
};

/// Encodes a [Curve] object to its string representation, defaulting to 'linear'.
@preferInline
String _encodeCurve(Curve curve) => _curveToStringMap[curve] ?? "linear";
