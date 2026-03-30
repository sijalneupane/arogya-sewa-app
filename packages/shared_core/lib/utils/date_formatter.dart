import 'package:intl/intl.dart';
import 'package:nepali_date_converter/nepali_date_converter.dart';

/// Utility class for formatting dates across the application
/// 
/// Supports both AD (Gregorian) and BS (Bikram Sambat - Nepali) date formats
class DateFormatter {
  DateFormatter._();

  static NepaliDateConverter? _nepaliDateConverter;

  /// Initialize the Nepali date converter (must be called before using BS date methods)
  static Future<void> initialize() async {
    _nepaliDateConverter = await NepaliDateConverter.load();
  }

  /// Check if the converter is initialized
  static bool get isInitialized => _nepaliDateConverter != null;

  /// Get the converter instance, initializing if necessary
  static Future<NepaliDateConverter> _getConverter() async {
    if (_nepaliDateConverter == null) {
      await initialize();
    }
    return _nepaliDateConverter!;
  }

  // ==================== AD DATE FORMATTING ====================

  /// Format date to "MMM dd, yyyy" (e.g., "Jan 15, 2024")
  static String formatDateStandard(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  /// Format date to "dd MMMM yyyy" (e.g., "15 January 2024")
  static String formatDateLong(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  /// Format date to "MMM dd, yyyy - hh:mm a" (e.g., "Jan 15, 2024 - 02:30 PM")
  static String formatDateWithTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  /// Format date to "EEEE, MMMM dd, yyyy" (e.g., "Monday, January 15, 2024")
  static String formatDateFull(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('EEEE, MMMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  /// Format date to "dd/MM/yyyy" (e.g., "15/01/2024")
  static String formatDateShort(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  /// Format date to "MMMM yyyy" (e.g., "January 2024")
  static String formatDateMonthYear(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  /// Format date to "hh:mm a" (e.g., "02:30 PM")
  static String formatTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  /// Format date to relative time (e.g., "2 hours ago", "Yesterday")
  static String formatRelativeTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          if (difference.inMinutes == 0) {
            return 'Just now';
          }
          return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
        }
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return '$weeks week${weeks > 1 ? 's' : ''} ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return '$months month${months > 1 ? 's' : ''} ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return '$years year${years > 1 ? 's' : ''} ago';
      }
    } catch (e) {
      return dateString;
    }
  }

  /// Check if date is today
  static bool isToday(String? dateString) {
    if (dateString == null || dateString.isEmpty) return false;
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    } catch (e) {
      return false;
    }
  }

  /// Check if date is in the past
  static bool isPast(String? dateString) {
    if (dateString == null || dateString.isEmpty) return false;
    try {
      final date = DateTime.parse(dateString);
      return date.isBefore(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  /// Check if date is in the future
  static bool isFuture(String? dateString) {
    if (dateString == null || dateString.isEmpty) return false;
    try {
      final date = DateTime.parse(dateString);
      return date.isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  /// Get day name from date (e.g., "Monday")
  static String getDayName(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('EEEE').format(date);
    } catch (e) {
      return '';
    }
  }

  /// Get short day name from date (e.g., "Mon")
  static String getShortDayName(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('EEE').format(date);
    } catch (e) {
      return '';
    }
  }

  /// Get month name from date (e.g., "January")
  static String getMonthName(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMMM').format(date);
    } catch (e) {
      return '';
    }
  }

  /// Get year from date
  static int getYear(String? dateString) {
    if (dateString == null || dateString.isEmpty) return DateTime.now().year;
    try {
      final date = DateTime.parse(dateString);
      return date.year;
    } catch (e) {
      return DateTime.now().year;
    }
  }

  /// Calculate age from birth date
  static int calculateAge(String? birthDateString) {
    if (birthDateString == null || birthDateString.isEmpty) return 0;
    try {
      final birthDate = DateTime.parse(birthDateString);
      final now = DateTime.now();
      int age = now.year - birthDate.year;
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }

  /// Format duration in minutes to human readable format
  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) {
      return '$hours hr';
    }
    return '$hours hr $remainingMinutes min';
  }

  /// Parse date string to DateTime object
  static DateTime? parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Format DateTime to ISO8601 string
  static String toIso8601(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  /// Get current date in ISO8601 format
  static String getCurrentDateIso() {
    return DateTime.now().toIso8601String();
  }

  /// Add days to a date string
  static String addDays(String? dateString, int days) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      final newDate = date.add(Duration(days: days));
      return newDate.toIso8601String();
    } catch (e) {
      return '';
    }
  }

  /// Get difference in days between two dates
  static int daysBetween(String? startDate, String? endDate) {
    if (startDate == null || startDate.isEmpty || endDate == null || endDate.isEmpty) return 0;
    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);
      return end.difference(start).inDays;
    } catch (e) {
      return 0;
    }
  }

  // ==================== BS (BIKRAM SAMBAT) DATE FORMATTING ====================

  /// Convert AD date string to BS date string
  /// Returns format: "YYYY-MM-DD" (e.g., "2081-12-02")
  static Future<String?> convertAdToBs(String? adDateString) async {
    if (adDateString == null || adDateString.isEmpty) return null;
    try {
      final adDate = DateTime.parse(adDateString);
      final adDateObj = AdDate(year: adDate.year, month: adDate.month, day: adDate.day);
      final converter = await _getConverter();
      final bsDate = converter.convertAdToBs(adDateObj);
      if (bsDate == null) return null;
      return '${bsDate.year}-${bsDate.month.toString().padLeft(2, '0')}-${bsDate.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return null;
    }
  }

  /// Convert AD date string to BS date string with Nepali month name
  /// Returns format: "DD Month YYYY" (e.g., "02 Chaitra 2081")
  static Future<String?> convertAdToBsFormatted(String? adDateString) async {
    if (adDateString == null || adDateString.isEmpty) return null;
    try {
      final adDate = DateTime.parse(adDateString);
      final adDateObj = AdDate(year: adDate.year, month: adDate.month, day: adDate.day);
      final converter = await _getConverter();
      final bsDate = converter.convertAdToBs(adDateObj);
      if (bsDate == null) return null;
      return _formatNepaliDate(bsDate);
    } catch (e) {
      return null;
    }
  }

  /// Convert AD date string to BS date with short format
  /// Returns format: "YYYY/MM/DD" (e.g., "2081/12/02")
  static Future<String?> convertAdToBsShort(String? adDateString) async {
    if (adDateString == null || adDateString.isEmpty) return null;
    try {
      final adDate = DateTime.parse(adDateString);
      final adDateObj = AdDate(year: adDate.year, month: adDate.month, day: adDate.day);
      final converter = await _getConverter();
      final bsDate = converter.convertAdToBs(adDateObj);
      if (bsDate == null) return null;
      return '${bsDate.year}/${bsDate.month.toString().padLeft(2, '0')}/${bsDate.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return null;
    }
  }

  /// Convert AD date string to BS date with full format including day
  /// Returns format: "Day, DD Month YYYY" (e.g., "Sunday, 02 Chaitra 2081")
  static Future<String?> convertAdToBsFull(String? adDateString) async {
    if (adDateString == null || adDateString.isEmpty) return null;
    try {
      final adDate = DateTime.parse(adDateString);
      final adDateObj = AdDate(year: adDate.year, month: adDate.month, day: adDate.day);
      final converter = await _getConverter();
      final bsDate = converter.convertAdToBs(adDateObj);
      if (bsDate == null) return null;
      final dayName = DateFormat('EEEE').format(adDate);
      return '$dayName, ${_formatNepaliDate(bsDate)}';
    } catch (e) {
      return null;
    }
  }

  /// Get current BS date
  /// Returns format: "DD Month YYYY" (e.g., "02 Chaitra 2081")
  static Future<String> getCurrentBsDate() async {
    final now = DateTime.now();
    final adDateObj = AdDate(year: now.year, month: now.month, day: now.day);
    final converter = await _getConverter();
    final bsDate = converter.convertAdToBs(adDateObj);
    if (bsDate == null) return '';
    return _formatNepaliDate(bsDate);
  }

  /// Get current BS date in short format
  /// Returns format: "YYYY/MM/DD"
  static Future<String> getCurrentBsDateShort() async {
    final now = DateTime.now();
    final adDateObj = AdDate(year: now.year, month: now.month, day: now.day);
    final converter = await _getConverter();
    final bsDate = converter.convertAdToBs(adDateObj);
    if (bsDate == null) return '';
    return '${bsDate.year}/${bsDate.month.toString().padLeft(2, '0')}/${bsDate.day.toString().padLeft(2, '0')}';
  }

  /// Get BS year from AD date
  static Future<int?> getBsYear(String? adDateString) async {
    if (adDateString == null || adDateString.isEmpty) return null;
    try {
      final adDate = DateTime.parse(adDateString);
      final adDateObj = AdDate(year: adDate.year, month: adDate.month, day: adDate.day);
      final converter = await _getConverter();
      final bsDate = converter.convertAdToBs(adDateObj);
      return bsDate?.year;
    } catch (e) {
      return null;
    }
  }

  /// Get BS month from AD date (returns month number 1-12)
  static Future<int?> getBsMonth(String? adDateString) async {
    if (adDateString == null || adDateString.isEmpty) return null;
    try {
      final adDate = DateTime.parse(adDateString);
      final adDateObj = AdDate(year: adDate.year, month: adDate.month, day: adDate.day);
      final converter = await _getConverter();
      final bsDate = converter.convertAdToBs(adDateObj);
      return bsDate?.month;
    } catch (e) {
      return null;
    }
  }

  /// Get BS day from AD date
  static Future<int?> getBsDay(String? adDateString) async {
    if (adDateString == null || adDateString.isEmpty) return null;
    try {
      final adDate = DateTime.parse(adDateString);
      final adDateObj = AdDate(year: adDate.year, month: adDate.month, day: adDate.day);
      final converter = await _getConverter();
      final bsDate = converter.convertAdToBs(adDateObj);
      return bsDate?.day;
    } catch (e) {
      return null;
    }
  }

  /// Get BS month name from AD date
  static Future<String?> getBsMonthName(String? adDateString) async {
    if (adDateString == null || adDateString.isEmpty) return null;
    try {
      final adDate = DateTime.parse(adDateString);
      final adDateObj = AdDate(year: adDate.year, month: adDate.month, day: adDate.day);
      final converter = await _getConverter();
      final bsDate = converter.convertAdToBs(adDateObj);
      if (bsDate == null) return null;
      return _getNepaliMonthName(bsDate.month);
    } catch (e) {
      return null;
    }
  }

  /// Format NepaliDate to readable string
  static String _formatNepaliDate(NepaliDate nepaliDate) {
    final monthName = _getNepaliMonthName(nepaliDate.month);
    return '${nepaliDate.day.toString().padLeft(2, '0')} $monthName ${nepaliDate.year}';
  }

  /// Get Nepali month name from month number
  static String _getNepaliMonthName(int month) {
    const months = [
      'Baishakh',
      'Jestha',
      'Ashadh',
      'Shrawan',
      'Bhadra',
      'Ashwin',
      'Kartik',
      'Mangsir',
      'Poush',
      'Magh',
      'Falgun',
      'Chaitra',
    ];

    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }

  /// Get Nepali day name from AD date
  static String? getNepaliDayName(String? adDateString) {
    if (adDateString == null || adDateString.isEmpty) return null;
    try {
      final adDate = DateTime.parse(adDateString);
      const days = ['Aaitabar', 'Sombar', 'Mangalbar', 'Budhabar', 'Bihibar', 'Shukrabar', 'Shanibar'];
      return days[adDate.weekday % 7];
    } catch (e) {
      return null;
    }
  }

  /// Check if BS year is leap (Note: BS calendar doesn't have leap years like AD)
  static bool isBsLeapYear(int bsYear) {
    // Bikram Sambat doesn't have leap years in the same way as Gregorian
    // This is a simplified check
    return false;
  }

  /// Calculate age in BS years from birth date (AD)
  static Future<int?> calculateAgeInBs(String? birthDateAd) async {
    if (birthDateAd == null || birthDateAd.isEmpty) return null;
    try {
      final birthYearBs = await getBsYear(birthDateAd);
      if (birthYearBs == null) return null;
      final currentYearBs = await getBsYear(DateTime.now().toIso8601String());
      if (currentYearBs == null) return null;
      return currentYearBs - birthYearBs;
    } catch (e) {
      return null;
    }
  }

  /// Convert BS date to AD date
  /// Input format: "YYYY-MM-DD" or "YYYY/MM/DD"
  static Future<String?> convertBsToAd(String? bsDateString) async {
    if (bsDateString == null || bsDateString.isEmpty) return null;
    try {
      // Parse BS date string
      final parts = bsDateString.contains('-')
          ? bsDateString.split('-')
          : bsDateString.split('/');

      if (parts.length != 3) return null;

      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      final nepaliDate = NepaliDate(year: year, month: month, day: day);
      final converter = await _getConverter();
      final adDate = converter.convertBsToAd(nepaliDate);
      if (adDate == null) return null;
      return '${adDate.year}-${adDate.month.toString().padLeft(2, '0')}-${adDate.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return null;
    }
  }

  /// Format BS date with custom format
  /// Supported formats: 'YYYY', 'MM', 'DD', 'Month', 'Day'
  static Future<String?> formatBsDateCustom(String? adDateString, String format) async {
    if (adDateString == null || adDateString.isEmpty) return null;
    try {
      final adDate = DateTime.parse(adDateString);
      final adDateObj = AdDate(year: adDate.year, month: adDate.month, day: adDate.day);
      final converter = await _getConverter();
      final bsDate = converter.convertAdToBs(adDateObj);
      if (bsDate == null) return null;

      String result = format;
      result = result.replaceAll('YYYY', bsDate.year.toString());
      result = result.replaceAll('MM', bsDate.month.toString().padLeft(2, '0'));
      result = result.replaceAll('DD', bsDate.day.toString().padLeft(2, '0'));
      result = result.replaceAll('Month', _getNepaliMonthName(bsDate.month));
      result = result.replaceAll('Day', DateFormat('EEEE').format(adDate));

      return result;
    } catch (e) {
      return null;
    }
  }
}
