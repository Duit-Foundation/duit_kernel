import 'index.dart';

///A class that defines methods for implementation in the parser on the framework side
abstract class AttributeParserBase {
  ViewAttributeWrapper<T> parse<T>(
    String type,
    Map<String, dynamic>? json,
    String? tag, {
    String? id,
  });
}
