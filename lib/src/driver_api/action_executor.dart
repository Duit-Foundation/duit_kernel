import 'package:duit_kernel/duit_kernel.dart';
import 'package:flutter/material.dart' show BuildContext;

/// The [ActionExecutor] is an abstract class responsible for executing actions.
///
/// It relies on a [UIDriver] to perform actions and an [Logger] to log messages.
/// This class serves as a base for concrete implementations that define how actions
/// should be executed.
///
/// Subclasses must implement the [executeAction] method to handle different types
/// of [ServerAction]s.
abstract class ActionExecutor {
  final UIDriver driver;
  final Logger? logger;

  ActionExecutor({
    required this.driver,
    this.logger,
  });

  Future<void> executeAction(BuildContext context,ServerAction action);
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
  Future<void> executeAction(BuildContext context, ServerAction action) async {
    final resolver = driver.eventResolver;

    switch (action) {
      //transport
      case TransportAction():
        try {
          final payload = driver.preparePayload(action.dependsOn);

          final event = await driver.transport?.execute(action, payload);
          //case with http request
          if (event != null) {
            await resolver.resolveEvent(context, event);
          }
        } catch (e, s) {
          logger?.error(
            "[Error while executing transport action]",
            error: e,
            stackTrace: s,
          );
        }

        break;
      //local execution
      case LocalAction():
        try {
          await resolver.resolveEvent(context, action.event);
        } catch (e, s) {
          logger?.error(
            "[Error while executing local action]",
            error: e,
            stackTrace: s,
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

          await resolver.resolveEvent(context, scriptInvocationResult);
        } catch (e, s) {
          logger?.error(
            "[Error while executing script action]",
            error: e,
            stackTrace: s,
          );
        }
        break;
    }
  }
}
