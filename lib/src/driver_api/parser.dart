abstract interface class Parser<T> {
  T parse(Map<String, dynamic> json);
}