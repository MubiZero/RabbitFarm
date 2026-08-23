import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/widgets/app_form_scaffold.dart';

import '../support/test_app.dart';

/// Форма с одним полем, которая помечает себя изменённой при вводе — как это
/// делают настоящие экраны.
class _DirtyForm extends StatefulWidget {
  const _DirtyForm();

  @override
  State<_DirtyForm> createState() => _DirtyFormState();
}

class _DirtyFormState extends State<_DirtyForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  bool _touched = false;

  @override
  void initState() {
    super.initState();
    _name.addListener(() => _touched = true);
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormScaffold(
      title: 'Проба',
      formKey: _formKey,
      submitLabel: 'Сохранить',
      successMessage: 'Готово',
      onSubmit: () async => null,
      isDirty: () => _touched,
      children: [TextFormField(controller: _name)],
    );
  }
}

/// Форма открывается поверх другого экрана — как в приложении, где к ней
/// приходят из списка. На корневом маршруте выходить некуда, и проверка
/// ничего бы не показала.
Future<void> _openForm(WidgetTester tester) async {
  await tester.pumpWidget(testAppScreen(
    Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const _DirtyForm()),
            ),
            child: const Text('Открыть'),
          ),
        ),
      ),
    ),
  ));
  await tester.tap(find.text('Открыть'));
  await tester.pumpAndSettle();
}

void main() {
  /// Признак «есть несохранённое» читался только при перерисовке, а набор
  /// текста её не вызывает: заполненная форма закрывалась молча, и введённое
  /// пропадало без единого вопроса.
  testWidgets('заполненная форма не закрывается молча', (tester) async {
    await _openForm(tester);

    await tester.enterText(find.byType(TextFormField), 'Калифорнийская');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('Выйти без сохранения?'), findsOneWidget);
    expect(find.text('Проба'), findsOneWidget, reason: 'форма осталась открытой');
  });

  testWidgets('пустая форма закрывается без лишних вопросов', (tester) async {
    await _openForm(tester);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('Выйти без сохранения?'), findsNothing);
    expect(find.text('Открыть'), findsOneWidget, reason: 'вернулись на экран до формы');
  });
}
