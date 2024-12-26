import 'package:duit_kernel/duit_kernel.dart';

final class DefaultEventParser implements Parser<ServerEvent> {
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
      "animationTrigger" => AnimationTriggerEvent.fromJson(json),
      "timer" => TimerEvent.fromJson(json),
      String() || Object() || null => NullEvent(),
    };
  }
}
