import '../index.dart';

///A class that defines methods for implementation in the parser on the framework side
abstract interface class AttributeParserBase {
  /// Parses the given [type], [json], and [tag] and returns a new instance of [ViewAttribute].
  ViewAttribute<T> parse<T>(
    String type,
    Map<String, dynamic>? json,
    String? tag, {
    String? id,
  });
}
