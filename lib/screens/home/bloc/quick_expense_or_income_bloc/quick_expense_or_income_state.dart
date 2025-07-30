import 'package:equatable/equatable.dart';

abstract class QuickExpenseOrIncomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QuickExpenseOrIncomeInitial extends QuickExpenseOrIncomeState {}

class QuickExpenseOrIncomeLoaded extends QuickExpenseOrIncomeState {
  final List<String> categoriesList;
  final String? selectedCategory;
  final bool showError;

  QuickExpenseOrIncomeLoaded({
    required this.categoriesList,
    this.selectedCategory,
    this.showError = false,
  });

  @override
  List<Object?> get props => [categoriesList, selectedCategory, showError];

  QuickExpenseOrIncomeLoaded copyWith({
    List<String>? categoriesList,
    String? selectedCategory,
    bool? showError,
  }) {
    return QuickExpenseOrIncomeLoaded(
      categoriesList: categoriesList ?? this.categoriesList,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      showError: showError ?? this.showError,
    );
  }
}

class QuickExpenseOrIncomeErorr extends QuickExpenseOrIncomeState {
  final String message;
  QuickExpenseOrIncomeErorr({required this.message});
  
  @override
  List<Object?> get props => [message];
}