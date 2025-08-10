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
    return UpdateEvent(
      updates: json["updates"] ?? const <String, dynamic>{},
    );
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
    final source = DuitDataSource(json);
    return NavigationEvent(
      path: source.getString(key: "path"),
      extra: source["extra"] ?? const <String, dynamic>{},
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
      url: DuitDataSource(json).getString(key: "url"),
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
    final source = DuitDataSource(json);
    return CustomEvent(
      key: source.getString(key: "key"),
      extra: source["extra"] ?? const <String, dynamic>{},
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
    final list = List<Map<String, dynamic>>.from(json["events"] ?? []);

    final events = list.map(
      (model) {
        return GroupMember(
          event: ServerEvent.parseEvent(
            model["event"],
          ),
        );
      },
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
    final list = List<Map<String, dynamic>>.from(json["events"] ?? []);

    final events = list.map(
      (model) {
        final source = DuitDataSource(model);
        final delay = source.duration(key: "delay");

        return SequencedGroupMember(
          event: ServerEvent.parseEvent(source["event"]),
          delay: delay,
        );
      },
    );
    return SequencedEventGroup(events: events.toList());
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
    final source = DuitDataSource(json);
    return TimerEvent(
      timerDelay: source.duration(key: "timerDelay"),
      payload: ServerEvent.parseEvent(source["event"]),
    );
  }
}

final class CommandEvent extends ServerEvent {
  final RemoteCommand command;

  const CommandEvent({
    required this.command,
  }) : super(type: "command");

  factory CommandEvent.fromJson(Map<String, dynamic> json) {
    final source = DuitDataSource(json);
    return CommandEvent(
      command: RemoteCommand(
        controllerId: source.getString(key: "controllerId"),
        type: source.getString(key: "type"),
        commandData: source["commandData"] ?? <String, dynamic>{},
      ),
    );
  }
}
