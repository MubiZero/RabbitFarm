import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/l10n/error_text.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/rabbit_photo_model.dart';
import '../providers/gallery_provider.dart';

/// Галерея снимков кролика — в отличие от одной фотографии на карточке,
/// снимков здесь может быть сколько угодно.
///
/// Принимает id и подпись отдельно, а не целую модель кролика: открыть эту
/// галерею можно и из записи Дневника, где полной модели нет — только
/// урезанная ссылка на кролика (id и то, чем его называют).
class PhotoGalleryScreen extends ConsumerWidget {
  final int rabbitId;
  final String rabbitLabel;

  const PhotoGalleryScreen({
    super.key,
    required this.rabbitId,
    required this.rabbitLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosAsync = ref.watch(galleryProvider(rabbitId));
    final canManage = ref.watch(canProvider(FarmCapability.manageLivestock));

    Future<void> refresh() async {
      ref.invalidate(galleryProvider(rabbitId));
      await ref.read(galleryProvider(rabbitId).future);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.galleryTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.screenH,
              bottom: AppSpacing.sm,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                rabbitLabel,
                style: AppTypography.bodyMd
                    .copyWith(color: context.colors.onSurfaceVariant),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: AppAsyncView<List<RabbitPhoto>>(
          value: photosAsync,
          onRetry: refresh,
          skeleton: (_) => _gallerySkeleton(),
          builder: (photos) => photos.isEmpty
              ? AppEmptyState(
                  icon: Icons.photo_library_outlined,
                  title: context.l10n.galleryEmptyTitle,
                  subtitle: context.l10n.galleryEmptyBody,
                  actionLabel: canManage ? context.l10n.galleryAdd : null,
                  onAction:
                      canManage ? () => _addPhoto(context, ref) : null,
                )
              : _grid(context, ref, photos, canManage),
        ),
      ),
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              onPressed: () => _addPhoto(context, ref),
              icon: const Icon(Icons.add_a_photo_outlined),
              label: Text(context.l10n.galleryAdd),
            )
          : null,
    );
  }

  Widget _gallerySkeleton() => GridView.builder(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH,
          AppSpacing.lg,
          AppSpacing.screenH,
          AppSpacing.fabSafeBottom,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 1,
        ),
        itemCount: 4,
        itemBuilder: (_, __) =>
            SkeletonBox(height: double.infinity, borderRadius: AppRadius.mdAll),
      );

  Widget _grid(
    BuildContext context,
    WidgetRef ref,
    List<RabbitPhoto> photos,
    bool canManage,
  ) {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.lg,
        AppSpacing.screenH,
        AppSpacing.fabSafeBottom,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) => _PhotoTile(
        photo: photos[index],
        canManage: canManage,
        onTap: () => _showPhotoDialog(context, photos[index]),
        onDelete: () => _delete(context, ref, photos[index]),
      ),
    );
  }

  void _showPhotoDialog(BuildContext context, RabbitPhoto photo) {
    final url = ImageUrlHelper.getFullImageUrl(photo.url);
    if (url == null) return;

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4,
                child: CachedNetworkImage(
                  imageUrl: url,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
              ),
            ),
            if (photo.caption?.trim().isNotEmpty == true)
              Positioned(
                left: 16,
                right: 56,
                bottom: 16,
                child: Text(
                  photo.caption!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                tooltip: dialogContext.l10n.commonClose,
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(dialogContext).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addPhoto(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(context.l10n.rabbitFormPhotoGallery),
              onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(context.l10n.rabbitFormPhotoCamera),
              onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null || !context.mounted) return;

    XFile? image;
    try {
      image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
    } catch (_) {
      image = null;
    }
    if (image == null || !context.mounted) return;

    final caption = await _captionDialog(context);
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final uploaded = l10n.galleryUploaded;

    Uint8List? bytes;
    if (kIsWeb) bytes = await image.readAsBytes();

    await ref.read(galleryNotifierProvider.notifier).upload(
          rabbitId,
          image.path,
          bytes: bytes,
          caption: caption,
        );

    final state = ref.read(galleryNotifierProvider);
    if (state.hasError) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(errorText(l10n, state.error!)),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text(uploaded)));
  }

  Future<String?> _captionDialog(BuildContext context) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.galleryCaptionTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: context.l10n.galleryCaptionLabel,
            prefixIcon: const Icon(Icons.short_text),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, ''),
            child: Text(context.l10n.galleryCaptionSkip),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim()),
            child: Text(context.l10n.commonSave),
          ),
        ],
      ),
    );
    return (result == null || result.isEmpty) ? null : result;
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    RabbitPhoto photo,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.galleryDeleteTitle),
        content: Text(context.l10n.galleryDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final deleted = l10n.galleryDeleted;

    await ref.read(galleryNotifierProvider.notifier).delete(rabbitId, photo.id);

    final state = ref.read(galleryNotifierProvider);
    if (state.hasError) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(errorText(l10n, state.error!)),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text(deleted)));
  }
}

class _PhotoTile extends StatelessWidget {
  final RabbitPhoto photo;
  final bool canManage;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _PhotoTile({
    required this.photo,
    required this.canManage,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final url = ImageUrlHelper.getFullImageUrl(photo.url);
    final cs = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: AppRadius.mdAll,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (url != null)
              CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: cs.surfaceContainerHighest,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: cs.surfaceContainerHighest,
                  child: Icon(Icons.broken_image, color: cs.onSurfaceVariant),
                ),
              ),
            if (photo.takenAt != null)
              Positioned(
                left: 6,
                bottom: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: AppRadius.smAll,
                  ),
                  child: Text(
                    DateFormat('d MMM', 'ru').format(photo.takenAt!),
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
            if (canManage)
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  tooltip: context.l10n.commonDelete,
                  icon: const Icon(Icons.delete_outline,
                      color: Colors.white, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.45),
                    minimumSize: const Size(32, 32),
                  ),
                  onPressed: onDelete,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
