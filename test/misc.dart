import 'package:duit_kernel/duit_kernel.dart';

final class TestAttrParser implements AttributeParserBase {
  dynamic _parseCustom(Map<String, dynamic> data, String tag) {
    return const CustomAttributes();
  }

  @override
  ViewAttribute<T> parse<T>(
    String type,
    Map<String, dynamic>? json,
    String? tag, {
    String? id,
  }) {
    if (tag != null) {
      return ViewAttribute(
        payload: _parseCustom(json!, tag) as T,
        id: id ?? "",
      );
    }

    return ViewAttribute(
      payload: json as T,
      id: id ?? "",
    );
  }
}

final class TestAttributes implements DuitAttributes<TestAttributes> {
  const TestAttributes();

  @override
  TestAttributes copyWith(TestAttributes other) {
    return const TestAttributes();
  }

  @override
  ReturnT dispatchInternalCall<ReturnT>(
    String methodName, {
    Iterable? positionalParams,
    Map<String, dynamic>? namedParams,
  }) {
    throw UnimplementedError();
  }
}

final class CustomAttributes implements DuitAttributes<CustomAttributes> {
  const CustomAttributes();

  @override
  CustomAttributes copyWith(CustomAttributes other) {
    return const CustomAttributes();
  }

  @override
  ReturnT dispatchInternalCall<ReturnT>(
    String methodName, {
    Iterable? positionalParams,
    Map<String, dynamic>? namedParams,
  }) {
    throw UnimplementedError();
  }
}

final class SomeWidgetThemeToken extends ThemeToken {
  const SomeWidgetThemeToken(
    Map<String, dynamic> data,
  ) : super(
          const {},
          data,
          'SomeCustomWidget',
        );
}

final class OverridedTextThemeToken extends ThemeToken {
  const OverridedTextThemeToken(
    Map<String, dynamic> data,
  ) : super(
          const {
            "data",
            "style",
          },
          data,
          'Text',
        );
}
