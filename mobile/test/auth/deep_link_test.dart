import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/router/deep_links.dart';

/// Ссылку выдаёт сервер вместе с приглашением (`staffController`): сейчас
/// это `https://<домен>/i`, а `rabbitfarm://join?phone=…` остаётся у тех,
/// кого звали раньше.
void main() {
  group('isInviteLink', () {
    test('узнаёт ссылку-приглашение своего домена', () {
      expect(isInviteLink(Uri.parse('https://rabbitfarm.mubi.dev/i')), isTrue);
      expect(isInviteLink(Uri.parse('https://rabbitfarm.mubi.dev/i/')), isTrue);
    });

    test('чужой домен приглашением не считается', () {
      // Проверка домена здесь — не про безопасность (ссылку и так приводит
      // операционная система), а про то, чтобы случайная ссылка из
      // мессенджера не выбрасывала человека на экран входа.
      expect(isInviteLink(Uri.parse('https://example.com/i')), isFalse);
    });

    test('другие страницы того же домена — не приглашение', () {
      expect(isInviteLink(Uri.parse('https://rabbitfarm.mubi.dev/')), isFalse);
      expect(
        isInviteLink(Uri.parse('https://rabbitfarm.mubi.dev/privacy.html')),
        isFalse,
      );
    });

    test('http вместо https не принимается', () {
      expect(isInviteLink(Uri.parse('http://rabbitfarm.mubi.dev/i')), isFalse);
    });
  });
  group('phoneFromInviteLink', () {
    test('берёт номер из ссылки приглашения', () {
      expect(
        phoneFromInviteLink(
            Uri.parse('rabbitfarm://join?phone=%2B992901234567')),
        '+992901234567',
      );
    });

    test('номер без кода страны нормализуется', () {
      expect(
        phoneFromInviteLink(Uri.parse('rabbitfarm://join?phone=901234567')),
        '+992901234567',
      );
    });

    test('новая https-ссылка номера не несёт — и не должна', () {
      expect(
        phoneFromInviteLink(Uri.parse('https://rabbitfarm.mubi.dev/i')),
        isNull,
      );
    });

    test('чужая схема и чужой адрес игнорируются', () {
      expect(
        phoneFromInviteLink(
            Uri.parse('https://example.com/join?phone=901234567')),
        isNull,
      );
      expect(
        phoneFromInviteLink(Uri.parse('rabbitfarm://pay?phone=901234567')),
        isNull,
      );
    });

    test('мусорный или пустой номер не открывает вход', () {
      expect(phoneFromInviteLink(Uri.parse('rabbitfarm://join')), isNull);
      expect(
          phoneFromInviteLink(Uri.parse('rabbitfarm://join?phone=')), isNull);
      expect(
        phoneFromInviteLink(
            Uri.parse('rabbitfarm://join?phone=%2B79161234567')),
        isNull,
      );
    });
  });
}
