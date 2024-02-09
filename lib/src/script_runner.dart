import 'index.dart';

abstract class ScriptRunner<TInitOptions> {
  TInitOptions runnerOptions;

  ScriptRunner({
    required this.runnerOptions,
  });

  Future<Map<String, dynamic>?> runScript(String name, {
    String url,
    Map<String, dynamic> meta,
    Map<String, dynamic> body,
  });

  Future<void> initWithTransport(Transport transport);
}
