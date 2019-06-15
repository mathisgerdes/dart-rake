import 'package:rake/src/rake_base.dart';
import 'package:rake/src/parse_num.dart';
import 'package:test/test.dart';

void main() {
  group('Test isNum', () {
    test('Simple', () {
      expect(isNum('10322.320'), true);
    });
    test('Simple German 1', () {
      expect(isNum('10322,30'), true);
    });
    test('Simple German 2', () {
      expect(isNum('10322,230'), true);
    });
    test('German style', () {
      expect(isNum('10.000.322,32'), true);
    });
    test('International style', () {
      expect(isNum('10,000,322.32'), true);
    });
    test('Mix 1', () {
      expect(isNum('10.000.322.32'), false);
    });
    test('Mix 2', () {
      expect(isNum('10,000,322,32'), false);
    });
  });

  group('Test tryParseNum', () {
    test('Simple', () {
      expect(isNum('10322.320'), true);
    });
    test('Simple German 1', () {
      expect(isNum('10322,30'), true);
    });
    test('Simple German 2', () {
      expect(isNum('10322,230'), true);
    });
    test('German style', () {
      expect(isNum('10.000.322,32'), true);
    });
    test('International style', () {
      expect(isNum('10,000,322.32'), true);
    });
  });

  group('RAKE', () {
    test('Init RAKE', () {
      expect(Rake().runtimeType, Rake);
    });
    test('Run RAKE', () {
      final rake = Rake();
      expect(rake.rank('this large world'), ['large world']);
      expect(rake.run('this large world is blue').length, 2);
      expect(rake.rank('this world', minChars: 10), []);
      expect(rake.rank('the world is big so big', minFrequency: 2), ['big']);
    });
  });
}
