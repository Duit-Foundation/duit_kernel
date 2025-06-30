import 'package:duit_kernel/duit_kernel.dart';

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
    final ds = DuitDataSource(json);
    final ignoreTheme = ds.getBool("ignoreTheme");
    var value = json;

    if (!ignoreTheme) {
      final themeKey = ds.tryGetString("theme");
      final overrideRule = ds.themeOverrideRule();

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

  /// Casts the view attribute payload to the specified type.
  ///
  /// Return new instance of [ViewAttribute] with new payload type and same data.
  // ViewAttribute<R> cast<R>() {
  //   return ViewAttribute<R>(
  //     id: id,
  //     payload: payload as R,
  //   );
  // }

  /// Creates a new [ViewAttribute] from the given [type], [json], and [tag].
  ///
  /// This factory method is used to create a [ViewAttribute] instance
  /// based on the specified [type], [json], and [tag]. It returns a new instance
  /// of [ViewAttribute] with the appropriate payload type.
  @Deprecated("Use .from instead")
  static ViewAttribute createAttributes(
    String type,
    Map<String, dynamic>? json,
    String? tag, {
    String? id,
  }) {
    assert(json != null);
    assert(id != null);

    final ignoreTheme = json!["ignoreTheme"] ?? false;
    var value = json;

    if (!ignoreTheme) {
      final themeKey = json["theme"] as String?;
      final overrideRule = ThemeOverrideRule.fromString(json["overrideRule"]);

      if (themeKey != null) {
        ThemeToken token;

        if (tag != null) {
          token = DuitRegistry.theme.getToken(
            themeKey,
            tag,
          );
        } else {
          token = DuitRegistry.theme.getToken(
            themeKey,
            type,
          );
        }

        if (token is UnknownThemeToken) {
          return ViewAttribute._(
            id: id!,
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
      id: id!,
      payload: Map<String, dynamic>.from(value),
    );
  }
}
