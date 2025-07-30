import 'package:equatable/equatable.dart';


abstract class QuickExpenseOrIncomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Rename your existing event from QuickExpenseOrIncome to LoadCategories
class LoadCategories extends QuickExpenseOrIncomeEvent {
  final bool isExpense;
  LoadCategories(this.isExpense);
  
  @override
  List<Object?> get props => [isExpense];
}

class UpdateSelectedCategory extends QuickExpenseOrIncomeEvent {
  final String? category;
  UpdateSelectedCategory(this.category);
  
  @override
  List<Object?> get props => [category];
}

class ShowValidationError extends QuickExpenseOrIncomeEvent {}

class ClearForm extends QuickExpenseOrIncomeEvent {}