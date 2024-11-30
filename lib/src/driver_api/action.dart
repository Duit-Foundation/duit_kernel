import 'package:duit_kernel/src/driver_api/dependency.dart';
import 'package:duit_kernel/src/driver_api/event.dart';
import 'package:duit_kernel/src/driver_api/http_meta.dart';
import 'package:duit_kernel/src/driver_api/script_def.dart';
import 'package:duit_kernel/src/driver_api/server_action_view.dart';

base class ServerAction {
  /// The list of dependencies for the server action.
  final Iterable<ActionDependency> dependsOn;

  /// The event associated with the server action.
  final String eventName;

  /// Event execution type
  ///
  /// 0 - transport
  ///
  /// 1 - local execution
  ///
  /// 2 - script
  final int executionType;

  ServerAction({
    required this.eventName,
    required this.executionType,
    this.dependsOn = const [],
  });

  static ServerAction parse(Map<String, dynamic> json) {
    final view = ServerActionJsonView(json);

    return switch (view.executionType) {
      0 => TransportAction.fromJson(json),
      1 => LocalAction.fromJson(json),
      2 => ScriptAction.fromJson(json),
      _ => throw Exception("Unknown execution type ${view.executionType}"),
    };
  }
}

final class LocalAction extends ServerAction {
  final ServerEvent event;

  LocalAction({
    required this.event,
  }) : super(
          eventName: "local_exec",
          executionType: 1,
        );

  factory LocalAction.fromJson(Map<String, dynamic> json) {
    return LocalAction(
      event: ServerEvent.parseEvent(json["event"]),
    );
  }
}

abstract interface class DependentAction {
  final Iterable<ActionDependency> dependsOn;

  DependentAction({
    required this.dependsOn,
  });
}

final class TransportAction extends ServerAction implements DependentAction {
  final HttpActionMetainfo? meta;

  TransportAction({
    required super.eventName,
    required super.dependsOn,
    this.meta,
  }) : super(
          executionType: 0,
        );

  factory TransportAction.fromJson(Map<String, dynamic> json) {
    final view = ServerActionJsonView(json);

    return TransportAction(
      eventName: view.eventName,
      dependsOn: view.dependsOn,
      meta: view.meta,
    );
  }
}

final class ScriptAction extends ServerAction implements DependentAction {
  final ScriptDefinition script;

  ScriptAction({
    required this.script,
    required super.dependsOn,
  }) : super(
          eventName: "script",
          executionType: 2,
        );

  factory ScriptAction.fromJson(Map<String, dynamic> json) {
    final view = ServerActionJsonView(json);

    return ScriptAction(
      script: view.script!,
      dependsOn: view.dependsOn,
    );
  }
}
