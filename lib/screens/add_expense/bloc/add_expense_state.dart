part of 'add_expense_bloc.dart';

abstract class AddExpenseState extends Equatable {
  const AddExpenseState();
  
  @override
  List<Object> get props => [];
}

final class AddExpenseInitial extends AddExpenseState {}

class AddTransactionLoading extends AddExpenseState {}

class AddTransactionSuccess extends AddExpenseState {}

class AddTransactionError extends AddExpenseState {
  final String message;
  const AddTransactionError(this.message);
}