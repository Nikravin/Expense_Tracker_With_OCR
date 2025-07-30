import 'package:expense_tracker/screens/dashboard/bloc/category_list/category_list_event.dart';
import 'package:expense_tracker/screens/dashboard/bloc/category_list/category_list_state.dart';
import 'package:expense_tracker/screens/dashboard/models/expense_data.dart';
import 'package:expense_tracker/screens/dashboard/repository/dashboard_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryListBloc extends Bloc<CategoryListEvent, CategoryListState> {
  CategoryListBloc() : super(CategoryListInitialState()) {
    on<CategoryShowEvent>((event, emit) async {
      try {
        emit(CategoryListLoadingState());
        final rawList = await DashboardRepo().getMonthlyExpenseDataByCategory();
        final categoryListData = rawList.map((e) {
          return ExpenseCategory(
            name: e['category'],
            amount: e['amount'].toDouble(),
          );
        }).toList();
        final List value = [];
        for (var val = 0; val < categoryListData.length; val++) {
          value.add(categoryListData[val].amount);
        }
        double maxValue = value.reduce((a, b) => a > b ? a : b);
            
        emit(CategoryListLoadedState(lineLength: maxValue.toStringAsFixed(0), categoryList: categoryListData));
      } catch (e) {
        emit(CategoryListErrorState(message: e.toString()));
      }
    });
  }
}
