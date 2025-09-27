import "package:duit_kernel/src/ui/slots/op.dart";

abstract interface class SlotManager {
  /// Attach a slot host to the slot manager.
  void attachSlotHost(String id, covariant view);

  /// Detach a slot host from the slot manager.
  void detachSlotHost(String id);

  /// Get a slot host as a specific type.
  T? getSlotHostAs<T>(String id);

  /// Update the content of a slot host.
  void updateSlotHostContent(
    String id,
    List<SlotOp> ops,
  );
}
