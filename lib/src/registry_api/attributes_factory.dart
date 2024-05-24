import 'package:duit_kernel/duit_kernel.dart';

/// The [AttributesFactory] is a function type that maps the attributes of a DUIT element to [ViewAttribute].
///
/// The function takes in the following parameters:
/// - [type]: The type of the DUIT element.
/// - [json]: The JSON object representing the attributes of the DUIT element.
///
/// It returns a `DUITAttributes` object that represents the mapped attributes.
typedef AttributesFactory = DuitAttributes Function(
  String type,
  Map<String, dynamic>? json,
);
