part of 'data_source.dart';

///Lookup table for [TextAlign] values by [int] type key
const _textAlignIntLookupTable = <int, TextAlign>{
  0: TextAlign.left,
  1: TextAlign.right,
  2: TextAlign.center,
  3: TextAlign.justify,
  4: TextAlign.start,
  5: TextAlign.end,
};

///Lookup table for [TextAlign] values by [String] type key
const _textAlignStringLookupTable = <String, TextAlign>{
  "left": TextAlign.left,
  "right": TextAlign.right,
  "center": TextAlign.center,
  "justify": TextAlign.justify,
  "start": TextAlign.start,
  "end": TextAlign.end,
};

///Lookup table for [TextDirection] values by [String] type key
const _textDirectionStringLookupTable = <String, TextDirection>{
  "ltr": TextDirection.ltr,
  "rtl": TextDirection.rtl,
};

///Lookup table for [TextDirection] values by [int] type key
const _textDirectionIntLookupTable = <int, TextDirection>{
  0: TextDirection.ltr,
  1: TextDirection.rtl,
};

///Lookup table for [FontWeight] values by [int] type key
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

const _textOverflowIntLookupTable = <int, TextOverflow>{
  0: TextOverflow.clip,
  1: TextOverflow.ellipsis,
  2: TextOverflow.fade,
  3: TextOverflow.visible,
};

const _textOverflowStringLookupTable = <String, TextOverflow>{
  "clip": TextOverflow.clip,
  "ellipsis": TextOverflow.ellipsis,
  "fade": TextOverflow.fade,
  "visible": TextOverflow.visible,
};

const _clipStringLookupTable = <String, Clip>{
  "hardEdge": Clip.hardEdge,
  "antiAlias": Clip.antiAlias,
  "antiAliasWithSaveLayer": Clip.antiAliasWithSaveLayer,
  "none": Clip.none,
};

const _clipIntLookupTable = <int, Clip>{
  0: Clip.hardEdge,
  1: Clip.antiAlias,
  2: Clip.antiAliasWithSaveLayer,
  3: Clip.none,
};

const _curveIntLookupTable = <int, Curve>{
  0: Curves.linear,
  1: Curves.fastEaseInToSlowEaseOut,
  2: Curves.bounceIn,
  3: Curves.bounceInOut,
  4: Curves.bounceOut,
  5: Curves.decelerate,
  6: Curves.ease,
  7: Curves.easeIn,
  8: Curves.easeInBack,
  9: Curves.easeInCirc,
  10: Curves.easeInSine,
  11: Curves.easeInCubic,
  12: Curves.easeInExpo,
  13: Curves.easeInOutCubicEmphasized,
  14: Curves.easeInOutBack,
  15: Curves.easeInOutCirc,
  16: Curves.easeInOutExpo,
  17: Curves.easeInOutQuad,
  18: Curves.easeInOutQuart,
  19: Curves.easeInOutQuint,
  20: Curves.easeInOutSine,
  21: Curves.easeInToLinear,
  22: Curves.easeOutSine,
  23: Curves.easeOutBack,
  24: Curves.easeOutCirc,
  25: Curves.easeOutCubic,
  26: Curves.easeOutExpo,
  27: Curves.easeOutQuad,
  28: Curves.easeOutQuart,
  29: Curves.easeOutQuint,
  30: Curves.linearToEaseOut,
  31: Curves.slowMiddle,
  32: Curves.fastOutSlowIn,
  33: Curves.elasticIn,
  34: Curves.elasticInOut,
  35: Curves.elasticOut,
};

