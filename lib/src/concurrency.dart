import 'dart:async';
import 'dart:isolate';

typedef TaskOperation = dynamic Function(dynamic params);

///An object used for basic configuration of a [WorkerPool]
base class WorkerPoolConfiguration {
  ///The number of workers in the pool
  final int workerCount;

  WorkerPoolConfiguration({
    required this.workerCount,
  });
}

///Base class for all Task objects executed by workers
final class Task {
  final TaskOperation func;

  ///The payload of the task
  final dynamic payload;
  late final Capability cap;

  Task({
    required this.func,
    required this.payload,
    required this.cap,
  });
}

final class TaskResult {
  final dynamic result;
  final Capability cap;

  TaskResult(this.result, this.cap);
}

///Base class for all worker pools
abstract base class WorkerPool {
  ///Whether the pool has been initialized
  bool initialized = false;

  ///Initializes the pool with the specified configuration
  Future<void> initWithConfiguration(WorkerPoolConfiguration configuration);

  ///Performs the task
  Future<TaskResult> perform(TaskOperation func, dynamic payload);

  ///Disposes the workers in pool
  void dispose();
}
