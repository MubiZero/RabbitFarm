import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/utils/phone_utils.dart';

/// Правило одно на клиент и сервер (`backend/src/utils/phone.js`): номер —
/// это логин, и разойтись они не должны.
void main() {
  group('normalizeTjPhone', () {
    test('дописывает код страны к девяти цифрам', () {
      expect(normalizeTjPhone('901234567'), '+992901234567');
      expect(normalizeTjPhone('90 123 45 67'), '+992901234567');
    });

    test('ставит плюс к номеру с кодом страны', () {
      expect(normalizeTjPhone('992901234567'), '+992901234567');
      expect(normalizeTjPhone('+992 90 123 45 67'), '+992901234567');
    });

    test('неразобранный номер возвращает как есть, а не чужой', () {
      expect(normalizeTjPhone('12345'), '12345');
      expect(normalizeTjPhone('+7 916 123 45 67'), '+7 916 123 45 67');
    });
  });

  group('isTjPhone', () {
    test('принимает только +992 и девять цифр', () {
      expect(isTjPhone('+992901234567'), isTrue);
      expect(isTjPhone('992901234567'), isFalse);
      expect(isTjPhone('+99290123456'), isFalse);
      expect(isTjPhone('+9929012345678'), isFalse);
      expect(isTjPhone('+79161234567'), isFalse);
    });
  });

  group('formatTjPhone', () {
    test('разбивает номер по группам для показа', () {
      expect(formatTjPhone('+992901234567'), '+992 90 123 45 67');
    });

    test('чужой формат не режет по своим правилам', () {
      expect(formatTjPhone('+79161234567'), '+79161234567');
    });
  });
}
