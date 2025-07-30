part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

final class DashboardInitial extends DashboardState {}

class DashboradLoading extends DashboardState {}

class DashboradSuccess extends DashboardState {
  final String incomeBalance;
  final String expenseBalance;
  const DashboradSuccess({
    required this.expenseBalance,
    required this.incomeBalance,
  });
}

class DashboardCurrentMonthExpenseLoaded extends DashboardState {
  final String currentMonthExpense;
  const DashboardCurrentMonthExpenseLoaded({required this.currentMonthExpense});
}

class DashboradError extends DashboardState {
  final String message;

  const DashboradError({required this.message});
}
