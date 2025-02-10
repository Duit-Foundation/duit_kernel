abstract interface class ResourceLoader<T> {
  const ResourceLoader();

  Future<T> load();
}
