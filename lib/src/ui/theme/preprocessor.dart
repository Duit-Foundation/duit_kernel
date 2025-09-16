import "package:duit_kernel/src/ui/theme/index.dart";

/// Function for custom tokenization of themes.
typedef TokenizationCallback = ThemeToken? Function(
  String type,
  Map<String, dynamic> themeData,
);

abstract class ThemePreprocessor {
  final TokenizationCallback? customWidgetTokenizer, overrideWidgetTokenizer;

  const ThemePreprocessor({
    this.customWidgetTokenizer,
    this.overrideWidgetTokenizer,
  });

  ///Creates token for default cases
  ThemeToken createToken(
    String widgetType,
    Map<String, dynamic> themeData,
  );

  DuitTheme tokenize(Map<String, dynamic> theme) {
    final errors = <String>{};
    final tokens = <String, ThemeToken>{};

    for (var themeEntry in theme.entries) {
      final theme = themeEntry.value as Map<String, dynamic>;
      final themeData = theme["data"] as Map<String, dynamic>;
      final widgetType = theme["type"];

      ThemeToken token;

      if (overrideWidgetTokenizer != null) {
        final overridedToken = overrideWidgetTokenizer!(
          widgetType,
          themeData,
        );

        if (overridedToken != null) {
          token = overridedToken;
        } else {
          token = createToken(
            widgetType,
            themeData,
          );
        }
      } else {
        token = createToken(
          widgetType,
          themeData,
        );
      }

      for (var entry in themeData.entries) {
        final key = entry.key;
        if (token.excludedFields.contains(key)) {
          errors.add("Token can`t contains excluded field - |$key|");
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
