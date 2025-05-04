import 'package:duit_kernel/src/view_attributes/data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getDouble', () {
    test('parses double value', () {
      final attrs = DuitDataSource({
        'int': 42,
        'double': 42.5,
        'string': '42.5',
      });

      expect(attrs.getDouble(key: 'int'), 42.0);
      expect(attrs.getDouble(key: 'double'), 42.5);
      expect(attrs.getDouble(key: 'string'), 0.0);
    });

    test('returns default value when key does not exist', () {
      final attrs = DuitDataSource({});

      expect(attrs.getDouble(key: 'nonexistent'), 0.0);
      expect(attrs.getDouble(key: 'nonexistent', defaultValue: 100.5), 100.5);
    });

    test('returns default value for invalid types', () {
      final attrs = DuitDataSource({
        'bool': true,
        'list': [1, 2, 3],
        'map': {'key': 'value'},
      });

      expect(attrs.getDouble(key: 'bool'), 0.0);
      expect(attrs.getDouble(key: 'list'), 0.0);
      expect(attrs.getDouble(key: 'map'), 0.0);
      expect(attrs.getDouble(key: 'bool', defaultValue: 100.5), 100.5);
    });
  });

  group('tryGetDouble', () {
    test('parses double value', () {
      final attrs = DuitDataSource({
        'int': 42,
        'double': 42.5,
        'string': '42.5',
      });

      expect(attrs.tryGetDouble(key: 'int'), 42.0);
      expect(attrs.tryGetDouble(key: 'double'), 42.5);
      expect(attrs.tryGetDouble(key: 'string'), null);
    });

    test('returns default value when key does not exist', () {
      final attrs = DuitDataSource({});

      expect(attrs.tryGetDouble(key: 'nonexistent'), null);
      expect(
          attrs.tryGetDouble(key: 'nonexistent', defaultValue: 100.5), 100.5);
    });

    test('returns default value for invalid types', () {
      final attrs = DuitDataSource({
        'bool': true,
        'list': [1, 2, 3],
        'map': {'key': 'value'},
      });

      expect(attrs.tryGetDouble(key: 'bool'), null);
      expect(attrs.tryGetDouble(key: 'list'), null);
      expect(attrs.tryGetDouble(key: 'map'), null);
      expect(attrs.tryGetDouble(key: 'bool', defaultValue: 100.5), 100.5);
    });
  });
}
