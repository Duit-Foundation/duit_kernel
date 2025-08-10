import 'package:duit_kernel/duit_kernel.dart';

/// Description of the component for registering it
/// in the [DuitRegistry] under the key corresponding to the [tag] property
final class ComponentDescription {
  final String tag;

  /// Immutable base layout of the component. Do not mutate.
  final Map<String, dynamic> _data;

  /// Precomputed patch write operations derived from refs during registration.
  final List<PatchTemplate> writeOps;

  Map<String, dynamic> get data => _data;

  const ComponentDescription({
    required this.tag,
    required Map<String, dynamic> data,
    required this.writeOps,
  }) : _data = data;
}
