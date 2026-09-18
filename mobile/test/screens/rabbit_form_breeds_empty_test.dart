import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/cages/data/models/cage_model.dart';
import 'package:mobile/features/cages/presentation/providers/cages_provider.dart';
import 'package:mobile/features/rabbits/data/models/breed_model.dart';
import 'package:mobile/features/rabbits/data/repositories/breeds_repository.dart';
import 'package:mobile/features/rabbits/presentation/screens/rabbit_form_screen.dart';

import '../support/test_app.dart';

/// Новая ферма получает справочник пород вместе с регистрацией, но у ферм,
/// заведённых раньше, он остался пустым. И тогда карточка кролика была
/// тупиком: поле «Порода» обязательное, выпадающий список по нажатию не
/// открывался, а сохранение отвечало «Выберите породу». Выбрать было не из
/// чего, завести породу из формы нельзя, а без кролика нет ни случки, ни
/// кормления, ни продажи.
class _EmptyBreedsRepository extends BreedsRepository {
  _EmptyBreedsRepository()
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  @override
  Future<List<BreedModel>> getBreeds() async => const [];
}

class _OneBreedRepository extends BreedsRepository {
  _OneBreedRepository()
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  @override
  Future<List<BreedModel>> getBreeds() async => const [
        BreedModel(id: 1, name: 'Калифорнийская'),
      ];
}

Future<void> _tall(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 2400));
  addTearDown(() => tester.binding.setSurfaceSize(null));
}

void main() {
  testWidgets('пустой справочник пород объясняет себя и даёт выход',
      (tester) async {
    await tester.pumpWidget(testAppScreen(
      const RabbitFormScreen(),
      overrides: [
        breedsRepositoryProvider.overrideWithValue(_EmptyBreedsRepository()),
        cageOptionsProvider.overrideWith((ref) async => const <CageModel>[]),
      ],
    ));
    await _tall(tester);
    await tester.pumpAndSettle();

    expect(find.text('Пород пока нет'), findsOneWidget);
    expect(find.text('Завести породу'), findsOneWidget,
        reason: 'без выхода отсюда человек упирается в тупик на первом кролике');
  });

  testWidgets('когда породы есть, показывается обычный выбор', (tester) async {
    await tester.pumpWidget(testAppScreen(
      const RabbitFormScreen(),
      overrides: [
        breedsRepositoryProvider.overrideWithValue(_OneBreedRepository()),
        cageOptionsProvider.overrideWith((ref) async => const <CageModel>[]),
      ],
    ));
    await _tall(tester);
    await tester.pumpAndSettle();

    expect(find.text('Пород пока нет'), findsNothing);

    // Закрытое поле показывает только подпись, поэтому проверяем то же, что
    // делает человек: нажимает и ждёт, что список откроется.
    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();

    expect(find.text('Калифорнийская'), findsWidgets);
  });
}
