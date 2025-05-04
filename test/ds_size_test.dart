import 'package:duit_kernel/src/view_attributes/data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('size', () {
    test('parses Size value', () {
      final attrs = DuitDataSource({
        'size': const Size(100, 200),
      });

      expect(attrs.size('size'), const Size(100, 200));
    });

    test('parses map values', () {
      final attrs = DuitDataSource({
        'size': {
          'width': 100.0,
          'height': 200.0,
        },
      });

      expect(attrs.size('size'), const Size(100, 200));
    });

    test('parses list values', () {
      final attrs = DuitDataSource({
        'size': [100, 200],
      });

      expect(attrs.size('size'), const Size(100, 200));
    });

    test('returns default value when key does not exist', () {
      final attrs = DuitDataSource({});

      expect(attrs.size('nonexistent'), Size.zero);
      expect(attrs.size('nonexistent1', defaultValue: const Size(100, 200)),
          const Size(100, 200));
    });

    // test('returns default value for invalid values', () {
    //   final attrs = DuitDataSource({
    //     'size': 'invalid',
    //     'size2': 42,
    //     'size3': true,
    //     'size4': {'invalid': 'map'},
    //     'size5': [1],
    //     'size6': null,
    //   });

    //   expect(attrs.size('size'), Size.zero);
    //   expect(attrs.size('size2'), Size.zero);
    //   expect(attrs.size('size3'), Size.zero);
    //   expect(attrs.size('size4'), Size.zero);
    //   expect(attrs.size('size5'), Size.zero);
    //   expect(attrs.size('size6'), Size.zero);
    //   expect(
    //     attrs.size('size1', defaultValue: const Size(100, 200)),
    //     const Size(100, 200),
    //   );
    // });
  });
}
