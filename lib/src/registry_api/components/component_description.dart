import 'package:duit_kernel/duit_kernel.dart';

/// Description of the component for registering it
/// in the [DuitRegistry] under the key corresponding to the [tag] property
final class ComponentDescription {
  final String tag;
  final Map<String, dynamic> data;
  final Set<RefWithTarget> refs;

  const ComponentDescription({
    required this.tag,
    required this.data,
    required this.refs,
  });
}
