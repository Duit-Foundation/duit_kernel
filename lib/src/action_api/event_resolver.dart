import "dart:async";

import "package:duit_kernel/duit_kernel.dart";
import "package:flutter/material.dart" show BuildContext;

@Deprecated("Will be removed in the next major release.")
abstract class EventResolver {
  final UIDriver driver;
  @Deprecated("Use [LoggingCapabilityDelegate] instead")
  final DebugLogger? logger;

  EventResolver({
    required this.driver,
    this.logger,
  });

  Future<void> resolveEvent(BuildContext context, eventData);
}

@Deprecated("Will be removed in the next major release.")
final class DefaultEventResolver extends EventResolver {
  DefaultEventResolver({
    required super.driver,
    super.logger,
  });

  @override
  Future<void> resolveEvent(BuildContext context, eventData) async {
    ServerEvent event;

    if (eventData is ServerEvent) {
      event = eventData;
    } else {
      event = ServerEvent.parseEvent(eventData);
    }

    try {
      switch (event) {
        case UpdateEvent():
          event.updates.forEach((key, value) async {
            await driver.updateAttributes(key, value);
          });
          break;
        case NavigationEvent():
          assert(
            driver.externalEventHandler != null,
            "ExternalEventHandler instance is not set",
          );
          if (driver.externalEventHandler != null) {
            driver.logError("ExternalEventHandler instance is not set");
            throw StateError("ExternalEventHandler instance is not set");
          }
          await driver.externalEventHandler?.handleNavigation(
            context,
            event.path,
            event.extra,
          );
          break;
        case OpenUrlEvent():
          if (driver.externalEventHandler != null) {
            driver.logError("ExternalEventHandler instance is not set");
            throw StateError("ExternalEventHandler instance is not set");
          }
          await driver.externalEventHandler?.handleOpenUrl(event.url);
          break;
        case CustomEvent():
          if (driver.isModule) {
            await driver.driverChannel
                ?.invokeMethod<Map<String, dynamic>>(event.key, event.extra);
          } else {
            await driver.externalEventHandler?.handleCustomEvent(
              context,
              event.key,
              event.extra,
            );
          }
          break;
        case SequencedEventGroup():
          for (final entry in event.events) {
            if (context.mounted) {
              await resolveEvent(context, entry.event);
              await Future.delayed(entry.delay);
            }
          }
          break;
        case CommonEventGroup():
          for (final entry in event.events) {
            await resolveEvent(context, entry.event);
          }
          break;
        case CommandEvent():
          final c = driver.getController(event.command.controllerId);
          await c?.emitCommand(event.command);
          break;
        case TimerEvent():
          final evt = event;
          Future.delayed(
            evt.timerDelay,
            () async {
              if (context.mounted) {
                await resolveEvent(context, evt.payload);
              }
            },
          );
          break;
        default:
          break;
      }
    } catch (e, s) {
      driver.logError(
        "Error while resolving ${event.type} event",
        e,
        s,
      );
    }
  }
}
