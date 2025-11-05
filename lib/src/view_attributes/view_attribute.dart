import "package:duit_kernel/duit_kernel.dart";

/// Represents a wrapper for view attributes.
///
/// The [ViewAttribute] class is used to wrap view attributes,
/// providing a convenient way to access and manipulate them.
final class ViewAttribute {
  /// The unique identifier of the view.
  final String id;

  /// The payload of the view attribute.
  ///
  /// Use the [payload] property to access or modify the value of the view attribute.
  final DuitDataSource payload;

  /// Creates a new instance of the [ViewAttribute] class.
  ///
  /// The [payload] parameter is the initial value of the view attribute.
  ViewAttribute._({
    required Map<String, dynamic> payload,
    required this.id,
  }) : payload = DuitDataSource(payload);

  factory ViewAttribute.from(
    String type,
    Map<String, dynamic> json,
    String id, {
    String? tag,
  }) {
    final source = DuitDataSource(json);
    final ignoreTheme = source.getBool("ignoreTheme");
    var value = json;

    if (!ignoreTheme) {
      final themeKey = source.tryGetString("theme");
      final overrideRule = source.themeOverrideRule();

      if (themeKey != null) {
        ThemeToken token;

        token = DuitRegistry.theme.getToken(
          themeKey,
          tag ?? type,
        );

        if (token is UnknownThemeToken) {
          return ViewAttribute._(
            id: id,
            payload: Map<String, dynamic>.from(value),
          );
        }

        if (overrideRule == ThemeOverrideRule.themeOverlay) {
          value = {
            ...token.widgetTheme,
            ...value,
          };
        } else {
          value.addAll(
            token.widgetTheme,
          );
        }
      }
    }

    return ViewAttribute._(
      id: id,
      payload: Map<String, dynamic>.from(value),
    );
  }
}
