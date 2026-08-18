import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/json/double_converter.dart';
import 'package:mobile/core/json/int_converter.dart';

void main() {
  group('nullableIntFromJson', () {
    test('пустое значение — это null, а не ошибка', () {
      expect(nullableIntFromJson(null), isNull);
      expect(nullableIntFromJson(''), isNull);
    });

    test('разбирает число и строку', () {
      expect(nullableIntFromJson(5), 5);
      expect(nullableIntFromJson('5'), 5);
      // MySQL отдаёт DECIMAL строкой, а COUNT() иногда числом с точкой.
      expect(nullableIntFromJson(5.0), 5);
    });
  });

  group('doubleFromJson', () {
    test('принимает число и строку из DECIMAL', () {
      expect(doubleFromJson(12.5), 12.5);
      expect(doubleFromJson(12), 12.0);
      expect(doubleFromJson('1234.50'), 1234.5);
    });

    test('ругается на то, что числом не является', () {
      expect(() => doubleFromJson(Object()), throwsArgumentError);
      expect(() => doubleFromJson('abc'), throwsA(isA<FormatException>()));
    });
  });

  group('DoubleConverter', () {
    test('оборачивает ту же функцию', () {
      const converter = DoubleConverter();
      expect(converter.fromJson('0.5'), 0.5);
      expect(converter.toJson(0.5), 0.5);
    });
  });
}
