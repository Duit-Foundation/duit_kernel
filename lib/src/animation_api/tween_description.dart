import "package:duit_kernel/duit_kernel.dart";
import "package:flutter/material.dart";

/// Base class for describing a Tween object.
///
/// This class serves as the foundation for all tween descriptions in the animation API.
/// It encapsulates the common properties needed to define an animation between two values.
///
/// Generic type [T] represents the type of values being animated (e.g., double, Color, TextStyle).
///
/// Example usage:
/// ```dart
/// final tween = TweenDescription(
///   animatedPropKey: 'opacity',
///   duration: Duration(milliseconds: 500),
///   begin: 0.0,
///   end: 1.0,
///   curve: Curves.easeInOut,
///   trigger: AnimationTrigger.onTap,
///   method: AnimationMethod.forward,
///   reverseOnRepeat: false,
/// );
/// ```
base class DuitTweenDescription<T> {
  /// The key identifier for the animated property in the UI component.
  /// This key is used to map the animation to the correct property.
  final String animatedPropKey;

  /// The duration of the animation.
  final Duration duration;

  /// The starting value for the animation.
  final T begin;

  /// The ending value for the animation.
  final T end;

  /// The curve that defines the animation's easing function.
  final Curve curve;

  /// The trigger that initiates the animation.
  final AnimationTrigger trigger;

  /// The method that controls how the animation plays.
  final AnimationMethod method;

  /// Whether the animation should reverse direction when repeating.
  final bool reverseOnRepeat;

  /// Optional interval configuration for controlling animation timing.
  final AnimationInterval? interval;

  /// Creates a new tween description with the specified parameters.
  ///
  /// All parameters are required except [interval] which is optional.
  const DuitTweenDescription({
    required this.animatedPropKey,
    required this.duration,
    required this.begin,
    required this.end,
    required this.trigger,
    required this.curve,
    required this.method,
    required this.reverseOnRepeat,
    this.interval,
  });

  @mustCallSuper
  Map<String, dynamic> toJson() => {
        "animatedPropKey": animatedPropKey,
        "duration": duration,
        "begin": begin,
        "end": end,
        "curve": curve,
        "trigger": trigger,
        "method": method,
        "reverseOnRepeat": reverseOnRepeat,
        if (interval != null) "interval": interval,
      };
}

/// A group of tween descriptions that can be executed together.
///
/// This class allows multiple animations to be grouped and executed simultaneously
/// or in sequence. It's useful for creating complex animation sequences.
///
/// Example usage:
/// ```dart
/// final group = TweenDescriptionGroup(
///   groupId: 'fade_and_scale',
///   duration: Duration(milliseconds: 800),
///   tweens: [
///     TweenDescription(
///       animatedPropKey: 'opacity',
///       duration: Duration(milliseconds: 800),
///       begin: 0.0,
///       end: 1.0,
///       curve: Curves.easeInOut,
///       trigger: AnimationTrigger.onTap,
///       method: AnimationMethod.forward,
///       reverseOnRepeat: false,
///     ),
///     TweenDescription(
///       animatedPropKey: 'scale',
///       duration: Duration(milliseconds: 800),
///       begin: 0.5,
///       end: 1.0,
///       curve: Curves.elasticOut,
///       trigger: AnimationTrigger.onTap,
///       method: AnimationMethod.forward,
///       reverseOnRepeat: false,
///     ),
///   ],
///   method: AnimationMethod.forward,
///   reverseOnRepeat: false,
///   trigger: AnimationTrigger.onTap,
/// );
/// ```
final class TweenDescriptionGroup extends DuitTweenDescription<dynamic> {
  /// The collection of individual tween descriptions in this group.
  final Iterable<DuitTweenDescription> tweens;

  /// Unique identifier for the tween group.
  final String groupId;

  /// Creates a new tween description group.
  ///
  /// The [tweens] parameter contains all the individual animations that will be
  /// executed as part of this group. The [groupId] provides a unique identifier
  /// for the group.
  const TweenDescriptionGroup({
    required super.duration,
    required this.groupId,
    required this.tweens,
    required super.method,
    required super.reverseOnRepeat,
    required super.trigger,
  }) : super(
          animatedPropKey: "",
          end: null,
          begin: null,
          curve: Curves.linear,
        );

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json["type"] = "tweenGroup";
    json["groupId"] = groupId;
    json["tweens"] = tweens.map((tween) => tween.toJson()).toList();
    return json;
  }
}

