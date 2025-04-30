import 'package:duit_kernel/duit_kernel.dart';

/// The [ServerEvent] class represents an event that was sent by the server.
///
/// The concrete event types are defined in sub-classes of [ServerEvent].
///
/// The [ServerEvent] class provides a static [parse] method for parsing a JSON map
/// into a concrete event object.
base class ServerEvent {
  static late Parser<ServerEvent> _eventParser;

  static set eventParser(Parser<ServerEvent> value) {
    _eventParser = value;
  }

  final String type;

  const ServerEvent({
    required this.type,
  });

  static ServerEvent parseEvent(Map<String, dynamic> json) {
    return _eventParser.parse(json);
  }
}

final class NullEvent extends ServerEvent {
  NullEvent() : super(type: "null_event");
}

/// Represents an update event.
final class UpdateEvent extends ServerEvent {
  /// The updates associated with the event.
  Map<String, dynamic> updates;

  /// Constructs an [UpdateEvent] object with the specified updates.
  ///
  /// The [updates] parameter is a map of key-value pairs representing the updates.
  UpdateEvent({
    required this.updates,
  }) : super(type: "update");

  /// Creates an [UpdateEvent] object from a JSON object.
  ///
  /// The [json] parameter is a JSON object representing the update event.
  /// Returns an [UpdateEvent] object if the JSON object is valid, otherwise throws an exception.
  factory UpdateEvent.fromJson(Map<String, dynamic> json) {
    return UpdateEvent(updates: json["updates"]);
  }
}

final class NavigationEvent extends ServerEvent {
  final String path;

  final Map<String, dynamic> extra;

  NavigationEvent({
    required this.path,
    required this.extra,
  }) : super(type: "navigation");

  factory NavigationEvent.fromJson(Map<String, dynamic> json) {
    return NavigationEvent(
      path: json["path"] ?? "",
      extra: json["extra"] ?? {},
    );
  }
}

final class OpenUrlEvent extends ServerEvent {
  final String url;

  OpenUrlEvent({
    required this.url,
  }) : super(type: "openUrl");

  factory OpenUrlEvent.fromJson(Map<String, dynamic> json) {
    return OpenUrlEvent(
      url: json["url"] ?? "",
    );
  }
}

final class CustomEvent extends ServerEvent {
  final String key;

  final Map<String, dynamic> extra;

  CustomEvent({
    required this.key,
    required this.extra,
  }) : super(type: "custom");

  factory CustomEvent.fromJson(Map<String, dynamic> json) {
    return CustomEvent(
      key: json["key"] ?? "",
      extra: json["extra"] ?? {},
    );
  }
}

final class GroupMember {
  final ServerEvent event;

  GroupMember({
    required this.event,
  });
}

final class SequencedGroupMember extends GroupMember {
  final Duration delay;

  SequencedGroupMember({
    required super.event,
    required this.delay,
  });
}

final class CommonEventGroup extends ServerEvent {
  final List<GroupMember> events;

  CommonEventGroup({
    required this.events,
  }) : super(type: "grouped");

  factory CommonEventGroup.fromJson(Map<String, dynamic> json) {
    final list = List.from(json["events"] ?? []);

    final events = list.map(
      (model) => GroupMember(event: ServerEvent.parseEvent(model)),
    );
    return CommonEventGroup(events: events.toList());
  }
}

final class SequencedEventGroup extends ServerEvent {
  final List<SequencedGroupMember> events;

  SequencedEventGroup({
    required this.events,
  }) : super(type: "sequenced");

  factory SequencedEventGroup.fromJson(Map<String, dynamic> json) {
    final list = List.from(json["events"] ?? []);

    final events = list.map((model) {
      final delay = Duration(milliseconds: model["delay"] ?? 0);

      return SequencedGroupMember(
        event: ServerEvent.parseEvent(model["event"]),
        delay: delay,
      );
    });
    return SequencedEventGroup(events: events.toList());
  }
}

final class AnimationTriggerEvent extends ServerEvent {
  final AnimationCommand command;

  AnimationTriggerEvent({
    required this.command,
  }) : super(type: "animationTrigger");

  factory AnimationTriggerEvent.fromJson(Map<String, dynamic> json) {
    return AnimationTriggerEvent(
      command: AnimationCommand(
        method: switch (json["method"]) {
          0 => AnimationMethod.forward,
          1 => AnimationMethod.repeat,
          2 => AnimationMethod.reverse,
          3 => AnimationMethod.toggle,
          Object() || null => AnimationMethod.forward,
        },
        controllerId: json["controllerId"],
        animatedPropKey: json["animatedPropKey"],
      ),
    );
  }
}

final class TimerEvent extends ServerEvent {
  final Duration timerDelay;
  final ServerEvent payload;

  TimerEvent({
    required this.timerDelay,
    required this.payload,
  }) : super(type: "timer");

  factory TimerEvent.fromJson(Map<String, dynamic> json) {
    return TimerEvent(
      timerDelay: Duration(milliseconds: json["timerDelay"] ?? 0),
      payload: ServerEvent.parseEvent(json["event"]),
    );
  }
}

final class ShowBottomSheetEvent extends ServerEvent {
  final Map<String, dynamic> child;
  final Map<String, dynamic>? configuration;

  ShowBottomSheetEvent({
    required this.child,
    this.configuration,
  }) : super(type: "bottomSheet");

  factory ShowBottomSheetEvent.fromJson(Map<String, dynamic> json) {
    return ShowBottomSheetEvent(
      child: json["child"] ?? {},
      configuration: json["configuration"],
    );
  }
}

final class HideBottomSheetEvent extends ServerEvent {
  final String id;
  const HideBottomSheetEvent(this.id) : super(type: "hideBottomSheet");
}

final class ShowDialogEvent extends ServerEvent {
  final Map<String, dynamic> child;
  final Map<String, dynamic>? configuration;

  ShowDialogEvent({
    required this.child,
    this.configuration,
  }) : super(type: "dialog");

  factory ShowDialogEvent.fromJson(Map<String, dynamic> json) {
    return ShowDialogEvent(
      child: json["child"] ?? {},
      configuration: json["configuration"],
    );
  }
}

final class HideDialogEvent extends ServerEvent {
  final String id;
  const HideDialogEvent(this.id) : super(type: "hideBottomSheet");
}
