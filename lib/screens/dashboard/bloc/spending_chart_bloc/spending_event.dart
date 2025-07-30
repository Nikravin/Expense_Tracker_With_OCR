import 'package:equatable/equatable.dart';

abstract class SpendingEvent extends Equatable{
  const SpendingEvent();
  @override
  List<Object> get props => [];
}

class SpendingChartDataEvent extends SpendingEvent{}