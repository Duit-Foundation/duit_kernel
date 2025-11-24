import "package:duit_kernel/duit_kernel.dart";
import "package:flutter/material.dart";

/// Parser for creating [Curve] from a data map.
///
/// Takes a [Map<String, dynamic>] and returns a corresponding [Curve] object.
/// Used for deserializing animation curves from JSON or other data formats.
typedef CustomCurveParser = Curve Function(Map<String, dynamic>);

/// A custom animation curve that slows down the animation progress.
///
/// [SlowpokeCurve] applies a slowdown coefficient [slowRate] to the animation progress,
/// creating a slowdown effect. The [slowRate] value determines how much
/// the animation will be slowed down.
///
/// Example usage:
/// ```dart
/// final curve = SlowpokeCurve(0.5);
/// final animation = Tween(begin: 0.0, end: 1.0).animate(
///   CurvedAnimation(parent: controller, curve: curve)
/// );
/// ```
final class SlowpokeCurve extends Curve {
  /// The slowdown coefficient for the animation.
  ///
  /// The higher the value, the stronger the slowdown.
  /// Default value: 1.0
  final double slowRate;

  /// Creates an instance of [SlowpokeCurve] with the given slowdown coefficient.
  ///
  /// [slowRate] - the slowdown coefficient for the animation.
  const SlowpokeCurve(
    this.slowRate,
  );

  /// Creates an instance of [SlowpokeCurve] from a data map.
  ///
  /// Parses [data] and extracts the [slowRate] value using the "slowRate" key.
  /// If the key is missing, the default value of 1.0 is used.
  ///
  /// Parameters:
  /// - [data] - the data map containing the curve parameters.
  ///
  /// Returns:
  /// - A new instance of [SlowpokeCurve] with parameters from [data].
  factory SlowpokeCurve.fromMap(Map<String, dynamic> data) {
    final source = DuitDataSource(data);
    return SlowpokeCurve(
      source.getDouble(
        key: "slowRate",
        defaultValue: 1.0,
      ),
    );
  }

  @override
  double transform(double t) {
    if (t == 0.0 || t == 1.0) {
      return t;
    }
    return 1.0 - slowRate * t;
  }
}
