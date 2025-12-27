import "package:duit_kernel/duit_kernel.dart";
import "package:flutter_test/flutter_test.dart";

import "testutil.dart";

// ignore: missing_override_of_must_be_overridden
class _DummyDelegate with UIControllerCapabilityDelegate {}

void main() {
  group(
    "UIControllerCapabilityDelegate default implementations",
    () {
      final delegate = _DummyDelegate();
      ServerAction.setActionParser(const DefaultActionParser());

      test("controllersCount throws MissingMethodImplementation", () {
        expect(
          () => delegate.controllersCount,
          throwsMissing(
            "controllersCount",
            "UIControllerCapabilityDelegate",
          ),
        );
      });

      test("controllersCount throws MissingMethodImplementation", () {
        expect(
          () => delegate.attachController("", MockController()),
          throwsMissing(
            "attachController",
            "UIControllerCapabilityDelegate",
          ),
        );
      });

      test("detachController throws MissingMethodImplementation", () {
        expect(
          () => delegate.detachController(""),
          throwsMissing(
            "detachController",
            "UIControllerCapabilityDelegate",
          ),
        );
      });

      test("getController throws MissingMethodImplementation", () {
        expect(
          () => delegate.getController(""),
          throwsMissing(
            "getController",
            "UIControllerCapabilityDelegate",
          ),
        );
      });

      test("updateAttributes throws MissingMethodImplementation", () {
        expect(
          () => delegate.updateAttributes("", {}),
          throwsMissing(
            "updateAttributes",
            "UIControllerCapabilityDelegate",
          ),
        );
      });

      test("releaseResources throws MissingMethodImplementation", () {
        expect(
          delegate.releaseResources,
          throwsMissing(
            "releaseResources",
            "UIControllerCapabilityDelegate",
          ),
        );
      });
    },
  );
}
