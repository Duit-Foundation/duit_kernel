import 'package:duit_kernel/duit_kernel.dart';

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
