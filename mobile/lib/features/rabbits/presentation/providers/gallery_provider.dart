import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/rabbit_photo_model.dart';
import 'rabbits_provider.dart';

/// Галерея снимков одного кролика.
final galleryProvider =
    FutureProvider.family<List<RabbitPhoto>, int>((ref, rabbitId) async {
  final repository = ref.watch(rabbitsRepositoryProvider);
  return repository.getGalleryPhotos(rabbitId);
});

/// Загрузка и удаление снимков галереи.
final galleryNotifierProvider =
    StateNotifierProvider<GalleryNotifier, AsyncValue<void>>((ref) {
  return GalleryNotifier(ref);
});

class GalleryNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  GalleryNotifier(this._ref) : super(const AsyncData(null));

  Future<void> upload(
    int rabbitId,
    String filePath, {
    Uint8List? bytes,
    String? caption,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = _ref.read(rabbitsRepositoryProvider);
      await repository.uploadGalleryPhoto(
        rabbitId,
        filePath,
        bytes: bytes,
        caption: caption,
      );
      _ref.invalidate(galleryProvider(rabbitId));
    });
  }

  Future<void> delete(int rabbitId, int photoId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = _ref.read(rabbitsRepositoryProvider);
      await repository.deleteGalleryPhoto(rabbitId, photoId);
      _ref.invalidate(galleryProvider(rabbitId));
    });
  }
}
