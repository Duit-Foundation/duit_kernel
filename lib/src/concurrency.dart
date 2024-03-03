import 'dart:async';
import 'dart:isolate';

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

  late final Capability cap;

  Task({
    required this.key,
    required this.payload,
  });

  void setCapability(Capability c) => cap = c;
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
