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
  late final int _taskId;

  Task({
    required this.key,
    required this.payload,
  });

  set taskId(int taskId) => this.taskId = taskId;

  int get id => _taskId;
}

abstract class WorkerPool {
  Future<void> initWithConfiguration(WorkerPoolConfiguration policy);

  Future<Object?> perform(Task task);

  void dispose();
}
