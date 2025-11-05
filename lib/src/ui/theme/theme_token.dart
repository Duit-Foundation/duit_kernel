/// An abstract class representing a token for a theme in the application.
///
/// [ThemeToken] is used to encapsulate theme-related data for widgets,
/// allowing for consistent styling and theme management across the application.
/// It holds a set of excluded fields, theme data in the form of a map, and a type
/// identifier.
///
/// Subclasses of [ThemeToken] provide specific implementations for different
/// types of themes.
///
/// Fields:
/// - [excludedFields]: A set of field names that are excluded from the theme data.
/// - [_data]: A map containing the theme data associated with the widget.
/// - [type]: A string identifier indicating the type of the theme.
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

/// A concrete implementation of [ThemeToken] that can be used directly.
///
/// Provides a default implementation of [ThemeToken] that can be used for
/// widgets that do not have specific styling requirements.
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

/// A [ThemeToken] that represents a theme that is not recognized.
///
/// This token always has empty theme data and is used when the type of the
/// theme is not recognized.
final class UnknownThemeToken extends ThemeToken {
  const UnknownThemeToken() : super(const {}, const {}, "Unknown");

  @override
  Map<String, dynamic> get widgetTheme => const {};
}
