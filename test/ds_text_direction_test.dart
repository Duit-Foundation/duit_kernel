import 'package:duit_kernel/src/view_attributes/data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('textDirection', () {
    test('parses TextDirection enum value', () {
      final attrs = DuitDataSource({
        'direction': TextDirection.rtl,
      });

      expect(attrs.textDirection(key: 'direction'), TextDirection.rtl);
    });

    test('parses string values', () {
      final attrs = DuitDataSource({
        'ltr': 'ltr',
        'rtl': 'rtl',
      });

      expect(attrs.textDirection(key: 'ltr'), TextDirection.ltr);
      expect(attrs.textDirection(key: 'rtl'), TextDirection.rtl);
    });

    test('parses integer values', () {
      final attrs = DuitDataSource({
        'ltr': 0,
        'rtl': 1,
      });

      expect(attrs.textDirection(key: 'ltr'), TextDirection.ltr);
      expect(attrs.textDirection(key: 'rtl'), TextDirection.rtl);
    });

    test('returns default value when key does not exist', () {
      final attrs = DuitDataSource({});

      expect(attrs.textDirection(key: 'nonexistent'), TextDirection.ltr);
      expect(
          attrs.textDirection(
              key: 'nonexistent2', defaultValue: TextDirection.rtl),
          TextDirection.rtl);
    });

    test('returns default value for invalid values', () {
      final attrs = DuitDataSource({
        'invalid_string': 'invalid',
        'invalid_number': 42,
        'bool': true,
        'list': [1, 2, 3],
        'map': {'key': 'value'},
        'null': null,
      });

      expect(attrs.textDirection(key: 'invalid_string'), null);
      expect(attrs.textDirection(key: 'invalid_number'), null);
      expect(attrs.textDirection(key: 'bool'), TextDirection.ltr);
      expect(attrs.textDirection(key: 'list'), TextDirection.ltr);
      expect(attrs.textDirection(key: 'map'), TextDirection.ltr);
      expect(attrs.textDirection(key: 'null'), TextDirection.ltr);
      expect(
          attrs.textDirection(
              key: 'invalid_string1', defaultValue: TextDirection.rtl),
          TextDirection.rtl);
    });
  });
}
