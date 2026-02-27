part of "data_source.dart";

/// Lookup table for [TextAlign] values by [int] type key.
///
/// Maps integer identifiers to [TextAlign] enum values for text alignment.
/// Supported values: 0 (left), 1 (right), 2 (center), 3 (justify), 4 (start), 5 (end).
const _textAlignIntLookupTable = <int, TextAlign>{
  0: TextAlign.left,
  1: TextAlign.right,
  2: TextAlign.center,
  3: TextAlign.justify,
  4: TextAlign.start,
  5: TextAlign.end,
};

/// Lookup table for [TextAlign] values by [String] type key.
///
/// Maps string identifiers to [TextAlign] enum values for text alignment.
/// Supported values: "left", "right", "center", "justify", "start", "end".
const _textAlignStringLookupTable = <String, TextAlign>{
  "left": TextAlign.left,
  "TextAlign.left": TextAlign.left,
  "right": TextAlign.right,
  "TextAlign.right": TextAlign.right,
  "center": TextAlign.center,
  "TextAlign.center": TextAlign.center,
  "justify": TextAlign.justify,
  "TextAlign.justify": TextAlign.justify,
  "start": TextAlign.start,
  "TextAlign.start": TextAlign.start,
  "end": TextAlign.end,
  "TextAlign.end": TextAlign.end,
};

/// Lookup table for [TextDirection] values by [String] type key.
///
/// Maps string identifiers to [TextDirection] enum values for text direction.
/// Supported values: "ltr" (left-to-right), "rtl" (right-to-left).
const _textDirectionStringLookupTable = <String, TextDirection>{
  "ltr": TextDirection.ltr,
  "TextDirection.ltr": TextDirection.ltr,
  "rtl": TextDirection.rtl,
  "TextDirection.rtl": TextDirection.rtl,
};

/// Lookup table for [TextDirection] values by [int] type key.
///
/// Maps integer identifiers to [TextDirection] enum values for text direction.
/// Supported values: 0 (ltr), 1 (rtl).
const _textDirectionIntLookupTable = <int, TextDirection>{
  0: TextDirection.ltr,
  1: TextDirection.rtl,
};

/// Lookup table for [FontWeight] values by [int] type key.
///
/// Maps integer identifiers to [FontWeight] enum values for font weight.
/// Supported values: 100-900 (w100-w900).
const _fontWeightLookupTable = <int, FontWeight>{
  100: FontWeight.w100,
  200: FontWeight.w200,
  300: FontWeight.w300,
  400: FontWeight.w400,
  500: FontWeight.w500,
  600: FontWeight.w600,
  700: FontWeight.w700,
  800: FontWeight.w800,
  900: FontWeight.w900,
};

/// Lookup table for [TextOverflow] values by [int] type key.
///
/// Maps integer identifiers to [TextOverflow] enum values for text overflow behavior.
/// Supported values: 0 (clip), 1 (ellipsis), 2 (fade), 3 (visible).
const _textOverflowIntLookupTable = <int, TextOverflow>{
  0: TextOverflow.clip,
  1: TextOverflow.ellipsis,
  2: TextOverflow.fade,
  3: TextOverflow.visible,
};

/// Lookup table for [TextOverflow] values by [String] type key.
///
/// Maps string identifiers to [TextOverflow] enum values for text overflow behavior.
/// Supported values: "clip", "ellipsis", "fade", "visible".
const _textOverflowStringLookupTable = <String, TextOverflow>{
  "clip": TextOverflow.clip,
  "TextOverflow.clip": TextOverflow.clip,
  "ellipsis": TextOverflow.ellipsis,
  "TextOverflow.ellipsis": TextOverflow.ellipsis,
  "fade": TextOverflow.fade,
  "TextOverflow.fade": TextOverflow.fade,
  "visible": TextOverflow.visible,
  "TextOverflow.visible": TextOverflow.visible,
};

/// Lookup table for [Clip] values by [String] type key.
///
/// Maps string identifiers to [Clip] enum values for clipping behavior.
/// Supported values: "hardEdge", "antiAlias", "antiAliasWithSaveLayer", "none".
const _clipStringLookupTable = <String, Clip>{
  "hardEdge": Clip.hardEdge,
  "Clip.hardEdge": Clip.hardEdge,
  "antiAlias": Clip.antiAlias,
  "Clip.antiAlias": Clip.antiAlias,
  "antiAliasWithSaveLayer": Clip.antiAliasWithSaveLayer,
  "Clip.antiAliasWithSaveLayer": Clip.antiAliasWithSaveLayer,
  "none": Clip.none,
  "Clip.none": Clip.none,
};

/// Lookup table for [Clip] values by [int] type key.
///
/// Maps integer identifiers to [Clip] enum values for clipping behavior.
/// Supported values: 0 (hardEdge), 1 (antiAlias), 2 (antiAliasWithSaveLayer), 3 (none).
const _clipIntLookupTable = <int, Clip>{
  0: Clip.hardEdge,
  1: Clip.antiAlias,
  2: Clip.antiAliasWithSaveLayer,
  3: Clip.none,
};

/// Lookup table for [Curve] values by [int] type key.
///
/// Maps integer identifiers to [Curve] values for animation curves.
/// Supported values: 0-41 (various curve types including linear, ease, bounce, etc.).
const _curveIntLookupTable = <int, Curve>{
  0: Curves.linear,
  1: Curves.fastLinearToSlowEaseIn,
  2: Curves.fastEaseInToSlowEaseOut,
  3: Curves.bounceIn,
  4: Curves.bounceInOut,
  5: Curves.bounceOut,
  6: Curves.decelerate,
  7: Curves.ease,
  8: Curves.easeIn,
  9: Curves.easeInBack,
  10: Curves.easeInCirc,
  11: Curves.easeInSine,
  12: Curves.easeInCubic,
  13: Curves.easeInExpo,
  14: Curves.easeInQuad,
  15: Curves.easeInQuart,
  16: Curves.easeInQuint,
  17: Curves.easeOut,
  18: Curves.easeInOut,
  19: Curves.easeInOutBack,
  20: Curves.easeInOutCirc,
  21: Curves.easeInOutExpo,
  22: Curves.easeInOutQuad,
  23: Curves.easeInOutQuart,
  24: Curves.easeInOutQuint,
  25: Curves.easeInOutSine,
  26: Curves.easeInToLinear,
  27: Curves.easeOutSine,
  28: Curves.easeOutBack,
  29: Curves.easeOutCirc,
  30: Curves.easeOutCubic,
  31: Curves.easeOutExpo,
  32: Curves.easeOutQuad,
  33: Curves.easeOutQuart,
  34: Curves.easeOutQuint,
  35: Curves.linearToEaseOut,
  36: Curves.slowMiddle,
  37: Curves.fastOutSlowIn,
  38: Curves.elasticIn,
  39: Curves.elasticInOut,
  40: Curves.elasticOut,
  41: Curves.easeInOutCubicEmphasized,
};

/// Lookup table for [Curve] values by [String] type key.
///
/// Maps string identifiers to [Curve] values for animation curves.
/// Supported values: "linear", "fastLinearToSlowEaseIn", "fastEaseInToSlowEaseOut", "bounceIn", etc.
const _curveStringLookupTable = <String, Curve>{
  "linear": Curves.linear,
  "Curves.linear": Curves.linear,
  "fastLinearToSlowEaseIn": Curves.fastLinearToSlowEaseIn,
  "Curves.fastLinearToSlowEaseIn": Curves.fastLinearToSlowEaseIn,
  "fastEaseInToSlowEaseOut": Curves.fastEaseInToSlowEaseOut,
  "Curves.fastEaseInToSlowEaseOut": Curves.fastEaseInToSlowEaseOut,
  "bounceIn": Curves.bounceIn,
  "Curves.bounceIn": Curves.bounceIn,
  "bounceInOut": Curves.bounceInOut,
  "Curves.bounceInOut": Curves.bounceInOut,
  "bounceOut": Curves.bounceOut,
  "Curves.bounceOut": Curves.bounceOut,
  "decelerate": Curves.decelerate,
  "Curves.decelerate": Curves.decelerate,
  "ease": Curves.ease,
  "Curves.ease": Curves.ease,
  "easeIn": Curves.easeIn,
  "Curves.easeIn": Curves.easeIn,
  "easeInBack": Curves.easeInBack,
  "Curves.easeInBack": Curves.easeInBack,
  "easeInCirc": Curves.easeInCirc,
  "Curves.easeInCirc": Curves.easeInCirc,
  "easeInSine": Curves.easeInSine,
  "Curves.easeInSine": Curves.easeInSine,
  "easeInCubic": Curves.easeInCubic,
  "Curves.easeInCubic": Curves.easeInCubic,
  "easeInExpo": Curves.easeInExpo,
  "Curves.easeInExpo": Curves.easeInExpo,
  "easeInQuad": Curves.easeInQuad,
  "Curves.easeInQuad": Curves.easeInQuad,
  "easeInQuart": Curves.easeInQuart,
  "Curves.easeInQuart": Curves.easeInQuart,
  "easeInQuint": Curves.easeInQuint,
  "Curves.easeInQuint": Curves.easeInQuint,
  "easeOut": Curves.easeOut,
  "Curves.easeOut": Curves.easeOut,
  "easeInOut": Curves.easeInOut,
  "Curves.easeInOut": Curves.easeInOut,
  "easeInOutBack": Curves.easeInOutBack,
  "Curves.easeInOutBack": Curves.easeInOutBack,
  "easeInOutCirc": Curves.easeInOutCirc,
  "Curves.easeInOutCirc": Curves.easeInOutCirc,
  "easeInOutExpo": Curves.easeInOutExpo,
  "Curves.easeInOutExpo": Curves.easeInOutExpo,
  "easeInOutQuad": Curves.easeInOutQuad,
  "Curves.easeInOutQuad": Curves.easeInOutQuad,
  "easeInOutQuart": Curves.easeInOutQuart,
  "Curves.easeInOutQuart": Curves.easeInOutQuart,
  "easeInOutQuint": Curves.easeInOutQuint,
  "Curves.easeInOutQuint": Curves.easeInOutQuint,
  "easeInOutSine": Curves.easeInOutSine,
  "Curves.easeInOutSine": Curves.easeInOutSine,
  "easeInToLinear": Curves.easeInToLinear,
  "Curves.easeInToLinear": Curves.easeInToLinear,
  "easeOutSine": Curves.easeOutSine,
  "Curves.easeOutSine": Curves.easeOutSine,
  "easeOutBack": Curves.easeOutBack,
  "Curves.easeOutBack": Curves.easeOutBack,
  "easeOutCirc": Curves.easeOutCirc,
  "Curves.easeOutCirc": Curves.easeOutCirc,
  "easeOutCubic": Curves.easeOutCubic,
  "Curves.easeOutCubic": Curves.easeOutCubic,
  "easeOutExpo": Curves.easeOutExpo,
  "Curves.easeOutExpo": Curves.easeOutExpo,
  "easeOutQuad": Curves.easeOutQuad,
  "Curves.easeOutQuad": Curves.easeOutQuad,
  "easeOutQuart": Curves.easeOutQuart,
  "Curves.easeOutQuart": Curves.easeOutQuart,
  "easeOutQuint": Curves.easeOutQuint,
  "Curves.easeOutQuint": Curves.easeOutQuint,
  "linearToEaseOut": Curves.linearToEaseOut,
  "Curves.linearToEaseOut": Curves.linearToEaseOut,
  "slowMiddle": Curves.slowMiddle,
  "Curves.slowMiddle": Curves.slowMiddle,
  "fastOutSlowIn": Curves.fastOutSlowIn,
  "Curves.fastOutSlowIn": Curves.fastOutSlowIn,
  "elasticIn": Curves.elasticIn,
  "Curves.elasticIn": Curves.elasticIn,
  "elasticInOut": Curves.elasticInOut,
  "Curves.elasticInOut": Curves.elasticInOut,
  "elasticOut": Curves.elasticOut,
  "Curves.elasticOut": Curves.elasticOut,
  "easeInOutCubicEmphasized": Curves.easeInOutCubicEmphasized,
  "Curves.easeInOutCubicEmphasized": Curves.easeInOutCubicEmphasized,
};

