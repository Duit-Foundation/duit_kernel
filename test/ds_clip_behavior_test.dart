import 'package:duit_kernel/src/view_attributes/data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('clipBehavior', () {
    test('parses Clip enum value', () {
      final attrs = DuitDataSource({
        'clipBehavior': Clip.antiAlias,
      });

      expect(attrs.clipBehavior(), Clip.antiAlias);
    });

    test('parses string values', () {
      final attrs = DuitDataSource({
        'clipBehavior': 'hardEdge',
        'clipBehavior2': 'antiAlias',
        'clipBehavior3': 'antiAliasWithSaveLayer',
        'clipBehavior4': 'none',
      });

      expect(attrs.clipBehavior(key: 'clipBehavior'), Clip.hardEdge);
      expect(attrs.clipBehavior(key: 'clipBehavior2'), Clip.antiAlias);
      expect(attrs.clipBehavior(key: 'clipBehavior3'),
          Clip.antiAliasWithSaveLayer);
      expect(attrs.clipBehavior(key: 'clipBehavior4'), Clip.none);
    });

    test('parses integer values', () {
      final attrs = DuitDataSource({
        'clipBehavior': 0,
        'clipBehavior2': 1,
        'clipBehavior3': 2,
        'clipBehavior4': 3,
      });

      expect(attrs.clipBehavior(key: 'clipBehavior'), Clip.hardEdge);
      expect(attrs.clipBehavior(key: 'clipBehavior2'), Clip.antiAlias);
      expect(attrs.clipBehavior(key: 'clipBehavior3'),
          Clip.antiAliasWithSaveLayer);
      expect(attrs.clipBehavior(key: 'clipBehavior4'), Clip.none);
    });

    test('returns default value when key does not exist', () {
      final attrs = DuitDataSource({});

      expect(attrs.clipBehavior(key: 'nonexistent'), Clip.hardEdge);
      expect(
          attrs.clipBehavior(key: 'nonexistent1', defaultValue: Clip.antiAlias),
          Clip.antiAlias);
    });

    test('returns default value for invalid values', () {
      final attrs = DuitDataSource({
        'clipBehavior': 'invalid',
        'clipBehavior2': 42,
        'clipBehavior3': true,
        'clipBehavior4': [1, 2, 3],
        'clipBehavior5': {'key': 'value'},
        'clipBehavior6': null,
      });

      expect(attrs.clipBehavior(key: 'clipBehavior'), Clip.hardEdge);
      expect(attrs.clipBehavior(key: 'clipBehavior2'), Clip.hardEdge);
      expect(attrs.clipBehavior(key: 'clipBehavior3'), Clip.hardEdge);
      expect(attrs.clipBehavior(key: 'clipBehavior4'), Clip.hardEdge);
      expect(attrs.clipBehavior(key: 'clipBehavior5'), Clip.hardEdge);
      expect(attrs.clipBehavior(key: 'clipBehavior6'), Clip.hardEdge);
      expect(
          attrs.clipBehavior(
              key: 'clipBehavior1', defaultValue: Clip.antiAlias),
          Clip.antiAlias);
    });
  });
}
