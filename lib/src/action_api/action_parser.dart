import 'package:duit_kernel/duit_kernel.dart';

final class DefaultActionParser implements Parser<ServerAction> {
  @override
  ServerAction parse(Map<String, dynamic> json) {
    final view = ServerActionJsonView(json);

    return switch (view.executionType) {
      0 => TransportAction.fromJson(json),
      1 => LocalAction.fromJson(json),
      2 => ScriptAction.fromJson(json),
      _ => UnknownAction(),
    };
  }
}
