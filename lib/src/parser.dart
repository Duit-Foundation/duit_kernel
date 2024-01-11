import 'index.dart';

abstract class AttributeParserBase {
  ViewAttributeWrapper<T> parse<T>(
    String type,
    Map<String, dynamic>? json,
    String? tag,
  );

  ViewAttributeWrapper<T> mergeAndParse<T>(
      String type,
    Map<String, dynamic>? json,
    Map<String, dynamic> data,
  );
}
