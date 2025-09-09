// lib/utils/date_helper.dart
import 'package:intl/intl.dart';

class DateHelper {
  static const List<String> monthsInSpanish = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];

  static const List<String> shortMonthsInSpanish = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ];

  /// Formats date as "15 de marzo de 2024"
  static String formatLongDate(DateTime date) {
    return '${date.day} de ${monthsInSpanish[date.month - 1]} de ${date.year}';
  }

  /// Formats date as "15 mar, 2:30 PM"
  static String formatShortDateTime(DateTime date) {
    final timeFormat = DateFormat('h:mm a');
    return '${date.day} ${shortMonthsInSpanish[date.month - 1]}, ${timeFormat.format(date)}';
  }

  /// Formats date as "15 mar"
  static String formatShortDate(DateTime date) {
    return '${date.day} ${shortMonthsInSpanish[date.month - 1]}';
  }
}
