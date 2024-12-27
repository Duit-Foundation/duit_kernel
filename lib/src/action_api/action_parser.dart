import 'package:duit_kernel/duit_kernel.dart';

/// The [DefaultActionParser] is a default parser for [ServerAction] objects.
///
/// It uses a [ServerActionJsonView] to parse the JSON map into a concrete action
/// object based on the [ExecutionType] of the action.
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
