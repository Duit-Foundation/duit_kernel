enum ThemeOverrideRule {
  themeOverlay,
  themePriority();

  static ThemeOverrideRule fromString(dynamic value) {
    switch (value) {
      case "themeOverlay" || 0:
        return ThemeOverrideRule.themeOverlay;
      case "themePriority" || 1:
        return ThemeOverrideRule.themePriority;
      default:
        throw ArgumentError("Invalid ThemeOverrideRule value: $value");
    }
  }
}
