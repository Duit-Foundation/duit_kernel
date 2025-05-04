import 'package:duit_kernel/src/view_attributes/data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getString', () {
    test('parses string value', () {
      final attrs = DuitDataSource({
        'string': 'test',
        'number': 42,
        'bool': true,
      });

      expect(attrs.getString(key: 'string'), 'test');
      expect(attrs.getString(key: 'number'), '');
      expect(attrs.getString(key: 'bool'), '');
    });

    test('returns default value when key does not exist', () {
      final attrs = DuitDataSource({});

      expect(attrs.getString(key: 'nonexistent'), '');
      expect(attrs.getString(key: 'nonexistent', defaultValue: 'default'),
          'default');
    });

    test('returns default value for invalid types', () {
      final attrs = DuitDataSource({
        'list': [1, 2, 3],
        'map': {'key': 'value'},
        'null': null,
      });

      expect(attrs.getString(key: 'list'), '');
      expect(attrs.getString(key: 'map'), '');
      expect(attrs.getString(key: 'null'), '');
      expect(attrs.getString(key: 'list', defaultValue: 'default'), 'default');
    });
  });

  group('tryGetString', () {
    test('parses string value', () {
      final attrs = DuitDataSource({
        'string': 'test',
        'number': 42,
        'bool': true,
      });

      expect(attrs.tryGetString('string'), 'test');
      expect(attrs.tryGetString('number'), null);
      expect(attrs.tryGetString('bool'), null);
    });

    test('returns default value when key does not exist', () {
      final attrs = DuitDataSource({});

      expect(attrs.tryGetString('nonexistent'), null);
      expect(attrs.tryGetString('nonexistent', defaultValue: 'default'),
          'default');
    });

    test('returns default value for invalid types', () {
      final attrs = DuitDataSource({
        'list': [1, 2, 3],
        'map': {'key': 'value'},
        'null': null,
      });

      expect(attrs.tryGetString('list'), null);
      expect(attrs.tryGetString('map'), null);
      expect(attrs.tryGetString('null'), null);
      expect(attrs.tryGetString('list', defaultValue: 'default'), 'default');
    });
  });
}
