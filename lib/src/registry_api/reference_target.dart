import 'package:duit_kernel/duit_kernel.dart';

final class RefWithTarget {
  final Object target;
  final ValueReference ref;

  RefWithTarget({
    required this.target,
    required this.ref,
  });
}
