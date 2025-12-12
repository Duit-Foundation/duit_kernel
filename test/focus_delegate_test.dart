import "package:duit_kernel/duit_kernel.dart";
import "package:flutter/widgets.dart";
import "package:flutter_test/flutter_test.dart";

// ignore: missing_override_of_must_be_overridden
class _DummyFocusDelegate with FocusDelegate {}

Matcher _throwsMissing(String method) => throwsA(
      isA<MissingMethodImplementation>()
          .having((e) => e.methodName, "methodName", method)
          .having((e) => e.mixinName, "mixinName", "FocusDelegate"),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("FocusDelegate default implementations", () {
    final delegate = _DummyFocusDelegate();

    test("requestFocus throws MissingMethodImplementation", () {
      expect(
        () => delegate.requestFocus("node"),
        _throwsMissing("requestFocus"),
      );
    });

    test("nextFocus throws MissingMethodImplementation", () {
      expect(() => delegate.nextFocus("node"), _throwsMissing("nextFocus"));
    });

    test("previousFocus throws MissingMethodImplementation", () {
      expect(
        () => delegate.previousFocus("node"),
        _throwsMissing("previousFocus"),
      );
    });

    test("unfocus throws MissingMethodImplementation regardless of disposition",
        () {
      expect(
        () => delegate.unfocus(
          "node",
          disposition: UnfocusDisposition.previouslyFocusedChild,
        ),
        _throwsMissing("unfocus"),
      );
    });

    test("focusInDirection throws MissingMethodImplementation", () {
      expect(
        () => delegate.focusInDirection("node", TraversalDirection.down),
        _throwsMissing("focusInDirection"),
      );
    });

    test("attachFocusNode throws MissingMethodImplementation", () {
      expect(
        () => delegate.attachFocusNode("node", FocusNode()),
        _throwsMissing("attachNode"),
      );
    });

    test("detachFocusNode throws MissingMethodImplementation", () {
      expect(
        () => delegate.detachFocusNode("node"),
        _throwsMissing("detachNode"),
      );
    });
  });
}
