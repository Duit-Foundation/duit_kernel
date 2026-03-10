import "package:duit_kernel/duit_kernel.dart";
import "package:flutter/widgets.dart";
import "package:meta/meta.dart";

/// A function that builds a [Widget] from a given [ElementTreeEntry].
///
/// Used as the core rendering callback inside [WidgetDescriptor.widgetBuilder].
/// The [entry] argument carries the element's id, attributes, children, and
/// controller reference so the builder can produce the correct Flutter widget.
typedef ModelToWidget = Widget Function(ElementTreeEntry entry);

/// Describes a single widget type that belongs to an external Duit library.
///
/// [WidgetDescriptor] acts as a static configuration record that the
/// [DuitRegistry] uses to instantiate, theme, and wire up widgets that are
/// **not** part of the Duit core widget set.  Register descriptors indirectly
/// by loading a [LibraryDescriptor] via [DuitRegistry.loadLibrary].
///
/// Example — defining a descriptor for a custom "badge" widget:
/// ```dart
/// const badgeDescriptor = WidgetDescriptor(
///   type: 'Badge',
///   childRelation: ChildRelationType.none,
///   isControlledByDefault: false,
///   mayHaveRelatedAction: true,
///   buildFn: _buildBadge,
///   themeTokenBuilder: _badgeThemeToken,
/// );
/// ```
@experimental
final class WidgetDescriptor {
  /// The unique string identifier that maps server-side widget type names to
  /// this descriptor.  Must match the `type` field in the JSON layout tree.
  final String type;

  /// Defines the child relationship pattern for this element type.
  ///
  /// - `0`: No child elements (leaf widgets like Text, Image)
  /// - `1`: Single child element (wrapper widgets like Container, Padding)
  /// - `2`: Multiple child elements (layout widgets like Row, Column, Stack)
  /// - `3`: Component content
  /// - `4`: Fragment content
  final int childRelation;

  /// Whether this element type is controlled by default.
  ///
  /// Controlled elements typically have state management capabilities
  /// and can respond to user interactions or programmatic updates.
  /// Examples of controlled elements include TextField, CheckBox, ElevatedButton.
  final bool isControlledByDefault;

// Determines whether a widget of this type can have an associated action (which is passed in the widget model, not through attributes)
  final bool mayHaveRelatedAction;

  /// The factory function invoked by the widget-from-element pipeline to
  /// produce the actual [Widget] for this descriptor type.
  ///
  /// Receives the fully resolved [ElementTreeEntry] (with attributes, children,
  /// and controller already attached) and must return the corresponding widget.
  final ModelToWidget widgetBuilder;

  /// Optional factory that extracts a [ThemeToken] from raw theme data for
  /// this widget type.
  ///
  /// When non-null, the theme preprocessor calls this function during theme
  /// application to generate a typed token that [widgetBuilder] can consume.
  /// If null, no theme token is produced for the widget.
  final ThemeToken Function(
    String widgetType,
    Map<String, dynamic> themeData,
  )? themeTokenBuilder;

  const WidgetDescriptor({
    required this.type,
    required this.childRelation,
    required this.widgetBuilder,
    this.isControlledByDefault = false,
    this.mayHaveRelatedAction = false,
    this.themeTokenBuilder,
  });
}

/// Base class for a named collection of [WidgetDescriptor]s that form an
/// external Duit widget library.
///
/// Implement [LibraryDescriptor] to package a set of custom widgets and load
/// them into [DuitRegistry] via [DuitRegistry.loadLibrary].  Once loaded, the
/// registry builds a reverse-index so that any widget type declared in
/// [descriptors] can be resolved at render time.
///
/// Implementations must be compile-time constants (`const` constructors) so
/// that they can be passed to [DuitRegistry.loadLibrary] which requires
/// `@mustBeConst`.
///
/// Example:
/// ```dart
/// class MyLibrary extends LibraryDescriptor {
///   const MyLibrary() : super(name: 'my_library');
///
///   @override
///   Map<String, WidgetDescriptor> get descriptors => const {
///     'Badge': badgeDescriptor,
///     'Chip': chipDescriptor,
///   };
/// }
///
/// // At app startup:
/// DuitRegistry.loadLibrary(const MyLibrary());
/// ```
@experimental
abstract base class LibraryDescriptor {
  /// The unique name of this library used as the primary key in the
  /// [DuitRegistry] library map.  Duplicate names are rejected at load time.
  final String name;

  const LibraryDescriptor({
    required this.name,
  });

  /// A map from widget type strings to their [WidgetDescriptor]s.
  ///
  /// Keys must be unique across **all** loaded libraries; a duplicate key
  /// causes an error to be logged and the second descriptor is ignored.
  ///
  /// ### Recommended to use `const` Map for the descriptors.
  Map<String, WidgetDescriptor> get descriptors;

  /// Returns the [WidgetDescriptor] for [type], or `null` if this library does
  /// not contain a descriptor with that type string.
  @preferInline
  WidgetDescriptor? getDescriptor(String type) => descriptors[type];

  /// Returns `true` if this library contains a descriptor whose type equals
  /// [type].
  @preferInline
  bool hasDescriptor(String type) => descriptors.containsKey(type);
}
