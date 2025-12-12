import "dart:core";

/// An [Exception] thrown when a required method implementation is missing
/// from a class that uses a particular mixin.
///
/// For example, if a mixin declares a method as required but a class
/// with that mixin does not provide an implementation, this exception
/// can be thrown to indicate the specific method and mixin where the
/// implementation is missing.
///
/// The exception message will include the method name and the mixin name
/// for easier debugging.
/// 
/// Example usage:
/// ```dart
/// throw MissingMethodImplementation('someMethod', 'SomeMixin');
/// ```
final class MissingMethodImplementation implements Exception {
  final String methodName, mixinName;

  const MissingMethodImplementation(this.methodName, this.mixinName);

  @override
  String toString() =>
      "Missing [$methodName] method implementation of $mixinName mixin";
}
