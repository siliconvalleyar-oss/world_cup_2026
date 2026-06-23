import 'package:intl/intl.dart';

class DateHelper {
  static final DateFormat _matchDateFormat = DateFormat('MMM d, yyyy');
  static final DateFormat _matchTimeFormat = DateFormat('h:mm a');
  static final DateFormat _fullDateTimeFormat = DateFormat('MMM d, yyyy h:mm a');

  static String formatMatchDate(DateTime date) {
    return _matchDateFormat.format(date);
  }

  static String formatMatchTime(DateTime date) {
    return _matchTimeFormat.format(date);
  }

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) return 'Tomorrow';
      if (difference.inDays < 7) return 'In ${difference.inDays} days';
      return _matchDateFormat.format(date);
    } else if (difference.inDays < 0) {
      if (difference.inDays == -1) return 'Yesterday';
      if (difference.inDays > -7) return '${-difference.inDays} days ago';
      return _matchDateFormat.format(date);
    } else {
      if (difference.inHours > 0) return 'In ${difference.inHours} hours';
      if (difference.inMinutes > 0) return 'In ${difference.inMinutes} minutes';
      return 'Now';
    }
  }

  static String getMatchStatus(DateTime matchDate) {
    final now = DateTime.now();
    final difference = matchDate.difference(now);

    if (difference.inMinutes > 0) {
      return 'Scheduled';
    } else if (difference.inMinutes >= -90) {
      return 'Live';
    } else {
      return 'Finished';
    }
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  static String formatFullDateTime(DateTime date) {
    return _fullDateTimeFormat.format(date);
  }

  static DateTime? parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }
}
