import "package:duit_kernel/duit_kernel.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("MissingMethodImplementation toString", () {
    final str = const MissingMethodImplementation("testMethod", "testMixin").toString();
    expect(str,  "Missing [testMethod] method implementation of testMixin mixin");
  });
}