const _curveStringLookupTable = <String, Curve>{
  "linear": Curves.linear,
  "fastEaseInToSlowEaseOut": Curves.fastEaseInToSlowEaseOut,
  "bounceIn": Curves.bounceIn,
  "bounceInOut": Curves.bounceInOut,
  "bounceOut": Curves.bounceOut,
  "decelerate": Curves.decelerate,
  "ease": Curves.ease,
  "easeIn": Curves.easeIn,
  "easeInBack": Curves.easeInBack,
  "easeInCirc": Curves.easeInCirc,
  "easeInSine": Curves.easeInSine,
  "easeInCubic": Curves.easeInCubic,
  "easeInExpo": Curves.easeInExpo,
  "easeInOutCubicEmphasized": Curves.easeInOutCubicEmphasized,
  "easeInOutBack": Curves.easeInOutBack,
  "easeInOutCirc": Curves.easeInOutCirc,
  "easeInOutExpo": Curves.easeInOutExpo,
  "easeInOutQuad": Curves.easeInOutQuad,
  "easeInOutQuart": Curves.easeInOutQuart,
  "easeInOutQuint": Curves.easeInOutQuint,
  "easeInOutSine": Curves.easeInOutSine,
  "easeInToLinear": Curves.easeInToLinear,
  "easeOutSine": Curves.easeOutSine,
  "easeOutBack": Curves.easeOutBack,
  "easeOutCirc": Curves.easeOutCirc,
  "easeOutCubic": Curves.easeOutCubic,
  "easeOutExpo": Curves.easeOutExpo,
  "easeOutQuad": Curves.easeOutQuad,
  "easeOutQuart": Curves.easeOutQuart,
  "easeOutQuint": Curves.easeOutQuint,
  "linearToEaseOut": Curves.linearToEaseOut,
  "slowMiddle": Curves.slowMiddle,
  "fastOutSlowIn": Curves.fastOutSlowIn,
  "elasticIn": Curves.elasticIn,
  "elasticInOut": Curves.elasticInOut,
  "elasticOut": Curves.elasticOut,
};

const _fontStyleIntLookupTable = <int, FontStyle>{
  0: FontStyle.normal,
  1: FontStyle.italic,
};

const _fontStyleStringLookupTable = <String, FontStyle>{
  "normal": FontStyle.normal,
  "italic": FontStyle.italic,
};

const _textBaselineStringLookupTable = <String, TextBaseline>{
  "alphabetic": TextBaseline.alphabetic,
  "ideographic": TextBaseline.ideographic,
};

const _textBaselineIntLookupTable = <int, TextBaseline>{
  0: TextBaseline.alphabetic,
  1: TextBaseline.ideographic,
};

const _textWidthBasisStringLookupTable = <String, TextWidthBasis>{
  "parent": TextWidthBasis.parent,
  "longestLine": TextWidthBasis.longestLine,
};

const _textWidthBasisIntLookupTable = <int, TextWidthBasis>{
  0: TextWidthBasis.parent,
  1: TextWidthBasis.longestLine,
};

const _textDecorationStringLookupTable = <String, TextDecoration>{
  "none": TextDecoration.none,
  "underline": TextDecoration.underline,
  "overline": TextDecoration.overline,
  "lineThrough": TextDecoration.lineThrough,
};

const _textDecorationIntLookupTable = <int, TextDecoration>{
  0: TextDecoration.none,
  1: TextDecoration.underline,
  2: TextDecoration.overline,
  3: TextDecoration.lineThrough,
};

const _textDecorationStyleStringLookupTable = <String, TextDecorationStyle>{
  "solid": TextDecorationStyle.solid,
  "double": TextDecorationStyle.double,
  "dotted": TextDecorationStyle.dotted,
  "dashed": TextDecorationStyle.dashed,
  "wavy": TextDecorationStyle.wavy,
};

const _textDecorationStyleIntLookupTable = <int, TextDecorationStyle>{
  0: TextDecorationStyle.solid,
  1: TextDecorationStyle.double,
  2: TextDecorationStyle.dotted,
  3: TextDecorationStyle.dashed,
  4: TextDecorationStyle.wavy,
};

const _leadingDistributionStringLookupTable = <String, TextLeadingDistribution>{
  "proportional": TextLeadingDistribution.proportional,
  "even": TextLeadingDistribution.even,
};

const _leadingDistributionIntLookupTable = <int, TextLeadingDistribution>{
  0: TextLeadingDistribution.proportional,
  1: TextLeadingDistribution.even,
};

const _axisStringLookupTable = <String, Axis>{
  "vertical": Axis.vertical,
  "horizontal": Axis.horizontal,
};

const _axisIntLookupTable = <int, Axis>{
  0: Axis.vertical,
  1: Axis.horizontal,
};

const _wrapCrossAlignmentIntLookupTable = <int, WrapCrossAlignment>{
  0: WrapCrossAlignment.start,
  1: WrapCrossAlignment.end,
  2: WrapCrossAlignment.center,
};

const _wrapCrossAlignmentStringLookupTable = <String, WrapCrossAlignment>{
  "start": WrapCrossAlignment.start,
  "end": WrapCrossAlignment.end,
  "center": WrapCrossAlignment.center,
};

const _wrapAlignmentIntLookupTable = <int, WrapAlignment>{
  0: WrapAlignment.start,
  1: WrapAlignment.end,
  2: WrapAlignment.center,
  3: WrapAlignment.spaceBetween,
  4: WrapAlignment.spaceAround,
  5: WrapAlignment.spaceEvenly,
};

