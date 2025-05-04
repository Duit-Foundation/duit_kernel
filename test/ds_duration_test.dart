import 'package:duit_kernel/src/view_attributes/data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    "Duration parsing",
    () {
      final attrs = DuitDataSource({
        "duration": 1000,
        "durationInst": const Duration(seconds: 5),
      });

      final duration = attrs.duration();
      final defaultDurationValue = attrs.duration(
        key: "duration1",
        defaultValue: const Duration(seconds: 2),
      );
      final defaultDurationValue2 = attrs.duration(
        key: "duration2",
      );
      final inst = attrs.duration(key: "durationInst");

      expect(duration, const Duration(milliseconds: 1000));
      expect(defaultDurationValue, const Duration(seconds: 2));
      expect(defaultDurationValue2, Duration.zero);
      expect(inst, const Duration(seconds: 5));
    },
  );

  test(
    "Duration source rewrite",
    () {
      final attrs = DuitDataSource({
        "duration": 1000,
      });

      expect(attrs["duration"], isA<int>());

      attrs.duration();

      expect(attrs["duration"], isA<Duration>());

      attrs["duration"] = null;

      attrs.duration();

      expect(attrs["duration"], Duration.zero);
    },
  );
}
