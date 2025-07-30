import 'package:cloud_firestore/cloud_firestore.dart';

class AddTrancationModel {
  final String type;
  final String transactionId;
  final double amount;
  final DateTime date;
  final Timestamp createdat;
  final String category;
  final String? note;
  final String? imageUrl;

  AddTrancationModel({
    required this.type,
    required this.transactionId,
    required this.amount,
    required this.date,
    required this.createdat,
    required this.category,
    this.note,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'trancationId': transactionId,
      'amount': amount,
      'date': date,
      'createdat': createdat,
      'category': category,
      'note': note,
      'imageUrl' : imageUrl
    };
  }
}
