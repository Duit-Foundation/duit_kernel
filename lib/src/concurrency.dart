import 'dart:async';

///An object used for basic configuration of a [WorkerPool]
base class WorkerPoolConfiguration {
  ///The number of workers in the pool
  final int workerCount;

  WorkerPoolConfiguration({
    required this.workerCount,
  });
}

///Base class for all Task objects executed by workers
base class Task {
  ///The key of the task
  final String key;

  ///The payload of the task
  final dynamic payload;

  ///The id of the task
  late final int _taskId;

  Task({
    required this.key,
    required this.payload,
  });

  set taskId(int taskId) => this.taskId = taskId;

  int get id => _taskId;
}

///Base class for all worker pools
abstract class WorkerPool {
  ///Whether the pool has been initialized
  bool initialized = false;

  ///Initializes the pool with the specified configuration
  Future<void> initWithConfiguration(WorkerPoolConfiguration configuration);

  ///Performs the task
  Future<Object?> perform(Task task);

  ///Disposes the workers in pool
  void dispose();
}
