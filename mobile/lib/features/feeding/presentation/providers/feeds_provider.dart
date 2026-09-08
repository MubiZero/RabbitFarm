import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/api/load_all_pages.dart';
import '../../../../core/providers/session.dart';
import '../../../../core/providers/api_providers.dart';
import '../../data/models/feed_model.dart';
import '../../data/repositories/feeds_repository.dart';

/// Provider for FeedsRepository
final feedsRepositoryProvider = Provider<FeedsRepository>((ref) {
  ref.watch(sessionRevisionProvider);
  final apiClient = ref.watch(apiClientProvider);
  return FeedsRepository(apiClient);
});

/// State class for feeds list
class FeedsState {
  final List<Feed> feeds;
  final bool isLoading;
  final Object? error;
  final bool hasMore;
  final int currentPage;

  /// Выбранный тип корма и режим «только на исходе».
  ///
  /// Фильтры живут в состоянии, а не в экране: раньше обновление жестом и
  /// подгрузка следующей страницы вызывали загрузку без них, и список
  /// незаметно смешивался с кормами других типов.
  final FeedType? type;
  final bool lowStockOnly;

  const FeedsState({
    this.feeds = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
    this.type,
    this.lowStockOnly = false,
  });

  bool get hasFilters => type != null || lowStockOnly;

  FeedsState copyWith({
    List<Feed>? feeds,
    bool? isLoading,
    Object? error,
    bool? hasMore,
    int? currentPage,
    FeedType? type,
    bool clearType = false,
    bool? lowStockOnly,
  }) {
    // clearError передаёт сюда null, а «?? this.error» его игнорировал —
    // сообщение об ошибке залипало в состоянии до перезапуска приложения,
    // переживая любые успешные загрузки. В остальных фичах принято
    // присваивать error напрямую; приводим к тому же виду.
    return FeedsState(
      feeds: feeds ?? this.feeds,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      type: clearType ? null : (type ?? this.type),
      lowStockOnly: lowStockOnly ?? this.lowStockOnly,
    );
  }
}

/// Notifier for managing feeds list state
class FeedsNotifier extends StateNotifier<FeedsState> {
  final FeedsRepository _repository;

  FeedsNotifier(this._repository) : super(const FeedsState());

