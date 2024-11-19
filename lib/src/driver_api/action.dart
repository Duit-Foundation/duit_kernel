import 'package:duit_kernel/src/driver_api/dependency.dart';
import 'package:duit_kernel/src/driver_api/event.dart';

/// Represents the metadata for an HTTP action.
///
/// The [HttpActionMetainfo] class contains information about the HTTP method to be used for the action.
final class HttpActionMetainfo {
  String method;

  HttpActionMetainfo({required this.method});

  static HttpActionMetainfo fromJson(Map<String, dynamic> json) {
    return HttpActionMetainfo(method: json["method"] ?? "GET");
  }
}

final class DuitScript {
  final String sourceCode, functionName;
  final Map<String, dynamic>? meta;

  DuitScript({
    required this.sourceCode,
    required this.functionName,
    required this.meta,
  });

  factory DuitScript.fromJson(Map<String, dynamic> json) {
    return DuitScript(
      sourceCode: json["sourceCode"],
      functionName: json["functionName"],
      meta: json["meta"],
    );
  }
}

extension type ActionJsonView(Map<String, dynamic> json) {
  Iterable<ActionDependency> get dependsOn {
    final hasProperty = json.containsKey("dependsOn");
    if (hasProperty) {
      return json["dependsOn"].map((el) => ActionDependency.fromJson(el));
    } else {
      return [];
    }
  }

  String get eventName {
    final hasProperty = json.containsKey("event");
    if (hasProperty) {
      return json["event"];
    } else {
      return "";
    }
  }

  /// Parse helper for script model
  ///
  /// Use this method with !
  DuitScript? get script {
    final hasProperty = json.containsKey("script");

    if (!hasProperty) {
      throw Exception(
          "An action with execution type 2 (script action) was created, but the script model is missing");
    } else {
      final scriptData = json["script"];

      if (scriptData == null ||
          scriptData is! Map<String, dynamic> ||
          scriptData.isEmpty) {
        throw Exception(
            "An action with execution type 2 (script action) was created, but the script model is missing");
      }
    }

    return DuitScript.fromJson(json["script"]);
  }

  HttpActionMetainfo? get meta {
    final hasProperty = json.containsKey("meta");

    if (hasProperty) {
      return HttpActionMetainfo.fromJson(json["meta"]);
    } else {
      return null;
    }
  }

  int get executionType {
    final hasProperty = json.containsKey("executionType");
    if (hasProperty) {
      return json["executionType"];
    } else {
      return 0;
    }
  }
}

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
    final view = ActionJsonView(json);

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

  LocalAction({required this.event})
      : super(
          eventName: "local_exec",
          executionType: 1,
        );

  factory LocalAction.fromJson(Map<String, dynamic> json) {
    return LocalAction(
      event: ServerEvent.parseEvent(json),
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
    final view = ActionJsonView(json);

    return TransportAction(
      eventName: view.eventName,
      dependsOn: view.dependsOn,
      meta: view.meta,
    );
  }
}

final class ScriptAction extends ServerAction implements DependentAction {
  final DuitScript script;

  ScriptAction({required this.script, required super.dependsOn})
      : super(
          eventName: "script",
          executionType: 2,
        );

  factory ScriptAction.fromJson(Map<String, dynamic> json) {
    final view = ActionJsonView(json);

    return ScriptAction(
      script: view.script!,
      dependsOn: view.dependsOn,
    );
  }
}
