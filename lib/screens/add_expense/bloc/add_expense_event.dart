part of 'add_expense_bloc.dart';

abstract class AddExpenseEvent extends Equatable {
  const AddExpenseEvent();

  @override
  List<Object> get props => [];
}


class SubmitTrancation extends AddExpenseEvent {
  final AddTrancationModel addTrancationModel;
  const SubmitTrancation({required this.addTrancationModel});
}
