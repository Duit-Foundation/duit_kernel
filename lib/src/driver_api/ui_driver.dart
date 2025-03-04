import 'dart:async';

import 'package:duit_kernel/duit_kernel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract interface class UIDriver implements WidgetDisplayStateNotifier {
  /// The source url of the UI driver.
  abstract final String source;

  /// The options for the transport used by the UI driver.
  abstract final TransportOptions transportOptions;

  /// The transport used by the UI driver.
  abstract Transport? transport;

  /// The build context associated with the UI driver.
  @protected
  abstract BuildContext buildContext;

  /// The stream controller for the UI driver.
  @protected
  @Deprecated("Use eventStreamController instead")
  abstract StreamController<ElementTree?> streamController;

  /// The stream controller for the UI driver.
  @protected
  abstract StreamController<UIDriverEvent> eventStreamController;

  /// The script runner used by the UI driver.
  abstract ScriptRunner? scriptRunner;

  /// The script runner used by the UI driver.
  ///
  /// The script runner is used to execute scripts defined in the layout.
  abstract EventResolver eventResolver;

  /// The executor of actions used by the UI driver.
  ///
  /// The action executor is used to execute actions defined in the layout.
  abstract ActionExecutor actionExecutor;

  /// The action executor used by the UI driver.
  abstract ExternalEventHandler? externalEventHandler;

  abstract MethodChannel? driverChannel;

  abstract bool isModule;

  abstract DebugLogger? logger;

  /// Attaches a controller to the UI driver.
  ///
  /// Parameters:
  /// - [id]: The ID of the controller.
  /// - [controller]: The UI element controller to attach.
  void attachController(String id, UIElementController controller);

  /// Detaches a controller from the UI driver.
  void detachController(String id);

  /// Gets the controller associated with the given ID.
  UIElementController? getController(String id);

  /// Initializes the UI driver.
  ///
  /// This method initializes the UI driver by performing any necessary setup or
  /// configuration. It can be called before using the UI driver to ensure that
  /// it is ready to perform its intended tasks.
  ///
  /// Returns: A [Future] that completes when the initialization is done. If the
  /// initialization is successful, the [Future] completes successfully. If there
  /// is an error during initialization, the [Future] completes with an error.
  Future<void> init();

  /// Builds the UI.
  ///
  /// This method is responsible for building the user interface (UI) based on the
  /// current state of the UI driver. It creates and returns a widget that represents
  /// the UI to be rendered on the screen.
  ///
  /// Returns: The widget representing the UI.
  Widget? build();

  /// Executes a server action and handles the response event.
  ///
  /// If [dependencies] is not empty, it collects the data from the controllers
  /// associated with each dependency and adds it to the payload. The payload is
  /// then passed to the server action.
  ///
  /// This method is called when a server action needs to be executed.
  ///
  /// Parameters:
  /// - [action]: The server action to be executed.
  /// - [dependencies]: A list of dependencies for the server action.
  Future<void> execute(ServerAction action);

  /// Evaluates a script source code.
  Future<void> evalScript(String source);

  /// Disposes of the driver and releases any resources.
  ///
  /// This method is called when the driver is no longer needed.
  void dispose();

  /// Returns the stream of UI abstract trees.
  @Deprecated("Use eventStream instead")
  Stream<ElementTree?> get stream;

  Stream<UIDriverEvent> get eventStream;

  /// Set the BuildContext.
  set context(BuildContext value);

  /// Prepares the payload for a server action.
  Map<String, dynamic> preparePayload(
    Iterable<ActionDependency> dependencies,
  );

  /// Updates the attributes of a controller.
  Future<void> updateAttributes(
    String controllerId,
    Map<String, dynamic> json,
  );
}
