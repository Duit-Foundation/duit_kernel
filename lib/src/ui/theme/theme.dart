import "package:duit_kernel/src/ui/theme/theme_token.dart";

final class DuitTheme {
  final Map<String, ThemeToken> _tokens;

  const DuitTheme(
    Map<String, ThemeToken> theme,
  ) : _tokens = theme;

  ThemeToken getToken(
    String key,
    String type,
  ) {
    final token = _tokens[key];

    if (token == null) {
      return const UnknownThemeToken();
    } else if (token.type == type) {
      return token;
    } else {
      return const UnknownThemeToken();
    }
  }
}
