import 'package:cashu_app/utils/result.dart';

/// Utility class for URL operations
class UrlUtils {
  /// Validates if a string is a valid URL
  ///
  /// Returns a [Result] with the validated URL string or an error
  static bool validateUrl(String url) {
    try {
      final uri = Uri.parse(url);

      // Check if the URL has a scheme and host
      if (uri.scheme.isEmpty || uri.host.isEmpty) {
        return false;
      }

      // Check if the scheme is http or https
      if (uri.scheme != 'http' && uri.scheme != 'https') {
        return false;
      }

      // Ensure the URL is properly formatted
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Extracts the host from a URL string
  ///
  /// Returns the host or an empty string if the URL is invalid
  static String extractHost(String url) {
    try {
      final uri = Uri.parse(url);

      if (uri.host.isEmpty) {
        return '';
      }

      return uri.host;
    } catch (e) {
      return '';
    }
  }
}
