import "package:duit_kernel/duit_kernel.dart";
import "package:flutter_test/flutter_test.dart";

import "testutil.dart";

// ignore: missing_override_of_must_be_overridden
class _DummyDelegate with ServerActionExecutionCapabilityDelegate {}

void main() {
  group(
    "ServerActionExecutionCapabilityDelegate default implementations",
    () {
      final delegate = _DummyDelegate();
      ServerAction.setActionParser(const DefaultActionParser());

      test("addExternalEventStream throws MissingMethodImplementation", () {
        expect(
          () => delegate.addExternalEventStream(const Stream.empty()),
          throwsMissing(
            "addExternalEventStream",
            "ServerActionExecutionCapabilityDelegate",
          ),
        );
      });

      test("attachExternalHandler throws MissingMethodImplementation", () {
        expect(
          () => delegate.attachExternalHandler(
            UserDefinedHandlerKind.custom,
            (_, __, ___) {},
          ),
          throwsMissing(
            "attachExternalHandler",
            "ServerActionExecutionCapabilityDelegate",
          ),
        );
      });

      test("execute throws MissingMethodImplementation", () {
        expect(
          () => delegate.execute(
            ServerAction.parse(
              {},
            ),
          ),
          throwsMissing(
            "execute",
            "ServerActionExecutionCapabilityDelegate",
          ),
        );
      });

      test("resolveEvent throws MissingMethodImplementation", () {
        expect(
          () => delegate.resolveEvent(
            MockBuildCtx(),
            const ServerEvent(type: ""),
          ),
          throwsMissing(
            "resolveEvent",
            "ServerActionExecutionCapabilityDelegate",
          ),
        );
      });

      test("releaseResources throws MissingMethodImplementation", () {
        expect(
          delegate.releaseResources,
          throwsMissing(
            "releaseResources",
            "ServerActionExecutionCapabilityDelegate",
          ),
        );
      });

      test("preparePayload throws MissingMethodImplementation", () {
        expect(
          () => delegate.preparePayload([]),
          throwsMissing(
            "preparePayload",
            "ServerActionExecutionCapabilityDelegate",
          ),
        );
      });
    },
  );
}
