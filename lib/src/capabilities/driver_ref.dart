import "package:duit_kernel/duit_kernel.dart";

/// An interface that provides access to a [UIDriver] instance.
///
/// This interface is used by capability delegates (mixins) to maintain a reference
/// to the [UIDriver] that uses them. It allows capability delegates to access
/// driver functionality and coordinate with other capabilities.
///
/// Classes implementing this interface must:
/// - Implement the [linkDriver] method to establish the driver reference
abstract interface class DriverRefHolder {
  /// Links a [UIDriver] instance to this holder.
  ///
  /// This method should be called to establish the connection between
  /// the capability delegate and the driver that uses it.
  ///
  /// The [driver] parameter is the [UIDriver] instance to link.
  void linkDriver(UIDriver driver);
}
