import 'dart:convert' as conv;

import 'package:duit_kernel/src/misc/annotations.dart';
import 'package:flutter/material.dart';

String jsonEncode(Object? object) {
  return switch (object) {
    TextInputType() => object.toJson()['name'],
    _ => conv.jsonEncode(object, toEncodable: (nonEncodable) {
        return switch (nonEncodable) {
          Duration() => _encodeDuration(nonEncodable),
          Size() => _encodeSize(nonEncodable),
          EdgeInsets() => _encodeEdgeInsets(nonEncodable),
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
          _ => nonEncodable.toString(),
        };
      }),
  };
}

@preferInline
int _encodeDuration(Duration duration) => duration.inMilliseconds;

@preferInline
List _encodeSize(Size size) => [size.width, size.height];

@preferInline
List _encodeEdgeInsets(EdgeInsets edgeInsets) => [
      edgeInsets.left,
      edgeInsets.top,
      edgeInsets.right,
      edgeInsets.bottom,
    ];

@preferInline
Map _encodeTextStyle(TextStyle textStyle) => {
      if (textStyle.color != null) 'color': textStyle.color,
      if (textStyle.fontFamily != null) 'fontFamily': textStyle.fontFamily,
      if (textStyle.fontWeight != null) 'fontWeight': textStyle.fontWeight,
      if (textStyle.fontSize != null) 'fontSize': textStyle.fontSize,
      if (textStyle.fontStyle != null) 'fontStyle': textStyle.fontStyle,
      if (textStyle.overflow != null) 'overflow': textStyle.overflow,
      if (textStyle.textBaseline != null)
        'textBaseline': textStyle.textBaseline,
      if (textStyle.height != null) 'height': textStyle.height,
      if (textStyle.letterSpacing != null)
        'letterSpacing': textStyle.letterSpacing,
      if (textStyle.wordSpacing != null) 'wordSpacing': textStyle.wordSpacing,
      if (textStyle.backgroundColor != null)
        'backgroundColor': textStyle.backgroundColor,
      if (textStyle.decoration != null) 'decoration': textStyle.decoration,
      if (textStyle.decorationColor != null)
        'decorationColor': textStyle.decorationColor,
      if (textStyle.decorationStyle != null)
        'decorationStyle': textStyle.decorationStyle,
      if (textStyle.decorationThickness != null)
        'decorationThickness': textStyle.decorationThickness,
      if (textStyle.debugLabel != null) 'debugLabel': textStyle.debugLabel,
      if (textStyle.leadingDistribution != null)
        'leadingDistribution': textStyle.leadingDistribution,
    };

@preferInline
String _encodeColor(Color color) => "#${color.value.toRadixString(16)}";

@preferInline
Map _encodeGradient(LinearGradient gradient) => {
      'colors': gradient.colors,
      'stops': gradient.stops,
      'begin': gradient.begin,
      'end': gradient.end,
      if (gradient.transform != null)
        'transform': (gradient.transform as GradientRotation).radians,
    };

@preferInline
Map _encodeBoxShadow(BoxShadow boxShadow) => {
      'color': boxShadow.color,
      'offset': boxShadow.offset,
      'blurRadius': boxShadow.blurRadius,
      'spreadRadius': boxShadow.spreadRadius,
    };

@preferInline
Map _encodeOffset(Offset offset) => {
      "dx": offset.dx,
      "dy": offset.dy,
    };

@preferInline
Map _encodeDecoration(BoxDecoration decoration) => {
      if (decoration.color != null) 'color': decoration.color,
      if (decoration.borderRadius != null)
        'borderRadius': decoration.borderRadius,
      if (decoration.border != null) 'border': decoration.border,
      if (decoration.gradient != null) 'gradient': decoration.gradient,
      if (decoration.boxShadow != null) 'boxShadow': decoration.boxShadow,
    };

@preferInline
Map _encodeBorder(Border border) => {
      "side": {
        "color": border.top.color,
        "width": border.top.width,
        "style": border.top.style,
      }
    };

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
      if (inputBorder is OutlineInputBorder)
        "gapPadding": inputBorder.gapPadding,
      if (inputBorder is OutlineInputBorder)
        //Circular border radius, use any value for now
        "borderRadius": inputBorder.borderRadius.resolve(null).bottomLeft,
    };

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

@preferInline
Map _encodeVisualDensity(VisualDensity visualDensity) => {
      "horizontal": visualDensity.horizontal,
      "vertical": visualDensity.vertical,
    };

@preferInline
String _encodeScrollPhysics(ScrollPhysics scrollPhysics) =>
    scrollPhysics.runtimeType.toString();

@preferInline
BorderSide? _getSide(ShapeBorder shapeBorder) => switch (shapeBorder) {
      RoundedRectangleBorder() => shapeBorder.side,
      BeveledRectangleBorder() => shapeBorder.side,
      ContinuousRectangleBorder() => shapeBorder.side,
      StadiumBorder() => shapeBorder.side,
      CircleBorder() => shapeBorder.side,
      _ => null,
    };

@preferInline
BorderRadius? _getBorderRadius(ShapeBorder shapeBorder) =>
    switch (shapeBorder) {
      RoundedRectangleBorder() => shapeBorder.borderRadius.resolve(null),
      BeveledRectangleBorder() => shapeBorder.borderRadius.resolve(null),
      ContinuousRectangleBorder() => shapeBorder.borderRadius.resolve(null),
      _ => null,
    };

@preferInline
Map _encodeBorderSide(BorderSide borderSide) => {
      "color": borderSide.color,
      "width": borderSide.width,
      "style": borderSide.style,
    };

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

//NOTE: extend to support all types of radii and sides

/// Encodes a [Radius] object to a [double] value.
///
/// Since this project always uses [Radius.circular], both x and y values
/// are identical. Therefore, using radius.x is equivalent to radius.y
/// and provides the circular radius value.
@preferInline
double _encodeRadius(BorderRadius radius) => radius.bottomLeft.x;

//NOTE: остановился на widgetStateProperty