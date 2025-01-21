import 'package:duit_kernel/duit_kernel.dart';

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
  final ElementTree model;

  UIDriverViewEvent(this.model);
}

final class UIDriverTaggedViewEvent extends UIDriverViewEvent {
  final String viewTag;

  UIDriverTaggedViewEvent(
    super.model,
    this.viewTag,
  );
}
