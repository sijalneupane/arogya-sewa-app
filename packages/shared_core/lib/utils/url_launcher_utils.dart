import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:url_launcher/url_launcher.dart';

/// Utility class for launching URLs across the application
class UrlLauncher {
  UrlLauncher._();

  /// Launch a phone call with the given phone number
  static Future<bool> launchPhone(String phoneNumber) async {
    if (phoneNumber.isEmpty) return false;
    try {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(phoneUri)) {
        return await url_launcher.launchUrl(phoneUri);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Launch email client with the given email address
  static Future<bool> launchEmail(String email, {
    String? subject,
    String? body,
  }) async {
    if (email.isEmpty) return false;
    try {
      String emailUri = 'mailto:$email';
      final params = <String, String>{};

      if (subject != null && subject.isNotEmpty) {
        params['subject'] = subject;
      }
      if (body != null && body.isNotEmpty) {
        params['body'] = body;
      }

      if (params.isNotEmpty) {
        final queryString = params.entries
            .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
            .join('&');
        emailUri += '?$queryString';
      }

      final Uri uri = Uri.parse(emailUri);
      if (await canLaunchUrl(uri)) {
        return await url_launcher.launchUrl(uri);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Launch a website URL
  static Future<bool> launchWebsite(String url) async {
    if (url.isEmpty) return false;
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await url_launcher.launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Launch Google Maps with a query (address or place name)
  static Future<bool> launchMapsQuery(String query) async {
    if (query.isEmpty) return false;
    try {
      final Uri uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}',
      );
      if (await canLaunchUrl(uri)) {
        return await url_launcher.launchUrl(uri);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Launch Google Maps with latitude and longitude
  static Future<bool> launchMapsLocation(double latitude, double longitude, {
    String? label,
  }) async {
    try {
      String url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      if (label != null && label.isNotEmpty) {
        url += '&query_place_id=${Uri.encodeComponent(label)}';
      }
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await url_launcher.launchUrl(uri);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Launch Google Maps with address
  static Future<bool> launchMapsAddress(String address) async {
    if (address.isEmpty) return false;
    try {
      final Uri uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
      );
      if (await canLaunchUrl(uri)) {
        return await url_launcher.launchUrl(uri);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Launch WhatsApp with a phone number
  static Future<bool> launchWhatsApp(String phoneNumber, {
    String? message,
  }) async {
    if (phoneNumber.isEmpty) return false;
    try {
      // Remove any non-digit characters from phone number
      final cleanNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
      String url = 'https://wa.me/$cleanNumber';

      if (message != null && message.isNotEmpty) {
        url += '?text=${Uri.encodeComponent(message)}';
      }

      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await url_launcher.launchUrl(uri);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Launch SMS with phone number and optional message
  static Future<bool> launchSms(String phoneNumber, {
    String? message,
  }) async {
    if (phoneNumber.isEmpty) return false;
    try {
      String smsUri = 'sms:$phoneNumber';
      if (message != null && message.isNotEmpty) {
        // Different platforms use different separators for SMS body
        smsUri += '?body=${Uri.encodeComponent(message)}';
      }
      final Uri uri = Uri.parse(smsUri);
      if (await canLaunchUrl(uri)) {
        return await url_launcher.launchUrl(uri);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Launch YouTube video or channel
  static Future<bool> launchYouTube(String videoIdOrUrl) async {
    if (videoIdOrUrl.isEmpty) return false;
    try {
      String url = videoIdOrUrl;
      if (!videoIdOrUrl.startsWith('http')) {
        // Assume it's a video ID
        url = 'https://www.youtube.com/watch?v=$videoIdOrUrl';
      }
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await url_launcher.launchUrl(uri);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Launch social media profile
  static Future<bool> launchSocialMedia(String platform, String username) async {
    if (platform.isEmpty || username.isEmpty) return false;
    try {
      String url;
      switch (platform.toLowerCase()) {
        case 'facebook':
          url = 'https://www.facebook.com/$username';
          break;
        case 'twitter':
        case 'x':
          url = 'https://twitter.com/$username';
          break;
        case 'instagram':
          url = 'https://www.instagram.com/$username';
          break;
        case 'linkedin':
          url = 'https://www.linkedin.com/in/$username';
          break;
        case 'tiktok':
          url = 'https://www.tiktok.com/@$username';
          break;
        default:
          return false;
      }
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await url_launcher.launchUrl(uri);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Launch generic URL with validation
  static Future<bool> openUrl(String urlString, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    if (urlString.isEmpty) return false;
    try {
      // Ensure URL has a scheme
      String url = urlString;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://$url';
      }
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await url_launcher.launchUrl(uri, mode: mode);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Check if a URL can be launched
  static Future<bool> canLaunch(String urlString) async {
    if (urlString.isEmpty) return false;
    try {
      String url = urlString;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://$url';
      }
      final Uri uri = Uri.parse(url);
      return await canLaunchUrl(uri);
    } catch (e) {
      return false;
    }
  }

  /// Launch app store page for a specific app
  static Future<bool> launchAppStore(String appId, {
    required String platform,
  }) async {
    if (appId.isEmpty) return false;
    try {
      String url;
      switch (platform.toLowerCase()) {
        case 'ios':
        case 'apple':
        case 'app store':
          url = 'https://apps.apple.com/app/id$appId';
          break;
        case 'android':
        case 'google':
        case 'play store':
          url = 'https://play.google.com/store/apps/details?id=$appId';
          break;
        default:
          return false;
      }
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await url_launcher.launchUrl(uri);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Launch calendar event (platform dependent)
  static Future<bool> launchCalendarEvent({
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    String? location,
    String? description,
  }) async {
    try {
      // Format dates for calendar URL
      final startFormatted = startTime.toUtc().toString().replaceAll(RegExp(r'[-:]'), '').split('.').first + 'Z';
      final endFormatted = endTime.toUtc().toString().replaceAll(RegExp(r'[-:]'), '').split('.').first + 'Z';

      String url = 'https://calendar.google.com/calendar/render?action=TEMPLATE'
          '&text=${Uri.encodeComponent(title)}'
          '&dates=$startFormatted/$endFormatted';

      if (location != null && location.isNotEmpty) {
        url += '&location=${Uri.encodeComponent(location)}';
      }
      if (description != null && description.isNotEmpty) {
        url += '&details=${Uri.encodeComponent(description)}';
      }

      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await url_launcher.launchUrl(uri);
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
