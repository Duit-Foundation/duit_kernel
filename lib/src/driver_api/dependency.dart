/// Represents a dependency for a server action.
///
/// The [ActionDependency] class contains information about the dependency target and ID.
final class ActionDependency {
  /// The ID of the dependency.
  String id;

  /// Name of the target property at resulting object.
  String target;

  ActionDependency({
    required this.target,
    required this.id,
  });

  /// Creates an instance of [ActionDependency] from a JSON map.
  factory ActionDependency.fromJson(Map<String, dynamic> json) {
    return ActionDependency(
      target: json["target"],
      id: json["id"],
    );
  }
}