const _wrapAlignmentStringLookupTable = <String, WrapAlignment>{
  "start": WrapAlignment.start,
  "end": WrapAlignment.end,
  "center": WrapAlignment.center,
  "spaceBetween": WrapAlignment.spaceBetween,
  "spaceAround": WrapAlignment.spaceAround,
  "spaceEvenly": WrapAlignment.spaceEvenly,
};

const _stackFitIntLookupTable = <int, StackFit>{
  0: StackFit.expand,
  1: StackFit.passthrough,
  2: StackFit.loose,
};

const _stackFitStringLookupTable = <String, StackFit>{
  "expand": StackFit.expand,
  "passthrough": StackFit.passthrough,
  "loose": StackFit.loose,
};

const _overflowBoxFitIntLookupTable = <int, OverflowBoxFit>{
  0: OverflowBoxFit.max,
  1: OverflowBoxFit.deferToChild,
};

const _overflowBoxFitStringLookupTable = <String, OverflowBoxFit>{
  "max": OverflowBoxFit.max,
  "deferToChild": OverflowBoxFit.deferToChild,
};

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

const _alignmentStringLookupTable = <String, Alignment>{
  "topCenter": Alignment.topCenter,
  "topLeft": Alignment.topLeft,
  "topRight": Alignment.topRight,
  "centerLeft": Alignment.centerLeft,
  "center": Alignment.center,
  "centerRight": Alignment.centerRight,
  "bottomLeft": Alignment.bottomLeft,
  "bottomCenter": Alignment.bottomCenter,
  "bottomRight": Alignment.bottomRight,
};

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

const _alignmentDirectionalStringLookupTable = <String, AlignmentDirectional>{
  "topStart": AlignmentDirectional.topStart,
  "topCenter": AlignmentDirectional.topCenter,
  "topEnd": AlignmentDirectional.topEnd,
  "bottomCenter": AlignmentDirectional.bottomCenter,
  "bottomEnd": AlignmentDirectional.bottomEnd,
  "bottomStart": AlignmentDirectional.bottomStart,
  "center": AlignmentDirectional.center,
  "centerStart": AlignmentDirectional.centerStart,
  "centerEnd": AlignmentDirectional.centerEnd,
};

const _mainAxisAlignmentIntLookupTable = <int, MainAxisAlignment>{
  0: MainAxisAlignment.start,
  1: MainAxisAlignment.end,
  2: MainAxisAlignment.center,
  3: MainAxisAlignment.spaceBetween,
  4: MainAxisAlignment.spaceAround,
  5: MainAxisAlignment.spaceEvenly,
};

const _mainAxisAlignmentStringLookupTable = <String, MainAxisAlignment>{
  "start": MainAxisAlignment.start,
  "end": MainAxisAlignment.end,
  "center": MainAxisAlignment.center,
  "spaceBetween": MainAxisAlignment.spaceBetween,
  "spaceAround": MainAxisAlignment.spaceAround,
  "spaceEvenly": MainAxisAlignment.spaceEvenly,
};

const _crossAxisAlignmentIntLookupTable = <int, CrossAxisAlignment>{
  0: CrossAxisAlignment.start,
  1: CrossAxisAlignment.end,
  2: CrossAxisAlignment.center,
  3: CrossAxisAlignment.stretch,
  4: CrossAxisAlignment.baseline,
};

const _crossAxisAlignmentStringLookupTable = <String, CrossAxisAlignment>{
  "start": CrossAxisAlignment.start,
  "end": CrossAxisAlignment.end,
  "center": CrossAxisAlignment.center,
  "stretch": CrossAxisAlignment.stretch,
  "baseline": CrossAxisAlignment.baseline,
};

const _mainAxisSizeIntLookupTable = <int, MainAxisSize>{
  0: MainAxisSize.min,
  1: MainAxisSize.max,
};

const _mainAxisSizeStringLookupTable = <String, MainAxisSize>{
  "min": MainAxisSize.min,
  "max": MainAxisSize.max,
};

const _sliderInteractionIntLookupTable = <int, SliderInteraction>{
  0: SliderInteraction.tapOnly,
  1: SliderInteraction.tapAndSlide,
  2: SliderInteraction.slideOnly,
  3: SliderInteraction.slideThumb,
};

