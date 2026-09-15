import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/rabbits/data/models/birth_model.dart';
import 'package:mobile/features/rabbits/data/repositories/births_repository.dart';
import 'package:mobile/features/rabbits/presentation/providers/births_provider.dart';

class _FakeBirthsRepository extends BirthsRepository {
  _FakeBirthsRepository()
    : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  var calls = 0;

  @override
  Future<List<BirthModel>> getBirths() async {
    calls++;
    return const [
      BirthModel(
        id: 1,
        motherId: 7,
        birthDate: '2026-09-14',
        kitsBornAlive: 8,
        kitsBornDead: 1,
      ),
    ];
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('список окролов грузится с первого чтения провайдера', () async {
    final repository = _FakeBirthsRepository();
    final container = ProviderContainer(
      overrides: [birthsRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    // Раньше первое чтение обрывалось на «provider depending on itself»:
    // загрузка не начиналась вовсе, и экран окролов оставался пустым до
    // следующего ручного обновления.
    expect(container.read(birthsProvider).isLoading, isTrue);

    await Future<void>.delayed(Duration.zero);

    expect(repository.calls, 1);
    expect(container.read(birthsProvider).births, hasLength(1));
    expect(container.read(birthsProvider).isLoading, isFalse);
  });
}
