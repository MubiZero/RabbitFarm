/// Недописанная запись, пережившая смерть приложения.
///
/// Форма спрашивала «выйти без сохранения?» только когда с неё уходят кнопкой
/// «назад». От того, что систему приложение не спрашивает вовсе — Android
/// выгружает его из памяти, пока человек отвечает на звонок, — защиты не было
/// никакой: набранная заметка о падеже просто исчезала. У телефона в кишлаке
/// память кончается постоянно, и это не редкий случай, а обычный день.
///
/// Сохраняется только набранный текст, не выбранное.
///
/// Так решено намеренно. Текст — это то, на что тратят минуты: симптомы,
/// заметка, описание операции. Выбор породы или клетки — одно касание, зато
/// сохранённый выбор легко оказывается неверным: клетку успели удалить, и
/// форма открылась бы со ссылкой в никуда. Правило «текст переживает, выбор —
/// нет» человеку объяснимо, а обратное поведение было бы непредсказуемым.
library;

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _boxName = 'form_drafts';

/// Черновик одной формы: чем она отличается от других и какие поля хранит.
@immutable
class FormDraft {
  const FormDraft({required this.key, required this.fields});

  /// Что именно заполняют: `rabbit-new`, `rabbit-42`, `note-7`. Черновик
  /// правки одной записи не должен всплыть в форме другой.
  final String key;

  /// Поля, которые стоит пережить. Имя — своё для формы, оно же ключ
  /// хранения: переименование поля просто теряет старый черновик, а не
  /// подставляет текст не туда.
  final Map<String, TextEditingController> fields;

  Map<String, String> snapshot() => {
        for (final entry in fields.entries)
          if (entry.value.text.trim().isNotEmpty) entry.key: entry.value.text,
      };

  /// Разложить сохранённое обратно по полям. Неизвестные имена пропускаются:
  /// форма могла измениться с прошлой версии приложения.
  void apply(Map<String, dynamic> data) {
    for (final entry in data.entries) {
      final controller = fields[entry.key];
      final value = entry.value;
      if (controller != null && value is String) controller.text = value;
    }
  }
}

/// Хранилище черновиков. Один ящик на всё приложение, ключ — владелец и форма.
class FormDraftStore {
  const FormDraftStore(this.scope);

  /// Чей это черновик. `null` — никто не вошёл: писать и читать нечего, как
  /// и в кэше списков.
  final String? scope;

  String _key(String draftKey) => '$scope/$draftKey';

  Future<Map<String, dynamic>?> read(String draftKey) async {
    if (scope == null) return null;
    try {
      final box = await _box();
      final raw = box.get(_key(draftKey));
      if (raw is! String) return null;
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (e) {
      debugPrint('FormDraft: черновик $draftKey не прочитан: $e');
      return null;
    }
  }

  Future<void> write(String draftKey, Map<String, String> data) async {
    if (scope == null) return;
    if (data.isEmpty) return forget(draftKey);
    try {
      final box = await _box();
      await box.put(_key(draftKey), jsonEncode(data));
    } catch (e) {
      // Черновик — подстраховка, а не обязательство: не записался, значит
      // форма ведёт себя как раньше.
      debugPrint('FormDraft: черновик $draftKey не сохранён: $e');
    }
  }

  Future<void> forget(String draftKey) async {
    if (scope == null) return;
    try {
      final box = await _box();
      await box.delete(_key(draftKey));
    } catch (_) {
      // Ящик не открылся — стирать нечего.
    }
  }

  Future<Box<dynamic>> _box() =>
      Hive.isBoxOpen(_boxName) ? Future.value(Hive.box(_boxName)) : Hive.openBox(_boxName);
}

/// Забыть все черновики — вместе с выходом из учётной записи.
///
/// На общем планшете фермы следующий работник не должен увидеть чужую
/// недописанную заметку.
Future<void> clearFormDrafts() async {
  try {
    await Hive.deleteBoxFromDisk(_boxName);
  } catch (e) {
    debugPrint('FormDraft: не удалось очистить черновики: $e');
  }
}
