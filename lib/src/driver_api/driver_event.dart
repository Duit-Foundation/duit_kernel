import 'package:duit_kernel/src/driver_api/view.dart';

/// Base class for driver events
sealed class UIDriverEvent {}

final class UIDriverErrorEvent extends UIDriverEvent {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  UIDriverErrorEvent(
    this.message, {
    this.error,
    this.stackTrace,
  });
}

final class UIDriverViewEvent extends UIDriverEvent {
  final DuitView model;

  UIDriverViewEvent(this.model);
}
