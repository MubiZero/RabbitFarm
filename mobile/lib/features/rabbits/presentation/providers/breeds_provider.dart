import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/breed_model.dart';
import '../../data/repositories/breeds_repository.dart';

/// Состояние списка пород
class BreedsState {
  final List<BreedModel> breeds;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  BreedsState({
    this.breeds = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  BreedsState copyWith({
    List<BreedModel>? breeds,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return BreedsState(
      breeds: breeds ?? this.breeds,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  /// Получить отфильтрованный список пород
  List<BreedModel> get filteredBreeds {
    if (searchQuery.isEmpty) {
      return breeds;
    }

    return breeds.where((breed) {
      final query = searchQuery.toLowerCase();
      return breed.name.toLowerCase().contains(query) ||
          (breed.description?.toLowerCase().contains(query) ?? false) ||
          (breed.purpose?.toLowerCase().contains(query) ?? false);
    }).toList();
  }
}

/// StateNotifier для управления породами
class BreedsNotifier extends StateNotifier<BreedsState> {
  final BreedsRepository _repository;

  BreedsNotifier(this._repository) : super(BreedsState()) {
    loadBreeds();
  }

  /// Загрузить список пород
  Future<void> loadBreeds() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final breeds = await _repository.getBreeds();
      state = state.copyWith(
        breeds: breeds,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Обновить поисковый запрос
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Создать новую породу
  Future<bool> createBreed(Map<String, dynamic> breedData) async {
    try {
      final newBreed = await _repository.createBreed(breedData);
      state = state.copyWith(
        breeds: [...state.breeds, newBreed],
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Обновить породу
  Future<bool> updateBreed(int id, Map<String, dynamic> breedData) async {
    try {
      final updatedBreed = await _repository.updateBreed(id, breedData);
      final updatedBreeds = state.breeds.map((breed) {
        return breed.id == id ? updatedBreed : breed;
      }).toList();

      state = state.copyWith(breeds: updatedBreeds);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Удалить породу
  Future<bool> deleteBreed(int id) async {
    try {
      await _repository.deleteBreed(id);
      final updatedBreeds = state.breeds.where((breed) => breed.id != id).toList();

      state = state.copyWith(breeds: updatedBreeds);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Очистить ошибку
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider для StateNotifier пород
final breedsProvider = StateNotifierProvider<BreedsNotifier, BreedsState>((ref) {
  final repository = ref.watch(breedsRepositoryProvider);
  return BreedsNotifier(repository);
});