/// Description for a standard [Tween] animation that animates between double values.
///
/// This class is used for animating numeric properties such as opacity, scale,
/// rotation, and other double-based values.
///
/// Example usage:
/// ```dart
/// final opacityTween = TweenDescription(
///   animatedPropKey: 'opacity',
///   duration: Duration(milliseconds: 500),
///   begin: 0.0,
///   end: 1.0,
///   curve: Curves.easeInOut,
///   trigger: AnimationTrigger.onTap,
///   method: AnimationMethod.forward,
///   reverseOnRepeat: false,
/// );
/// ```
final class TweenDescription extends DuitTweenDescription<double> {
  /// Creates a new tween description for double-based animations.
  TweenDescription({
    required super.animatedPropKey,
    required super.duration,
    required super.begin,
    required super.end,
    required super.curve,
    required super.trigger,
    required super.method,
    required super.reverseOnRepeat,
    super.interval,
  });
}

/// Description for a [ColorTween] animation that animates between Color values.
///
/// This class is used for animating color properties such as background color,
/// text color, border color, and other color-based values.
///
/// Example usage:
/// ```dart
/// final colorTween = ColorTweenDescription(
///   animatedPropKey: 'backgroundColor',
///   duration: Duration(milliseconds: 300),
///   begin: Colors.red,
///   end: Colors.blue,
///   curve: Curves.easeInOut,
///   trigger: AnimationTrigger.onHover,
///   method: AnimationMethod.forward,
///   reverseOnRepeat: true,
/// );
/// ```
final class ColorTweenDescription extends DuitTweenDescription<Color> {
  /// Creates a new color tween description.
  ColorTweenDescription({
    required super.animatedPropKey,
    required super.duration,
    required super.begin,
    required super.end,
    required super.curve,
    required super.trigger,
    required super.method,
    required super.reverseOnRepeat,
    super.interval,
  });

  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..["type"] = TweenType.colorTween;
}

/// Description for a [TextStyleTween] animation that animates between TextStyle values.
///
/// This class is used for animating text style properties such as font size,
/// font weight, color, and other text-related styling.
///
/// Example usage:
/// ```dart
/// final textStyleTween = TextStyleTweenDescription(
///   animatedPropKey: 'textStyle',
///   duration: Duration(milliseconds: 400),
///   begin: TextStyle(fontSize: 14, color: Colors.black),
///   end: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
///   curve: Curves.easeInOut,
///   trigger: AnimationTrigger.onFocus,
///   method: AnimationMethod.forward,
///   reverseOnRepeat: false,
/// );
/// ```
final class TextStyleTweenDescription extends DuitTweenDescription<TextStyle> {
  /// Creates a new text style tween description.
  TextStyleTweenDescription({
    required super.animatedPropKey,
    required super.duration,
    required super.begin,
    required super.end,
    required super.curve,
    required super.trigger,
    required super.method,
    required super.reverseOnRepeat,
    super.interval,
  });

  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..["type"] = TweenType.textStyleTween;
}

/// Description for a [DecorationTween] animation that animates between Decoration values.
///
/// This class is used for animating decoration properties such as borders,
/// backgrounds, shadows, and other decorative elements.
///
/// Example usage:
/// ```dart
/// final decorationTween = DecorationTweenDescription(
///   animatedPropKey: 'decoration',
///   duration: Duration(milliseconds: 600),
///   begin: BoxDecoration(
///     color: Colors.white,
///     borderRadius: BorderRadius.circular(8),
///   ),
///   end: BoxDecoration(
///     color: Colors.blue,
///     borderRadius: BorderRadius.circular(20),
///     boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
///   ),
///   curve: Curves.easeInOut,
///   trigger: AnimationTrigger.onTap,
///   method: AnimationMethod.forward,
///   reverseOnRepeat: true,
/// );
/// ```
final class DecorationTweenDescription
    extends DuitTweenDescription<Decoration> {
  /// Creates a new decoration tween description.
  DecorationTweenDescription({
    required super.animatedPropKey,
    required super.duration,
    required super.begin,
    required super.end,
    required super.curve,
    required super.trigger,
    required super.method,
    required super.reverseOnRepeat,
    super.interval,
  });

  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..["type"] = TweenType.decorationTween;
}

/// Description for an [AlignmentTween] animation that animates between AlignmentGeometry values.
///
/// This class is used for animating alignment properties such as positioning
/// of widgets within their containers.
///
/// Example usage:
/// ```dart
/// final alignmentTween = AlignmentTweenDescription(
///   animatedPropKey: 'alignment',
///   duration: Duration(milliseconds: 500),
///   begin: Alignment.topLeft,
///   end: Alignment.bottomRight,
///   curve: Curves.easeInOut,
///   trigger: AnimationTrigger.onTap,
///   method: AnimationMethod.forward,
///   reverseOnRepeat: true,
/// );
/// ```
final class AlignmentTweenDescription
    extends DuitTweenDescription<AlignmentGeometry> {
  /// Creates a new alignment tween description.
  AlignmentTweenDescription({
    required super.animatedPropKey,
    required super.duration,
    required super.begin,
    required super.end,
    required super.curve,
    required super.trigger,
    required super.method,
    required super.reverseOnRepeat,
    super.interval,
  });

  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..["type"] = TweenType.alignmentTween;
}

