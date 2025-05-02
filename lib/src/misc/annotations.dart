const _envPreferInlineFn = bool.fromEnvironment(
  "preferInline",
  defaultValue: true,
);

const Object preferInline =
    _envPreferInlineFn ? pragma("vm:prefer-inline") : Object();
