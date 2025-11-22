/// Describes when an animation should trigger.
enum AnimationTrigger {
  /// Triggers when the animation enters the screen.
  onEnter,

  /// Triggers when the action is triggered.
  onAction;

  /// Whether the animation should run immediately when entering the screen.
  bool get needsRunImmediently => this == AnimationTrigger.onEnter;
}
