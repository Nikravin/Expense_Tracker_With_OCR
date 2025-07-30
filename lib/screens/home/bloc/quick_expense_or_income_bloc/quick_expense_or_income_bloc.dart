import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/screens/home/bloc/quick_expense_or_income_bloc/quick_expense_or_income_event.dart';
import 'package:expense_tracker/screens/home/bloc/quick_expense_or_income_bloc/quick_expense_or_income_state.dart';
import 'package:expense_tracker/screens/home/repository/home_screen_repo.dart';

class QuickExpenseOrIncomeBloc
    extends Bloc<QuickExpenseOrIncomeEvent, QuickExpenseOrIncomeState> {
  QuickExpenseOrIncomeBloc() : super(QuickExpenseOrIncomeInitial()) {
    
    // Your existing event handler (renamed for clarity)
    on<LoadCategories>((event, emit) async {
      try {
        final bool isExpense = event.isExpense;
        final List<String> categoriesList = await HomeScreenRepo()
            .getUserExpenseOrIncomeCategories(isExpense);
        return emit(QuickExpenseOrIncomeLoaded(categoriesList: categoriesList));
      } on FirebaseException catch (e) {
        emit(QuickExpenseOrIncomeErorr(message: e.message.toString()));
      }
    });

    // New event handlers for form state management
    on<UpdateSelectedCategory>((event, emit) {
      if (state is QuickExpenseOrIncomeLoaded) {
        final currentState = state as QuickExpenseOrIncomeLoaded;
        emit(currentState.copyWith(
          selectedCategory: event.category,
          showError: false, // Clear error when user selects category
        ));
      }
    });

    on<ShowValidationError>((event, emit) {
      if (state is QuickExpenseOrIncomeLoaded) {
        final currentState = state as QuickExpenseOrIncomeLoaded;
        emit(currentState.copyWith(showError: true));
      }
    });

    on<ClearForm>((event, emit) {
      if (state is QuickExpenseOrIncomeLoaded) {
        final currentState = state as QuickExpenseOrIncomeLoaded;
        emit(currentState.copyWith(
          selectedCategory: null,
          showError: false,
        ));
      }
    });
  }
}