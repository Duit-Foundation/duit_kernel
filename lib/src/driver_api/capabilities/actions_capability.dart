import "dart:async";

import "package:duit_kernel/duit_kernel.dart";
import "package:flutter/widgets.dart";
import "package:meta/meta.dart";

typedef UserDefinedEventHandler = FutureOr<void> Function(
  BuildContext context,
  String path,
  Object? extra,
);

enum UserDefinedHandlerKind {
  openUrl,
  navigation,
  custom;
}

/// A mixin that provides an interface for managing [ServerAction] execution
/// and [ServerEvent] handling
///
/// Classes that use [ServerActionExecutionCapabilityDelegate] must implement focus management
/// behaviors by overriding the methods. By default, methods throw
/// [MissingCapabilityMethodImplementation] if not overridden.
///
/// See also:
/// - https://duit.pro/en/docs/core_concepts/actions_events
mixin ServerActionExecutionCapabilityDelegate {
  late final UIDriver driver;

  @mustBeOverridden
  Future<void> execute(ServerAction action) =>
      throw const MissingCapabilityMethodImplementation(
        "execute",
        "ServerActionExecutionCapabilityDelegate",
      );

  @mustBeOverridden
  Map<String, dynamic> preparePayload(
    Iterable<ActionDependency> dependencies,
  ) =>
      throw const MissingCapabilityMethodImplementation(
        "preparePayload",
        "ServerActionExecutionCapabilityDelegate",
      );

  @mustBeOverridden
  Future<void> resolveEvent(BuildContext context, eventData) =>
      throw const MissingCapabilityMethodImplementation(
        "resolveEvent",
        "ServerActionExecutionCapabilityDelegate",
      );

  @mustBeOverridden
  void addExternalEventStream(
    Stream<Map<String, dynamic>> stream,
  ) =>
      throw const MissingCapabilityMethodImplementation(
        "addExternalEventStream",
        "ServerActionExecutionCapabilityDelegate",
      );

  @mustBeOverridden
  void releaseResources() => throw const MissingCapabilityMethodImplementation(
        "releaseResources",
        "ServerActionExecutionCapabilityDelegate",
      );

  @mustBeOverridden
  void attachExternalHandler(
    UserDefinedHandlerKind type,
    UserDefinedEventHandler handle,
  ) =>
      throw const MissingCapabilityMethodImplementation(
        "dispose",
        "ServerActionExecutionCapabilityDelegate",
      );
}
