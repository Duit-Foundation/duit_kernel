/// A base interface for parsers in the DUIT library.
///
/// This interface defines a single method, `parse`, which takes in a JSON object
/// and returns a parsed object of type `T`. This interface is used to define
/// specific parsers for different types of data, such as UI elements, attributes,
/// and scripts.
abstract interface class Parser<T> {
  T parse(Map<String, dynamic> json);
}