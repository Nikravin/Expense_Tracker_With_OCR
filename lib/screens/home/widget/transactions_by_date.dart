import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/utils/date_formate_word.dart';
import 'package:intl/intl.dart';

Map<String, List<Map<String, dynamic>>> getAllTransactionByDate(
  List<Map<String, dynamic>> docs,
) {
  Map<String, List<Map<String, dynamic>>> grouped = {};

  for (var doc in docs) {
    final rawDate = doc["date"];
    DateTime date;

    if (rawDate is Timestamp) {
      date = rawDate.toDate();
    } else if (rawDate is String) {
      try {
        date = DateFormat('dd MM yyyy').parse(rawDate);
      } catch (_) {
        continue; // skip invalid
      }
    } else {
      continue;
    }

    final dateKey = formatFriendlyDate(date);

    if (!grouped.containsKey(dateKey)) {
      grouped[dateKey] = [];
    }

    grouped[dateKey]!.add(doc);
  }

  return grouped;
}