/// Lookup table for mapping custom curve names (as [String]) to their corresponding [CustomCurveParser] factory methods.
///
/// Currently supports:
/// - "slowpoke": parses [SlowpokeCurve] from map data.
const _customCurveStringLookupTable = <String, CustomCurveParser>{
  "slowpoke": SlowpokeCurve.fromMap,
};

/// Lookup table for [FontStyle] values by [int] type key.
///
/// Maps integer identifiers to [FontStyle] enum values for font style.
/// Supported values: 0 (normal), 1 (italic).
const _fontStyleIntLookupTable = <int, FontStyle>{
  0: FontStyle.normal,
  1: FontStyle.italic,
};

/// Lookup table for [FontStyle] values by [String] type key.
///
/// Maps string identifiers to [FontStyle] enum values for font style.
/// Supported values: "normal", "italic".
const _fontStyleStringLookupTable = <String, FontStyle>{
  "normal": FontStyle.normal,
  "FontStyle.normal": FontStyle.normal,
  "italic": FontStyle.italic,
  "FontStyle.italic": FontStyle.italic,
};

/// Lookup table for [TextBaseline] values by [String] type key.
///
/// Maps string identifiers to [TextBaseline] enum values for text baseline.
/// Supported values: "alphabetic", "ideographic".
const _textBaselineStringLookupTable = <String, TextBaseline>{
  "alphabetic": TextBaseline.alphabetic,
  "TextBaseline.alphabetic": TextBaseline.alphabetic,
  "ideographic": TextBaseline.ideographic,
  "TextBaseline.ideographic": TextBaseline.ideographic,
};

/// Lookup table for [TextBaseline] values by [int] type key.
///
/// Maps integer identifiers to [TextBaseline] enum values for text baseline.
/// Supported values: 0 (alphabetic), 1 (ideographic).
const _textBaselineIntLookupTable = <int, TextBaseline>{
  0: TextBaseline.alphabetic,
  1: TextBaseline.ideographic,
};

/// Lookup table for [TextWidthBasis] values by [String] type key.
///
/// Maps string identifiers to [TextWidthBasis] enum values for text width calculation.
/// Supported values: "parent", "longestLine".
const _textWidthBasisStringLookupTable = <String, TextWidthBasis>{
  "parent": TextWidthBasis.parent,
  "TextWidthBasis.parent": TextWidthBasis.parent,
  "longestLine": TextWidthBasis.longestLine,
  "TextWidthBasis.longestLine": TextWidthBasis.longestLine,
};

/// Lookup table for [TextWidthBasis] values by [int] type key.
///
/// Maps integer identifiers to [TextWidthBasis] enum values for text width calculation.
/// Supported values: 0 (parent), 1 (longestLine).
const _textWidthBasisIntLookupTable = <int, TextWidthBasis>{
  0: TextWidthBasis.parent,
  1: TextWidthBasis.longestLine,
};

/// Lookup table for [TextDecoration] values by [String] type key.
///
/// Maps string identifiers to [TextDecoration] enum values for text decoration.
/// Supported values: "none", "underline", "overline", "lineThrough".
const _textDecorationStringLookupTable = <String, TextDecoration>{
  "none": TextDecoration.none,
  "TextDecoration.none": TextDecoration.none,
  "underline": TextDecoration.underline,
  "TextDecoration.underline": TextDecoration.underline,
  "overline": TextDecoration.overline,
  "TextDecoration.overline": TextDecoration.overline,
  "lineThrough": TextDecoration.lineThrough,
  "TextDecoration.lineThrough": TextDecoration.lineThrough,
};

/// Lookup table for [TextDecoration] values by [int] type key.
///
/// Maps integer identifiers to [TextDecoration] enum values for text decoration.
/// Supported values: 0 (none), 1 (underline), 2 (overline), 3 (lineThrough).
const _textDecorationIntLookupTable = <int, TextDecoration>{
  0: TextDecoration.none,
  1: TextDecoration.underline,
  2: TextDecoration.overline,
  3: TextDecoration.lineThrough,
};

/// Lookup table for [TextDecorationStyle] values by [String] type key.
///
/// Maps string identifiers to [TextDecorationStyle] enum values for text decoration style.
/// Supported values: "solid", "double", "dotted", "dashed", "wavy".
const _textDecorationStyleStringLookupTable = <String, TextDecorationStyle>{
  "solid": TextDecorationStyle.solid,
  "TextDecorationStyle.solid": TextDecorationStyle.solid,
  "double": TextDecorationStyle.double,
  "TextDecorationStyle.double": TextDecorationStyle.double,
  "dotted": TextDecorationStyle.dotted,
  "TextDecorationStyle.dotted": TextDecorationStyle.dotted,
  "dashed": TextDecorationStyle.dashed,
  "TextDecorationStyle.dashed": TextDecorationStyle.dashed,
  "wavy": TextDecorationStyle.wavy,
  "TextDecorationStyle.wavy": TextDecorationStyle.wavy,
};

/// Lookup table for [TextDecorationStyle] values by [int] type key.
///
/// Maps integer identifiers to [TextDecorationStyle] enum values for text decoration style.
/// Supported values: 0 (solid), 1 (double), 2 (dotted), 3 (dashed), 4 (wavy).
const _textDecorationStyleIntLookupTable = <int, TextDecorationStyle>{
  0: TextDecorationStyle.solid,
  1: TextDecorationStyle.double,
  2: TextDecorationStyle.dotted,
  3: TextDecorationStyle.dashed,
  4: TextDecorationStyle.wavy,
};

/// Lookup table for [TextLeadingDistribution] values by [String] type key.
///
/// Maps string identifiers to [TextLeadingDistribution] enum values for text leading distribution.
/// Supported values: "proportional", "even".
const _leadingDistributionStringLookupTable = <String, TextLeadingDistribution>{
  "proportional": TextLeadingDistribution.proportional,
  "TextLeadingDistribution.proportional": TextLeadingDistribution.proportional,
  "even": TextLeadingDistribution.even,
  "TextLeadingDistribution.even": TextLeadingDistribution.even,
};

/// Lookup table for [TextLeadingDistribution] values by [int] type key.
///
/// Maps integer identifiers to [TextLeadingDistribution] enum values for text leading distribution.
/// Supported values: 0 (proportional), 1 (even).
const _leadingDistributionIntLookupTable = <int, TextLeadingDistribution>{
  0: TextLeadingDistribution.proportional,
  1: TextLeadingDistribution.even,
};

/// Lookup table for [Axis] values by [String] type key.
///
/// Maps string identifiers to [Axis] enum values for layout direction.
/// Supported values: "vertical", "horizontal".
const _axisStringLookupTable = <String, Axis>{
  "vertical": Axis.vertical,
  "Axis.vertical": Axis.vertical,
  "horizontal": Axis.horizontal,
  "Axis.horizontal": Axis.horizontal,
};

/// Lookup table for [Axis] values by [int] type key.
///
/// Maps integer identifiers to [Axis] enum values for layout direction.
/// Supported values: 0 (vertical), 1 (horizontal).
const _axisIntLookupTable = <int, Axis>{
  0: Axis.vertical,
  1: Axis.horizontal,
};

/// Lookup table for [WrapCrossAlignment] values by [int] type key.
///
/// Maps integer identifiers to [WrapCrossAlignment] enum values for wrap cross alignment.
/// Supported values: 0 (start), 1 (end), 2 (center).
const _wrapCrossAlignmentIntLookupTable = <int, WrapCrossAlignment>{
  0: WrapCrossAlignment.start,
  1: WrapCrossAlignment.end,
  2: WrapCrossAlignment.center,
};

/// Lookup table for [WrapCrossAlignment] values by [String] type key.
///
/// Maps string identifiers to [WrapCrossAlignment] enum values for wrap cross alignment.
/// Supported values: "start", "end", "center".
const _wrapCrossAlignmentStringLookupTable = <String, WrapCrossAlignment>{
  "start": WrapCrossAlignment.start,
  "WrapCrossAlignment.start": WrapCrossAlignment.start,
  "end": WrapCrossAlignment.end,
  "WrapCrossAlignment.end": WrapCrossAlignment.end,
  "center": WrapCrossAlignment.center,
  "WrapCrossAlignment.center": WrapCrossAlignment.center,
};

/// Lookup table for [WrapAlignment] values by [int] type key.
///
/// Maps integer identifiers to [WrapAlignment] enum values for wrap alignment.
/// Supported values: 0 (start), 1 (end), 2 (center), 3 (spaceBetween), 4 (spaceAround), 5 (spaceEvenly).
const _wrapAlignmentIntLookupTable = <int, WrapAlignment>{
  0: WrapAlignment.start,
  1: WrapAlignment.end,
  2: WrapAlignment.center,
  3: WrapAlignment.spaceBetween,
  4: WrapAlignment.spaceAround,
  5: WrapAlignment.spaceEvenly,
};

/// Lookup table for [WrapAlignment] values by [String] type key.
///
/// Maps string identifiers to [WrapAlignment] enum values for wrap alignment.
/// Supported values: "start", "end", "center", "spaceBetween", "spaceAround", "spaceEvenly".
const _wrapAlignmentStringLookupTable = <String, WrapAlignment>{
  "start": WrapAlignment.start,
  "WrapAlignment.start": WrapAlignment.start,
  "end": WrapAlignment.end,
  "WrapAlignment.end": WrapAlignment.end,
  "center": WrapAlignment.center,
  "WrapAlignment.center": WrapAlignment.center,
  "spaceBetween": WrapAlignment.spaceBetween,
  "WrapAlignment.spaceBetween": WrapAlignment.spaceBetween,
  "spaceAround": WrapAlignment.spaceAround,
  "WrapAlignment.spaceAround": WrapAlignment.spaceAround,
  "spaceEvenly": WrapAlignment.spaceEvenly,
  "WrapAlignment.spaceEvenly": WrapAlignment.spaceEvenly,
};

/// Lookup table for [StackFit] values by [int] type key.
///
/// Maps integer identifiers to [StackFit] enum values for stack fit behavior.
/// Supported values: 0 (expand), 1 (passthrough), 2 (loose).
const _stackFitIntLookupTable = <int, StackFit>{
  0: StackFit.expand,
  1: StackFit.passthrough,
  2: StackFit.loose,
};

/// Lookup table for [StackFit] values by [String] type key.
///
/// Maps string identifiers to [StackFit] enum values for stack fit behavior.
/// Supported values: "expand", "passthrough", "loose".
const _stackFitStringLookupTable = <String, StackFit>{
  "expand": StackFit.expand,
  "StackFit.expand": StackFit.expand,
  "passthrough": StackFit.passthrough,
  "StackFit.passthrough": StackFit.passthrough,
  "loose": StackFit.loose,
  "StackFit.loose": StackFit.loose,
};

