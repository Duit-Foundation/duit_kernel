/// Defines the execution modifier for actions.
///
/// Execution modifiers control how frequently an action can be executed,
/// providing mechanisms to prevent excessive or rapid-fire executions.
enum ExecutionModifier {
  /// Throttles action execution to a maximum frequency.
  ///
  /// When using [throttle], the action will be executed at most once per
  /// specified duration. If the action is called multiple times within
  /// the duration window, only the first call will be executed, and
  /// subsequent calls will be ignored until the duration expires.
  ///
  /// Example:
  /// ```dart
  /// ExecutionOptions(
  ///   modifier: ExecutionModifier.throttle,
  ///   duration: Duration(milliseconds: 500),
  /// )
  /// ```
  /// This will ensure the action executes at most once every 500ms.
  throttle,

  /// Debounces action execution by delaying execution until after a quiet period.
  ///
  /// When using [debounce], the action execution is delayed until the specified
  /// duration has passed without any new calls. If the action is called again
  /// before the duration expires, the timer resets. This is useful for actions
  /// that should only execute after the user has stopped performing the triggering
  /// action for a certain period.
  ///
  /// Example:
  /// ```dart
  /// ExecutionOptions(
  ///   modifier: ExecutionModifier.debounce,
  ///   duration: Duration(milliseconds: 300),
  /// )
  /// ```
  /// This will execute the action only after 300ms of inactivity.
  debounce;
}

/// Configuration options for controlling action execution behavior.
///
/// [ExecutionOptions] provides a way to control how and when actions are executed
/// by applying execution modifiers. This is particularly useful for UI interactions
/// where you want to prevent excessive server requests or improve user experience
/// by controlling the frequency of action executions.
///
/// ## Usage
///
/// Execution options are typically used in conjunction with [ServerAction] and
/// are processed by the view controller to apply the appropriate execution
/// strategy before sending actions to the server or executing them locally.
///
/// ## Examples
///
/// ### Throttling button clicks
/// ```dart
/// final action = ServerAction(
///   eventName: "button_click",
///   executionType: 0,
///   executionOptions: ExecutionOptions(
///     modifier: ExecutionModifier.throttle,
///     duration: Duration(milliseconds: 1000),
///   ),
/// );
/// ```
///
/// ### Debouncing search input
/// ```dart
/// final action = ServerAction(
///   eventName: "search",
///   executionType: 0,
///   executionOptions: ExecutionOptions(
///     modifier: ExecutionModifier.debounce,
///     duration: Duration(milliseconds: 500),
///   ),
/// );
/// ```
final class ExecutionOptions {
  /// The execution modifier that determines how the action should be executed.
  ///
  /// This controls whether the action should be throttled or debounced.
  final ExecutionModifier modifier;

  /// The duration used by the execution modifier.
  ///
  /// For [ExecutionModifier.throttle], this is the minimum time between executions.
  /// For [ExecutionModifier.debounce], this is the delay before execution after
  /// the last trigger.
  final Duration duration;

  /// Creates execution options with the specified modifier and duration.
  ///
  /// Both parameters are required as they define the complete execution behavior.
  const ExecutionOptions({
    required this.modifier,
    required this.duration,
  });
}
