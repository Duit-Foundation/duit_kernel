import "package:duit_kernel/duit_kernel.dart";

/// The [ServerAction] class represents an action that was sent by the server.
base class ServerAction {
  static late Parser<ServerAction> _actionParser;

  /// Set the parser to use for [ServerAction]s.
  ///
  /// This should be set by the framework before calling [parse].
  static void setActionParser(Parser<ServerAction> parser) {
    _actionParser = parser;
  }

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

  /// Optional execution behavior overrides (e.g., debounce, timeouts).
  final ExecutionOptions? executionOptions;

  /// The TTL of the action in seconds.
  ///
  /// The TTL is the time after which the action can be executed again.
  final Duration? suppressionTTL;

  /// Whether the action is idempotent.
  ///
  /// If the action is idempotent, it will be executed only once with the same payload.
  final bool idempotent;

  ServerAction({
    required this.eventName,
    required this.executionType,
    this.dependsOn = const [],
    this.executionOptions,
    this.suppressionTTL,
    this.idempotent = false,
  });

  static ServerAction parse(Map<String, dynamic> json) =>
      _actionParser.parse(json);
}

/// An unknown action is an action that the framework does not know how to parse.
///
/// This can happen if the framework is not configured correctly or if the
/// server sends an action that is not recognized.
final class UnknownAction extends ServerAction {
  UnknownAction()
      : super(
          eventName: "unknown",
          executionType: -1,
        );
}

/// A local action is an action that is executed locally in the client.
///
/// A local action is an action that is not sent to the server and is executed
/// immediately in the client. A local action is typically used to execute a
/// local event handler.
final class LocalAction extends ServerAction {
  final ServerEvent event;

  LocalAction({
    required this.event,
    super.executionOptions,
  }) : super(
          eventName: "local_exec",
          executionType: 1,
        );

  factory LocalAction.fromJson(Map<String, dynamic> json) {
    final source = DuitDataSource(json);
    return LocalAction(
      event: ServerEvent.parseEvent(json["payload"]),
      executionOptions: source.executionOptions(),
    );
  }
}

/// A dependent action is an action that has dependencies.
///
/// A dependent action is an action that requires other actions to be executed
/// before it can be executed. The dependencies are specified in the
/// [dependsOn] property.
abstract interface class DependentAction {
  final Iterable<ActionDependency> dependsOn;

  DependentAction({
    required this.dependsOn,
  });
}

/// A transport action represents an action that is executed using a transport mechanism.
///
/// A transport action is an action that requires communication with the server
/// to be executed. It implements the [DependentAction] interface, which means it
/// has dependencies that need to be resolved before execution. The action can also
/// include optional metadata, represented by the [meta] property, which may contain
/// additional information required for execution.

final class TransportAction extends ServerAction implements DependentAction {
  final HttpActionMetainfo? meta;

  TransportAction({
    required super.eventName,
    required super.dependsOn,
    this.meta,
    super.executionOptions,
    super.suppressionTTL,
    super.idempotent,
  }) : super(
          executionType: 0,
        );

  factory TransportAction.fromJson(Map<String, dynamic> json) {
    final source = DuitDataSource(json);

    return TransportAction(
      eventName: source.getString(key: "event"),
      dependsOn: source.getActionDependencies(),
      meta: source.meta,
      executionOptions: source.executionOptions(),
      suppressionTTL: source.containsKey("suppressionTTL")
          ? source.duration(key: "suppressionTTL")
          : null,
      idempotent: source.getBool("idempotent"),
    );
  }
}

/// A script action represents an action that is executed using a script.
///
/// A script action is an action that requires the execution of a script to be
/// executed. It implements the [DependentAction] interface, which means it
/// has dependencies that need to be resolved before execution. The script
/// to be executed is represented by the [script] property.
final class ScriptAction extends ServerAction implements DependentAction {
  final ScriptDefinition script;

  ScriptAction({
    required this.script,
    required super.dependsOn,
    super.executionOptions,
    super.suppressionTTL,
    super.idempotent,
  }) : super(
          eventName: "script",
          executionType: 2,
        );

  factory ScriptAction.fromJson(Map<String, dynamic> json) {
    final source = DuitDataSource(json);

    return ScriptAction(
      script: source.script,
      dependsOn: source.getActionDependencies(),
      executionOptions: source.executionOptions(),
      suppressionTTL: source.containsKey("suppressionTTL")
          ? source.duration(key: "suppressionTTL")
          : null,
      idempotent: source.getBool("idempotent"),
    );
  }
}
