import "package:duit_kernel/src/misc/env.dart";

const Object preferInline =
    envPreferInlineFn ? pragma("vm:prefer-inline") : Object();