const _sliderInteractionStringLookupTable = <String, SliderInteraction>{
  "tapOnly": SliderInteraction.tapOnly,
  "tapAndSlide": SliderInteraction.tapAndSlide,
  "slideOnly": SliderInteraction.slideOnly,
  "slideThumb": SliderInteraction.slideThumb,
};

const _materialTapTargetSizeIntLookupTable = <int, MaterialTapTargetSize>{
  0: MaterialTapTargetSize.shrinkWrap,
  1: MaterialTapTargetSize.padded,
};

const _materialTapTargetSizeStringLookupTable = <String, MaterialTapTargetSize>{
  "shrinkWrap": MaterialTapTargetSize.shrinkWrap,
  "padded": MaterialTapTargetSize.padded,
};

const _filterQualityIntLookupTable = <int, FilterQuality>{
  0: FilterQuality.none,
  1: FilterQuality.low,
  2: FilterQuality.medium,
  3: FilterQuality.high,
};

const _filterQualityStringLookupTable = <String, FilterQuality>{
  "none": FilterQuality.none,
  "low": FilterQuality.low,
  "medium": FilterQuality.medium,
  "high": FilterQuality.high,
};

const _imageRepeatIntLookupTable = <int, ImageRepeat>{
  0: ImageRepeat.repeat,
  1: ImageRepeat.repeatX,
  2: ImageRepeat.repeatY,
  3: ImageRepeat.noRepeat,
};

const _imageRepeatStringLookupTable = <String, ImageRepeat>{
  "repeat": ImageRepeat.repeat,
  "repeatX": ImageRepeat.repeatX,
  "repeatY": ImageRepeat.repeatY,
  "noRepeat": ImageRepeat.noRepeat,
};

const _boxFitIntLookupTable = <int, BoxFit>{
  0: BoxFit.fill,
  1: BoxFit.contain,
  2: BoxFit.cover,
  3: BoxFit.fitHeight,
  4: BoxFit.fitWidth,
  5: BoxFit.none,
  6: BoxFit.scaleDown,
};

const _boxFitStringLookupTable = <String, BoxFit>{
  "fill": BoxFit.fill,
  "contain": BoxFit.contain,
  "cover": BoxFit.cover,
  "fitHeight": BoxFit.fitHeight,
  "fitWidth": BoxFit.fitWidth,
  "none": BoxFit.none,
  "scaleDown": BoxFit.scaleDown,
};

const _blendModeStringLookupTable = <String, BlendMode>{
  "clear": BlendMode.clear,
  "src": BlendMode.src,
  "dst": BlendMode.dst,
  "srcOver": BlendMode.srcOver,
  "dstOver": BlendMode.dstOver,
  "srcIn": BlendMode.srcIn,
  "dstIn": BlendMode.dstIn,
  "srcOut": BlendMode.srcOut,
  "dstOut": BlendMode.dstOut,
  "srcATop": BlendMode.srcATop,
  "dstATop": BlendMode.dstATop,
  "xor": BlendMode.xor,
  "plus": BlendMode.plus,
  "modulate": BlendMode.modulate,
  "screen": BlendMode.screen,
  "overlay": BlendMode.overlay,
  "darken": BlendMode.darken,
  "lighten": BlendMode.lighten,
  "colorDodge": BlendMode.colorDodge,
  "colorBurn": BlendMode.colorBurn,
  "hardLight": BlendMode.hardLight,
  "softLight": BlendMode.softLight,
  "difference": BlendMode.difference,
  "exclusion": BlendMode.exclusion,
  "multiply": BlendMode.multiply,
  "hue": BlendMode.hue,
  "saturation": BlendMode.saturation,
  "color": BlendMode.color,
  "luminosity": BlendMode.luminosity,
};

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

const _verticalDirectionIntLookupTable = <int, VerticalDirection>{
  0: VerticalDirection.up,
  1: VerticalDirection.down,
};

const _verticalDirectionStringLookupTable = <String, VerticalDirection>{
  "up": VerticalDirection.up,
  "down": VerticalDirection.down,
};

const _boxShapeIntLookupTable = <int, BoxShape>{
  0: BoxShape.circle,
  1: BoxShape.rectangle,
};

const _boxShapeStringLookupTable = <String, BoxShape>{
  "circle": BoxShape.circle,
  "rectangle": BoxShape.rectangle,
};

const _borderStyleIntLookupTable = <int, BorderStyle>{
  0: BorderStyle.solid,
  1: BorderStyle.none,
};

const _borderStyleStringLookupTable = <String, BorderStyle>{
  "solid": BorderStyle.solid,
  "none": BorderStyle.none,
};

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

