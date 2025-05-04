import 'package:duit_kernel/src/view_attributes/data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getInt', () {
    test('parses integer value', () {
      final attrs = DuitDataSource({
        'int': 42,
        'double': 42.0,
        'string': '42',
      });

      expect(attrs.getInt(key: 'int'), 42);
      expect(attrs.getInt(key: 'double'), 42);
      expect(attrs.getInt(key: 'string'), 0);
    });

    test('returns default value when key does not exist', () {
      final attrs = DuitDataSource({});

      expect(attrs.getInt(key: 'nonexistent'), 0);
      expect(attrs.getInt(key: 'nonexistent', defaultValue: 100), 100);
    });

    test('returns default value for invalid types', () {
      final attrs = DuitDataSource({
        'bool': true,
        'list': [1, 2, 3],
        'map': {'key': 'value'},
      });

      expect(attrs.getInt(key: 'bool'), 0);
      expect(attrs.getInt(key: 'list'), 0);
      expect(attrs.getInt(key: 'map'), 0);
      expect(attrs.getInt(key: 'bool', defaultValue: 100), 100);
    });
  });

  group('tryGetInt', () {
    test('parses integer value', () {
      final attrs = DuitDataSource({
        'int': 42,
        'double': 42.0,
        'string': '42',
      });

      expect(attrs.tryGetInt(key: 'int'), 42);
      expect(attrs.tryGetInt(key: 'double'), 42);
      expect(attrs.tryGetInt(key: 'string'), null);
    });

    test('returns default value when key does not exist', () {
      final attrs = DuitDataSource({});

      expect(attrs.tryGetInt(key: 'nonexistent'), null);
      expect(attrs.tryGetInt(key: 'nonexistent', defaultValue: 100), 100);
    });

    test('returns default value for invalid types', () {
      final attrs = DuitDataSource({
        'bool': true,
        'list': [1, 2, 3],
        'map': {'key': 'value'},
      });

      expect(attrs.tryGetInt(key: 'bool'), null);
      expect(attrs.tryGetInt(key: 'list'), null);
      expect(attrs.tryGetInt(key: 'map'), null);
      expect(attrs.tryGetInt(key: 'bool', defaultValue: 100), 100);
    });
  });
}
