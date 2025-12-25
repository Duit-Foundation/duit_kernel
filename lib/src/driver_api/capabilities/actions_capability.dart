import "package:duit_kernel/duit_kernel.dart";
import "package:meta/meta.dart";

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
        "ActionCapabilityDelegate",
      );

  @mustBeOverridden
  Map<String, dynamic> preparePayload(
    Iterable<ActionDependency> dependencies,
  ) =>
      throw const MissingCapabilityMethodImplementation(
        "preparePayload",
        "ActionCapabilityDelegate",
      );
}
