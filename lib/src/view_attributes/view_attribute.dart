import '../index.dart';

/// Represents a wrapper for view attributes.
///
/// The [ViewAttribute] class is used to wrap view attributes,
/// providing a convenient way to access and manipulate them.
final class ViewAttribute<T> {
  /// The unique identifier of the view.
  final String id;

  /// The payload of the view attribute.
  ///
  /// Use the [payload] property to access or modify the value of the view attribute.
  final T payload;

  static late AttributeParserBase attributeParser;

  /// Creates a new instance of the [ViewAttribute] class.
  ///
  /// The [payload] parameter is the initial value of the view attribute.
  ViewAttribute({
    required this.payload,
    required this.id,
  });

  /// Creates a new [ViewAttribute] from the given [type], [json], and [tag].
  ///
  /// This factory method is used to create a [ViewAttribute] instance
  /// based on the specified [type], [json], and [tag]. It returns a new instance
  /// of [ViewAttribute] with the appropriate payload type.
  static ViewAttribute<T> createAttributes<T>(
    String type,
    Map<String, dynamic>? json,
    String? tag, {
    String? id,
  }) {
    return attributeParser.parse(
      type,
      json,
      tag,
    );
  }
}
