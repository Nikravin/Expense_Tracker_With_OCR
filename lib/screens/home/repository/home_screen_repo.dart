import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/model/user_fetch_data.dart';
import 'package:intl/intl.dart';

class HomeScreenRepo {
  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    DocumentSnapshot fetchUserInfo = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (fetchUserInfo.exists) {
      Map<String, dynamic> data = fetchUserInfo.data() as Map<String, dynamic>;
      return data;
    } else {
      return null;
    }
  }

  Stream<QuerySnapshot> getUserTrancationsDetails(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("transactions")
        .orderBy("createdat", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserLimitedTrancationsDetails(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("transactions")
        .orderBy("createdat", descending: true)
        .limit(5)
        .snapshots();
  }

  Future<void> calculateAndSaveBalance(String userId) async {
    double totalBalance = 0;
    double incomeBalance = 0;
    double expenseBalance = 0;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy HH:mm').format(now);

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data["type"] == "Expense") {
          expenseBalance += data["amount"];
        } else if (data["type"] == "Income") {
          incomeBalance += data["amount"];
        }
      }
      totalBalance += incomeBalance - expenseBalance;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('balance')
          .doc("${userId}Balance")
          .set({
            "incomeBalance": incomeBalance,
            "expenseBalance": expenseBalance,
            "totalBalance": totalBalance,
            "lastUpdate": formattedDate,
          });
    } on FirebaseException catch (e) {
      e.code;
    }
  }

  Future<Map<String, dynamic>?> getUserBalanceDetails(String userId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('balance')
        .get();

    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          snapshot.docs.first.data() as Map<String, dynamic>;
      return data;
    } else {
      return null;
    }
  }

  Stream<QuerySnapshot> getUserTrancationsDetailsByFilter(
    String userId,
    String byFliter,
  ) {
    final myCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("transactions");

    if (byFliter == "All") {
      return myCollection.orderBy("createdat", descending: true).snapshots();
    } else {
      return myCollection
          .where('type', isEqualTo: byFliter)
          .orderBy("createdat", descending: true)
          .snapshots();
    }
  }

  Future<void> userTransactionDelete(
    String userId,
    String transactionId,
  ) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("transactions")
        .doc(transactionId)
        .delete();
  }

  Future<List<String>> getUserExpenseOrIncomeCategories(bool expense) async {
    final userInfo = getUserLocalData();
    if (userInfo == null) {
      return ["User info not found"];
    }
    List<String> userExpenseOrIncomeCategoryList = [];
    final String isExpense = expense ? 'Expense' : 'Income';

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userInfo.id.toString())
          .collection('transactions')
          .where('type', isEqualTo: isExpense)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['category'] != null) {
          userExpenseOrIncomeCategoryList.add(data['category']);
        }
      }
      return userExpenseOrIncomeCategoryList.toSet().toList();
    } on FirebaseException catch (e) {
      return [e.message.toString()];
    }
  }
}
