import 'package:duit_kernel/src/misc/json_patch/semantics.dart';

/// Patch template describes where and how to write a value into the component
/// layout when building an instance.
final class PatchTemplate {
  /// JSON path segments from component root to the writable field
  /// Example: ['children', 0, 'attributes', 'title']
  final List<Object> path;

  /// Key in the input data map to read the value from
  final String sourceKey;

  /// Default value used when sourceKey is missing in input data
  final Object? defaultValue;

  /// Patch semantics (replace/add/remove). Defaults to replace in most cases.
  final PatchSemantics semantics;

  const PatchTemplate({
    required this.path,
    required this.sourceKey,
    this.defaultValue,
    this.semantics = PatchSemantics.replace,
  });
}