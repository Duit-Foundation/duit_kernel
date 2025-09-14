const envAttributeWarmUpEnabled = bool.fromEnvironment(
  "DK_ENABLE_ATTRIBUTE_WARM_UP",
  defaultValue: false,
);

const envPreferInlineFn = bool.fromEnvironment(
  "DK_PREFER_INLINE",
  defaultValue: false,
);