/// Lookup table for [OverflowBoxFit] values by [int] type key.
///
/// Maps integer identifiers to [OverflowBoxFit] enum values for overflow box fit behavior.
/// Supported values: 0 (max), 1 (deferToChild).
const _overflowBoxFitIntLookupTable = <int, OverflowBoxFit>{
  0: OverflowBoxFit.max,
  1: OverflowBoxFit.deferToChild,
};

/// Lookup table for [OverflowBoxFit] values by [String] type key.
///
/// Maps string identifiers to [OverflowBoxFit] enum values for overflow box fit behavior.
/// Supported values: "max", "deferToChild".
const _overflowBoxFitStringLookupTable = <String, OverflowBoxFit>{
  "max": OverflowBoxFit.max,
  "OverflowBoxFit.max": OverflowBoxFit.max,
  "deferToChild": OverflowBoxFit.deferToChild,
  "OverflowBoxFit.deferToChild": OverflowBoxFit.deferToChild,
};

/// Lookup table for [Alignment] values by [int] type key.
///
/// Maps integer identifiers to [Alignment] values for widget alignment.
/// Supported values: 0-8 (topCenter, topLeft, topRight, centerLeft, center, centerRight, bottomLeft, bottomCenter, bottomRight).
const _alignmentIntLookupTable = <int, Alignment>{
  0: Alignment.topCenter,
  1: Alignment.topLeft,
  2: Alignment.topRight,
  3: Alignment.centerLeft,
  4: Alignment.center,
  5: Alignment.centerRight,
  6: Alignment.bottomLeft,
  7: Alignment.bottomCenter,
  8: Alignment.bottomRight,
};

/// Lookup table for [Alignment] values by [String] type key.
///
/// Maps string identifiers to [Alignment] values for widget alignment.
/// Supported values: "topCenter", "topLeft", "topRight", "centerLeft", "center", "centerRight", "bottomLeft", "bottomCenter", "bottomRight".
const _alignmentStringLookupTable = <String, Alignment>{
  "topCenter": Alignment.topCenter,
  "Alignment.topCenter": Alignment.topCenter,
  "topLeft": Alignment.topLeft,
  "Alignment.topLeft": Alignment.topLeft,
  "topRight": Alignment.topRight,
  "Alignment.topRight": Alignment.topRight,
  "centerLeft": Alignment.centerLeft,
  "Alignment.centerLeft": Alignment.centerLeft,
  "center": Alignment.center,
  "Alignment.center": Alignment.center,
  "centerRight": Alignment.centerRight,
  "Alignment.centerRight": Alignment.centerRight,
  "bottomLeft": Alignment.bottomLeft,
  "Alignment.bottomLeft": Alignment.bottomLeft,
  "bottomCenter": Alignment.bottomCenter,
  "Alignment.bottomCenter": Alignment.bottomCenter,
  "bottomRight": Alignment.bottomRight,
  "Alignment.bottomRight": Alignment.bottomRight,
};

/// Lookup table for [AlignmentDirectional] values by [int] type key.
///
/// Maps integer identifiers to [AlignmentDirectional] values for directional alignment.
/// Supported values: 0-8 (topStart, topCenter, topEnd, bottomCenter, bottomEnd, bottomStart, center, centerStart, centerEnd).
const _alignmentDirectionalIntLookupTable = <int, AlignmentDirectional>{
  0: AlignmentDirectional.topStart,
  1: AlignmentDirectional.topCenter,
  2: AlignmentDirectional.topEnd,
  3: AlignmentDirectional.bottomCenter,
  4: AlignmentDirectional.bottomEnd,
  5: AlignmentDirectional.bottomStart,
  6: AlignmentDirectional.center,
  7: AlignmentDirectional.centerStart,
  8: AlignmentDirectional.centerEnd,
};

/// Lookup table for [AlignmentDirectional] values by [String] type key.
///
/// Maps string identifiers to [AlignmentDirectional] values for directional alignment.
/// Supported values: "topStart", "topCenter", "topEnd", "bottomCenter", "bottomEnd", "bottomStart", "center", "centerStart", "centerEnd".
const _alignmentDirectionalStringLookupTable = <String, AlignmentDirectional>{
  "topStart": AlignmentDirectional.topStart,
  "AlignmentDirectional.topStart": AlignmentDirectional.topStart,
  "topCenter": AlignmentDirectional.topCenter,
  "AlignmentDirectional.topCenter": AlignmentDirectional.topCenter,
  "topEnd": AlignmentDirectional.topEnd,
  "AlignmentDirectional.topEnd": AlignmentDirectional.topEnd,
  "bottomCenter": AlignmentDirectional.bottomCenter,
  "AlignmentDirectional.bottomCenter": AlignmentDirectional.bottomCenter,
  "bottomEnd": AlignmentDirectional.bottomEnd,
  "AlignmentDirectional.bottomEnd": AlignmentDirectional.bottomEnd,
  "bottomStart": AlignmentDirectional.bottomStart,
  "AlignmentDirectional.bottomStart": AlignmentDirectional.bottomStart,
  "center": AlignmentDirectional.center,
  "AlignmentDirectional.center": AlignmentDirectional.center,
  "centerStart": AlignmentDirectional.centerStart,
  "AlignmentDirectional.centerStart": AlignmentDirectional.centerStart,
  "centerEnd": AlignmentDirectional.centerEnd,
  "AlignmentDirectional.centerEnd": AlignmentDirectional.centerEnd,
};

/// Lookup table for [MainAxisAlignment] values by [int] type key.
///
/// Maps integer identifiers to [MainAxisAlignment] enum values for main axis alignment.
/// Supported values: 0 (start), 1 (end), 2 (center), 3 (spaceBetween), 4 (spaceAround), 5 (spaceEvenly).
const _mainAxisAlignmentIntLookupTable = <int, MainAxisAlignment>{
  0: MainAxisAlignment.start,
  1: MainAxisAlignment.end,
  2: MainAxisAlignment.center,
  3: MainAxisAlignment.spaceBetween,
  4: MainAxisAlignment.spaceAround,
  5: MainAxisAlignment.spaceEvenly,
};

/// Lookup table for [MainAxisAlignment] values by [String] type key.
///
/// Maps string identifiers to [MainAxisAlignment] enum values for main axis alignment.
/// Supported values: "start", "end", "center", "spaceBetween", "spaceAround", "spaceEvenly".
const _mainAxisAlignmentStringLookupTable = <String, MainAxisAlignment>{
  "start": MainAxisAlignment.start,
  "MainAxisAlignment.start": MainAxisAlignment.start,
  "end": MainAxisAlignment.end,
  "MainAxisAlignment.end": MainAxisAlignment.end,
  "center": MainAxisAlignment.center,
  "MainAxisAlignment.center": MainAxisAlignment.center,
  "spaceBetween": MainAxisAlignment.spaceBetween,
  "MainAxisAlignment.spaceBetween": MainAxisAlignment.spaceBetween,
  "spaceAround": MainAxisAlignment.spaceAround,
  "MainAxisAlignment.spaceAround": MainAxisAlignment.spaceAround,
  "spaceEvenly": MainAxisAlignment.spaceEvenly,
  "MainAxisAlignment.spaceEvenly": MainAxisAlignment.spaceEvenly,
};

/// Lookup table for [CrossAxisAlignment] values by [int] type key.
///
/// Maps integer identifiers to [CrossAxisAlignment] enum values for cross axis alignment.
/// Supported values: 0 (start), 1 (end), 2 (center), 3 (stretch), 4 (baseline).
const _crossAxisAlignmentIntLookupTable = <int, CrossAxisAlignment>{
  0: CrossAxisAlignment.start,
  1: CrossAxisAlignment.end,
  2: CrossAxisAlignment.center,
  3: CrossAxisAlignment.stretch,
  4: CrossAxisAlignment.baseline,
};

/// Lookup table for [CrossAxisAlignment] values by [String] type key.
///
/// Maps string identifiers to [CrossAxisAlignment] enum values for cross axis alignment.
/// Supported values: "start", "end", "center", "stretch", "baseline".
const _crossAxisAlignmentStringLookupTable = <String, CrossAxisAlignment>{
  "start": CrossAxisAlignment.start,
  "CrossAxisAlignment.start": CrossAxisAlignment.start,
  "end": CrossAxisAlignment.end,
  "CrossAxisAlignment.end": CrossAxisAlignment.end,
  "center": CrossAxisAlignment.center,
  "CrossAxisAlignment.center": CrossAxisAlignment.center,
  "stretch": CrossAxisAlignment.stretch,
  "CrossAxisAlignment.stretch": CrossAxisAlignment.stretch,
  "baseline": CrossAxisAlignment.baseline,
  "CrossAxisAlignment.baseline": CrossAxisAlignment.baseline,
};

/// Lookup table for [MainAxisSize] values by [int] type key.
///
/// Maps integer identifiers to [MainAxisSize] enum values for main axis size.
/// Supported values: 0 (min), 1 (max).
const _mainAxisSizeIntLookupTable = <int, MainAxisSize>{
  0: MainAxisSize.min,
  1: MainAxisSize.max,
};

/// Lookup table for [MainAxisSize] values by [String] type key.
///
/// Maps string identifiers to [MainAxisSize] enum values for main axis size.
/// Supported values: "min", "max".
const _mainAxisSizeStringLookupTable = <String, MainAxisSize>{
  "min": MainAxisSize.min,
  "MainAxisSize.min": MainAxisSize.min,
  "max": MainAxisSize.max,
  "MainAxisSize.max": MainAxisSize.max,
};

/// Lookup table for [SliderInteraction] values by [int] type key.
///
/// Maps integer identifiers to [SliderInteraction] enum values for slider interaction behavior.
/// Supported values: 0 (tapOnly), 1 (tapAndSlide), 2 (slideOnly), 3 (slideThumb).
const _sliderInteractionIntLookupTable = <int, SliderInteraction>{
  0: SliderInteraction.tapOnly,
  1: SliderInteraction.tapAndSlide,
  2: SliderInteraction.slideOnly,
  3: SliderInteraction.slideThumb,
};

/// Lookup table for [SliderInteraction] values by [String] type key.
///
/// Maps string identifiers to [SliderInteraction] enum values for slider interaction behavior.
/// Supported values: "tapOnly", "tapAndSlide", "slideOnly", "slideThumb".
const _sliderInteractionStringLookupTable = <String, SliderInteraction>{
  "tapOnly": SliderInteraction.tapOnly,
  "SliderInteraction.tapOnly": SliderInteraction.tapOnly,
  "tapAndSlide": SliderInteraction.tapAndSlide,
  "SliderInteraction.tapAndSlide": SliderInteraction.tapAndSlide,
  "slideOnly": SliderInteraction.slideOnly,
  "SliderInteraction.slideOnly": SliderInteraction.slideOnly,
  "slideThumb": SliderInteraction.slideThumb,
  "SliderInteraction.slideThumb": SliderInteraction.slideThumb,
};

/// Lookup table for [MaterialTapTargetSize] values by [int] type key.
///
/// Maps integer identifiers to [MaterialTapTargetSize] enum values for material tap target size.
/// Supported values: 0 (shrinkWrap), 1 (padded).
const _materialTapTargetSizeIntLookupTable = <int, MaterialTapTargetSize>{
  0: MaterialTapTargetSize.shrinkWrap,
  1: MaterialTapTargetSize.padded,
};

