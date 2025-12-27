import "dart:async";

import "package:flutter/material.dart" show BuildContext;

///An interface that defines a set of methods that, for some reason,
///cannot be processed by the library and cannot be implemented by the user.
@Deprecated("Will be removed in the next major release.")
abstract interface class ExternalEventHandler {
  FutureOr<void> handleNavigation(
    BuildContext context,
    String path,
    Object? extra,
  );

  FutureOr<void> handleOpenUrl(String url);

  FutureOr<void> handleCustomEvent(
    BuildContext context,
    String key,
    Object? extra,
  );
}
