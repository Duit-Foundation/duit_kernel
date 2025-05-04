import 'package:duit_kernel/src/view_attributes/data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getBool', () {
    test('parses boolean value', () {
      final attrs = DuitDataSource({
        'true': true,
        'false': false,
        'string_true': 'true',
        'string_false': 'false',
        'number': 42,
      });

      expect(attrs.getBool('true'), true);
      expect(attrs.getBool('false'), false);
      expect(attrs.getBool('string_true'), false);
      expect(attrs.getBool('string_false'), false);
      expect(attrs.getBool('number'), false);
    });

    test('returns default value when key does not exist', () {
      final attrs = DuitDataSource({});

      expect(attrs.getBool('nonexistent'), false);
      expect(attrs.getBool('nonexistent', defaultValue: true), true);
    });

    test('returns default value for invalid types', () {
      final attrs = DuitDataSource({
        'list': [1, 2, 3],
        'map': {'key': 'value'},
        'null': null,
      });

      expect(attrs.getBool('list'), false);
      expect(attrs.getBool('map'), false);
      expect(attrs.getBool('null'), false);
      expect(attrs.getBool('list', defaultValue: true), true);
    });
  });

  group('tryGetBool', () {
    test('parses boolean value', () {
      final attrs = DuitDataSource({
        'true': true,
        'false': false,
        'string_true': 'true',
        'string_false': 'false',
        'number': 42,
      });

      expect(attrs.tryGetBool('true'), true);
      expect(attrs.tryGetBool('false'), false);
      expect(attrs.tryGetBool('string_true'), null);
      expect(attrs.tryGetBool('string_false'), null);
      expect(attrs.tryGetBool('number'), null);
    });

    test('returns default value when key does not exist', () {
      final attrs = DuitDataSource({});

      expect(attrs.tryGetBool('nonexistent'), null);
      expect(attrs.tryGetBool('nonexistent', defaultValue: true), true);
    });

    test('returns default value for invalid types', () {
      final attrs = DuitDataSource({
        'list': [1, 2, 3],
        'map': {'key': 'value'},
        'null': null,
      });

      expect(attrs.tryGetBool('list'), null);
      expect(attrs.tryGetBool('map'), null);
      expect(attrs.tryGetBool('null'), null);
      expect(attrs.tryGetBool('list', defaultValue: true), true);
    });
  });
}