/// Description for an [EdgeInsetsTween] animation that animates between EdgeInsetsGeometry values.
///
/// This class is used for animating padding and margin properties.
///
/// Example usage:
/// ```dart
/// final edgeInsetsTween = EdgeInsetsTweenDescription(
///   animatedPropKey: 'padding',
///   duration: Duration(milliseconds: 300),
///   begin: EdgeInsets.all(8),
///   end: EdgeInsets.all(16),
///   curve: Curves.easeInOut,
///   trigger: AnimationTrigger.onHover,
///   method: AnimationMethod.forward,
///   reverseOnRepeat: true,
/// );
/// ```
final class EdgeInsetsTweenDescription
    extends DuitTweenDescription<EdgeInsetsGeometry> {
  /// Creates a new edge insets tween description.
  EdgeInsetsTweenDescription({
    required super.animatedPropKey,
    required super.duration,
    required super.begin,
    required super.end,
    required super.curve,
    required super.trigger,
    required super.method,
    required super.reverseOnRepeat,
    super.interval,
  });

  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..["type"] = TweenType.edgeInsetsTween;
}

/// Description for a [BoxConstraintsTween] animation that animates between BoxConstraints values.
///
/// This class is used for animating constraint properties such as minimum and maximum
/// width and height of widgets.
///
/// Example usage:
/// ```dart
/// final boxConstraintsTween = BoxConstraintsTweenDescription(
///   animatedPropKey: 'constraints',
///   duration: Duration(milliseconds: 400),
///   begin: BoxConstraints(minWidth: 100, minHeight: 50),
///   end: BoxConstraints(minWidth: 200, minHeight: 100),
///   curve: Curves.easeInOut,
///   trigger: AnimationTrigger.onTap,
///   method: AnimationMethod.forward,
///   reverseOnRepeat: false,
/// );
/// ```
final class BoxConstraintsTweenDescription
    extends DuitTweenDescription<BoxConstraints> {
  /// Creates a new box constraints tween description.
  BoxConstraintsTweenDescription({
    required super.animatedPropKey,
    required super.duration,
    required super.begin,
    required super.end,
    required super.curve,
    required super.trigger,
    required super.method,
    required super.reverseOnRepeat,
    super.interval,
  });

  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..["type"] = TweenType.boxConstraintsTween;
}

/// Description for a [SizeTween] animation that animates between Size values.
///
/// This class is used for animating size properties of widgets.
///
/// Example usage:
/// ```dart
/// final sizeTween = SizeTweenDescription(
///   animatedPropKey: 'size',
///   duration: Duration(milliseconds: 500),
///   begin: Size(100, 50),
///   end: Size(200, 100),
///   curve: Curves.easeInOut,
///   trigger: AnimationTrigger.onTap,
///   method: AnimationMethod.forward,
///   reverseOnRepeat: true,
/// );
/// ```
final class SizeTweenDescription extends DuitTweenDescription<Size> {
  /// Creates a new size tween description.
  SizeTweenDescription({
    required super.animatedPropKey,
    required super.duration,
    required super.begin,
    required super.end,
    required super.curve,
    required super.trigger,
    required super.method,
    required super.reverseOnRepeat,
    super.interval,
  });

  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..["type"] = TweenType.sizeTween;
}

/// Description for a [BorderTween] animation that animates between Border values.
///
/// This class is used for animating border properties such as border width,
/// border color, and border style.
///
/// Example usage:
/// ```dart
/// final borderTween = BorderTweenDescription(
///   animatedPropKey: 'border',
///   duration: Duration(milliseconds: 300),
///   begin: Border.all(color: Colors.grey, width: 1),
///   end: Border.all(color: Colors.blue, width: 3),
///   curve: Curves.easeInOut,
///   trigger: AnimationTrigger.onFocus,
///   method: AnimationMethod.forward,
///   reverseOnRepeat: false,
/// );
/// ```
final class BorderTweenDescription extends DuitTweenDescription<Border> {
  /// Creates a new border tween description.
  BorderTweenDescription({
    required super.animatedPropKey,
    required super.duration,
    required super.begin,
    required super.end,
    required super.curve,
    required super.trigger,
    required super.method,
    required super.reverseOnRepeat,
    super.interval,
  });

  @override
  Map<String, dynamic> toJson() =>
      super.toJson()..["type"] = TweenType.borderTween;
}
