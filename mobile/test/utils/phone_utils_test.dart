import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/utils/phone_utils.dart';

void main() {
  group('normalizeTjPhone', () {
    test('9 цифр без кода страны получают +992', () {
      expect(normalizeTjPhone('901234567'), '+992901234567');
    });

    test('12 цифр, начинающихся с 992, получают плюс', () {
      expect(normalizeTjPhone('992901234567'), '+992901234567');
    });

    test('разделители (пробелы, скобки, дефисы) игнорируются', () {
      expect(normalizeTjPhone('+992 90 123 45 67'), '+992901234567');
      expect(normalizeTjPhone('(992) 90-123-45-67'), '+992901234567');
    });

    test('нераспознанный номер возвращается как есть', () {
      expect(normalizeTjPhone('12345'), '12345');
    });
  });

  group('isTjPhone', () {
    test('валидный номер проходит', () {
      expect(isTjPhone('+992901234567'), isTrue);
    });

    test('без плюса — нет', () {
      expect(isTjPhone('992901234567'), isFalse);
    });

    test('неверная длина — нет', () {
      expect(isTjPhone('+99290123456'), isFalse);
      expect(isTjPhone('+9929012345678'), isFalse);
    });
  });
}
