import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/birth_model.dart';
import '../../data/models/rabbit_model.dart';
import '../../data/repositories/births_repository.dart';

/// Состояние списка окролов
class BirthsState {
  final List<BirthModel> births;
  final bool isLoading;
  final String? error;

  BirthsState({
    this.births = const [],
    this.isLoading = false,
    this.error,
  });

  BirthsState copyWith({
    List<BirthModel>? births,
    bool? isLoading,
    String? error,
  }) {
    return BirthsState(
      births: births ?? this.births,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier для управления окролами
class BirthsNotifier extends StateNotifier<BirthsState> {
  final BirthsRepository _repository;

  BirthsNotifier(this._repository) : super(BirthsState()) {
    loadBirths();
  }

  /// Загрузить список окролов
  Future<void> loadBirths() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final births = await _repository.getBirths();
      state = state.copyWith(
        births: births,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
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

  /// Удалить окрол
  Future<bool> deleteBirth(int id) async {
    try {
      await _repository.deleteBirth(id);
      final updatedBirths = state.births.where((birth) => birth.id != id).toList();

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
    required int breedId,
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

/// Provider для StateNotifier окролов
final birthsProvider = StateNotifierProvider<BirthsNotifier, BirthsState>((ref) {
  final repository = ref.watch(birthsRepositoryProvider);
  return BirthsNotifier(repository);
});

/// Provider для окролов конкретной самки
final birthsByMotherProvider = FutureProvider.family<List<BirthModel>, int>((ref, motherId) async {
  final repository = ref.watch(birthsRepositoryProvider);
  return repository.getBirthsByMother(motherId);
});
