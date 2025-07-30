import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionRepo {
  Future addTrancation(
    String userId,
    Map<String, dynamic> transactionAdd,
  ) async {
    final String transactionId = transactionAdd["trancationId"];
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("transactions")
        .doc(transactionId)
        .set(transactionAdd);
  }
}
