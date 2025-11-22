import "package:duit_kernel/duit_kernel.dart";
import "package:flutter/material.dart";

typedef CustomCurveParser = Curve Function(Map<String, dynamic>);

final class SlowpokeCurve extends Curve {
  final double slowRate;

  const SlowpokeCurve(
    this.slowRate,
  );

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
