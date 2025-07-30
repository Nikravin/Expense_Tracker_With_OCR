part of 'home_screen_bloc.dart';

sealed class HomeScreenState extends Equatable {
  const HomeScreenState();

  @override
  List<Object> get props => [];
}

class HomeScreenInitial extends HomeScreenState {}

class HomeScreenLoading extends HomeScreenState {}

class HomeScreenSuccess extends HomeScreenState {
  final double userTotalBalance;
  final double userIncomeBalance;
  final double userExpenseBalance;
  const HomeScreenSuccess({
    required this.userTotalBalance,
    required this.userExpenseBalance,
    required this.userIncomeBalance,
  });

  @override
  List<Object> get props => [
    userTotalBalance,
    userIncomeBalance,
    userExpenseBalance,
  ];
}

class HomeScreenError extends HomeScreenState {
  final String message;
  const HomeScreenError({required this.message});
}

abstract class UserTransactionState extends Equatable {
  const UserTransactionState();

  @override
  List<Object> get props => [];
}

class UserTransactionInitial extends UserTransactionState {}

class UserTransactionLoading extends UserTransactionState {}

class UserTransactionSuccess extends UserTransactionState {}

class UserTransactionError extends UserTransactionState {
  final String message;
  const UserTransactionError({required this.message});

  @override
  List<Object> get props => [message];
}

abstract class UserSearchTransactionState extends Equatable {
  const UserSearchTransactionState();

  @override
  List<Object> get props => [];
}

class UserSearchTransactionInitial extends UserSearchTransactionState {}

class UserSearchTransactionLoading extends UserSearchTransactionState {}

class UserSearchTransactionSuccess extends UserSearchTransactionState {
  final List<Map<String, dynamic>> transactions;
  final String filterType;
  const UserSearchTransactionSuccess({required this.transactions, required this.filterType});

  @override
  List<Object> get props => [transactions];
}
class UserSearchTransactionLoaded extends UserSearchTransactionState {
  final String searchText;
  const UserSearchTransactionLoaded({required this.searchText});

  @override
  List<Object> get props => [searchText];
}

class UserSearchTransactionError extends UserSearchTransactionState {
  final String message;
  const UserSearchTransactionError({required this.message});

  @override
  List<Object> get props => [message];
}
