import 'package:equatable/equatable.dart';
import 'package:expense_tracker/screens/dashboard/models/expense_data.dart';

abstract class CategoryListState extends Equatable {
  const CategoryListState();
  @override
  List<Object> get props => [];
}

class CategoryListInitialState extends CategoryListState {}

class CategoryListLoadingState extends CategoryListState {}

class CategoryListLoadedState extends CategoryListState {
  final String lineLength;
  final List<ExpenseCategory> categoryList;
  const CategoryListLoadedState({required this.lineLength, required this.categoryList});
}

class CategoryListErrorState extends CategoryListState {
  final String message;
  const CategoryListErrorState({required this.message});
}
