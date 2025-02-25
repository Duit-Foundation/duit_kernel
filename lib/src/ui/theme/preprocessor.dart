import 'package:duit_kernel/src/ui/theme/index.dart';

/// Function for custom tokenization of themes.
typedef CustomTokenizer = ThemeToken? Function(
  String type,
  Map<String, dynamic> themeData,
);

final class ThemePreprocessor {
  final CustomTokenizer? customWidgetTokenizer, overrideWidgetTokenizer;

  const ThemePreprocessor({
    this.customWidgetTokenizer,
    this.overrideWidgetTokenizer,
  });

  ///Creates token for default cases
  ThemeToken _createToken(
    String widgetType,
    Map<String, dynamic> themeData,
  ) {
    return switch (widgetType) {
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
      _ => customWidgetTokenizer?.call(widgetType, themeData) ??
          const UnknownThemeToken(),
    };
  }

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
          token = _createToken(
            widgetType,
            themeData,
          );
        }
      } else {
        token = _createToken(
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
