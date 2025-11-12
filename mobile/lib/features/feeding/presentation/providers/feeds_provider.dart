import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/providers/api_providers.dart';
import '../../data/models/feed_model.dart';
import '../../data/repositories/feeds_repository.dart';

/// Provider for FeedsRepository
final feedsRepositoryProvider = Provider<FeedsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FeedsRepository(apiClient);
});

/// State class for feeds list
class FeedsState {
  final List<Feed> feeds;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int currentPage;

  const FeedsState({
    this.feeds = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
  });

  FeedsState copyWith({
    List<Feed>? feeds,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? currentPage,
  }) {
    return FeedsState(
      feeds: feeds ?? this.feeds,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
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
    FeedType? type,
    bool? lowStockOnly,
    bool refresh = false,
  }) async {
    if (state.isLoading) return;

    if (refresh) {
      state = const FeedsState(isLoading: true);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final feeds = await _repository.getFeeds(
        page: page ?? state.currentPage,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
        type: type?.name,
        lowStock: lowStockOnly,
      );

      if (refresh) {
        state = FeedsState(
          feeds: feeds,
          isLoading: false,
          hasMore: feeds.length >= (limit ?? 10),
          currentPage: page ?? 1,
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

  // Add to feeds list
  ref.read(feedsProvider.notifier).addFeed(feed);

  return feed;
});

/// Provider for updating a feed
final updateFeedProvider = FutureProvider.autoDispose
    .family<Feed, ({int id, FeedUpdate update})>((ref, params) async {
  final repository = ref.watch(feedsRepositoryProvider);
  final feed = await repository.updateFeed(params.id, params.update);

  // Update in feeds list
  ref.read(feedsProvider.notifier).updateFeed(feed);

  return feed;
});

/// Provider for deleting a feed
final deleteFeedProvider =
    FutureProvider.autoDispose.family<void, int>((ref, id) async {
  final repository = ref.watch(feedsRepositoryProvider);
  await repository.deleteFeed(id);

  // Remove from feeds list
  ref.read(feedsProvider.notifier).removeFeed(id);
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
