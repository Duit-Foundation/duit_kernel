import 'dart:async';

import 'package:duit_kernel/duit_kernel.dart';
import 'package:flutter/material.dart';

abstract class EventResolver {
  final UIDriver driver;
  final Logger logger;
  final BuildContext context;

  EventResolver(
    this.driver,
    this.logger,
    this.context,
  );

  Future<void> resolveEvent(dynamic eventData);
}

final class DefaultEventResolver extends EventResolver {
  DefaultEventResolver(
    super.driver,
    super.logger,
    super.context,
  );

  @override
  Future<void> resolveEvent(dynamic eventData) async {
    ServerEvent event;

    if (eventData is ServerEvent) {
      event = eventData;
    } else {
      event = ServerEvent.parseEvent(eventData);
    }

    try {
      final driver = this.driver;

      switch (event) {
        case UpdateEvent():
          event.updates.forEach((key, value) async {
            await driver.updateAttributes(key, value);
          });
          break;
        case NavigationEvent():
          assert(driver.externalEventHandler != null,
              "ExternalEventHandler instance is not set");
          await driver.externalEventHandler?.handleNavigation(
            context,
            event.path,
            event.extra,
          );
          break;
        case OpenUrlEvent():
          assert(driver.externalEventHandler != null,
              "ExternalEventHandler instance is not set");
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
            await resolveEvent(entry.event);
            await Future.delayed(entry.delay);
          }
          break;
        case CommonEventGroup():
          for (final entry in event.events) {
            resolveEvent(entry.event);
          }
          break;
        case AnimationTriggerEvent():
          final c = driver.getController(event.command.controllerId);
          await c?.emitCommand(event.command);
          break;
        case TimerEvent():
          final evt = event;
          Timer(
            evt.timerDelay,
            () async {
              await resolveEvent(evt.payload);
            },
          );
          break;
      }
    } catch (e, s) {
      logger.error(
        "Error while resolving ${event.type} event",
        error: e,
        stackTrace: s,
      );
    }
  }
}