/// Lookup table for [MaterialTapTargetSize] values by [String] type key.
///
/// Maps string identifiers to [MaterialTapTargetSize] enum values for material tap target size.
/// Supported values: "shrinkWrap", "padded".
const _materialTapTargetSizeStringLookupTable = <String, MaterialTapTargetSize>{
  "shrinkWrap": MaterialTapTargetSize.shrinkWrap,
  "MaterialTapTargetSize.shrinkWrap": MaterialTapTargetSize.shrinkWrap,
  "padded": MaterialTapTargetSize.padded,
  "MaterialTapTargetSize.padded": MaterialTapTargetSize.padded,
};

/// Lookup table for [FilterQuality] values by [int] type key.
///
/// Maps integer identifiers to [FilterQuality] enum values for image filter quality.
/// Supported values: 0 (none), 1 (low), 2 (medium), 3 (high).
const _filterQualityIntLookupTable = <int, FilterQuality>{
  0: FilterQuality.none,
  1: FilterQuality.low,
  2: FilterQuality.medium,
  3: FilterQuality.high,
};

/// Lookup table for [FilterQuality] values by [String] type key.
///
/// Maps string identifiers to [FilterQuality] enum values for image filter quality.
/// Supported values: "none", "low", "medium", "high".
const _filterQualityStringLookupTable = <String, FilterQuality>{
  "none": FilterQuality.none,
  "FilterQuality.none": FilterQuality.none,
  "low": FilterQuality.low,
  "FilterQuality.low": FilterQuality.low,
  "medium": FilterQuality.medium,
  "FilterQuality.medium": FilterQuality.medium,
  "high": FilterQuality.high,
  "FilterQuality.high": FilterQuality.high,
};

/// Lookup table for [ImageRepeat] values by [int] type key.
///
/// Maps integer identifiers to [ImageRepeat] enum values for image repeat behavior.
/// Supported values: 0 (repeat), 1 (repeatX), 2 (repeatY), 3 (noRepeat).
const _imageRepeatIntLookupTable = <int, ImageRepeat>{
  0: ImageRepeat.repeat,
  1: ImageRepeat.repeatX,
  2: ImageRepeat.repeatY,
  3: ImageRepeat.noRepeat,
};

/// Lookup table for [ImageRepeat] values by [String] type key.
///
/// Maps string identifiers to [ImageRepeat] enum values for image repeat behavior.
/// Supported values: "repeat", "repeatX", "repeatY", "noRepeat".
const _imageRepeatStringLookupTable = <String, ImageRepeat>{
  "repeat": ImageRepeat.repeat,
  "ImageRepeat.repeat": ImageRepeat.repeat,
  "repeatX": ImageRepeat.repeatX,
  "ImageRepeat.repeatX": ImageRepeat.repeatX,
  "repeatY": ImageRepeat.repeatY,
  "ImageRepeat.repeatY": ImageRepeat.repeatY,
  "noRepeat": ImageRepeat.noRepeat,
  "ImageRepeat.noRepeat": ImageRepeat.noRepeat,
};

/// Lookup table for [BoxFit] values by [int] type key.
///
/// Maps integer identifiers to [BoxFit] enum values for box fit behavior.
/// Supported values: 0 (fill), 1 (contain), 2 (cover), 3 (fitHeight), 4 (fitWidth), 5 (none), 6 (scaleDown).
const _boxFitIntLookupTable = <int, BoxFit>{
  0: BoxFit.fill,
  1: BoxFit.contain,
  2: BoxFit.cover,
  3: BoxFit.fitHeight,
  4: BoxFit.fitWidth,
  5: BoxFit.none,
  6: BoxFit.scaleDown,
};

/// Lookup table for [BoxFit] values by [String] type key.
///
/// Maps string identifiers to [BoxFit] enum values for box fit behavior.
/// Supported values: "fill", "contain", "cover", "fitHeight", "fitWidth", "none", "scaleDown".
const _boxFitStringLookupTable = <String, BoxFit>{
  "fill": BoxFit.fill,
  "BoxFit.fill": BoxFit.fill,
  "contain": BoxFit.contain,
  "BoxFit.contain": BoxFit.contain,
  "cover": BoxFit.cover,
  "BoxFit.cover": BoxFit.cover,
  "fitHeight": BoxFit.fitHeight,
  "BoxFit.fitHeight": BoxFit.fitHeight,
  "fitWidth": BoxFit.fitWidth,
  "BoxFit.fitWidth": BoxFit.fitWidth,
  "none": BoxFit.none,
  "BoxFit.none": BoxFit.none,
  "scaleDown": BoxFit.scaleDown,
  "BoxFit.scaleDown": BoxFit.scaleDown,
};

/// Lookup table for [BlendMode] values by [String] type key.
///
/// Maps string identifiers to [BlendMode] enum values for blend mode.
/// Supported values: "clear", "src", "dst", "srcOver", "dstOver", "srcIn", "dstIn", "srcOut", "dstOut", "srcATop", "dstATop", "xor", "plus", "modulate", "screen", "overlay", "darken", "lighten", "colorDodge", "colorBurn", "hardLight", "softLight", "difference", "exclusion", "multiply", "hue", "saturation", "color", "luminosity".
const _blendModeStringLookupTable = <String, BlendMode>{
  "clear": BlendMode.clear,
  "BlendMode.clear": BlendMode.clear,
  "src": BlendMode.src,
  "BlendMode.src": BlendMode.src,
  "dst": BlendMode.dst,
  "BlendMode.dst": BlendMode.dst,
  "srcOver": BlendMode.srcOver,
  "BlendMode.srcOver": BlendMode.srcOver,
  "dstOver": BlendMode.dstOver,
  "BlendMode.dstOver": BlendMode.dstOver,
  "srcIn": BlendMode.srcIn,
  "BlendMode.srcIn": BlendMode.srcIn,
  "dstIn": BlendMode.dstIn,
  "BlendMode.dstIn": BlendMode.dstIn,
  "srcOut": BlendMode.srcOut,
  "BlendMode.srcOut": BlendMode.srcOut,
  "dstOut": BlendMode.dstOut,
  "BlendMode.dstOut": BlendMode.dstOut,
  "srcATop": BlendMode.srcATop,
  "BlendMode.srcATop": BlendMode.srcATop,
  "dstATop": BlendMode.dstATop,
  "BlendMode.dstATop": BlendMode.dstATop,
  "xor": BlendMode.xor,
  "BlendMode.xor": BlendMode.xor,
  "plus": BlendMode.plus,
  "BlendMode.plus": BlendMode.plus,
  "modulate": BlendMode.modulate,
  "BlendMode.modulate": BlendMode.modulate,
  "screen": BlendMode.screen,
  "BlendMode.screen": BlendMode.screen,
  "overlay": BlendMode.overlay,
  "BlendMode.overlay": BlendMode.overlay,
  "darken": BlendMode.darken,
  "BlendMode.darken": BlendMode.darken,
  "lighten": BlendMode.lighten,
  "BlendMode.lighten": BlendMode.lighten,
  "colorDodge": BlendMode.colorDodge,
  "BlendMode.colorDodge": BlendMode.colorDodge,
  "colorBurn": BlendMode.colorBurn,
  "BlendMode.colorBurn": BlendMode.colorBurn,
  "hardLight": BlendMode.hardLight,
  "BlendMode.hardLight": BlendMode.hardLight,
  "softLight": BlendMode.softLight,
  "BlendMode.softLight": BlendMode.softLight,
  "difference": BlendMode.difference,
  "BlendMode.difference": BlendMode.difference,
  "exclusion": BlendMode.exclusion,
  "BlendMode.exclusion": BlendMode.exclusion,
  "multiply": BlendMode.multiply,
  "BlendMode.multiply": BlendMode.multiply,
  "hue": BlendMode.hue,
  "BlendMode.hue": BlendMode.hue,
  "saturation": BlendMode.saturation,
  "BlendMode.saturation": BlendMode.saturation,
  "color": BlendMode.color,
  "BlendMode.color": BlendMode.color,
  "luminosity": BlendMode.luminosity,
  "BlendMode.luminosity": BlendMode.luminosity,
};

/// Lookup table for [BlendMode] values by [int] type key.
///
/// Maps integer identifiers to [BlendMode] enum values for blend mode.
/// Supported values: 0-28 (см. порядок BlendMode).
const _blendModeIntLookupTable = <int, BlendMode>{
  0: BlendMode.clear,
  1: BlendMode.src,
  2: BlendMode.dst,
  3: BlendMode.srcOver,
  4: BlendMode.dstOver,
  5: BlendMode.srcIn,
  6: BlendMode.dstIn,
  7: BlendMode.srcOut,
  8: BlendMode.dstOut,
  9: BlendMode.srcATop,
  10: BlendMode.dstATop,
  11: BlendMode.xor,
  12: BlendMode.plus,
  13: BlendMode.modulate,
  14: BlendMode.screen,
  15: BlendMode.overlay,
  16: BlendMode.darken,
  17: BlendMode.lighten,
  18: BlendMode.colorDodge,
  19: BlendMode.colorBurn,
  20: BlendMode.hardLight,
  21: BlendMode.softLight,
  22: BlendMode.difference,
  23: BlendMode.exclusion,
  24: BlendMode.multiply,
  25: BlendMode.hue,
  26: BlendMode.saturation,
  27: BlendMode.color,
  28: BlendMode.luminosity,
};

/// Lookup table for [VerticalDirection] values by [int] type key.
///
/// Maps integer identifiers to [VerticalDirection] enum values for vertical direction.
/// Supported values: 0 (up), 1 (down).
const _verticalDirectionIntLookupTable = <int, VerticalDirection>{
  0: VerticalDirection.up,
  1: VerticalDirection.down,
};

/// Lookup table for [VerticalDirection] values by [String] type key.
///
/// Maps string identifiers to [VerticalDirection] enum values for vertical direction.
/// Supported values: "up", "down".
const _verticalDirectionStringLookupTable = <String, VerticalDirection>{
  "up": VerticalDirection.up,
  "VerticalDirection.up": VerticalDirection.up,
  "down": VerticalDirection.down,
  "VerticalDirection.down": VerticalDirection.down,
};

/// Lookup table for [BoxShape] values by [int] type key.
///
/// Maps integer identifiers to [BoxShape] enum values for box shape.
/// Supported values: 0 (circle), 1 (rectangle).
const _boxShapeIntLookupTable = <int, BoxShape>{
  0: BoxShape.circle,
  1: BoxShape.rectangle,
};

/// Lookup table for [BoxShape] values by [String] type key.
///
/// Maps string identifiers to [BoxShape] enum values for box shape.
/// Supported values: "circle", "rectangle".
const _boxShapeStringLookupTable = <String, BoxShape>{
  "circle": BoxShape.circle,
  "BoxShape.circle": BoxShape.circle,
  "rectangle": BoxShape.rectangle,
  "BoxShape.rectangle": BoxShape.rectangle,
};

/// Lookup table for [BorderStyle] values by [int] type key.
///
/// Maps integer identifiers to [BorderStyle] enum values for border style.
/// Supported values: 0 (solid), 1 (none).
const _borderStyleIntLookupTable = <int, BorderStyle>{
  0: BorderStyle.solid,
  1: BorderStyle.none,
};

