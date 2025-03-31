const _animatedOwnerExcludedFields = {
  "parentBuilderId",
  "affectedProperties",
};

const _attendedWidgetExcludedFields = {
  "value",
};

const _subviewsExcludedFields = {
  "leading",
  "title",
  "actions",
  "bottom",
  "flexibleSpace",
  "body",
  "appBar",
  "bottomNavigationBar",
  "floatingActionButton",
  "bottomSheet",
  "persistentFooterButtons"
};

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

// Token excluding properties associated with [AttendedModel] attributes
final class AttendedWidgetThemeToken extends ThemeToken {
  const AttendedWidgetThemeToken(
    Map<String, dynamic> data,
    String type,
  ) : super(
          _attendedWidgetExcludedFields,
          data,
          type,
        );
}

final class RadioGroupContextThemeToken extends ThemeToken {
  const RadioGroupContextThemeToken(
    Map<String, dynamic> data,
  ) : super(
          const {
            ..._attendedWidgetExcludedFields,
            "groupValue",
          },
          data,
          "RadioGroupContext",
        );
}

final class RadioThemeToken extends ThemeToken {
  const RadioThemeToken(
    Map<String, dynamic> data,
  ) : super(
          const {
            ..._attendedWidgetExcludedFields,
            ..._animatedOwnerExcludedFields,
          },
          data,
          "Radio",
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

/// A [ThemeToken] for text-related themes.
///
/// This token handles theme data specifically for text widgets.
final class TextThemeToken extends ThemeToken {
  /// Creates a [TextThemeToken] with the given theme [data].
  ///
  /// The [data] map contains key-value pairs representing the theme
  /// properties for text widgets.
  const TextThemeToken(Map<String, dynamic> data)
      : super(
          const {
            "data",
            ..._animatedOwnerExcludedFields,
          },
          data,
          "Text",
        );
}

/// A [ThemeToken] for animated property owner-related themes.
final class AnimatedPropOwnerThemeToken extends ThemeToken {
  /// Creates a [AnimatedPropOwnerThemeToken] with the given theme [data].
  ///
  /// The [data] map contains key-value pairs representing the theme
  /// properties for animated property owner widgets.
  const AnimatedPropOwnerThemeToken(
    Map<String, dynamic> data,
    String type,
  ) : super(
          _animatedOwnerExcludedFields,
          data,
          type,
        );
}

final class ImageThemeToken extends ThemeToken {
  const ImageThemeToken(Map<String, dynamic> data)
      : super(
          const {
            "type",
            "src",
            "byteData",
            ..._animatedOwnerExcludedFields,
          },
          data,
          "Image",
        );
}

final class ImplicitAnimatableThemeToken extends ThemeToken {
  const ImplicitAnimatableThemeToken(
    Map<String, dynamic> data,
    String type,
  ) : super(
          const {
            "onEnd",
          },
          data,
          type,
        );
}

final class RichTextThemeToken extends ThemeToken {
  const RichTextThemeToken(Map<String, dynamic> data)
      : super(
          const {
            ..._animatedOwnerExcludedFields,
            "textSpan",
          },
          data,
          "RichText",
        );
}

final class SliderThemeToken extends ThemeToken {
  const SliderThemeToken(Map<String, dynamic> data)
      : super(
          const {
            ..._attendedWidgetExcludedFields,
            "onChanged",
            "onChangeStart",
            "onChangeEnd",
          },
          data,
          "Slider",
        );
}

final class ExcludeGestureCallbacksThemeToken extends ThemeToken {
  const ExcludeGestureCallbacksThemeToken(
    Map<String, dynamic> data,
    String type,
  ) : super(
          const {
            ..._animatedOwnerExcludedFields,
            "onTap",
            "onTapDown",
            "onTapUp",
            "onTapCancel",
            "onDoubleTap",
            "onDoubleTapDown",
            "onDoubleTapCancel",
            "onLongPressDown",
            "onLongPressCancel",
            "onLongPress",
            "onLongPressStart",
            "onLongPressMoveUpdate",
            "onLongPressUp",
            "onLongPressEnd",
            "onPanStart",
            "onPanDown",
            "onPanUpdate",
            "onPanEnd",
            "onPanCancel",
            "onSecondaryTapDown",
            "onSecondaryTapCancel",
            "onSecondaryTap",
            "onSecondaryTapUp",
          },
          data,
          type,
        );
}

final class ExcludeChildThemeToken extends ThemeToken {
  const ExcludeChildThemeToken(
    Map<String, dynamic> data,
    String type,
  ) : super(
          const {
            ..._animatedOwnerExcludedFields,
            ..._subviewsExcludedFields,
          },
          data,
          type,
        );
}

final class DynamicChildHolderThemeToken extends ThemeToken {
  const DynamicChildHolderThemeToken(
    Map<String, dynamic> data,
    String type,
  ) : super(
          const {
            "childObjects",
            "constructor",
            "type",
            "restorationId",
          },
          data,
          type,
        );
}
