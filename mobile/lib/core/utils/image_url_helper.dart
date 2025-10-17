import '../api/api_endpoints.dart';

/// Helper class to convert relative image paths to full URLs
class ImageUrlHelper {
  /// Convert relative photo URL to full URL
  ///
  /// If [photoUrl] is null, returns null
  /// If [photoUrl] is already a full URL (starts with http), returns as is
  /// Otherwise, prepends the base URL without /api/v1 suffix
  static String? getFullImageUrl(String? photoUrl) {
    if (photoUrl == null || photoUrl.isEmpty) {
      return null;
    }

    // If already a full URL, return as is
    if (photoUrl.startsWith('http://') || photoUrl.startsWith('https://')) {
      return photoUrl;
    }

    // Remove /api/v1 from baseUrl for static files
    final baseUrl = ApiEndpoints.baseUrl.replaceAll('/api/v1', '');

    // Ensure photoUrl starts with /
    final path = photoUrl.startsWith('/') ? photoUrl : '/$photoUrl';

    return '$baseUrl$path';
  }
}
