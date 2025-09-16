import "package:duit_kernel/src/driver_api/view.dart";

/// Base class for driver events
sealed class UIDriverEvent {
  const UIDriverEvent();
}

/// Represents an error event in the UI driver.
///
/// The [UIDriverErrorEvent] class is used to encapsulate information about an error
/// that occurred within the UI driver. It extends the [UIDriverEvent] class and includes
/// a message, an optional error object, and an optional stack trace for debugging purposes.
final class UIDriverErrorEvent extends UIDriverEvent {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  const UIDriverErrorEvent(
    this.message, {
    this.error,
    this.stackTrace,
  });
}

/// Represents a view event in the UI driver.
///
/// The [UIDriverViewEvent] class is used to encapsulate information about a view event
/// that occurred within the UI driver. It extends the [UIDriverEvent] class and includes
/// a reference to the [DuitView] that triggered the event.
final class UIDriverViewEvent extends UIDriverEvent {
  final DuitView model;

  const UIDriverViewEvent(this.model);
}