/// Lookup table for [BorderStyle] values by [String] type key.
///
/// Maps string identifiers to [BorderStyle] enum values for border style.
/// Supported values: "solid", "none".
const _borderStyleStringLookupTable = <String, BorderStyle>{
  "solid": BorderStyle.solid,
  "BorderStyle.solid": BorderStyle.solid,
  "none": BorderStyle.none,
  "BorderStyle.none": BorderStyle.none,
};

/// Lookup table for [TextInputType] values by [int] type key.
///
/// Maps integer identifiers to [TextInputType] enum values for text input type.
/// Supported values: 0 (text), 1 (name), 2 (none), 3 (url), 4 (emailAddress), 5 (datetime), 6 (streetAddress), 7 (number), 8 (phone), 9 (multiline).
const _textInputTypeIntLookupTable = <int, TextInputType>{
  0: TextInputType.text,
  1: TextInputType.name,
  2: TextInputType.none,
  3: TextInputType.url,
  4: TextInputType.emailAddress,
  5: TextInputType.datetime,
  6: TextInputType.streetAddress,
  7: TextInputType.number,
  8: TextInputType.phone,
  9: TextInputType.multiline,
};

/// Lookup table for [TextInputType] values by [String] type key.
///
/// Maps string identifiers to [TextInputType] enum values for text input type.
/// Supported values: "text", "name", "none", "url", "emailAddress", "datetime", "streetAddress", "number", "phone", "multiline".
const _textInputTypeStringLookupTable = <String, TextInputType>{
  "text": TextInputType.text,
  "TextInputType.text": TextInputType.text,
  "name": TextInputType.name,
  "TextInputType.name": TextInputType.name,
  "none": TextInputType.none,
  "TextInputType.none": TextInputType.none,
  "url": TextInputType.url,
  "TextInputType.url": TextInputType.url,
  "emailAddress": TextInputType.emailAddress,
  "TextInputType.emailAddress": TextInputType.emailAddress,
  "datetime": TextInputType.datetime,
  "TextInputType.datetime": TextInputType.datetime,
  "streetAddress": TextInputType.streetAddress,
  "TextInputType.streetAddress": TextInputType.streetAddress,
  "number": TextInputType.number,
  "TextInputType.number": TextInputType.number,
  "phone": TextInputType.phone,
  "TextInputType.phone": TextInputType.phone,
  "multiline": TextInputType.multiline,
  "TextInputType.multiline": TextInputType.multiline,
};

/// Lookup table for [ScrollViewKeyboardDismissBehavior] values by [int] type key.
///
/// Maps integer identifiers to [ScrollViewKeyboardDismissBehavior] enum values for keyboard dismiss behavior in scroll views.
/// Supported values: 0 (manual), 1 (onDrag).
const _keyboardDismissBehaviorIntLookupTable =
    <int, ScrollViewKeyboardDismissBehavior>{
  0: ScrollViewKeyboardDismissBehavior.manual,
  1: ScrollViewKeyboardDismissBehavior.onDrag,
};

/// Lookup table for [ScrollViewKeyboardDismissBehavior] values by [String] type key.
///
/// Maps string identifiers to [ScrollViewKeyboardDismissBehavior] enum values for keyboard dismiss behavior in scroll views.
/// Supported values: "manual", "onDrag".
const _keyboardDismissBehaviorStringLookupTable =
    <String, ScrollViewKeyboardDismissBehavior>{
  "manual": ScrollViewKeyboardDismissBehavior.manual,
  "ScrollViewKeyboardDismissBehavior.manual":
      ScrollViewKeyboardDismissBehavior.manual,
  "onDrag": ScrollViewKeyboardDismissBehavior.onDrag,
  "ScrollViewKeyboardDismissBehavior.onDrag":
      ScrollViewKeyboardDismissBehavior.onDrag,
};

/// Lookup table for [TooltipTriggerMode] values by [int] type key.
///
/// Maps integer identifiers to [TooltipTriggerMode] enum values for tooltip trigger mode.
/// Supported values: 0 (manual), 1 (longPress), 2 (tap).
const _tooltipTriggerModeIntLookupTable = <int, TooltipTriggerMode>{
  0: TooltipTriggerMode.manual,
  1: TooltipTriggerMode.longPress,
  2: TooltipTriggerMode.tap,
};

/// Lookup table for [TooltipTriggerMode] values by [String] type key.
///
/// Maps string identifiers to [TooltipTriggerMode] enum values for tooltip trigger mode.
/// Supported values: "manual", "longPress", "tap".
const _tooltipTriggerModeStringLookupTable = <String, TooltipTriggerMode>{
  "manual": TooltipTriggerMode.manual,
  "TooltipTriggerMode.manual": TooltipTriggerMode.manual,
  "longPress": TooltipTriggerMode.longPress,
  "TooltipTriggerMode.longPress": TooltipTriggerMode.longPress,
  "tap": TooltipTriggerMode.tap,
  "TooltipTriggerMode.tap": TooltipTriggerMode.tap,
};

/// Lookup table for [ScrollPhysics] values by [int] type key.
///
/// Maps integer identifiers to [ScrollPhysics] objects for scroll physics behavior.
/// Supported values: 0 (AlwaysScrollableScrollPhysics), 1 (BouncingScrollPhysics), 2 (ClampingScrollPhysics), 3 (FixedExtentScrollPhysics), 4 (NeverScrollableScrollPhysics).
const _scrollPhysicsIntLookupTable = <int, ScrollPhysics>{
  0: AlwaysScrollableScrollPhysics(),
  1: BouncingScrollPhysics(),
  2: ClampingScrollPhysics(),
  3: FixedExtentScrollPhysics(),
  4: NeverScrollableScrollPhysics(),
};

/// Lookup table for [ScrollPhysics] values by [String] type key.
///
/// Maps string identifiers to [ScrollPhysics] objects for scroll physics behavior.
/// Supported values: "alwaysScrollableScrollPhysics", "bouncingScrollPhysics", "clampingScrollPhysics", "fixedExtentScrollPhysics", "neverScrollableScrollPhysics".
const _scrollPhysicsStringLookupTable = <String, ScrollPhysics>{
  "alwaysScrollableScrollPhysics": AlwaysScrollableScrollPhysics(),
  "AlwaysScrollableScrollPhysics": AlwaysScrollableScrollPhysics(),
  "bouncingScrollPhysics": BouncingScrollPhysics(),
  "BouncingScrollPhysics": BouncingScrollPhysics(),
  "clampingScrollPhysics": ClampingScrollPhysics(),
  "ClampingScrollPhysics": ClampingScrollPhysics(),
  "fixedExtentScrollPhysics": FixedExtentScrollPhysics(),
  "FixedExtentScrollPhysics": FixedExtentScrollPhysics(),
  "neverScrollableScrollPhysics": NeverScrollableScrollPhysics(),
  "NeverScrollableScrollPhysics": NeverScrollableScrollPhysics(),
};

/// Lookup table for [DragStartBehavior] values by [int] type key.
///
/// Maps integer identifiers to [DragStartBehavior] enum values for drag start behavior.
/// Supported values: 0 (start), 1 (down).
const _dragStartBehaviorIntLookupTable = <int, DragStartBehavior>{
  0: DragStartBehavior.start,
  1: DragStartBehavior.down,
};

/// Lookup table for [DragStartBehavior] values by [String] type key.
///
/// Maps string identifiers to [DragStartBehavior] enum values for drag start behavior.
/// Supported values: "start", "down".
const _dragStartBehaviorStringLookupTable = <String, DragStartBehavior>{
  "start": DragStartBehavior.start,
  "DragStartBehavior.start": DragStartBehavior.start,
  "down": DragStartBehavior.down,
  "DragStartBehavior.down": DragStartBehavior.down,
};

/// Lookup table for [HitTestBehavior] values by [int] type key.
///
/// Maps integer identifiers to [HitTestBehavior] enum values for hit test behavior.
/// Supported values: 0 (deferToChild), 1 (opaque), 2 (translucent).
const _hitTestBehaviorIntLookupTable = <int, HitTestBehavior>{
  0: HitTestBehavior.deferToChild,
  1: HitTestBehavior.opaque,
  2: HitTestBehavior.translucent,
};

/// Lookup table for [HitTestBehavior] values by [String] type key.
///
/// Maps string identifiers to [HitTestBehavior] enum values for hit test behavior.
/// Supported values: "deferToChild", "opaque", "translucent".
const _hitTestBehaviorStringLookupTable = <String, HitTestBehavior>{
  "deferToChild": HitTestBehavior.deferToChild,
  "HitTestBehavior.deferToChild": HitTestBehavior.deferToChild,
  "opaque": HitTestBehavior.opaque,
  "HitTestBehavior.opaque": HitTestBehavior.opaque,
  "translucent": HitTestBehavior.translucent,
  "HitTestBehavior.translucent": HitTestBehavior.translucent,
};

/// Lookup table for [FloatingActionButtonLocation] values by [String] type key.
///
/// Maps string identifiers to [FloatingActionButtonLocation] values for FAB location.
/// Supported values: "centerDocked", "centerFloat", "centerTop", "endDocked", "endFloat", "endTop", "startDocked", "startFloat", "startTop", "miniCenterDocked", "miniCenterFloat", "miniCenterTop", "miniEndDocked", "miniEndFloat", "miniEndTop", "miniStartDocked", "miniStartFloat", "miniStartTop".
const _fabLocationStringLookupTable = <String, FloatingActionButtonLocation>{
  "centerDocked": FloatingActionButtonLocation.centerDocked,
  "FloatingActionButtonLocation.centerDocked":
      FloatingActionButtonLocation.centerDocked,
  "centerFloat": FloatingActionButtonLocation.centerFloat,
  "FloatingActionButtonLocation.centerFloat":
      FloatingActionButtonLocation.centerFloat,
  "centerTop": FloatingActionButtonLocation.centerTop,
  "FloatingActionButtonLocation.centerTop":
      FloatingActionButtonLocation.centerTop,
  "endDocked": FloatingActionButtonLocation.endDocked,
  "FloatingActionButtonLocation.endDocked":
      FloatingActionButtonLocation.endDocked,
  "endFloat": FloatingActionButtonLocation.endFloat,
  "FloatingActionButtonLocation.endFloat":
      FloatingActionButtonLocation.endFloat,
  "endTop": FloatingActionButtonLocation.endTop,
  "FloatingActionButtonLocation.endTop": FloatingActionButtonLocation.endTop,
  "startDocked": FloatingActionButtonLocation.startDocked,
  "FloatingActionButtonLocation.startDocked":
      FloatingActionButtonLocation.startDocked,
  "startFloat": FloatingActionButtonLocation.startFloat,
  "FloatingActionButtonLocation.startFloat":
      FloatingActionButtonLocation.startFloat,
  "startTop": FloatingActionButtonLocation.startTop,
  "FloatingActionButtonLocation.startTop":
      FloatingActionButtonLocation.startTop,
  "miniCenterDocked": FloatingActionButtonLocation.miniCenterDocked,
  "FloatingActionButtonLocation.miniCenterDocked":
      FloatingActionButtonLocation.miniCenterDocked,
  "miniCenterFloat": FloatingActionButtonLocation.miniCenterFloat,
  "FloatingActionButtonLocation.miniCenterFloat":
      FloatingActionButtonLocation.miniCenterFloat,
  "miniCenterTop": FloatingActionButtonLocation.miniCenterTop,
  "FloatingActionButtonLocation.miniCenterTop":
      FloatingActionButtonLocation.miniCenterTop,
  "miniEndDocked": FloatingActionButtonLocation.miniEndDocked,
  "FloatingActionButtonLocation.miniEndDocked":
      FloatingActionButtonLocation.miniEndDocked,
  "miniEndFloat": FloatingActionButtonLocation.miniEndFloat,
  "FloatingActionButtonLocation.miniEndFloat":
      FloatingActionButtonLocation.miniEndFloat,
  "miniEndTop": FloatingActionButtonLocation.miniEndTop,
  "FloatingActionButtonLocation.miniEndTop":
      FloatingActionButtonLocation.miniEndTop,
  "miniStartDocked": FloatingActionButtonLocation.miniStartDocked,
  "FloatingActionButtonLocation.miniStartDocked":
      FloatingActionButtonLocation.miniStartDocked,
  "miniStartFloat": FloatingActionButtonLocation.miniStartFloat,
  "FloatingActionButtonLocation.miniStartFloat":
      FloatingActionButtonLocation.miniStartFloat,
  "miniStartTop": FloatingActionButtonLocation.miniStartTop,
  "FloatingActionButtonLocation.miniStartTop":
      FloatingActionButtonLocation.miniStartTop,
};

