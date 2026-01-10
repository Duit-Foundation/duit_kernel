import "package:duit_kernel/duit_kernel.dart";

/// The [ActionExecutor] is an abstract class responsible for executing actions.
///
/// It relies on a [UIDriver] to perform actions and an DebugLogger to log messages.
/// This class serves as a base for concrete implementations that define how actions
/// should be executed.
///
/// Subclasses must implement the [executeAction] method to handle different types
/// of [ServerAction]s.
abstract class ActionExecutor {
  final UIDriver driver;
  @Deprecated("Use [LoggingCapabilityDelegate] instead")
  final DebugLogger? logger;

  ActionExecutor({
    required this.driver,
    this.logger,
  });

  Future<ServerEvent?> executeAction(
    ServerAction action,
  );
}

/// Executes a given [ServerAction].
///
/// The [executeAction] method takes a [ServerAction] as a parameter and
/// performs the necessary operations to execute it. This is an abstract
/// method that must be implemented by subclasses. It relies on the [UIDriver]
/// to resolve the event associated with the action and perform the execution.
///
/// Implementations should handle different types of actions, such as
/// [TransportAction], by using switch cases or other control flow mechanisms.
///
/// This method is asynchronous and returns a [Future] that completes when
/// the action execution is finished.
final class DefaultActionExecutor extends ActionExecutor {
  DefaultActionExecutor({
    required super.driver,
    super.logger,
  });

  @override
  Future<ServerEvent?> executeAction(
    ServerAction action,
  ) async {
    switch (action) {
      //transport
      case TransportAction():
        try {
          final payload = driver.preparePayload(action.dependsOn);

          final res = await driver.transport?.execute(action, payload);

          if (res != null) {
            return ServerEvent.parseEvent(res);
          }

          return null;
        } catch (e, s) {
          driver.error(
            "[Error while executing transport action]",
            e,
            s,
          );
        }

        break;
      //local execution
      case LocalAction():
        try {
          return action.event;
        } catch (e, s) {
          driver.error(
            "[Error while executing local action]",
            e,
            s,
          );
        }
        break;
      //script
      case ScriptAction():
        try {
          final body = driver.preparePayload(action.dependsOn);
          final script = action.script;

          final scriptInvocationResult = await driver.scriptRunner?.runScript(
            script.functionName,
            url: action.eventName,
            meta: action.script.meta,
            body: body,
          );

          if (scriptInvocationResult != null) {
            return ServerEvent.parseEvent(scriptInvocationResult);
          }

          return null;
        } catch (e, s) {
          driver.error(
            "[Error while executing script action]",
            e,
            s,
          );
        }
        break;
    }

    return null;
  }
}
