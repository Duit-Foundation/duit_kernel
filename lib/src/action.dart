/// Represents the metadata for an HTTP action.
///
/// The [HttpActionMetainfo] class contains information about the HTTP method to be used for the action.
final class HttpActionMetainfo {
  String method;

  HttpActionMetainfo({required this.method});

  static HttpActionMetainfo? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

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

  static DuitScript? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return DuitScript(
      sourceCode: json["sourceCode"] ?? "",
      functionName: json["functionName"] ?? "",
      meta: json["meta"],
    );
  }
}

/// Represents a dependency for a server action.
///
/// The [ActionDependency] class contains information about the dependency target and ID.
final class ActionDependency {
  String id;
  String target;

  ActionDependency({
    required this.target,
    required this.id,
  });

  factory ActionDependency.fromJSON(Map<String, dynamic> json) {
    return ActionDependency(
      target: json["target"],
      id: json["id"],
    );
  }
}

/// Represents a server action.
///
/// The [ServerAction] class encapsulates information about a server action, including its dependencies, event, and metadata.
final class ServerAction {
  /// The list of dependencies for the server action.
  List<ActionDependency> dependsOn;

  /// The event associated with the server action.
  String event;

  /// The event associated with the server action.
  HttpActionMetainfo? meta;

  final DuitScript? script;

  /// Event execution type
  ///
  /// 0 - transport
  ///
  /// 1 - local execution
  ///
  /// 2 - script
  int executionType;

  /// Optional action payload for local execution
  Map<String, dynamic>? payload;

  ServerAction({
    required this.event,
    required this.executionType,
    this.dependsOn = const [],
    this.meta,
    this.script,
    this.payload,
  });

  static ServerAction? fromJSON(Map<String, dynamic>? json) {
    if (json == null) return null;

    List<ActionDependency> deps = [];

    if (json["dependsOn"] != null) {
      json["dependsOn"].forEach((el) {
        final it = ActionDependency.fromJSON(el);
        deps.add(it);
      });
    }

    return ServerAction(
      event: json["event"] ?? "",
      executionType: json["executionType"],
      dependsOn: deps,
      meta: HttpActionMetainfo.fromJson(json["meta"]),
      script: DuitScript.fromJson(json["script"]),
      payload: json["payload"],
    );
  }

  @override
  String toString() {
    return 'ServerAction{dependsOn: $dependsOn, event: $event, meta: $meta}';
  }
}
