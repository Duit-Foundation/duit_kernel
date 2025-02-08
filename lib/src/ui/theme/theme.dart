import 'package:duit_kernel/src/ui/theme/theme_token.dart';

final class DuitTheme {
  final Map<String, ThemeToken> _tokens;

  const DuitTheme(
    Map<String, ThemeToken> theme,
  ) : _tokens = theme;

  ThemeToken getToken(String key) => _tokens[key] ?? const UnknownThemeToken();
}