const _textInputTypeStringLookupTable = <String, TextInputType>{
  "text": TextInputType.text,
  "name": TextInputType.name,
  "none": TextInputType.none,
  "url": TextInputType.url,
  "emailAddress": TextInputType.emailAddress,
  "datetime": TextInputType.datetime,
  "streetAddress": TextInputType.streetAddress,
  "number": TextInputType.number,
  "phone": TextInputType.phone,
  "multiline": TextInputType.multiline,
};

const _keyboardDismissBehaviorIntLookupTable =
    <int, ScrollViewKeyboardDismissBehavior>{
  0: ScrollViewKeyboardDismissBehavior.manual,
  1: ScrollViewKeyboardDismissBehavior.onDrag,
};

const _keyboardDismissBehaviorStringLookupTable =
    <String, ScrollViewKeyboardDismissBehavior>{
  "manual": ScrollViewKeyboardDismissBehavior.manual,
  "onDrag": ScrollViewKeyboardDismissBehavior.onDrag,
};

const _scrollPhysicsIntLookupTable = <int, ScrollPhysics>{
  0: AlwaysScrollableScrollPhysics(),
  1: BouncingScrollPhysics(),
  2: ClampingScrollPhysics(),
  3: FixedExtentScrollPhysics(),
  4: NeverScrollableScrollPhysics(),
};

const _scrollPhysicsStringLookupTable = <String, ScrollPhysics>{
  "alwaysScrollableScrollPhysics": AlwaysScrollableScrollPhysics(),
  "bouncingScrollPhysics": BouncingScrollPhysics(),
  "clampingScrollPhysics": ClampingScrollPhysics(),
  "fixedExtentScrollPhysics": FixedExtentScrollPhysics(),
  "neverScrollableScrollPhysics": NeverScrollableScrollPhysics(),
};

const _dragStartBehaviorIntLookupTable = <int, DragStartBehavior>{
  0: DragStartBehavior.start,
  1: DragStartBehavior.down,
};

const _dragStartBehaviorStringLookupTable = <String, DragStartBehavior>{
  "start": DragStartBehavior.start,
  "down": DragStartBehavior.down,
};

const _hitTestBehaviorIntLookupTable = <int, HitTestBehavior>{
  0: HitTestBehavior.deferToChild,
  1: HitTestBehavior.opaque,
  2: HitTestBehavior.translucent,
};

const _hitTestBehaviorStringLookupTable = <String, HitTestBehavior>{
  "deferToChild": HitTestBehavior.deferToChild,
  "opaque": HitTestBehavior.opaque,
  "translucent": HitTestBehavior.translucent,
};

const _fabLocationStringLookupTable = <String, FloatingActionButtonLocation>{
  "centerDocked": FloatingActionButtonLocation.centerDocked,
  "centerFloat": FloatingActionButtonLocation.centerFloat,
  "centerTop": FloatingActionButtonLocation.centerTop,
  "endDocked": FloatingActionButtonLocation.endDocked,
  "endFloat": FloatingActionButtonLocation.endFloat,
  "endTop": FloatingActionButtonLocation.endTop,
  "startDocked": FloatingActionButtonLocation.startDocked,
  "startFloat": FloatingActionButtonLocation.startFloat,
  "startTop": FloatingActionButtonLocation.startTop,
  "miniCenterDocked": FloatingActionButtonLocation.miniCenterDocked,
  "miniCenterFloat": FloatingActionButtonLocation.miniCenterFloat,
  "miniCenterTop": FloatingActionButtonLocation.miniCenterTop,
  "miniEndDocked": FloatingActionButtonLocation.miniEndDocked,
  "miniEndFloat": FloatingActionButtonLocation.miniEndFloat,
  "miniEndTop": FloatingActionButtonLocation.miniEndTop,
  "miniStartDocked": FloatingActionButtonLocation.miniStartDocked,
  "miniStartFloat": FloatingActionButtonLocation.miniStartFloat,
  "miniStartTop": FloatingActionButtonLocation.miniStartTop,
};

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

const _tileModeStringLookupTable = <String, TileMode>{
  "clamp": TileMode.clamp,
  "mirror": TileMode.mirror,
  "repeated": TileMode.repeated,
  "decal": TileMode.decal,
};

const _tileModeIntLookupTable = <int, TileMode>{
  0: TileMode.clamp,
  1: TileMode.mirror,
  2: TileMode.repeated,
  3: TileMode.decal,
};
