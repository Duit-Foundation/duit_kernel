import "package:duit_kernel/duit_kernel.dart";

/// The [DefaultEventParser] is a default parser for [ServerEvent] objects.
///
/// It uses a simple switch statement to parse the JSON map into a concrete event
/// object based on the value of the "type" property of the JSON map.
///
/// The [DefaultEventParser] is used by the [DefaultEventResolver] to parse events
/// from the server.
final class DefaultEventParser implements Parser<ServerEvent> {
  const DefaultEventParser();

  @override
  ServerEvent parse(Map<String, dynamic> json) {
    final type = json["type"];

    return switch (type) {
      "update" => UpdateEvent.fromJson(json),
      "navigation" => NavigationEvent.fromJson(json),
      "openUrl" => OpenUrlEvent.fromJson(json),
      "custom" => CustomEvent.fromJson(json),
      "sequenced" => SequencedEventGroup.fromJson(json),
      "grouped" => CommonEventGroup.fromJson(json),
      "timer" => TimerEvent.fromJson(json),
      "command" => CommandEvent.fromJson(json),
      _ => NullEvent(),
    };
  }
}
