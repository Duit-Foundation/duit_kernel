import 'dart:async';

base class WorkerPoolConfiguration {
  final int workerCount;

  WorkerPoolConfiguration({
    required this.workerCount,
  });
}

base class Task {
  final String key;
  final dynamic payload;

  Task({
    required this.key,
    required this.payload,
  });
}

abstract class WorkerPool {
  Future<void> init();

  Future<void> initWithConfiguration(WorkerPoolConfiguration policy);

  Future<Object?> run(Task task);

  void dispose();
}
