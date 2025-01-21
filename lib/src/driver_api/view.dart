import 'package:duit_kernel/duit_kernel.dart';
import 'package:flutter/widgets.dart' show Widget;

abstract interface class DuitView {
  Future<void> prepareModel(
    Map<String, dynamic> json,
    UIDriver driver,
  );

  Widget build([String tag = ""]);

  ElementTree getElementTree([String tag = ""]);
}
