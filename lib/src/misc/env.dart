const envAttributeWarmUpEnabled = bool.fromEnvironment(
  "duit:enable-warm-up",
  defaultValue: false,
);

const envPreferInlineFn = bool.fromEnvironment(
  "duit:prefer-inline",
  defaultValue: true,
);

// ================================================== Experiment flags ==================================================

/// **Experiment** — allows overriding built-in Duit core widget implementations
/// with custom ones at render time.
///
/// When `true`, the element tree builder checks the [DuitRegistry] for a
/// registered [BuildFactory] even for widget types that belong to the Duit core
/// set, letting host apps replace e.g. the built-in `Text` widget with their
/// own version.
///
/// Disabled by default.  Enable via
/// `--dart-define=experiment:enable-core-widgets-oveeride=true`.
///
/// > **Warning:** This flag is experimental and may be removed or renamed in a
/// > future release.
const enableCoreWidgetsOveeride = bool.fromEnvironment(
  "experiment:enable-core-widgets-oveeride",
  defaultValue: false,
);

/// **Experiment** — enables support for external widget libraries loaded via
/// [DuitRegistry.loadLibrary].
///
/// When `true`, the element tree builder consults the library
/// descriptor reverse-index for widget types that are not part of the core set
/// and not registered as plain custom widgets.  Set to `true` via
/// `--dart-define=experiment:enable-external-library-support=true` to disable
/// this lookup path entirely (e.g. to save a map lookup in apps that never use
/// external libraries).
///
/// > **Warning:** This flag is experimental and may be removed or renamed in a
/// > future release.
const enableExternalLibrarySupport = bool.fromEnvironment(
  "experiment:enable-external-library-support",
  defaultValue: false,
);
