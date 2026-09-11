import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/router/deep_links.dart';

/// Ссылку выдаёт сервер вместе с приглашением по телефону
/// (`staffController.createInvitation` → `rabbitfarm://join?phone=…`).
void main() {
  group('phoneFromInviteLink', () {
    test('берёт номер из ссылки приглашения', () {
      expect(
        phoneFromInviteLink(Uri.parse('rabbitfarm://join?phone=%2B992901234567')),
        '+992901234567',
      );
    });

    test('номер без кода страны нормализуется', () {
      expect(
        phoneFromInviteLink(Uri.parse('rabbitfarm://join?phone=901234567')),
        '+992901234567',
      );
    });

    test('чужая схема и чужой адрес игнорируются', () {
      expect(
        phoneFromInviteLink(Uri.parse('https://example.com/join?phone=901234567')),
        isNull,
      );
      expect(
        phoneFromInviteLink(Uri.parse('rabbitfarm://pay?phone=901234567')),
        isNull,
      );
    });

    test('мусорный или пустой номер не открывает вход', () {
      expect(phoneFromInviteLink(Uri.parse('rabbitfarm://join')), isNull);
      expect(phoneFromInviteLink(Uri.parse('rabbitfarm://join?phone=')), isNull);
      expect(
        phoneFromInviteLink(Uri.parse('rabbitfarm://join?phone=%2B79161234567')),
        isNull,
      );
    });
  });
}
