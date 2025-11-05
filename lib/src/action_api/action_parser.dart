import "package:duit_kernel/duit_kernel.dart";

/// The [DefaultActionParser] is a default parser for [ServerAction] objects.
///
/// It uses a [ServerActionJsonView] to parse the JSON map into a concrete action
/// object based on the [ExecutionType] of the action.
final class DefaultActionParser implements Parser<ServerAction> {
  const DefaultActionParser();

  @override
  ServerAction parse(Map<String, dynamic> json) {
    final source = DuitDataSource(json);

    return switch (source.executionType) {
      0 => TransportAction.fromJson(source),
      1 => LocalAction.fromJson(source),
      2 => ScriptAction.fromJson(source),
      _ => UnknownAction(),
    };
  }
}
