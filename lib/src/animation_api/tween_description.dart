import 'package:duit_kernel/duit_kernel.dart';
import 'package:flutter/material.dart';

extension type _TweenView(Map<String, dynamic> value) implements Map {
  AnimationMethod get method {
    final val = value["method"];
    return switch (val) {
      0 || "forvard" => AnimationMethod.forward,
      1 || "repeat" => AnimationMethod.repeat,
      2 || "reverse" => AnimationMethod.reverse,
      3 || "toggle" => AnimationMethod.toggle,
      Object() || null => AnimationMethod.forward,
    };
  }

  AnimationInterval? get interval {
    final interval = value["interval"];
    if (interval == null) {
      return null;
    }

    if (interval is Map) {
      return AnimationInterval(
        interval["begin"] ?? 0.0,
        interval["end"] ?? 1.0,
      );
    }

    if (interval is List) {
      return AnimationInterval(
        interval[0],
        interval[1],
      );
    }

    return null;
  }

  AnimationTrigger get trigger {
    final trigger = value["trigger"];
    return switch (trigger) {
      0 || "onEnter" => AnimationTrigger.onEnter,
      1 || "onAction" => AnimationTrigger.onAction,
      Object() || null => AnimationTrigger.onEnter,
    };
  }
}

/// Base class for describing a Tween object, parsing json into concrete Tween types
base class DuitTweenDescription<T> {
  final String animatedPropKey;
  final Duration duration;
  final T begin, end;
  final Curve curve;
  final AnimationTrigger trigger;
  final AnimationMethod method;
  final bool reverseOnRepeat;
  final AnimationInterval? interval;

  const DuitTweenDescription({
    required this.animatedPropKey,
    required this.duration,
    required this.begin,
    required this.end,
    this.trigger = AnimationTrigger.onEnter,
    this.curve = Curves.linear,
    this.method = AnimationMethod.forward,
    this.reverseOnRepeat = false,
    this.interval,
  });

  /// Deserializes a [json] object into a [DuitTweenDescription]
  static DuitTweenDescription fromJson(Map<String, dynamic> json) {
    final type = json["type"] as String;

    final view = _TweenView(json);
    final data = DuitDataSource(json);

    if (type == "group") {
      assert(json.containsKey("tweens"),
          "Group object must have **tweens** property");
      assert(json["tweens"] is List,
          "Group object **tweens** property must be a list");

      return TweenDescriptionGroup(
        duration: data.duration(),
        groupId: json["groupId"],
        tweens: (json["tweens"] as List)
            .cast<Map<String, dynamic>>()
            .map((tween) => DuitTweenDescription.fromJson(tween))
            .toList(),
        method: view.method,
        reverseOnRepeat: data.getBool("reverseOnRepeat"),
        trigger: view.trigger,
      );
    }

    return switch (type) {
      "colorTween" => ColorTweenDescription(
          animatedPropKey: json["animatedPropKey"],
          duration: data.duration(),
          begin: data.parseColor(key: "begin"),
          end: data.parseColor(key: "end"),
          curve: data.curve(defaultValue: Curves.linear)!,
          trigger: view.trigger,
          method: view.method,
          reverseOnRepeat: data.getBool("reverseOnRepeat"),
          interval: view.interval,
        ),
      "tween" => TweenDescription(
          animatedPropKey: json["animatedPropKey"],
          duration: data.duration(),
          begin: data.getDouble(key: "begin"),
          end: data.getDouble(key: "end"),
          curve: data.curve(defaultValue: Curves.linear)!,
          trigger: view.trigger,
          method: view.method,
          reverseOnRepeat: data.getBool("reverseOnRepeat"),
          interval: view.interval,
        ),
      "textStyleTween" => TextStyleTweenDescription(
          animatedPropKey: json["animatedPropKey"],
          duration: data.duration(),
          begin: data.textStyle(
            key: "begin",
            defaultValue: const TextStyle(),
          )!,
          end: data.textStyle(
            key: "end",
            defaultValue: const TextStyle(),
          )!,
          curve: data.curve(defaultValue: Curves.linear)!,
          trigger: view.trigger,
          method: view.method,
          reverseOnRepeat: data.getBool("reverseOnRepeat"),
          interval: view.interval,
        ),
      "decorationTween" => DecorationTweenDescription(
          animatedPropKey: json["animatedPropKey"],
          duration: data.duration(),
          begin: data.decoration(
            key: "begin",
            defaultValue: const BoxDecoration(),
          )!,
          end: data.decoration(
            key: "end",
            defaultValue: const BoxDecoration(),
          )!,
          curve: data.curve(defaultValue: Curves.linear)!,
          trigger: view.trigger,
          method: view.method,
          reverseOnRepeat: data.getBool("reverseOnRepeat"),
          interval: view.interval,
        ),
      "alignmentTween" => AlignmentTweenDescription(
          animatedPropKey: json["animatedPropKey"],
          duration: data.duration(),
          begin: data.alignment(key: "begin")!,
          end: data.alignment(key: "end")!,
          curve: data.curve(defaultValue: Curves.linear)!,
          trigger: view.trigger,
          method: view.method,
          reverseOnRepeat: data.getBool("reverseOnRepeat"),
          interval: view.interval,
        ),
      "edgeInsetsTween" => EdgeInsetsTweenDescription(
          animatedPropKey: json["animatedPropKey"],
          duration: data.duration(),
          begin: data.edgeInsets(key: "begin"),
          end: data.edgeInsets(key: "end"),
          curve: data.curve(defaultValue: Curves.linear)!,
          trigger: view.trigger,
          method: view.method,
          reverseOnRepeat: data.getBool("reverseOnRepeat"),
          interval: view.interval,
        ),
      "boxConstraintsTween" => BoxConstraintsTweenDescription(
          animatedPropKey: json["animatedPropKey"],
          duration: data.duration(),
          begin: data.boxConstraints(key: "begin"),
          end: data.boxConstraints(key: "end"),
          curve: data.curve(defaultValue: Curves.linear)!,
          trigger: view.trigger,
          method: view.method,
          reverseOnRepeat: data.getBool("reverseOnRepeat"),
          interval: view.interval,
        ),
      "sizeTween" => SizeTweenDescription(
          animatedPropKey: json["animatedPropKey"],
          duration: data.duration(),
          begin: data.size("begin"),
          end: data.size("end"),
          curve: data.curve(defaultValue: Curves.linear)!,
          trigger: view.trigger,
          method: view.method,
          reverseOnRepeat: data.getBool("reverseOnRepeat"),
          interval: view.interval,
        ),
      "borderTween" => BorderTweenDescription(
          animatedPropKey: json["animatedPropKey"],
          duration: data.duration(),
          begin: data.border(key: "begin")!,
          end: data.border(key: "end")!,
          curve: data.curve(defaultValue: Curves.linear)!,
          trigger: view.trigger,
          method: view.method,
          reverseOnRepeat: data.getBool("reverseOnRepeat"),
          interval: view.interval,
        ),
      String() => throw UnimplementedError(),
    };
  }
}
