import 'package:duit_kernel/src/view_attributes/data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('textOverflow', () {
    test('parses TextOverflow enum value', () {
      final attrs = DuitDataSource({
        'overflow': TextOverflow.ellipsis,
      });

      expect(attrs.textOverflow(key: 'overflow'), TextOverflow.ellipsis);
    });

    test('parses string values', () {
      final attrs = DuitDataSource({
        'clip': 'clip',
        'ellipsis': 'ellipsis',
        'fade': 'fade',
        'visible': 'visible',
      });

      expect(attrs.textOverflow(key: 'clip'), TextOverflow.clip);
      expect(attrs.textOverflow(key: 'ellipsis'), TextOverflow.ellipsis);
      expect(attrs.textOverflow(key: 'fade'), TextOverflow.fade);
      expect(attrs.textOverflow(key: 'visible'), TextOverflow.visible);
    });

    test('parses integer values', () {
      final attrs = DuitDataSource({
        'clip': 0,
        'ellipsis': 1,
        'fade': 2,
        'visible': 3,
      });

      expect(attrs.textOverflow(key: 'clip'), TextOverflow.clip);
      expect(attrs.textOverflow(key: 'ellipsis'), TextOverflow.ellipsis);
      expect(attrs.textOverflow(key: 'fade'), TextOverflow.fade);
      expect(attrs.textOverflow(key: 'visible'), TextOverflow.visible);
    });

    test('returns default value when key does not exist', () {
      final attrs = DuitDataSource({});

      expect(attrs.textOverflow(key: 'nonexistent'), null);
      expect(
        attrs.textOverflow(
            key: 'nonexistent1', defaultValue: TextOverflow.ellipsis),
        TextOverflow.ellipsis,
      );
    });

    // test('returns default value for invalid values', () {
    //   final attrs = DuitDataSource({
    //     'invalid_string': 'invalid',
    //     'invalid_number': 42,
    //     'bool': true,
    //     'list': [1, 2, 3],
    //     'map': {'key': 'value'},
    //     'null': null,
    //   });

    //   expect(attrs.textOverflow(key: 'invalid_string'), TextOverflow.clip);
    //   expect(attrs.textOverflow(key: 'invalid_number'), TextOverflow.clip);
    //   expect(attrs.textOverflow(key: 'bool'), TextOverflow.clip);
    //   expect(attrs.textOverflow(key: 'list'), TextOverflow.clip);
    //   expect(attrs.textOverflow(key: 'map'), TextOverflow.clip);
    //   expect(attrs.textOverflow(key: 'null'), TextOverflow.clip);
    //   expect(
    //       attrs.textOverflow(
    //           key: 'invalid_string1', defaultValue: TextOverflow.ellipsis),
    //       TextOverflow.ellipsis);
    // });
  });
}
