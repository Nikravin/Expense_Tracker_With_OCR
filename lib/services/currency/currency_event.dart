part of 'currency_bloc.dart';

abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();

  @override
  List<Object> get props => [];
}

class LoadCurrency extends CurrencyEvent {}

class ChangeCurrency extends CurrencyEvent {
  final CurrencyModel currency;

  const ChangeCurrency(this.currency);

  @override
  List<Object> get props => [currency];
}
