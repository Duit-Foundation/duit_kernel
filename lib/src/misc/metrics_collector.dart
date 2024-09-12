abstract interface class MetricsCollector<TOptions> {
  MetricsCollector get instance;

  Future<MetricsCollector> init(TOptions options);

  Future<void> sendEvent<T>(T event);

  void dispose();
}