/// Lookup table for [FloatingActionButtonLocation] values by [int] type key.
///
/// Maps integer identifiers to [FloatingActionButtonLocation] values for FAB location.
/// Supported values: 0-17 (см. порядок FloatingActionButtonLocation).
const _fabLocationIntLookupTable = <int, FloatingActionButtonLocation>{
  0: FloatingActionButtonLocation.centerDocked,
  1: FloatingActionButtonLocation.centerFloat,
  2: FloatingActionButtonLocation.centerTop,
  3: FloatingActionButtonLocation.endDocked,
  4: FloatingActionButtonLocation.endFloat,
  5: FloatingActionButtonLocation.endTop,
  6: FloatingActionButtonLocation.startDocked,
  7: FloatingActionButtonLocation.startFloat,
  8: FloatingActionButtonLocation.startTop,
  9: FloatingActionButtonLocation.miniCenterDocked,
  10: FloatingActionButtonLocation.miniCenterFloat,
  11: FloatingActionButtonLocation.miniCenterTop,
  12: FloatingActionButtonLocation.miniEndDocked,
  13: FloatingActionButtonLocation.miniEndFloat,
  14: FloatingActionButtonLocation.miniEndTop,
  15: FloatingActionButtonLocation.miniStartDocked,
  16: FloatingActionButtonLocation.miniStartFloat,
  17: FloatingActionButtonLocation.miniStartTop,
};

/// Lookup table for [TileMode] values by [String] type key.
///
/// Maps string identifiers to [TileMode] enum values for tile mode.
/// Supported values: "clamp", "mirror", "repeated", "decal".
const _tileModeStringLookupTable = <String, TileMode>{
  "clamp": TileMode.clamp,
  "TileMode.clamp": TileMode.clamp,
  "mirror": TileMode.mirror,
  "TileMode.mirror": TileMode.mirror,
  "repeated": TileMode.repeated,
  "TileMode.repeated": TileMode.repeated,
  "decal": TileMode.decal,
  "TileMode.decal": TileMode.decal,
};

/// Lookup table for [TileMode] values by [int] type key.
///
/// Maps integer identifiers to [TileMode] enum values for tile mode.
/// Supported values: 0 (clamp), 1 (mirror), 2 (repeated), 3 (decal).
const _tileModeIntLookupTable = <int, TileMode>{
  0: TileMode.clamp,
  1: TileMode.mirror,
  2: TileMode.repeated,
  3: TileMode.decal,
};

/// Lookup table for [ThemeOverrideRule] values by [String] type key.
///
/// Maps string identifiers to [ThemeOverrideRule] enum values for theme override rules.
/// Supported values: "themeOverlay", "themePriority".
const _themeOverrideRuleStringLookupTable = <String, ThemeOverrideRule>{
  "themeOverlay": ThemeOverrideRule.themeOverlay,
  "ThemeOverrideRule.themeOverlay": ThemeOverrideRule.themeOverlay,
  "themePriority": ThemeOverrideRule.themePriority,
  "ThemeOverrideRule.themePriority": ThemeOverrideRule.themePriority,
};

/// Lookup table for [ThemeOverrideRule] values by [int] type key.
///
/// Maps integer identifiers to [ThemeOverrideRule] enum values for theme override rules.
/// Supported values: 0 (themeOverlay), 1 (themePriority).
const _themeOverrideRuleIntLookupTable = <int, ThemeOverrideRule>{
  0: ThemeOverrideRule.themeOverlay,
  1: ThemeOverrideRule.themePriority,
};

/// Lookup table for string-based image filter types.
///
/// Maps string identifiers to their corresponding filter creation functions.
/// Supported types: "blur", "compose", "dilate", "erode", "matrix".
const _imageFilterTypeStringLookupTable =
    <String, ImageFilter Function(Map<String, dynamic> value)>{
  "blur": DuitDataSource._blurImageFilterFromMap,
  "ImageFilter.blur": DuitDataSource._blurImageFilterFromMap,
  "compose": DuitDataSource._composeImageFilterFromMap,
  "ImageFilter.compose": DuitDataSource._composeImageFilterFromMap,
  "dilate": DuitDataSource._dilateImageFilterFromMap,
  "ImageFilter.dilate": DuitDataSource._dilateImageFilterFromMap,
  "erode": DuitDataSource._erodeImageFilterFromMap,
  "ImageFilter.erode": DuitDataSource._erodeImageFilterFromMap,
  "matrix": DuitDataSource._matrixImageFilterFromMap,
  "ImageFilter.matrix": DuitDataSource._matrixImageFilterFromMap,
};

/// Lookup table for integer-based image filter types.
///
/// Maps integer identifiers to their corresponding filter creation functions.
/// Supported types: 0 (blur), 1 (compose), 2 (dilate), 3 (erode), 4 (matrix).
const _imageFilterTypeIntLookupTable =
    <int, ImageFilter Function(Map<String, dynamic> value)>{
  0: DuitDataSource._blurImageFilterFromMap,
  1: DuitDataSource._composeImageFilterFromMap,
  2: DuitDataSource._dilateImageFilterFromMap,
  3: DuitDataSource._erodeImageFilterFromMap,
  4: DuitDataSource._matrixImageFilterFromMap,
};

/// Lookup table for [AnimationTrigger] values by [String] type key.
///
/// Maps string identifiers to [AnimationTrigger] enum values for animation triggers.
/// Supported values: "onEnter", "onAction".
const _animationTriggerStringLookupTable = <String, AnimationTrigger>{
  "onEnter": AnimationTrigger.onEnter,
  "AnimationTrigger.onEnter": AnimationTrigger.onEnter,
  "onAction": AnimationTrigger.onAction,
  "AnimationTrigger.onAction": AnimationTrigger.onAction,
};

/// Lookup table for [AnimationTrigger] values by [int] type key.
///
/// Maps integer identifiers to [AnimationTrigger] enum values for animation triggers.
/// Supported values: 0 (onEnter), 1 (onAction).
const _animationTriggerIntLookupTable = <int, AnimationTrigger>{
  0: AnimationTrigger.onEnter,
  1: AnimationTrigger.onAction,
};

/// Lookup table for [AnimationMethod] values by [String] type key.
///
/// Maps string identifiers to [AnimationMethod] enum values for animation methods.
/// Supported values: "forward", "repeat", "reverse", "toggle".
const _animationMethodStringLookupTable = <String, AnimationMethod>{
  "forward": AnimationMethod.forward,
  "AnimationMethod.forward": AnimationMethod.forward,
  "repeat": AnimationMethod.repeat,
  "AnimationMethod.repeat": AnimationMethod.repeat,
  "reverse": AnimationMethod.reverse,
  "AnimationMethod.reverse": AnimationMethod.reverse,
  "toggle": AnimationMethod.toggle,
  "AnimationMethod.toggle": AnimationMethod.toggle,
};

/// Lookup table for [AnimationMethod] values by [int] type key.
///
/// Maps integer identifiers to [AnimationMethod] enum values for animation methods.
/// Supported values: 0 (forward), 1 (repeat), 2 (reverse), 3 (toggle).
const _animationMethodIntLookupTable = <int, AnimationMethod>{
  0: AnimationMethod.forward,
  1: AnimationMethod.repeat,
  2: AnimationMethod.reverse,
  3: AnimationMethod.toggle,
};

/// Lookup table for [TweenType] values by [String] type key.
///
/// Maps string identifiers to [TweenType] enum values for tween types.
/// Supported values: "tween", "group", "colorTween", "textStyleTween", "decorationTween", "alignmentTween", "sizeTween", "edgeInsetsTween", "boxConstraintsTween", "borderTween".
const _tweenTypeStringLookupTable = <String, TweenType>{
  "tween": TweenType.tween,
  "TweenType.tween": TweenType.tween,
  "group": TweenType.group,
  "TweenType.group": TweenType.group,
  "colorTween": TweenType.colorTween,
  "TweenType.colorTween": TweenType.colorTween,
  "textStyleTween": TweenType.textStyleTween,
  "TweenType.textStyleTween": TweenType.textStyleTween,
  "decorationTween": TweenType.decorationTween,
  "TweenType.decorationTween": TweenType.decorationTween,
  "alignmentTween": TweenType.alignmentTween,
  "TweenType.alignmentTween": TweenType.alignmentTween,
  "sizeTween": TweenType.sizeTween,
  "TweenType.sizeTween": TweenType.sizeTween,
  "edgeInsetsTween": TweenType.edgeInsetsTween,
  "TweenType.edgeInsetsTween": TweenType.edgeInsetsTween,
  "boxConstraintsTween": TweenType.boxConstraintsTween,
  "TweenType.boxConstraintsTween": TweenType.boxConstraintsTween,
  "borderTween": TweenType.borderTween,
  "TweenType.borderTween": TweenType.borderTween,
};

/// Lookup table for [TweenType] values by [int] type key.
///
/// Maps integer identifiers to [TweenType] enum values for tween types.
/// Supported values: 0 (tween), 1 (colorTween), 2 (textStyleTween), 3 (decorationTween), 4 (alignmentTween), 5 (sizeTween), 6 (edgeInsetsTween), 7 (boxConstraintsTween), 8 (borderTween), 9 (group).
const _tweenTypeIntLookupTable = <int, TweenType>{
  0: TweenType.tween,
  1: TweenType.colorTween,
  2: TweenType.textStyleTween,
  3: TweenType.decorationTween,
  4: TweenType.alignmentTween,
  5: TweenType.sizeTween,
  6: TweenType.edgeInsetsTween,
  7: TweenType.boxConstraintsTween,
  8: TweenType.borderTween,
  9: TweenType.group,
};

/// Lookup table for [CollapseMode] values by [String] type key.
///
/// Maps string identifiers to [CollapseMode] enum values for collapse behavior.
/// Supported values: "parallax", "pin", "none".
const _collapseModeStringLookupTable = <String, CollapseMode>{
  "parallax": CollapseMode.parallax,
  "CollapseMode.parallax": CollapseMode.parallax,
  "pin": CollapseMode.pin,
  "CollapseMode.pin": CollapseMode.pin,
  "none": CollapseMode.none,
  "CollapseMode.none": CollapseMode.none,
};

/// Lookup table for [CollapseMode] values by [int] type key.
///
/// Maps integer identifiers to [CollapseMode] enum values for collapse behavior.
/// Supported values: 0 (parallax), 1 (pin), 2 (none).
const _collapseModeIntLookupTable = <int, CollapseMode>{
  0: CollapseMode.parallax,
  1: CollapseMode.pin,
  2: CollapseMode.none,
};

