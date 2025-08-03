import 'dart:convert';
import 'package:duit_kernel/duit_kernel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duit_kernel/src/misc/encode.dart';

void main() {
  group('duitJsonEncode', () {
    group('Duration encoding', () {
      test('should encode Duration to milliseconds', () {
        const duration = Duration(seconds: 5, milliseconds: 250);
        final result = duitJsonEncode(duration);

        expect(result, '5250');
      });

      test('should encode zero Duration', () {
        const duration = Duration.zero;
        final result = duitJsonEncode(duration);

        expect(result, '0');
      });

      test('should encode negative Duration', () {
        const duration = Duration(milliseconds: -1000);
        final result = duitJsonEncode(duration);

        expect(result, '-1000');
      });
    });

    group('Size encoding', () {
      test('should encode Size to array', () {
        const size = Size(100.5, 200.75);
        final result = duitJsonEncode(size);

        expect(result, '[100.5,200.75]');
      });

      test('should encode zero Size', () {
        const size = Size.zero;
        final result = duitJsonEncode(size);

        expect(result, '[0.0,0.0]');
      });
    });

    group('EdgeInsets encoding', () {
      test('should encode EdgeInsets to array', () {
        const edgeInsets = EdgeInsets.all(16.0);
        final result = duitJsonEncode(edgeInsets);

        expect(result, '[16.0,16.0,16.0,16.0]');
      });

      test('should encode EdgeInsets.only', () {
        const edgeInsets =
            EdgeInsets.only(left: 8.0, top: 12.0, right: 16.0, bottom: 20.0);
        final result = duitJsonEncode(edgeInsets);

        expect(result, '[8.0,12.0,16.0,20.0]');
      });

      test('should encode EdgeInsets.symmetric', () {
        const edgeInsets =
            EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0);
        final result = duitJsonEncode(edgeInsets);

        expect(result, '[10.0,15.0,10.0,15.0]');
      });
    });

    group('TextStyle encoding', () {
      test('should encode TextStyle with all properties', () {
        const textStyle = TextStyle(
          color: Colors.red,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
          fontStyle: FontStyle.italic,
          height: 1.5,
          letterSpacing: 2.0,
          wordSpacing: 3.0,
          backgroundColor: Colors.yellow,
          decoration: TextDecoration.underline,
          decorationColor: Colors.blue,
          decorationStyle: TextDecorationStyle.solid,
          decorationThickness: 2.0,
        );

        final result = duitJsonEncode(textStyle);
        final decoded = jsonDecode(result);

        expect(decoded['color'], '#fff44336');
        expect(decoded['fontSize'], 16.0);
        expect(decoded['fontWeight'], 'FontWeight.w700');
        expect(decoded['fontFamily'], 'Roboto');
        expect(decoded['fontStyle'], 'FontStyle.italic');
        expect(decoded['height'], 1.5);
        expect(decoded['letterSpacing'], 2.0);
        expect(decoded['wordSpacing'], 3.0);
        expect(decoded['backgroundColor'], '#ffffeb3b');
        expect(decoded['decoration'], 'TextDecoration.underline');
        expect(decoded['decorationColor'], '#ff2196f3');
        expect(decoded['decorationStyle'], 'TextDecorationStyle.solid');
        expect(decoded['decorationThickness'], 2.0);
      });

      test('should encode TextStyle with minimal properties', () {
        const textStyle = TextStyle();
        final result = duitJsonEncode(textStyle);

        expect(result, '{}');
      });
    });

    group('Color encoding', () {
      test('should encode Color to hex string', () {
        const color = Colors.red;
        final result = duitJsonEncode(color);

        expect(result, '"#fff44336"');
      });

      test('should encode transparent color', () {
        const color = Colors.transparent;
        final result = duitJsonEncode(color);

        expect(result, '"#0"');
      });

      test('should encode custom color', () {
        const color = Color(0xFF123456);
        final result = duitJsonEncode(color);

        expect(result, '"#ff123456"');
      });
    });

    group('LinearGradient encoding', () {
      test('should encode LinearGradient with all properties', () {
        const gradient = LinearGradient(
          colors: [Colors.red, Colors.blue],
          stops: [0.0, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: GradientRotation(0.5),
        );

        final result = duitJsonEncode(gradient);
        final decoded = jsonDecode(result);

        expect(decoded['colors'], ['#fff44336', '#ff2196f3']);
        expect(decoded['stops'], [0.0, 1.0]);
        expect(decoded['begin'], 'Alignment.topLeft');
        expect(decoded['end'], 'Alignment.bottomRight');
        expect(decoded['transform'], 0.5);
      });

      test('should encode LinearGradient without transform', () {
        const gradient = LinearGradient(
          colors: [Colors.green, Colors.yellow],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        );

        final result = duitJsonEncode(gradient);
        final decoded = jsonDecode(result);

        expect(decoded['colors'], ['#ff4caf50', '#ffffeb3b']);
        expect(decoded['begin'], 'Alignment.centerLeft');
        expect(decoded['end'], 'Alignment.centerRight');
        expect(decoded.containsKey('transform'), false);
      });
    });

    group('BoxShadow encoding', () {
      test('should encode BoxShadow with all properties', () {
        const shadow = BoxShadow(
          color: Colors.black,
          offset: Offset(2.0, 3.0),
          blurRadius: 5.0,
          spreadRadius: 1.0,
        );

        final result = duitJsonEncode(shadow);
        final decoded = jsonDecode(result);

        expect(decoded['color'], '#ff000000');
        expect(decoded['offset'], {'dx': 2.0, 'dy': 3.0});
        expect(decoded['blurRadius'], 5.0);
        expect(decoded['spreadRadius'], 1.0);
      });
    });

    group('Offset encoding', () {
      test('should encode Offset', () {
        const offset = Offset(10.5, 20.75);
        final result = duitJsonEncode(offset);

        expect(result, '{"dx":10.5,"dy":20.75}');
      });

      test('should encode zero Offset', () {
        const offset = Offset.zero;
        final result = duitJsonEncode(offset);

        expect(result, '{"dx":0.0,"dy":0.0}');
      });
    });

    group('BoxDecoration encoding', () {
      test('should encode BoxDecoration with all properties', () {
        final decoration = BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.red, width: 2.0),
          gradient: const LinearGradient(colors: [Colors.green, Colors.yellow]),
          boxShadow: const [
            BoxShadow(color: Colors.black, blurRadius: 4.0),
          ],
        );

        final result = duitJsonEncode(decoration);
        final decoded = jsonDecode(result);

        expect(decoded['color'], '#ff2196f3');
        expect(decoded['borderRadius'], 8.0);
        expect(decoded['border'], {
          'side': {
            'color': '#fff44336',
            'width': 2.0,
            'style': 'BorderStyle.solid'
          }
        });
        expect(decoded.containsKey('gradient'), true);
        expect(decoded.containsKey('boxShadow'), true);
      });

      test('should encode BoxDecoration with minimal properties', () {
        const decoration = BoxDecoration();
        final result = duitJsonEncode(decoration);

        expect(result, '{}');
      });
    });

    group('BorderRadius encoding', () {
      test('should encode BorderRadius.circular', () {
        final radius = BorderRadius.circular(12.0);
        final result = duitJsonEncode(radius);

        expect(result, '12.0');
      });

      test('should encode BorderRadius.all', () {
        const radius = BorderRadius.all(Radius.circular(8.0));
        final result = duitJsonEncode(radius);

        expect(result, '8.0');
      });
    });

    group('Border encoding', () {
      test('should encode Border.all', () {
        final border = Border.all(color: Colors.green, width: 3.0);
        final result = duitJsonEncode(border);

        expect(result,
            '{"side":{"color":"#ff4caf50","width":3.0,"style":"BorderStyle.solid"}}');
      });
    });

    group('BorderSide encoding', () {
      test('should encode BorderSide with all properties', () {
        const borderSide = BorderSide(
          color: Colors.purple,
          width: 2.5,
          style: BorderStyle.solid,
        );

        final result = duitJsonEncode(borderSide);

        expect(result,
            '{"color":"#ff9c27b0","width":2.5,"style":"BorderStyle.solid"}');
      });
    });

    group('InputBorder encoding', () {
      test('should encode OutlineInputBorder', () {
        final border = OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
          gapPadding: 4.0,
        );

        final result = duitJsonEncode(border);
        final decoded = jsonDecode(result);

        expect(decoded['type'], 'outline');
        expect(decoded['borderSide'],
            {'color': '#ff2196f3', 'width': 2.0, 'style': 'BorderStyle.solid'});
        expect(decoded['gapPadding'], 4.0);
        expect(decoded['borderRadius'], 'Radius.circular(8.0)');
      });

      test('should encode UnderlineInputBorder', () {
        const border = UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        );

        final result = duitJsonEncode(border);
        final decoded = jsonDecode(result);

        expect(decoded['type'], 'underline');
        expect(decoded['borderSide'],
            {'color': '#fff44336', 'width': 1.0, 'style': 'BorderStyle.solid'});
        expect(decoded.containsKey('gapPadding'), false);
        expect(decoded.containsKey('borderRadius'), false);
      });
    });

    group('InputDecoration encoding', () {
      test('should encode InputDecoration with all properties', () {
        const decoration = InputDecoration(
          labelText: 'Label',
          labelStyle: TextStyle(color: Colors.blue),
          hintText: 'Hint',
          hintStyle: TextStyle(color: Colors.grey),
          helperText: 'Helper',
          errorText: 'Error',
          enabled: true,
          isDense: true,
          contentPadding: EdgeInsets.all(16.0),
          prefixIcon: Icon(Icons.search),
          suffixIcon: Icon(Icons.clear),
        );

        final result = duitJsonEncode(decoration);
        final decoded = jsonDecode(result);

        expect(decoded['labelText'], 'Label');
        expect(decoded['hintText'], 'Hint');
        expect(decoded['helperText'], 'Helper');
        expect(decoded['errorText'], 'Error');
        expect(decoded['enabled'], true);
        expect(decoded['isDense'], true);
        expect(decoded['contentPadding'], [16.0, 16.0, 16.0, 16.0]);
        expect(decoded.containsKey('prefixIcon'), true);
        expect(decoded.containsKey('suffixIcon'), true);
      });
    });

    group('VisualDensity encoding', () {
      test('should encode VisualDensity', () {
        const density = VisualDensity(horizontal: 2.0, vertical: 3.0);
        final result = duitJsonEncode(density);

        expect(result, '{"horizontal":2.0,"vertical":3.0}');
      });

      test('should encode VisualDensity.standard', () {
        const density = VisualDensity.standard;
        final result = duitJsonEncode(density);

        expect(result, '{"horizontal":0.0,"vertical":0.0}');
      });
    });

    group('ScrollPhysics encoding', () {
      test('should encode AlwaysScrollableScrollPhysics', () {
        const physics = AlwaysScrollableScrollPhysics();
        final result = duitJsonEncode(physics);

        expect(result, '"AlwaysScrollableScrollPhysics"');
      });

      test('should encode BouncingScrollPhysics', () {
        const physics = BouncingScrollPhysics();
        final result = duitJsonEncode(physics);

        expect(result, '"BouncingScrollPhysics"');
      });
    });

    group('ShapeBorder encoding', () {
      test('should encode RoundedRectangleBorder', () {
        final border = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: const BorderSide(color: Colors.blue, width: 2.0),
        );

        final result = duitJsonEncode(border);
        final decoded = jsonDecode(result);

        expect(decoded['type'], 'RoundedRectangleBorder');
        expect(decoded['side'],
            {'color': '#ff2196f3', 'width': 2.0, 'style': 'BorderStyle.solid'});
        expect(decoded['borderRadius'], 12.0);
      });

      test('should encode CircleBorder', () {
        const border = CircleBorder(
          side: BorderSide(color: Colors.red, width: 1.0),
        );

        final result = duitJsonEncode(border);
        final decoded = jsonDecode(result);

        expect(decoded['type'], 'CircleBorder');
        expect(decoded['side'],
            {'color': '#fff44336', 'width': 1.0, 'style': 'BorderStyle.solid'});
        expect(decoded.containsKey('borderRadius'), false);
      });
    });

    group('WidgetStateProperty encoding', () {
      test('should encode WidgetStateProperty with all states', () {
        final property = WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return Colors.grey;
          if (states.contains(WidgetState.pressed)) return Colors.red;
          if (states.contains(WidgetState.hovered)) return Colors.blue;
          if (states.contains(WidgetState.focused)) return Colors.green;
        });

        final result = duitJsonEncode(property);
        final decoded = jsonDecode(result);

        expect(decoded['disabled'], '#ff9e9e9e');
        expect(decoded['pressed'], '#fff44336');
        expect(decoded['hovered'], '#ff2196f3');
        expect(decoded['focused'], '#ff4caf50');
        expect(decoded.containsKey('selected'), false);
        expect(decoded.containsKey('error'), false);
        expect(decoded.containsKey('dragged'), false);
      });
    });

    group('ButtonStyle encoding', () {
      test('should encode ButtonStyle with all properties', () {
        final style = ButtonStyle(
          textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 16.0)),
          backgroundColor: WidgetStateProperty.all(Colors.blue),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          padding: WidgetStateProperty.all(const EdgeInsets.all(16.0)),
          minimumSize: WidgetStateProperty.all(const Size(100.0, 50.0)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
        );

        final result = duitJsonEncode(style);
        final decoded = jsonDecode(result);

        expect(decoded.containsKey('textStyle'), true);
        expect(decoded.containsKey('backgroundColor'), true);
        expect(decoded.containsKey('foregroundColor'), true);
        expect(decoded.containsKey('padding'), true);
        expect(decoded.containsKey('minimumSize'), true);
        expect(decoded.containsKey('shape'), true);
      });
    });

    group('AnimationInterval encoding', () {
      test('should encode AnimationInterval', () {
        const interval = AnimationInterval(0.3, 0.7);
        final result = duitJsonEncode(interval);

        expect(result, '{"begin":0.3,"end":0.7}');
      });
    });

    group('DuitTweenDescription encoding', () {
      test('should encode DuitTweenDescription', () {
        final tween = TweenDescription(
          animatedPropKey: 'opacity',
          begin: 0.0,
          end: 1.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          trigger: AnimationTrigger.onEnter,
          method: AnimationMethod.forward,
          reverseOnRepeat: false,
        );

        final result = duitJsonEncode(tween);
        final decoded = jsonDecode(result);

        expect(decoded['begin'], 0.0);
        expect(decoded['end'], 1.0);
        expect(decoded['duration'], 500);
        expect(decoded['curve'], 'linear');
      });
    });

    group('Curve encoding', () {
      test('should encode common curves', () {
        expect(duitJsonEncode(Curves.linear), '"linear"');
        expect(duitJsonEncode(Curves.easeIn), '"easeIn"');
        expect(duitJsonEncode(Curves.easeOut), '"linear"');
        expect(duitJsonEncode(Curves.easeInOut), '"linear"');
        expect(duitJsonEncode(Curves.bounceIn), '"bounceIn"');
        expect(duitJsonEncode(Curves.bounceOut), '"bounceOut"');
        expect(duitJsonEncode(Curves.elasticIn), '"elasticIn"');
        expect(duitJsonEncode(Curves.elasticOut), '"elasticOut"');
      });

      test('should encode unknown curve as linear', () {
        const customCurve = Curves.linear;
        final result = duitJsonEncode(customCurve);

        expect(result, '"linear"');
      });
    });

    group('TextInputType encoding', () {
      test('should encode TextInputType to name', () {
        const inputType = TextInputType.text;
        final result = duitJsonEncode(inputType);

        expect(result, 'TextInputType.text');
      });

      test('should encode TextInputType.number', () {
        const inputType = TextInputType.number;
        final result = duitJsonEncode(inputType);

        expect(result, 'TextInputType.number');
      });
    });

    group('Regular JSON encoding', () {
      test('should encode simple types', () {
        expect(duitJsonEncode('string'), '"string"');
        expect(duitJsonEncode(42), '42');
        expect(duitJsonEncode(3.14), '3.14');
        expect(duitJsonEncode(true), 'true');
        expect(duitJsonEncode(false), 'false');
        expect(duitJsonEncode(null), 'null');
      });

      test('should encode lists', () {
        final list = [1, 2, 3, 'string', true];
        final result = duitJsonEncode(list);

        expect(result, '[1,2,3,"string",true]');
      });

      test('should encode maps', () {
        final map = {'key1': 'value1', 'key2': 42, 'key3': true};
        final result = duitJsonEncode(map);

        expect(result, '{"key1":"value1","key2":42,"key3":true}');
      });

      test('should encode nested structures', () {
        final nested = {
          'list': [1, 2, 3],
          'map': {'nested': 'value'},
          'mixed': [
            {'key': 'value'},
            42,
            true
          ],
        };
        final result = duitJsonEncode(nested);

        expect(result,
            '{"list":[1,2,3],"map":{"nested":"value"},"mixed":[{"key":"value"},42,true]}');
      });
    });

    group('Fallback encoding', () {
      test('should encode unknown objects using toString', () {
        final unknownObject = Object();
        final result = duitJsonEncode(unknownObject);

        expect(result, '"${unknownObject.toString()}"');
      });

      test('should encode custom classes using toString', () {
        final custom = _TestCustomClass('test');
        final result = duitJsonEncode(custom);

        expect(result, '"CustomClass(test)"');
      });
    });
  });
}

class _TestCustomClass {
  final String name;
  _TestCustomClass(this.name);

  @override
  String toString() => 'CustomClass($name)';
}
