import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/birth_model.dart';
import '../../data/models/rabbit_model.dart';
import '../../data/repositories/births_repository.dart';

/// Состояние списка окролов
class BirthsState {
  final List<BirthModel> births;
  final bool isLoading;
  final Object? error;

  /// Какая страница загружена и есть ли следующая. Без этого список
  /// обрывался на пятидесятой записи и выглядел полным: у фермы, которая
  /// ведёт окролы третий год, старые выводки просто переставали
  /// показываться.
  final int currentPage;
  final bool hasMore;

  BirthsState({
    this.births = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = false,
  });

  BirthsState copyWith({
    List<BirthModel>? births,
    bool? isLoading,
    Object? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return BirthsState(
      births: births ?? this.births,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Notifier для управления окролами
class BirthsNotifier extends Notifier<BirthsState> {
  late final BirthsRepository _repository;

  @override
  BirthsState build() {
    _repository = ref.watch(birthsRepositoryProvider);
    // Через microtask, а не прямым вызовом: `loadBirths` первой же строкой
    // присваивает `state`, а во время build провайдер ещё не существует —
    // riverpod бросает «provider depending on itself», загрузка обрывается
    // на первой строке, и список окролов оставался пустым до тех пор, пока
    // что-нибудь не дёрнет обновление ещё раз.
    Future.microtask(loadBirths);
    return BirthsState(isLoading: true);
  }

  /// Размер страницы — как у остальных списков хозяйства.
  static const _pageSize = 30;

  /// Загрузить список окролов — первую страницу.
  Future<void> loadBirths() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final page = await _repository.getBirths(page: 1, limit: _pageSize);
      state = state.copyWith(
        births: page.items,
        isLoading: false,
        currentPage: page.page,
        hasMore: page.page < page.totalPages,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Догрузить следующую страницу.
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final page = await _repository.getBirths(
        page: state.currentPage + 1,
        limit: _pageSize,
      );
      state = state.copyWith(
        births: [...state.births, ...page.items],
        isLoading: false,
        currentPage: page.page,
        hasMore: page.page < page.totalPages,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Создать новый окрол
  Future<BirthModel?> createBirth(Map<String, dynamic> birthData) async {
    try {
      final newBirth = await _repository.createBirth(birthData);
      state = state.copyWith(
        births: [...state.births, newBirth],
      );
      return newBirth;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// Обновить окрол
  Future<bool> updateBirth(int id, Map<String, dynamic> birthData) async {
    try {
      final updatedBirth = await _repository.updateBirth(id, birthData);
      final updatedBirths = state.births.map((birth) {
        return birth.id == id ? updatedBirth : birth;
      }).toList();

      state = state.copyWith(births: updatedBirths);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Убрать окрол из списка, не трогая сервер.
  ///
  /// Удаление идёт с окном на отмену: строка должна исчезнуть сразу, а запрос
  /// уходит только когда окно закрылось. Вернуть строку на место —
  /// `loadBirths()`.
  void removeBirth(int id) {
    state = state.copyWith(
      births: state.births.where((birth) => birth.id != id).toList(),
    );
  }

  /// Удалить окрол
  Future<bool> deleteBirth(int id) async {
    try {
      await _repository.deleteBirth(id);
      final updatedBirths =
          state.births.where((birth) => birth.id != id).toList();

      state = state.copyWith(births: updatedBirths);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Создать крольчат из окрола
  Future<List<RabbitModel>?> createKitsFromBirth({
    required int birthId,
    required int motherId,
    required int? fatherId,
    int? breedId,
    required String birthDate,
    required int count,
    String? namePrefix,
  }) async {
    try {
      final kits = await _repository.createKitsFromBirth(
        birthId: birthId,
        motherId: motherId,
        fatherId: fatherId,
        breedId: breedId,
        birthDate: birthDate,
        count: count,
        namePrefix: namePrefix,
      );
      return kits;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// Очистить ошибку
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider для окролов
final birthsProvider =
    NotifierProvider<BirthsNotifier, BirthsState>(BirthsNotifier.new);

/// Provider для окролов конкретной самки
final birthsByMotherProvider =
    FutureProvider.family<List<BirthModel>, int>((ref, motherId) async {
  final repository = ref.watch(birthsRepositoryProvider);
  return repository.getBirthsByMother(motherId);
});
