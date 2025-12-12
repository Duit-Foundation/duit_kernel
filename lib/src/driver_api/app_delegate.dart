import "package:flutter/widgets.dart";
import "package:meta/meta.dart";

part "focus_delegate.dart";

abstract class BDUIApplicationDelegate with FocusDelegate, ScriptRunnerDelegate {}
