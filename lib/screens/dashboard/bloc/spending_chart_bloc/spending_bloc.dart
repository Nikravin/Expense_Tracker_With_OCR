import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/screens/dashboard/bloc/spending_chart_bloc/spending_event.dart';
import 'package:expense_tracker/screens/dashboard/bloc/spending_chart_bloc/spending_state.dart';
import 'package:expense_tracker/screens/dashboard/models/expense_data.dart';
import 'package:expense_tracker/screens/dashboard/repository/dashboard_repo.dart';

class SpendingBloc extends Bloc<SpendingEvent, SpendingState> {
  SpendingBloc() : super(SpendingInitialState()) {
    on<SpendingChartDataEvent>((event, emit) async {
      try {
        emit(SpendingLoadingState());
        final rawList = await DashboardRepo().getMonthlyExpenseData();
        final chartData = rawList.map((e) {
          return MonthlyData(
            day: e['date'],
            amount: (e['amount'] ?? 0).toDouble(),
          );
        }).toList();
        emit(SpendingLoadedState(chartData: chartData));
      } on FirebaseException catch (e) {
        emit(SpendingErrorState(message: e.toString()));
      }
    });
  }
}
