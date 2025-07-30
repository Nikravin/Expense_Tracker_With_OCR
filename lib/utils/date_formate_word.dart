import 'package:intl/intl.dart';

String formatFriendlyDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final dateToCompare = DateTime(date.year, date.month, date.day);

  final difference = today.difference(dateToCompare).inDays;

  if (difference == 0) return "Today";
  if (difference == 1) return "Yesterday";
  return DateFormat('dd MMM yyyy').format(date);
}
