abstract class ThemeToken {
  final Set<String> excludedFields;
  final Map<String, dynamic> _data;

  Map<String, dynamic> get widgetTheme => _data;

  const ThemeToken(this.excludedFields, this._data);
}

final class DefaultThemeToken extends ThemeToken {
  const DefaultThemeToken() : super(const {}, const {});
}

final class AttendedWidgetThemeToken extends ThemeToken {
  const AttendedWidgetThemeToken(Map<String, dynamic> data)
      : super(
          const {
            "value",
          },
          data,
        );
}

final class UnknownThemeToken extends ThemeToken {
  const UnknownThemeToken() : super(const {}, const {});

  @override
  Map<String, dynamic> get widgetTheme => throw UnimplementedError(
      "You try get theme from unknown token. Check your theme configuration.");
}

final class TextThemeToken extends ThemeToken {
  const TextThemeToken(Map<String, dynamic> data)
      : super(
          const {
            "data",
          },
          data,
        );
}

final class AnimatedWidgetThemeToken extends ThemeToken {
  const AnimatedWidgetThemeToken(Map<String, dynamic> data)
      : super(
          const {
            "parentBuilderId",
            "affectedProperties",
          },
          data,
        );
}