/// Lookup table for [StretchMode] values by [String] type key.
///
/// Maps string identifiers to [StretchMode] enum values for stretch behavior.
/// Supported values: "zoomBackground", "blurBackground", "fadeTitle".
const _stretchModeStringLookupTable = <String, StretchMode>{
  "zoomBackground": StretchMode.zoomBackground,
  "StretchMode.zoomBackground": StretchMode.zoomBackground,
  "blurBackground": StretchMode.blurBackground,
  "StretchMode.blurBackground": StretchMode.blurBackground,
  "fadeTitle": StretchMode.fadeTitle,
  "StretchMode.fadeTitle": StretchMode.fadeTitle,
};

/// Lookup table for [StretchMode] values by [int] type key.
///
/// Maps integer identifiers to [StretchMode] enum values for stretch behavior.
/// Supported values: 0 (zoomBackground), 1 (blurBackground), 2 (fadeTitle).
const _stretchModeIntLookupTable = <int, StretchMode>{
  0: StretchMode.zoomBackground,
  1: StretchMode.blurBackground,
  2: StretchMode.fadeTitle,
};

/// Lookup table for [InputBorder] creation functions by [String] type key.
///
/// Maps string identifiers to functions that create [InputBorder] instances from maps.
/// Supported values: "outline", "underline".
const _inputBorderTypeStringLookupTable =
    <String, InputBorder Function(Map<String, dynamic> value)>{
  "outline": DuitDataSource._outlineInputBorderFromMap,
  "InputBorder.outline": DuitDataSource._outlineInputBorderFromMap,
  "underline": DuitDataSource._underlineInputBorderFromMap,
  "InputBorder.underline": DuitDataSource._underlineInputBorderFromMap,
};

/// Lookup table for [ShapeBorder] creation functions by [String] type key.
///
/// Maps string identifiers to functions that create [ShapeBorder] instances from maps.
/// Supported values: "roundedRectangleBorder", "circleBorder", "stadiumBorder", "beveledRectangleBorder", "continuousRectangleBorder".
const _shapeBorderTypeStringLookupTable = <String,
    ShapeBorder Function(
  Map<String, dynamic> value,
)>{
  "RoundedRectangleBorder": DuitDataSource._roundedRectangleBorderFromMap,
  "roundedRectangleBorder": DuitDataSource._roundedRectangleBorderFromMap,
  "CircleBorder": DuitDataSource._circleBorderFromMap,
  "circleBorder": DuitDataSource._circleBorderFromMap,
  "StadiumBorder": DuitDataSource._stadiumBorderFromMap,
  "stadiumBorder": DuitDataSource._stadiumBorderFromMap,
  "BeveledRectangleBorder": DuitDataSource._beveledRectangleBorderFromMap,
  "beveledRectangleBorder": DuitDataSource._beveledRectangleBorderFromMap,
  "ContinuousRectangleBorder": DuitDataSource._continuousRectangleBorderFromMap,
  "continuousRectangleBorder": DuitDataSource._continuousRectangleBorderFromMap,
};

/// Lookup table for [ExecutionModifier] values by [String] type key.
///
/// Maps string identifiers to [ExecutionModifier] enum values for execution modifiers.
/// Supported values: "throttle", "debounce".
const _executionModifierStringLookupTable = <String, ExecutionModifier>{
  "throttle": ExecutionModifier.throttle,
  "debounce": ExecutionModifier.debounce,
};

/// Lookup table for [ExecutionModifier] values by [int] type key.
///
/// Maps integer identifiers to [ExecutionModifier] enum values for execution modifiers.
/// Supported values: 0 (throttle), 1 (debounce).
const _executionModifierIntLookupTable = <int, ExecutionModifier>{
  0: ExecutionModifier.throttle,
  1: ExecutionModifier.debounce,
};

/// Lookup table for [TraversalDirection] values by [String] type key.
///
/// Maps string identifiers to [TraversalDirection] enum values for focus traversal direction.
/// Supported values: "up", "right", "down", "left".
const _traversalDirectionStringLookupTable = <String, TraversalDirection>{
  "up": TraversalDirection.up,
  "TraversalDirection.up": TraversalDirection.up,
  "right": TraversalDirection.right,
  "TraversalDirection.right": TraversalDirection.right,
  "down": TraversalDirection.down,
  "TraversalDirection.down": TraversalDirection.down,
  "left": TraversalDirection.left,
  "TraversalDirection.left": TraversalDirection.left,
};

/// Lookup table for [TraversalDirection] values by [int] type key.
///
/// Maps integer identifiers to [TraversalDirection] enum values for focus traversal direction.
/// Supported values: 0 (up), 1 (right), 2 (down), 3 (left).
const _traversalDirectionIntLookupTable = <int, TraversalDirection>{
  0: TraversalDirection.up,
  1: TraversalDirection.right,
  2: TraversalDirection.down,
  3: TraversalDirection.left,
};

/// Lookup table for [UnfocusDisposition] values by [String] type key.
///
/// Maps string identifiers to [UnfocusDisposition] enum values for unfocus disposition.
/// Supported values: "scope", "previouslyFocusedChild".
const _unfocusDispositionStringLookupTable = <String, UnfocusDisposition>{
  "scope": UnfocusDisposition.scope,
  "UnfocusDisposition.scope": UnfocusDisposition.scope,
  "previouslyFocusedChild": UnfocusDisposition.previouslyFocusedChild,
  "UnfocusDisposition.previouslyFocusedChild":
      UnfocusDisposition.previouslyFocusedChild,
};

/// Lookup table for [UnfocusDisposition] values by [int] type key.
///
/// Maps integer identifiers to [UnfocusDisposition] enum values for unfocus disposition.
/// Supported values: 0 (scope), 1 (previouslyFocusedChild).
const _unfocusDispositionIntLookupTable = <int, UnfocusDisposition>{
  0: UnfocusDisposition.scope,
  1: UnfocusDisposition.previouslyFocusedChild,
};

/// Lookup table for [DatePickerEntryMode] values by [String] type key.
///
/// Maps string identifiers to [DatePickerEntryMode] enum values for date picker entry mode.
/// Supported values: "calendar", "calendarOnly", "input", "inputOnly".
const _datePickerEntryModeStringLookupTable = <String, DatePickerEntryMode>{
  "calendar": DatePickerEntryMode.calendar,
  "DatePickerEntryMode.calendar": DatePickerEntryMode.calendar,
  "calendarOnly": DatePickerEntryMode.calendarOnly,
  "DatePickerEntryMode.calendarOnly": DatePickerEntryMode.calendarOnly,
  "input": DatePickerEntryMode.input,
  "DatePickerEntryMode.input": DatePickerEntryMode.input,
  "inputOnly": DatePickerEntryMode.inputOnly,
  "DatePickerEntryMode.inputOnly": DatePickerEntryMode.inputOnly,
};

/// Lookup table for [DatePickerEntryMode] values by [int] type key.
///
/// Maps integer identifiers to [DatePickerEntryMode] enum values for date picker entry mode.
/// Supported values: 0 (calendar), 1 (calendarOnly), 2 (input), 3 (inputOnly).
const _datePickerEntryModeIntLookupTable = <int, DatePickerEntryMode>{
  0: DatePickerEntryMode.calendar,
  1: DatePickerEntryMode.calendarOnly,
  2: DatePickerEntryMode.input,
  3: DatePickerEntryMode.inputOnly,
};

/// Lookup table for [DatePickerMode] values by [String] type key.
///
/// Maps string identifiers to [DatePickerMode] enum values for calendar date picker display mode.
/// Supported values: "day", "year".
const _datePickerModeStringLookupTable = <String, DatePickerMode>{
  "day": DatePickerMode.day,
  "DatePickerMode.day": DatePickerMode.day,
  "year": DatePickerMode.year,
  "DatePickerMode.year": DatePickerMode.year,
};

/// Lookup table for [DatePickerMode] values by [int] type key.
///
/// Maps integer identifiers to [DatePickerMode] enum values for calendar date picker display mode.
/// Supported values: 0 (day), 1 (year).
const _datePickerModeIntLookupTable = <int, DatePickerMode>{
  0: DatePickerMode.day,
  1: DatePickerMode.year,
};

/// Lookup table for [TimePickerEntryMode] values by [String] type key.
///
/// Maps string identifiers to [TimePickerEntryMode] enum values for time picker entry mode.
/// Supported values: "dial", "input", "dialOnly", "inputOnly".
const _timePickerEntryModeStringLookupTable = <String, TimePickerEntryMode>{
  "dial": TimePickerEntryMode.dial,
  "TimePickerEntryMode.dial": TimePickerEntryMode.dial,
  "input": TimePickerEntryMode.input,
  "TimePickerEntryMode.input": TimePickerEntryMode.input,
  "dialOnly": TimePickerEntryMode.dialOnly,
  "TimePickerEntryMode.dialOnly": TimePickerEntryMode.dialOnly,
  "inputOnly": TimePickerEntryMode.inputOnly,
  "TimePickerEntryMode.inputOnly": TimePickerEntryMode.inputOnly,
};

/// Lookup table for [TimePickerEntryMode] values by [int] type key.
///
/// Maps integer identifiers to [TimePickerEntryMode] enum values for time picker entry mode.
/// Supported values: 0 (dial), 1 (input), 2 (dialOnly), 3 (inputOnly).
const _timePickerEntryModeIntLookupTable = <int, TimePickerEntryMode>{
  0: TimePickerEntryMode.dial,
  1: TimePickerEntryMode.input,
  2: TimePickerEntryMode.dialOnly,
  3: TimePickerEntryMode.inputOnly,
};

/// Lookup table for [Orientation] values by [String] type key.
///
/// Maps string identifiers to [Orientation] enum values for layout orientation.
/// Supported values: "portrait", "landscape".
const _orientationStringLookupTable = <String, Orientation>{
  "portrait": Orientation.portrait,
  "Orientation.portrait": Orientation.portrait,
  "landscape": Orientation.landscape,
  "Orientation.landscape": Orientation.landscape,
};

/// Lookup table for [Orientation] values by [int] type key.
///
/// Maps integer identifiers to [Orientation] enum values for layout orientation.
/// Supported values: 0 (portrait), 1 (landscape).
const _orientationIntLookupTable = <int, Orientation>{
  0: Orientation.portrait,
  1: Orientation.landscape,
};

/// Lookup table for [FlexFit] values by [String] type key.
///
/// Maps string identifiers to [FlexFit] enum values for flexible fit behavior.
/// Supported values: "tight", "loose".
const _flexFitStringLookupTable = <String, FlexFit>{
  "tight": FlexFit.tight,
  "FlexFit.tight": FlexFit.tight,
  "loose": FlexFit.loose,
  "FlexFit.loose": FlexFit.loose,
};

/// Lookup table for [FlexFit] values by [int] type key.
///
/// Maps integer identifiers to [FlexFit] enum values for flexible fit behavior.
/// Supported values: 0 (tight), 1 (loose).
const _flexFitIntLookupTable = <int, FlexFit>{
  0: FlexFit.tight,
  1: FlexFit.loose,
};

