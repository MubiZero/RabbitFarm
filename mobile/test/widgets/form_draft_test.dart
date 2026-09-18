import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:mobile/core/cache/cache_scope.dart';
import 'package:mobile/core/forms/form_draft.dart';
import 'package:mobile/core/widgets/app_form_scaffold.dart';

import '../support/test_app.dart';

/// Форма спрашивала «выйти без сохранения?» только когда с неё уходят кнопкой
/// «назад». От того, что систему приложение не спрашивает вовсе — Android
/// выгружает его из памяти, пока человек отвечает на звонок, — защиты не было
/// никакой: набранная заметка просто исчезала.
void main() {
  late Directory storage;

  setUp(() {
    storage = Directory.systemTemp.createTempSync('form_drafts');
    Hive.init(storage.path);
  });

  tearDown(() async {
    await Hive.close();
    storage.deleteSync(recursive: true);
  });

  group('снимок полей', () {
    test('пустые поля в черновик не идут', () {
      final draft = FormDraft(key: 'note-new', fields: {
        'content': TextEditingController(text: 'Пала самка из третьей клетки'),
        'extra': TextEditingController(text: '   '),
      });

      expect(draft.snapshot(), {'content': 'Пала самка из третьей клетки'});
    });

    test('незнакомое поле из старой версии приложения пропускается', () {
      final controller = TextEditingController();
      final draft = FormDraft(key: 'note-new', fields: {'content': controller});

      draft.apply({'content': 'Вернулось', 'выпилено': 'Не должно упасть'});

      expect(controller.text, 'Вернулось');
    });
  });

  group('хранилище', () {
    test('черновик переживает перезапуск приложения', () async {
      await const FormDraftStore('u1').write('note-new', {'content': 'Текст'});

      // Другой экземпляр хранилища — то же, что и новый запуск приложения.
      expect(
        await const FormDraftStore('u1').read('note-new'),
        {'content': 'Текст'},
      );
    });

    test('чужой черновик на общем планшете не показывается', () async {
      await const FormDraftStore('u1').write('note-new', {'content': 'Моё'});

      expect(await const FormDraftStore('u2').read('note-new'), isNull);
    });

    test('без вошедшего не пишется и не читается', () async {
      await const FormDraftStore(null).write('note-new', {'content': 'Текст'});

      expect(await const FormDraftStore(null).read('note-new'), isNull);
    });

    test('пустой снимок стирает прежний черновик', () async {
      const store = FormDraftStore('u1');
      await store.write('note-new', {'content': 'Текст'});
      await store.write('note-new', {});

      expect(await store.read('note-new'), isNull);
    });
  });

  group('форма', () {
    // Черновик лежит на диске, а это настоящий ввод-вывод: в тесте виджетов
    // время поддельное, и без `runAsync` такая работа никогда не завершится.
    Widget form(TextEditingController controller) => testAppScreen(
          AppFormScaffold(
            title: 'Заметка',
            formKey: GlobalKey<FormState>(),
            submitLabel: 'Сохранить',
            successMessage: 'Сохранено',
            onSubmit: () async => null,
            draft: FormDraft(key: 'note-new', fields: {'content': controller}),
            children: [TextFormField(controller: controller)],
          ),
          overrides: [cacheScopeProvider.overrideWithValue('u1')],
        );

    /// Всё, что трогает диск, идёт через `runAsync`: в тесте виджетов время
    /// поддельное, и настоящий ввод-вывод в нём иначе не завершается.
    /// `pumpAndSettle` здесь тоже не годится — он крутит кадры в том же
    /// поддельном времени и ждёт вечно.
    Future<void> tick(WidgetTester tester) async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    }

    testWidgets('набранное сохраняется само, без кнопки', (tester) async {
      final controller = TextEditingController();
      await tester.runAsync(() async {
        await tester.pumpWidget(form(controller));
        await tick(tester);
        await tester.enterText(find.byType(TextFormField), 'Пала самка');
        await tick(tester);

        expect(
          await const FormDraftStore('u1').read('note-new'),
          {'content': 'Пала самка'},
        );
      });
    });

    testWidgets('после гибели приложения текст возвращается', (tester) async {
      final controller = TextEditingController();
      await tester.runAsync(() async {
        await const FormDraftStore('u1')
            .write('note-new', {'content': 'Пала самка'});

        await tester.pumpWidget(form(controller));
        await tick(tester);

        expect(controller.text, 'Пала самка');
        // Молча подставленный текст пугает: человек должен понять, откуда он.
        expect(
          find.text('Вернули то, что вы не успели сохранить'),
          findsOneWidget,
        );
      });
    });

    testWidgets('«Очистить» убирает и поле, и сам черновик', (tester) async {
      final controller = TextEditingController();
      await tester.runAsync(() async {
        await const FormDraftStore('u1')
            .write('note-new', {'content': 'Пала самка'});

        await tester.pumpWidget(form(controller));
        await tick(tester);

        await tester.tap(find.text('Очистить'));
        await tick(tester);

        expect(controller.text, '');
        expect(await const FormDraftStore('u1').read('note-new'), isNull);
      });
    });

    testWidgets('сохранённая запись черновика за собой не оставляет',
        (tester) async {
      final controller = TextEditingController();
      await tester.runAsync(() async {
        await tester.pumpWidget(form(controller));
        await tick(tester);
        await tester.enterText(find.byType(TextFormField), 'Пала самка');
        await tick(tester);

        await tester.tap(find.text('Сохранить'));
        await tick(tester);

        expect(await const FormDraftStore('u1').read('note-new'), isNull);
      });
    });
  });
}
