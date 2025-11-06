const envAttributeWarmUpEnabled = bool.fromEnvironment(
  "duit:enable-warm-up",
  defaultValue: false,
);

const envPreferInlineFn = bool.fromEnvironment(
  "duit:prefer-inline",
  defaultValue: true,
);
