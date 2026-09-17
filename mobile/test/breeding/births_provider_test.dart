import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/rabbits/data/models/birth_model.dart';
import 'package:mobile/features/rabbits/data/repositories/births_repository.dart';
import 'package:mobile/features/rabbits/presentation/providers/births_provider.dart';
import 'package:mobile/shared/models/api_response.dart';

class _FakeBirthsRepository extends BirthsRepository {
  _FakeBirthsRepository()
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  var calls = 0;

  @override
  Future<PaginatedResponse<BirthModel>> getBirths({
    int page = 1,
    int limit = 30,
  }) async {
    calls++;
    const items = [
      BirthModel(
        id: 1,
        motherId: 7,
        birthDate: '2026-09-14',
        kitsBornAlive: 8,
        kitsBornDead: 1,
      ),
    ];

    return PaginatedResponse<BirthModel>(
      items: items,
      total: items.length,
      page: page,
      limit: limit,
      totalPages: 1,
    );
  }
}

/// Ферма с историей на несколько страниц.
///
/// Раньше список обрывался на пятидесятой записи и выглядел полным: у
/// хозяйства, которое ведёт окролы третий год, старые выводки просто
/// переставали показываться, а посчитанный по ним итог был неверным.
class _PagedBirthsRepository extends BirthsRepository {
  _PagedBirthsRepository()
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  final List<int> requestedPages = [];

  @override
  Future<PaginatedResponse<BirthModel>> getBirths({
    int page = 1,
    int limit = 30,
  }) async {
    requestedPages.add(page);

    return PaginatedResponse<BirthModel>(
      items: [
        BirthModel(
          id: page * 10,
          motherId: 7,
          birthDate: '2026-09-14',
          kitsBornAlive: 8,
          kitsBornDead: 1,
        ),
      ],
      total: 3,
      page: page,
      limit: limit,
      // Три страницы: после первой есть ещё, после третьей — нет.
      totalPages: 3,
    );
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

  test('список догружается страницами, а не обрывается молча', () async {
    final repository = _PagedBirthsRepository();
    final container = ProviderContainer(
      overrides: [birthsRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    container.listen(birthsProvider, (_, __) {});
    await Future<void>.delayed(Duration.zero);

    // Первая страница пришла, и приложение знает, что есть ещё.
    expect(container.read(birthsProvider).births, hasLength(1));
    expect(container.read(birthsProvider).hasMore, isTrue);

    await container.read(birthsProvider.notifier).loadMore();
    expect(container.read(birthsProvider).births, hasLength(2));
    expect(container.read(birthsProvider).hasMore, isTrue);

    await container.read(birthsProvider.notifier).loadMore();
    expect(container.read(birthsProvider).births, hasLength(3));
    // Дошли до конца — дальше звать нечего.
    expect(container.read(birthsProvider).hasMore, isFalse);

    expect(repository.requestedPages, [1, 2, 3]);
  });

  test('на последней странице догрузка ничего не запрашивает', () async {
    final repository = _FakeBirthsRepository();
    final container = ProviderContainer(
      overrides: [birthsRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    container.listen(birthsProvider, (_, __) {});
    await Future<void>.delayed(Duration.zero);

    final callsBefore = repository.calls;
    await container.read(birthsProvider.notifier).loadMore();

    expect(repository.calls, callsBefore);
  });
}
