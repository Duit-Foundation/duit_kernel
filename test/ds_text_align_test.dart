import 'package:duit_kernel/src/view_attributes/data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('textAlign', () {
    test('parses TextAlign enum value', () {
      final attrs = DuitDataSource({
        'align': TextAlign.center,
      });

      expect(attrs.textAlign(key: 'align'), TextAlign.center);
    });

    test('parses string values', () {
      final attrs = DuitDataSource({
        'left': 'left',
        'right': 'right',
        'center': 'center',
        'justify': 'justify',
        'start': 'start',
        'end': 'end',
      });

      expect(attrs.textAlign(key: 'left'), TextAlign.left);
      expect(attrs.textAlign(key: 'right'), TextAlign.right);
      expect(attrs.textAlign(key: 'center'), TextAlign.center);
      expect(attrs.textAlign(key: 'justify'), TextAlign.justify);
      expect(attrs.textAlign(key: 'start'), TextAlign.start);
      expect(attrs.textAlign(key: 'end'), TextAlign.end);
    });

    test('parses integer values', () {
      final attrs = DuitDataSource({
        'left': 0,
        'right': 1,
        'center': 2,
        'justify': 3,
        'start': 4,
        'end': 5,
      });

      expect(attrs.textAlign(key: 'left'), TextAlign.left);
      expect(attrs.textAlign(key: 'right'), TextAlign.right);
      expect(attrs.textAlign(key: 'center'), TextAlign.center);
      expect(attrs.textAlign(key: 'justify'), TextAlign.justify);
      expect(attrs.textAlign(key: 'start'), TextAlign.start);
      expect(attrs.textAlign(key: 'end'), TextAlign.end);
    });

    test('returns default value when key does not exist', () {
      final attrs = DuitDataSource({});

      expect(attrs.textAlign(key: 'nonexistent'), null);
      expect(
          attrs.textAlign(key: 'nonexistent', defaultValue: TextAlign.center),
          TextAlign.center);
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

      expect(attrs.textAlign(key: 'invalid_string'), null);
      expect(attrs.textAlign(key: 'invalid_number'), null);
      expect(attrs.textAlign(key: 'bool'), null);
      expect(attrs.textAlign(key: 'list'), null);
      expect(attrs.textAlign(key: 'map'), null);
      expect(attrs.textAlign(key: 'null'), null);
      expect(
          attrs.textAlign(
              key: 'invalid_string', defaultValue: TextAlign.center),
          TextAlign.center);
    });
  });
}
