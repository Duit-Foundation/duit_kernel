import 'package:duit_kernel/src/ui/theme/index.dart';
import 'package:duit_kernel/src/ui/theme/theme_token.dart';

final class ThemePreprocessor {
  DuitTheme tokenize(Map<String, dynamic> theme) {
    final errors = <String>{};
    final tokens = <String, ThemeToken>{};

    for (var themeEntry in theme.entries) {
      final theme = themeEntry.value as Map<String, dynamic>;
      final themeData = theme["data"] as Map<String, dynamic>;
      final widgetType = theme["type"];

      /* Ignored widget types:
      - AnimatedBuilder
      - GestureDetector
      - IntrinsicHeight
      - LifecycleStateListener
      - ListView
      - Meta
      - Subtree
      */
      final ThemeToken token = switch (widgetType) {
        "Text" => TextThemeToken(
            themeData,
          ),
        "Image" => ImageThemeToken(
            themeData,
          ),
        "Align" ||
        "BackdropFilter" ||
        "ColoredBox" ||
        "ConstrainedBoxAttributes" ||
        "DecoratedBox" ||
        "Expanded" ||
        "FittedBox" ||
        "Row" ||
        "Column" ||
        "SizedBox" ||
        "Container" ||
        "OverflowBox" ||
        "Padding" ||
        "Positioned" ||
        "Opacity" ||
        "RotatedBox" ||
        "Stack" ||
        "Wrap" ||
        "Transform" =>
          AnimatedPropOwnerThemeToken(
            themeData,
            widgetType,
          ),
        "AnimatedOpacity" => ImplicitAnimatableThemeToken(
            themeData,
            widgetType,
          ),
        "ElevatedButton" ||
        "Center" ||
        "IgnorePointerAttributes" ||
        "RepaintBoundary" ||
        "SingleChildScrollView" =>
          DefaultThemeToken(
            themeData,
            widgetType,
          ),
        "CheckboxAttributes" ||
        "Switch" ||
        "TextField" =>
          AttendedWidgetThemeToken(
            themeData,
            widgetType,
          ),
        "RadioGroupContext" => RadioGroupContextThemeToken(
            themeData,
          ),
        "Radio" => RadioThemeToken(
            themeData,
          ),
        "Slider" => SliderThemeToken(
            themeData,
          ),
        _ => const UnknownThemeToken(),
      };

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
