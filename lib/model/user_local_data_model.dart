import 'package:hive/hive.dart';

part 'user_local_data_model.g.dart';

@HiveType(typeId: 0)
class UserLocalData extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? email;

  @HiveField(2)
  String? name;

  @HiveField(3)
  bool? userLogged;

  UserLocalData({
    required this.id,
    required this.email,
    required this.name,
    required this.userLogged,
  });
}
@HiveType(typeId: 1)
class UserBalanceLocalData extends HiveObject {
  @HiveField(0)
  double? userTotalAmount;

  @HiveField(1)
  double? userIncomeAmount;

  @HiveField(2)
  double? userExpenseAmount;

  UserBalanceLocalData({
    required this.userTotalAmount,
    required this.userExpenseAmount,
    required this.userIncomeAmount,
  });
}

@HiveType(typeId: 2)
class CurrencyLocalData extends HiveObject {
  @HiveField(0)
  String code;

  @HiveField(1)
  String symbol;

  @HiveField(2)
  String name;

  CurrencyLocalData({
    required this.code,
    required this.symbol,
    required this.name,
  });
}
