/// [DuitAttributes] is an abstract interface that defines the contract for attribute classes in the DUIT library.
///
/// It provides a `copyWith` method that allows creating a copy
/// of an attribute object with updated values and a `dispatchInternalCall` method for calling
/// private methods or methods not included in the common interface through binding in siblings.
abstract interface class DuitAttributes<T> {
  /// Creates a copy of an attribute object with updated values.
  T copyWith(T other);

  ///Implementing a method in descendant classes allows
  ///you to call private methods or methods not included
  ///in the common interface
  ReturnT dispatchInternalCall<ReturnT>(
    String methodName, {
    Iterable<dynamic>? positionalParams,
    Map<String, dynamic>? namedParams,
  });
}
