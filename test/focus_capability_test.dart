import "package:duit_kernel/duit_kernel.dart";
import "package:flutter/widgets.dart";
import "package:flutter_test/flutter_test.dart";

import "testutil.dart";

// ignore: missing_override_of_must_be_overridden
class _DummyDelegate with FocusCapabilityDelegate {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("FocusDelegate default implementations", () {
    final delegate = _DummyDelegate();

    test("requestFocus throws MissingMethodImplementation", () {
      expect(
        () => delegate.requestFocus("node"),
        throwsMissing(
          "requestFocus",
          "FocusCapabilityDelegate",
        ),
      );
    });

    test("nextFocus throws MissingMethodImplementation", () {
      expect(
          () => delegate.nextFocus("node"),
          throwsMissing(
            "nextFocus",
            "FocusCapabilityDelegate",
          ));
    });

    test("previousFocus throws MissingMethodImplementation", () {
      expect(
        () => delegate.previousFocus("node"),
        throwsMissing(
          "previousFocus",
          "FocusCapabilityDelegate",
        ),
      );
    });

    test("unfocus throws MissingMethodImplementation regardless of disposition",
        () {
      expect(
        () => delegate.unfocus(
          "node",
          disposition: UnfocusDisposition.previouslyFocusedChild,
        ),
        throwsMissing(
          "unfocus",
          "FocusCapabilityDelegate",
        ),
      );
    });

    test("focusInDirection throws MissingMethodImplementation", () {
      expect(
        () => delegate.focusInDirection("node", TraversalDirection.down),
        throwsMissing(
          "focusInDirection",
          "FocusCapabilityDelegate",
        ),
      );
    });

    test("attachFocusNode throws MissingMethodImplementation", () {
      expect(
        () => delegate.attachFocusNode("node", FocusNode()),
        throwsMissing(
          "attachFocusNode",
          "FocusCapabilityDelegate",
        ),
      );
    });

    test("detachFocusNode throws MissingMethodImplementation", () {
      expect(
        () => delegate.detachFocusNode("node"),
        throwsMissing(
          "detachFocusNode",
          "FocusCapabilityDelegate",
        ),
      );
    });

    test("getNode throws MissingMethodImplementation", () {
      expect(
        () => delegate.getNode(""),
        throwsMissing(
          "getNode",
          "FocusCapabilityDelegate",
        ),
      );
    });

    test("releaseResources throws MissingMethodImplementation", () {
      expect(
        delegate.releaseResources,
        throwsMissing(
          "releaseResources",
          "FocusCapabilityDelegate",
        ),
      );
    });
  });
}
