import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/model/user_fetch_data.dart';
import 'package:intl/intl.dart';

class DashboardRepo {
  static getMonthlyExpenses() async {
    final userInfo = getUserLocalData();
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 1);
    final endDate = DateTime(now.year, now.month + 1, 0);

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userInfo!.id.toString())
          .collection('transactions')
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .get();

      double totalCurrentMonthExpense = 0;
      // double totalCurrentMonthIncome = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['type'] == 'Expense') {
          totalCurrentMonthExpense = totalCurrentMonthExpense + data['amount'];
        }
      }
      return totalCurrentMonthExpense.toStringAsFixed(0);
    } on FirebaseException catch (e) {
      e.code;
    }
  }

  Future<List<Map<String, dynamic>>> getMonthlyExpenseData() async {
    final userInfo = getUserLocalData();
    if (userInfo == null) {
      return [
        {"error": "User info not found"},
      ];
    }

    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 1);
    final endDate = DateTime(now.year, now.month + 1, 0);
    List<Map<String, dynamic>> monthlyExpenseDataList = [];

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userInfo.id.toString())
          .collection('transactions')
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .where('type', isEqualTo: 'Expense') // optional filter
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        if (data['date'] != null && data['amount'] != null) {
          Timestamp timestampDate = data['date'];
          DateTime date = timestampDate.toDate();
          final formattedDate = DateFormat('d MMM').format(date);
          final amount = (data['amount'] ?? 0).toDouble();

          monthlyExpenseDataList.add({"date": formattedDate, "amount": amount});
        }
      }

      return monthlyExpenseDataList;
    } on FirebaseException catch (e) {
      return [
        {"error": e.message ?? "Firebase error"},
      ];
    }
  }

  Future<List<Map<String, dynamic>>> getMonthlyExpenseDataByCategory() async {
    final userInfo = getUserLocalData();
    if (userInfo == null) {
      return [
        {"error": "User info not found"},
      ];
    }

    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 1);
    final endDate = DateTime(now.year, now.month + 1, 0);

    Map<String, dynamic> monthlyExpenseDataListByCategory = {};

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userInfo.id.toString())
          .collection('transactions')
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .where('type', isEqualTo: 'Expense') // optional filter
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        if (data['amount'] != null && data['category'] != null) {
          final category = data['category'];
          final amount = (data['amount'] ?? 0).toDouble();
          if (monthlyExpenseDataListByCategory.containsKey(category)) {
            monthlyExpenseDataListByCategory[category] =
                monthlyExpenseDataListByCategory[category]! + amount;
          } else {
            monthlyExpenseDataListByCategory[category] = amount;
          }
        }
      }

      return monthlyExpenseDataListByCategory.entries.map((entry) {
        return {"category": entry.key, "amount": entry.value};
      }).toList();
    } on FirebaseException catch (e) {
      return [
        {"error": e.message ?? "Firebase error"},
      ];
    }
  }

  
}
