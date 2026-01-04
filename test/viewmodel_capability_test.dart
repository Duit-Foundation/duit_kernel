import "package:duit_kernel/duit_kernel.dart";
import "package:flutter/widgets.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";

import "testutil.dart";

// ignore: missing_override_of_must_be_overridden
class _DummyDelegate with ViewModelCapabilityDelegate {}

class _MockBuildContext extends Mock implements BuildContext {}

class _DummyView extends Mock implements DuitView {}

void main() {
  group(
    "ViewModelCapabilityDelegate default implementations",
    () {
      final delegate = _DummyDelegate();
      ServerAction.setActionParser(const DefaultActionParser());

      test("addUIDriverError throws MissingMethodImplementation", () {
        expect(
          () => delegate.addUIDriverError(Object()),
          throwsMissing(
            "addUIDriverError",
            "ViewModelCapabilityDelegate",
          ),
        );
      });

      test("addUIDriverEvent throws MissingMethodImplementation", () {
        expect(
          () => delegate.addUIDriverEvent(UIDriverViewEvent(_DummyView())),
          throwsMissing(
            "addUIDriverEvent",
            "ViewModelCapabilityDelegate",
          ),
        );
      });

      test("buildContext throws MissingMethodImplementation", () {
        expect(
          () => delegate.buildContext,
          throwsMissing(
            "buildContext",
            "ViewModelCapabilityDelegate",
          ),
        );
      });

      test("context throws MissingMethodImplementation", () {
        expect(
          () => delegate.context = _MockBuildContext(),
          throwsMissing(
            "context",
            "ViewModelCapabilityDelegate",
          ),
        );
      });

      test("isWidgetReady throws MissingMethodImplementation", () {
        expect(
          () => delegate.isWidgetReady(""),
          throwsMissing(
            "isWidgetReady",
            "ViewModelCapabilityDelegate",
          ),
        );
      });

      test("notifyWidgetDisplayStateChanged throws MissingMethodImplementation",
          () {
        expect(
          () => delegate.notifyWidgetDisplayStateChanged("", 1),
          throwsMissing(
            "notifyWidgetDisplayStateChanged",
            "ViewModelCapabilityDelegate",
          ),
        );
      });

      test("prepareLayout throws MissingMethodImplementation", () {
        expect(
          () => delegate.prepareLayout({}),
          throwsMissing(
            "prepareLayout",
            "ViewModelCapabilityDelegate",
          ),
        );
      });

      test("releaseResources throws MissingMethodImplementation", () {
        expect(
          delegate.releaseResources,
          throwsMissing(
            "releaseResources",
            "ViewModelCapabilityDelegate",
          ),
        );
      });

      test("eventStream throws MissingMethodImplementation", () {
        expect(
          () => delegate.eventStream,
          throwsMissing(
            "eventStream",
            "ViewModelCapabilityDelegate",
          ),
        );
      });
    },
  );
}
