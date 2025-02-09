import 'package:duit_kernel/src/ui/theme/index.dart';
import 'package:duit_kernel/src/ui/theme/theme_token.dart';

final class ThemePreprocessor {
  DuitTheme tokenize(Map<String, dynamic> theme) {
    final errors = <String>{};
    final tokens = <String, ThemeToken>{};

    for (var themeEntry in theme.entries) {
      final theme = themeEntry.value as Map<String, dynamic>;
      final themeData = theme["data"] as Map<String, dynamic>;

      final ThemeToken token = switch (theme["type"]) {
        "Text" => TextThemeToken(themeData),
        "Align" ||
        "BackdropFilter" ||
        "ColoredBox" ||
        "Container" =>
          AnimatedWidgetThemeToken(
            themeData,
            theme["type"],
          ),
        "ElevatedButton" || "Center" => DefaultThemeToken(
            themeData,
            theme["type"],
          ),
        _ => const UnknownThemeToken(),
      };

      for (var entry in themeData.entries) {
        final key = entry.key;
        if (token.excludedFields.contains(key)) {
          errors.add("Token contains excluded field |$key|");
        }
      }

      tokens[themeEntry.key] = token;
    }

    if (errors.isNotEmpty) {
      throw FormatException(errors.join("\n"));
    }

    return DuitTheme(tokens);
  }
}
