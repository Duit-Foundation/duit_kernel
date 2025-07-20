import 'package:duit_kernel/duit_kernel.dart';

final class RefWithTarget {
  final Map<String, dynamic> target;
  final ValueReference ref;

  RefWithTarget({
    required this.target,
    required this.ref,
  });
}
