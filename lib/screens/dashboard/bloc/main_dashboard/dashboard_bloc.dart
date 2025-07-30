import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker/screens/dashboard/repository/dashboard_repo.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    // on<DashboardMainEvent>((event, emit) async { });
    on<DashboardCurrentMonth>(_dashboardCurrentMonth);
  }

  Future<void> _dashboardCurrentMonth(
    DashboardCurrentMonth event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      emit(DashboradLoading());

      final currentMonthExpense = await DashboardRepo.getMonthlyExpenses();

      emit(
        DashboardCurrentMonthExpenseLoaded(
          currentMonthExpense: currentMonthExpense ?? '0',
        ),
      );
    } catch (e) {
      emit(DashboradError(message: e.toString()));
    }
  }
}
