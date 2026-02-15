import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_coding_test/domain/watchlist/watchlist.dart';

void main() {
  group('AlertType enum', () {
    test('값이 정확히 3개여야 한다', () {
      expect(AlertType.values.length, 3);
    });

    test('upper, lower, both 값이 존재해야 한다', () {
      expect(AlertType.values, containsAll([
        AlertType.upper,
        AlertType.lower,
        AlertType.both,
      ]));
    });

    group('enum name 검증', () {
      test('upper의 name은 "upper"이어야 한다', () {
        expect(AlertType.upper.name, 'upper');
      });

      test('lower의 name은 "lower"이어야 한다', () {
        expect(AlertType.lower.name, 'lower');
      });

      test('both의 name은 "both"이어야 한다', () {
        expect(AlertType.both.name, 'both');
      });
    });

    group('enum index 검증', () {
      test('upper의 index는 0이어야 한다', () {
        expect(AlertType.upper.index, 0);
      });

      test('lower의 index는 1이어야 한다', () {
        expect(AlertType.lower.index, 1);
      });

      test('both의 index는 2이어야 한다', () {
        expect(AlertType.both.index, 2);
      });
    });
  });
}
