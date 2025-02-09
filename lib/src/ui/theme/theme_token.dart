abstract class ThemeToken {
  final Set<String> excludedFields;
  final Map<String, dynamic> _data;
  final String type;

  Map<String, dynamic> get widgetTheme => _data;

  const ThemeToken(
    this.excludedFields,
    this._data,
    this.type,
  );
}

final class DefaultThemeToken extends ThemeToken {
  const DefaultThemeToken(
    Map<String, dynamic> data,
    String type,
  ) : super(
          const {},
          data,
          type,
        );
}

final class AttendedWidgetThemeToken extends ThemeToken {
  const AttendedWidgetThemeToken(
    Map<String, dynamic> data,
    String type,
  ) : super(
          const {
            "value",
          },
          data,
          type,
        );
}

final class UnknownThemeToken extends ThemeToken {
  const UnknownThemeToken() : super(const {}, const {}, "Unknown");

  @override
  Map<String, dynamic> get widgetTheme => const {};
}

final class TextThemeToken extends ThemeToken {
  const TextThemeToken(Map<String, dynamic> data)
      : super(
          const {
            "data",
          },
          data,
          "Text",
        );
}

final class AnimatedWidgetThemeToken extends ThemeToken {
  const AnimatedWidgetThemeToken(
    Map<String, dynamic> data,
    String type,
  ) : super(
          const {
            "parentBuilderId",
            "affectedProperties",
          },
          data,
          type,
        );
}
