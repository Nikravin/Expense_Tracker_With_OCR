import 'package:equatable/equatable.dart';
import 'package:expense_tracker/screens/dashboard/models/expense_data.dart';

abstract class SpendingState extends Equatable {
  const SpendingState();

  @override
  List<Object> get props => [];
}

class SpendingInitialState extends SpendingState {}

class SpendingLoadingState extends SpendingState {}

class SpendingLoadedState extends SpendingState {
  final List<MonthlyData> chartData;
  const SpendingLoadedState({required this.chartData});
}

class SpendingErrorState extends SpendingState {
  final String message;
  const SpendingErrorState({required this.message});
}