  /// Load feeds with optional filters
  Future<void> loadFeeds({
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    bool refresh = false,
  }) async {
    if (state.isLoading) return;

    if (refresh) {
      state = FeedsState(
        isLoading: true,
        type: state.type,
        lowStockOnly: state.lowStockOnly,
      );
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final feeds = await _repository.getFeeds(
        page: page ?? state.currentPage,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
        type: state.type?.name,
        lowStock: state.lowStockOnly ? true : null,
      );

      if (refresh) {
        state = FeedsState(
          feeds: feeds,
          isLoading: false,
          hasMore: feeds.length >= (limit ?? 10),
          currentPage: page ?? 1,
          type: state.type,
          lowStockOnly: state.lowStockOnly,
        );
      } else {
        state = state.copyWith(
          feeds: [...state.feeds, ...feeds],
          isLoading: false,
          hasMore: feeds.length >= (limit ?? 10),
          currentPage: (page ?? state.currentPage) + 1,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh feeds list
  Future<void> refresh() async {
    await loadFeeds(refresh: true);
  }

  /// Load more feeds (pagination)
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    await loadFeeds(page: state.currentPage);
  }

  /// Add new feed to the list
  void addFeed(Feed feed) {
    state = state.copyWith(
      feeds: [feed, ...state.feeds],
    );
  }

  /// Update feed in the list
  void updateFeed(Feed feed) {
    final updatedFeeds = state.feeds.map((f) {
      return f.id == feed.id ? feed : f;
    }).toList();

    state = state.copyWith(feeds: updatedFeeds);
  }

  /// Remove feed from the list
  void removeFeed(int feedId) {
    final updatedFeeds = state.feeds.where((f) => f.id != feedId).toList();
    state = state.copyWith(feeds: updatedFeeds);
  }

  /// Задать фильтры и перезагрузить список.
  Future<void> setFilters({FeedType? type, bool? lowStockOnly}) async {
    state = state.copyWith(
      type: type,
      clearType: type == null,
      lowStockOnly: lowStockOnly ?? state.lowStockOnly,
    );
    await loadFeeds(refresh: true);
  }

  Future<void> clearFilters() async {
    state = state.copyWith(clearType: true, lowStockOnly: false);
    await loadFeeds(refresh: true);
  }

  /// Изменить остаток на складе.
  ///
  /// Возвращает текст ошибки или `null` при успехе. Раньше экран запускал
  /// запрос через `ref.read` одноразового провайдера и сразу сообщал об
  /// успехе, не дожидаясь ответа: сообщение появлялось даже когда сервер
  /// отказывал, а число на складе не менялось.
  Future<Object?> adjustStock(int feedId, StockAdjustment adjustment) async {
    try {
      final feed = await _repository.adjustStock(feedId, adjustment);
      updateFeed(feed);
      return null;
    } catch (e) {
      return e;
    }
  }

  /// Удалить корм со склада.
  Future<Object?> deleteFeed(int feedId) async {
    try {
      await _repository.deleteFeed(feedId);
      removeFeed(feedId);
      return null;
    } catch (e) {
      return e;
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for feeds list state
final feedsProvider = StateNotifierProvider<FeedsNotifier, FeedsState>((ref) {
  final repository = ref.watch(feedsRepositoryProvider);
  return FeedsNotifier(repository);
});

/// Provider for single feed by ID
final feedByIdProvider =
    FutureProvider.autoDispose.family<Feed, int>((ref, id) async {
  final repository = ref.watch(feedsRepositoryProvider);
  return repository.getFeedById(id);
});

/// Provider for creating a feed
final createFeedProvider =
    FutureProvider.autoDispose.family<Feed, FeedCreate>((ref, feedCreate) async {
  final repository = ref.watch(feedsRepositoryProvider);
  final feed = await repository.createFeed(feedCreate);

  return feed;
});

/// Provider for updating a feed
final updateFeedProvider = FutureProvider.autoDispose
    .family<Feed, ({int id, FeedUpdate update})>((ref, params) async {
  final repository = ref.watch(feedsRepositoryProvider);
  final feed = await repository.updateFeed(params.id, params.update);

  return feed;
});

/// Provider for deleting a feed
final deleteFeedProvider =
    FutureProvider.autoDispose.family<void, int>((ref, id) async {
  final repository = ref.watch(feedsRepositoryProvider);
  await repository.deleteFeed(id);
});

/// Provider for feed statistics
final feedStatisticsProvider = FutureProvider.autoDispose<FeedStatistics>((ref) async {
  final repository = ref.watch(feedsRepositoryProvider);
  return repository.getStatistics();
});

/// Provider for low stock feeds
final lowStockFeedsProvider = FutureProvider.autoDispose<List<Feed>>((ref) async {
  final repository = ref.watch(feedsRepositoryProvider);
  return repository.getLowStockFeeds();
});

/// Provider for adjusting feed stock
final adjustFeedStockProvider = FutureProvider.autoDispose
    .family<Feed, ({int id, StockAdjustment adjustment})>((ref, params) async {
  final repository = ref.watch(feedsRepositoryProvider);
  final feed = await repository.adjustStock(params.id, params.adjustment);

  // Update in feeds list
  ref.read(feedsProvider.notifier).updateFeed(feed);

  return feed;
});

/// Provider for filtering feeds by type
final feedsByTypeProvider = Provider.autoDispose.family<List<Feed>, FeedType?>((ref, type) {
  final feedsState = ref.watch(feedsProvider);

  if (type == null) {
    return feedsState.feeds;
  }

  return feedsState.feeds.where((feed) => feed.type == type).toList();
});

/// Provider for checking if feed has low stock
final feedHasLowStockProvider = Provider.autoDispose.family<bool, Feed>((ref, feed) {
  return feed.currentStock <= feed.minStock;
});

/// Полный список кормов для выпадающих полей в формах.
///
/// Обычный список склада постраничный, и форма кормления показывала только
/// первую страницу: корм, заведённый одиннадцатым, выбрать было нельзя.
/// Видов корма на ферме десятки, а не тысячи, поэтому страницы
/// перебираются до конца — но именно страницами: сервер ограничивает
/// размер страницы, и просьба «дай сразу всё» возвращала 422.
final feedOptionsProvider = FutureProvider<List<Feed>>((ref) async {
  final repository = ref.watch(feedsRepositoryProvider);
  return loadAllPages<Feed>(
    ({required page, required limit}) =>
        repository.getFeeds(page: page, limit: limit),
  );
});
