part of "data_source.dart";

/// Shortand for the extension type instance methods
typedef _DispatchFn = dynamic Function(
  DuitDataSource self,
  String key,
  Object? target,
  bool warmUp,
);

/// A function that converts a raw JSON value to a custom enum [T].
///
/// Used by [DuitDataSource.toEnum] when resolving enum values from JSON.
/// The [value] is typically a [String] (enum name) or [int] (enum index).
/// The factory must return a valid instance of [T] or throw.
// ignore: avoid_annotating_with_dynamic
typedef ToEnumFactory<T extends Enum> = T Function(dynamic value);

/// A function that converts a raw JSON value to a custom class [T].
///
/// Used by [DuitDataSource.toClass] when deserializing complex objects.
/// The [source] argument is the value at the requested key; for nested
/// objects this is typically a [Map<String, dynamic>], which can be wrapped
/// in [DuitDataSource] if the factory needs data-source-style access.
typedef ToClassFactory<T extends Object> = T Function(DuitDataSource source);
