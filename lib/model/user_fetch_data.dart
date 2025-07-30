import 'package:expense_tracker/model/user_local_data_model.dart';
import 'package:hive/hive.dart';

UserLocalData? getUserLocalData() {
  final userBox = Hive.box<UserLocalData>('userBox');
  final userInfo = userBox.get('currentUser');

  return userInfo;
}

UserBalanceLocalData? getUserBalanceLocalData() {
  final userBox = Hive.box<UserBalanceLocalData>('userBalanceBox');
  final userInfo = userBox.get('currentUserBalance');

  return userInfo;
}
