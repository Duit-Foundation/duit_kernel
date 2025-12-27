import "dart:async";

import "package:duit_kernel/duit_kernel.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter_test/flutter_test.dart";

Matcher throwsMissing(
  String method,
  String capName,
) =>
    throwsA(
      isA<MissingCapabilityMethodImplementation>()
          .having(
            (e) => e.methodName,
            "methodName",
            method,
          )
          .having(
            (e) => e.mixinName,
            "mixinName",
            capName,
          ),
    );

class MockController implements UIElementController {
  @override
  ServerAction? action;

  @override
  late ViewAttribute attributes;

  @override
  // ignore: close_sinks
  late StreamController<RemoteCommand> commandChannel;

  @override
  late UIDriver driver;

  @override
  late String id;

  @override
  String? tag;

  @override
  late String type;

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  void detach() {
    // TODO: implement detach
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  FutureOr<void> emitCommand(RemoteCommand command) {
    // TODO: implement emitCommand
    throw UnimplementedError();
  }

  @override
  void listenCommand(Future<void> Function(RemoteCommand command) callback) {
    // TODO: implement listenCommand
  }

  @override
  void performAction(ServerAction? action) {
    // TODO: implement performAction
  }

  @override
  Future<void> performActionAsync(ServerAction? action) {
    // TODO: implement performActionAsync
    throw UnimplementedError();
  }

  @override
  void performRelatedAction() {
    // TODO: implement performRelatedAction
  }

  @override
  Future<void> performRelatedActionAsync() {
    // TODO: implement performRelatedActionAsync
    throw UnimplementedError();
  }

  @override
  void removeCommandListener() {
    // TODO: implement removeCommandListener
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }

  @override
  void updateState(Map<String, dynamic> newState) {
    // TODO: implement updateState
  }
}

class MockBuildCtx extends BuildContext {
  @override
  // TODO: implement debugDoingBuild
  bool get debugDoingBuild => throw UnimplementedError();

  @override
  InheritedWidget dependOnInheritedElement(
    InheritedElement ancestor, {
    Object? aspect,
  }) {
    // TODO: implement dependOnInheritedElement
    throw UnimplementedError();
  }

  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>({
    Object? aspect,
  }) {
    // TODO: implement dependOnInheritedWidgetOfExactType
    throw UnimplementedError();
  }

  @override
  DiagnosticsNode describeElement(
    String name, {
    DiagnosticsTreeStyle style = DiagnosticsTreeStyle.errorProperty,
  }) {
    // TODO: implement describeElement
    throw UnimplementedError();
  }

  @override
  List<DiagnosticsNode> describeMissingAncestor({
    required Type expectedAncestorType,
  }) {
    // TODO: implement describeMissingAncestor
    throw UnimplementedError();
  }

  @override
  DiagnosticsNode describeOwnershipChain(String name) {
    // TODO: implement describeOwnershipChain
    throw UnimplementedError();
  }

  @override
  DiagnosticsNode describeWidget(
    String name, {
    DiagnosticsTreeStyle style = DiagnosticsTreeStyle.errorProperty,
  }) {
    // TODO: implement describeWidget
    throw UnimplementedError();
  }

  @override
  void dispatchNotification(Notification notification) {
    // TODO: implement dispatchNotification
  }

  @override
  T? findAncestorRenderObjectOfType<T extends RenderObject>() {
    // TODO: implement findAncestorRenderObjectOfType
    throw UnimplementedError();
  }

  @override
  T? findAncestorStateOfType<T extends State<StatefulWidget>>() {
    // TODO: implement findAncestorStateOfType
    throw UnimplementedError();
  }

  @override
  T? findAncestorWidgetOfExactType<T extends Widget>() {
    // TODO: implement findAncestorWidgetOfExactType
    throw UnimplementedError();
  }

  @override
  RenderObject? findRenderObject() {
    // TODO: implement findRenderObject
    throw UnimplementedError();
  }

  @override
  T? findRootAncestorStateOfType<T extends State<StatefulWidget>>() {
    // TODO: implement findRootAncestorStateOfType
    throw UnimplementedError();
  }

  @override
  InheritedElement?
      getElementForInheritedWidgetOfExactType<T extends InheritedWidget>() {
    // TODO: implement getElementForInheritedWidgetOfExactType
    throw UnimplementedError();
  }

  @override
  T? getInheritedWidgetOfExactType<T extends InheritedWidget>() {
    // TODO: implement getInheritedWidgetOfExactType
    throw UnimplementedError();
  }

  @override
  // TODO: implement mounted
  bool get mounted => throw UnimplementedError();

  @override
  // TODO: implement owner
  BuildOwner? get owner => throw UnimplementedError();

  @override
  // TODO: implement size
  Size? get size => throw UnimplementedError();

  @override
  void visitAncestorElements(ConditionalElementVisitor visitor) {
    // TODO: implement visitAncestorElements
  }

  @override
  void visitChildElements(ElementVisitor visitor) {
    // TODO: implement visitChildElements
  }

  @override
  // TODO: implement widget
  Widget get widget => throw UnimplementedError();
}
