import "package:duit_kernel/duit_kernel.dart";
import "package:flutter_test/flutter_test.dart";

enum _UnregisteredEnum { a, b }

enum _TestEnum {
  alpha,
  beta,
  gamma;

  static _TestEnum fromString(String value) {
    return _TestEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError("Unknown enum value: $value"),
    );
  }
}

class _UnregisteredClass {
  const _UnregisteredClass();
}

class _TestPoint {
  final int x;
  final int y;

  const _TestPoint(this.x, this.y);

  static _TestPoint fromMap(Map<String, dynamic> map) {
    return _TestPoint(
      (map["x"] as num).toInt(),
      (map["y"] as num).toInt(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _TestPoint && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}

void main() {
  group("Custom enum factory", () {
    setUp(() {
      DuitRegistry.registerCustomEnumFactory<_TestEnum>(
        (value) => _TestEnum.fromString(value as String),
      );
    });

    test("should parse enum from string via registered factory", () {
      final json = <String, dynamic>{"status": "beta"};
      final data = DuitDataSource(json);

      expect(data.toEnum<_TestEnum>(key: "status"), _TestEnum.beta);
    });

    test("should parse enum from int index via registered factory", () {
      DuitRegistry.registerCustomEnumFactory<_TestEnum>(
        (value) {
          if (value is int) {
            return _TestEnum.values[value];
          }
          return _TestEnum.fromString(value as String);
        },
      );

      final json = <String, dynamic>{"status": 2};
      final data = DuitDataSource(json);

      expect(data.toEnum<_TestEnum>(key: "status"), _TestEnum.gamma);
    });

    test("should return existing instance when value is already of type T", () {
      final json = <String, dynamic>{"status": _TestEnum.alpha};
      final data = DuitDataSource(json);

      expect(data.toEnum<_TestEnum>(key: "status"), _TestEnum.alpha);
    });

    test("should return defaultValue when value is null", () {
      final json = <String, dynamic>{};
      final data = DuitDataSource(json);

      expect(
        data.toEnum<_TestEnum>(
          key: "status",
          defaultValue: _TestEnum.gamma,
        ),
        _TestEnum.gamma,
      );
    });

    test("should cache result in underlying JSON map", () {
      final json = <String, dynamic>{"status": "alpha"};
      final data = DuitDataSource(json);

      data.toEnum<_TestEnum>(key: "status");

      expect(data["status"], _TestEnum.alpha);
    });

    test("should throw when value is null and no defaultValue", () {
      final json = <String, dynamic>{};
      final data = DuitDataSource(json);

      expect(
        () => data.toEnum<_TestEnum>(key: "status"),
        throwsA(isA<ArgumentError>()),
      );
    });

    test("should throw when no factory registered for type", () {
      final json = <String, dynamic>{
        "val": _UnregisteredEnum.a.name,
      };
      final data = DuitDataSource(json);

      expect(_UnregisteredEnum.values, contains(_UnregisteredEnum.b));
      expect(
        () => data.toEnum<_UnregisteredEnum>(key: "val"),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group("Custom object factory", () {
    setUp(() {
      DuitRegistry.registerCustomObjectFactory<_TestPoint>(
        (source) => _TestPoint.fromMap(
          Map<String, dynamic>.from(source as Map<String, dynamic>),
        ),
      );
    });

    test("should parse object from nested map via registered factory", () {
      final json = <String, dynamic>{
        "point": {"x": 10, "y": 20},
      };
      final data = DuitDataSource(json);

      expect(
        data.toClass<_TestPoint>(key: "point"),
        const _TestPoint(10, 20),
      );
    });

    test("should return existing instance when value is already of type T", () {
      const point = _TestPoint(5, 5);
      final json = <String, dynamic>{"point": point};
      final data = DuitDataSource(json);

      expect(data.toClass<_TestPoint>(key: "point"), point);
    });

    test("should return defaultValue when value is null", () {
      final json = <String, dynamic>{};
      final data = DuitDataSource(json);

      const defaultPoint = _TestPoint(0, 0);
      expect(
        data.toClass<_TestPoint>(
          key: "point",
          defaultValue: defaultPoint,
        ),
        defaultPoint,
      );
    });

    test("should use typeArg when provided", () {
      DuitRegistry.registerCustomObjectFactory<_TestPoint>(
        (source) => _TestPoint.fromMap(
          Map<String, dynamic>.from(source as Map<String, dynamic>),
        ),
      );

      final json = <String, dynamic>{"point": {"x": 1, "y": 2}};
      final data = DuitDataSource(json);

      expect(
        data.toClass<_TestPoint>(key: "point", typeArg: _TestPoint),
        const _TestPoint(1, 2),
      );
    });

    test("should cache result in underlying JSON map", () {
      final json = <String, dynamic>{"point": {"x": 3, "y": 4}};
      final data = DuitDataSource(json);

      final result = data.toClass<_TestPoint>(key: "point");

      expect(data["point"], result);
    });

    test("should throw when value is null and no defaultValue", () {
      final json = <String, dynamic>{};
      final data = DuitDataSource(json);

      expect(
        () => data.toClass<_TestPoint>(key: "point"),
        throwsA(isA<ArgumentError>()),
      );
    });

    test("should throw when no factory registered for type", () {
      final json = <String, dynamic>{"val": {}};
      final data = DuitDataSource(json);

      expect(
        () => data.toClass<_UnregisteredClass>(key: "val"),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group("DuitRegistry custom factory registration", () {
    test("registerCustomEnumFactory delegates to DuitDataSource", () {
      var called = false;
      DuitRegistry.registerCustomEnumFactory<_TestEnum>((value) {
        called = true;
        return _TestEnum.fromString(value as String);
      });

      final json = <String, dynamic>{"x": "alpha"};
      DuitDataSource(json).toEnum<_TestEnum>(key: "x");

      expect(called, isTrue);
    });

    test("registerCustomObjectFactory delegates to DuitDataSource", () {
      var called = false;
      DuitRegistry.registerCustomObjectFactory<_TestPoint>((source) {
        called = true;
        return _TestPoint.fromMap(
          Map<String, dynamic>.from(source as Map<String, dynamic>),
        );
      });

      final json = <String, dynamic>{"p": {"x": 0, "y": 0}};
      DuitDataSource(json).toClass<_TestPoint>(key: "p");

      expect(called, isTrue);
    });
  });
}
