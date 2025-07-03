/// A command that is sent to control an action by interacting with an
/// action controller identified by [controllerId]. The command specifies
/// the [type] of action to be executed.
base class RemoteCommand {
  final String controllerId;
  final String type;
  final Map<String, dynamic> payload;

  const RemoteCommand({
    required this.controllerId,
    required this.type,
    required this.payload,
  });
}
