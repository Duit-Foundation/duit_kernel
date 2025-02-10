import 'package:duit_kernel/duit_kernel.dart';

final class TestAttrParser implements AttributeParserBase {
  @override
  ViewAttribute<T> parse<T>(
    String type,
    Map<String, dynamic>? json,
    String? tag, {
    String? id,
  }) {
    return ViewAttribute(payload: json as T, id: id ?? "");
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
