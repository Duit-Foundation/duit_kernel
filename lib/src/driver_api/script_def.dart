/// The [ScriptDefinition] class represents a script definition used for script actions.
///
/// It contains the following fields:
/// - [sourceCode]: The source code of the script.
/// - [functionName]: The name of the function to be executed within the script.
/// - [meta]: An optional map containing metadata related to the script.
///
/// It also provides a factory method [fromJson] to create an instance of [ScriptDefinition]
/// from a JSON object. This is useful for deserializing script data from a server response.
final class ScriptDefinition {
  final String sourceCode, functionName;
  final Map<String, dynamic>? meta;

  ScriptDefinition({
    required this.sourceCode,
    required this.functionName,
    required this.meta,
  });
}
