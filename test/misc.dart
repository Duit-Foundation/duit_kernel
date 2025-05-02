import 'package:duit_kernel/duit_kernel.dart';

// final class TestAttrParser implements AttributeParserBase {
//   dynamic _parseCustom(Map<String, dynamic> data, String tag) {
//     return const CustomAttributes();
//   }

//   @override
//   ViewAttribute parse(
//     String type,
//     Map<String, dynamic>? json,
//     String? tag, {
//     String? id,
//   }) {
//     if (tag != null) {
//       return ViewAttribute(
//         payload: _parseCustom(json!, tag) as T,
//         id: id ?? "",
//       );
//     }

//     return ViewAttribute(
//       payload: json as T,
//       id: id ?? "",
//     );
//   }
// }

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