/// Lookup table for [PointerDeviceKind] values by [String] type key.
///
/// Maps string identifiers to [PointerDeviceKind] enum values for pointer device type.
/// Supported values: "touch", "mouse", "stylus", "invertedStylus", "trackpad", "unknown".
const _pointerDeviceKindStringLookupTable = <String, PointerDeviceKind>{
  "touch": PointerDeviceKind.touch,
  "PointerDeviceKind.touch": PointerDeviceKind.touch,
  "mouse": PointerDeviceKind.mouse,
  "PointerDeviceKind.mouse": PointerDeviceKind.mouse,
  "stylus": PointerDeviceKind.stylus,
  "PointerDeviceKind.stylus": PointerDeviceKind.stylus,
  "invertedStylus": PointerDeviceKind.invertedStylus,
  "PointerDeviceKind.invertedStylus": PointerDeviceKind.invertedStylus,
  "trackpad": PointerDeviceKind.trackpad,
  "PointerDeviceKind.trackpad": PointerDeviceKind.trackpad,
  "unknown": PointerDeviceKind.unknown,
  "PointerDeviceKind.unknown": PointerDeviceKind.unknown,
};

/// Lookup table for [PointerDeviceKind] values by [int] type key.
///
/// Maps integer identifiers to [PointerDeviceKind] enum values for pointer device type.
/// Supported values: 0 (touch), 1 (mouse), 2 (stylus), 3 (invertedStylus), 4 (trackpad), 5 (unknown).
const _pointerDeviceKindIntLookupTable = <int, PointerDeviceKind>{
  0: PointerDeviceKind.touch,
  1: PointerDeviceKind.mouse,
  2: PointerDeviceKind.stylus,
  3: PointerDeviceKind.invertedStylus,
  4: PointerDeviceKind.trackpad,
  5: PointerDeviceKind.unknown,
};

/// Lookup table for [MultitouchDragStrategy] values by [String] type key.
///
/// Maps string identifiers to [MultitouchDragStrategy] enum values for multi-pointer drag behavior.
/// Supported values: "latestPointer", "averageBoundaryPointers", "sumAllPointers".
const _multitouchDragStrategyStringLookupTable =
    <String, MultitouchDragStrategy>{
  "latestPointer": MultitouchDragStrategy.latestPointer,
  "MultitouchDragStrategy.latestPointer": MultitouchDragStrategy.latestPointer,
  "averageBoundaryPointers": MultitouchDragStrategy.averageBoundaryPointers,
  "MultitouchDragStrategy.averageBoundaryPointers":
      MultitouchDragStrategy.averageBoundaryPointers,
  "sumAllPointers": MultitouchDragStrategy.sumAllPointers,
  "MultitouchDragStrategy.sumAllPointers":
      MultitouchDragStrategy.sumAllPointers,
};

/// Lookup table for [MultitouchDragStrategy] values by [int] type key.
///
/// Maps integer identifiers to [MultitouchDragStrategy] enum values for multi-pointer drag behavior.
/// Supported values: 0 (latestPointer), 1 (averageBoundaryPointers), 2 (sumAllPointers).
const _multitouchDragStrategyIntLookupTable = <int, MultitouchDragStrategy>{
  0: MultitouchDragStrategy.latestPointer,
  1: MultitouchDragStrategy.averageBoundaryPointers,
  2: MultitouchDragStrategy.sumAllPointers,
};

/// Lookup table for [TargetPlatform] values by [String] type key.
///
/// Maps string identifiers to [TargetPlatform] enum values for target platform.
/// Supported values: "android", "fuchsia", "iOS", "linux", "macOS", "windows".
const _targetPlatformStringLookupTable = <String, TargetPlatform>{
  "android": TargetPlatform.android,
  "TargetPlatform.android": TargetPlatform.android,
  "fuchsia": TargetPlatform.fuchsia,
  "TargetPlatform.fuchsia": TargetPlatform.fuchsia,
  "iOS": TargetPlatform.iOS,
  "TargetPlatform.iOS": TargetPlatform.iOS,
  "linux": TargetPlatform.linux,
  "TargetPlatform.linux": TargetPlatform.linux,
  "macOS": TargetPlatform.macOS,
  "TargetPlatform.macOS": TargetPlatform.macOS,
  "windows": TargetPlatform.windows,
  "TargetPlatform.windows": TargetPlatform.windows,
};

/// Lookup table for [TargetPlatform] values by [int] type key.
///
/// Maps integer identifiers to [TargetPlatform] enum values for target platform.
/// Supported values: 0 (android), 1 (fuchsia), 2 (iOS), 3 (linux), 4 (macOS), 5 (windows).
const _targetPlatformIntLookupTable = <int, TargetPlatform>{
  0: TargetPlatform.android,
  1: TargetPlatform.fuchsia,
  2: TargetPlatform.iOS,
  3: TargetPlatform.linux,
  4: TargetPlatform.macOS,
  5: TargetPlatform.windows,
};

/// Lookup table for [LogicalKeyboardKey] values by [String] type key.
///
/// Maps string identifiers (static getter names) to [LogicalKeyboardKey] constants.
/// Supports common key names: "space", "enter", "escape", "backspace", "keyA", etc.
const _logicalKeyboardKeyStringLookupTable = <String, LogicalKeyboardKey>{
  "space": LogicalKeyboardKey.space,
  "enter": LogicalKeyboardKey.enter,
  "escape": LogicalKeyboardKey.escape,
  "backspace": LogicalKeyboardKey.backspace,
  "tab": LogicalKeyboardKey.tab,
  "shift": LogicalKeyboardKey.shift,
  "shiftLeft": LogicalKeyboardKey.shiftLeft,
  "shiftRight": LogicalKeyboardKey.shiftRight,
  "control": LogicalKeyboardKey.control,
  "controlLeft": LogicalKeyboardKey.controlLeft,
  "controlRight": LogicalKeyboardKey.controlRight,
  "alt": LogicalKeyboardKey.alt,
  "altLeft": LogicalKeyboardKey.altLeft,
  "altRight": LogicalKeyboardKey.altRight,
  "meta": LogicalKeyboardKey.meta,
  "metaLeft": LogicalKeyboardKey.metaLeft,
  "metaRight": LogicalKeyboardKey.metaRight,
  "capsLock": LogicalKeyboardKey.capsLock,
  "numLock": LogicalKeyboardKey.numLock,
  "scrollLock": LogicalKeyboardKey.scrollLock,
  "arrowUp": LogicalKeyboardKey.arrowUp,
  "arrowDown": LogicalKeyboardKey.arrowDown,
  "arrowLeft": LogicalKeyboardKey.arrowLeft,
  "arrowRight": LogicalKeyboardKey.arrowRight,
  "home": LogicalKeyboardKey.home,
  "end": LogicalKeyboardKey.end,
  "pageUp": LogicalKeyboardKey.pageUp,
  "pageDown": LogicalKeyboardKey.pageDown,
  "insert": LogicalKeyboardKey.insert,
  "delete": LogicalKeyboardKey.delete,
  "f1": LogicalKeyboardKey.f1,
  "f2": LogicalKeyboardKey.f2,
  "f3": LogicalKeyboardKey.f3,
  "f4": LogicalKeyboardKey.f4,
  "f5": LogicalKeyboardKey.f5,
  "f6": LogicalKeyboardKey.f6,
  "f7": LogicalKeyboardKey.f7,
  "f8": LogicalKeyboardKey.f8,
  "f9": LogicalKeyboardKey.f9,
  "f10": LogicalKeyboardKey.f10,
  "f11": LogicalKeyboardKey.f11,
  "f12": LogicalKeyboardKey.f12,
  "digit0": LogicalKeyboardKey.digit0,
  "digit1": LogicalKeyboardKey.digit1,
  "digit2": LogicalKeyboardKey.digit2,
  "digit3": LogicalKeyboardKey.digit3,
  "digit4": LogicalKeyboardKey.digit4,
  "digit5": LogicalKeyboardKey.digit5,
  "digit6": LogicalKeyboardKey.digit6,
  "digit7": LogicalKeyboardKey.digit7,
  "digit8": LogicalKeyboardKey.digit8,
  "digit9": LogicalKeyboardKey.digit9,
  "keyA": LogicalKeyboardKey.keyA,
  "keyB": LogicalKeyboardKey.keyB,
  "keyC": LogicalKeyboardKey.keyC,
  "keyD": LogicalKeyboardKey.keyD,
  "keyE": LogicalKeyboardKey.keyE,
  "keyF": LogicalKeyboardKey.keyF,
  "keyG": LogicalKeyboardKey.keyG,
  "keyH": LogicalKeyboardKey.keyH,
  "keyI": LogicalKeyboardKey.keyI,
  "keyJ": LogicalKeyboardKey.keyJ,
  "keyK": LogicalKeyboardKey.keyK,
  "keyL": LogicalKeyboardKey.keyL,
  "keyM": LogicalKeyboardKey.keyM,
  "keyN": LogicalKeyboardKey.keyN,
  "keyO": LogicalKeyboardKey.keyO,
  "keyP": LogicalKeyboardKey.keyP,
  "keyQ": LogicalKeyboardKey.keyQ,
  "keyR": LogicalKeyboardKey.keyR,
  "keyS": LogicalKeyboardKey.keyS,
  "keyT": LogicalKeyboardKey.keyT,
  "keyU": LogicalKeyboardKey.keyU,
  "keyV": LogicalKeyboardKey.keyV,
  "keyW": LogicalKeyboardKey.keyW,
  "keyX": LogicalKeyboardKey.keyX,
  "keyY": LogicalKeyboardKey.keyY,
  "keyZ": LogicalKeyboardKey.keyZ,
  "numpad0": LogicalKeyboardKey.numpad0,
  "numpad1": LogicalKeyboardKey.numpad1,
  "numpad2": LogicalKeyboardKey.numpad2,
  "numpad3": LogicalKeyboardKey.numpad3,
  "numpad4": LogicalKeyboardKey.numpad4,
  "numpad5": LogicalKeyboardKey.numpad5,
  "numpad6": LogicalKeyboardKey.numpad6,
  "numpad7": LogicalKeyboardKey.numpad7,
  "numpad8": LogicalKeyboardKey.numpad8,
  "numpad9": LogicalKeyboardKey.numpad9,
  "numpadEnter": LogicalKeyboardKey.numpadEnter,
  "numpadAdd": LogicalKeyboardKey.numpadAdd,
  "numpadSubtract": LogicalKeyboardKey.numpadSubtract,
  "numpadMultiply": LogicalKeyboardKey.numpadMultiply,
  "numpadDivide": LogicalKeyboardKey.numpadDivide,
  "numpadDecimal": LogicalKeyboardKey.numpadDecimal,
  "comma": LogicalKeyboardKey.comma,
  "period": LogicalKeyboardKey.period,
  "minus": LogicalKeyboardKey.minus,
  "equal": LogicalKeyboardKey.equal,
  "bracketLeft": LogicalKeyboardKey.bracketLeft,
  "bracketRight": LogicalKeyboardKey.bracketRight,
  "backslash": LogicalKeyboardKey.backslash,
  "semicolon": LogicalKeyboardKey.semicolon,
  "quote": LogicalKeyboardKey.quote,
  "slash": LogicalKeyboardKey.slash,
  "backquote": LogicalKeyboardKey.backquote,
  "paste": LogicalKeyboardKey.paste,
  "copy": LogicalKeyboardKey.copy,
  "cut": LogicalKeyboardKey.cut,
  "undo": LogicalKeyboardKey.undo,
  "redo": LogicalKeyboardKey.redo,
  "contextMenu": LogicalKeyboardKey.contextMenu,
  "unidentified": LogicalKeyboardKey.unidentified,
};
