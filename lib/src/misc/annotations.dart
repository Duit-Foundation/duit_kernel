const _envAllowInlineFn = bool.fromEnvironment(
  "allowInline",
  defaultValue: true,
);

const Object preferInline =
    _envAllowInlineFn ? pragma("vm:prefer-inline") : Object();
