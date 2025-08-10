import 'package:duit_kernel/src/registry_api/components/index.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duit_kernel/duit_kernel.dart';
import 'package:duit_kernel/src/registry_api/components/component_registry_impl.dart';

void main() {
  group('ComponentRegistry.writeOps generation', () {
    late DefaultComponentRegistry registry;

    setUp(() async {
      registry = DefaultComponentRegistry();
      await registry.init();
    });

    tearDown(() {
      registry.dispose();
    });

    test('root attributes refs -> path [attributes, key]', () async {
      final component = <String, dynamic>{
        'tag': 'root',
        'layoutRoot': {
          'type': 'Container',
          'id': 'root',
          'attributes': {
            'refs': [
              {
                'objectKey': 'mainColor',
                'attributeKey': 'color',
                'defaultValue': '#FFFFFF',
              },
            ],
          },
        },
      };

      await registry.prepareComponent(component);
      final desc = registry.getComponentDescription('root')!;

      expect(desc.writeOps.length, 1);
      final op = desc.writeOps.first;
      expect(op.path, ['attributes', 'color']);
      expect(op.sourceKey, 'mainColor');
      expect(op.defaultValue, '#FFFFFF');
      expect(op.semantics, PatchSemantics.replace);
    });

    test('child and children refs produce correct indexed paths', () async {
      final component = <String, dynamic>{
        'tag': 'x',
        'layoutRoot': {
          'type': 'Column',
          'id': 'col',
          'child': {
            'type': 'Container',
            'id': 'c1',
            'attributes': {
              'refs': [
                {
                  'objectKey': 'primary',
                  'attributeKey': 'color',
                },
              ],
            },
          },
          'children': [
            {
              'type': 'Container',
              'id': 'c2',
            },
            {
              'type': 'Container',
              'id': 'c3',
              'attributes': {
                'refs': [
                  {
                    'objectKey': 'secondary',
                    'attributeKey': 'color',
                  },
                ],
              },
            },
          ],
        },
      };

      await registry.prepareComponent(component);
      final desc = registry.getComponentDescription('x')!;

      // Two refs expected
      expect(desc.writeOps.length, 2);

      // Paths set
      final paths = desc.writeOps.map((e) => e.path).toSet();
      expect(
        paths,
        {
          ['child', 'attributes', 'color'],
          ['children', 1, 'attributes', 'color'],
        },
      );
    });

    test('no refs -> empty writeOps', () async {
      final component = <String, dynamic>{
        'tag': 'no_refs',
        'layoutRoot': {
          'type': 'Container',
          'id': 'root',
          'attributes': {
            'width': 10,
          },
        },
      };

      await registry.prepareComponent(component);
      final desc = registry.getComponentDescription('no_refs')!;
      expect(desc.writeOps, isEmpty);
    });
  });
}
