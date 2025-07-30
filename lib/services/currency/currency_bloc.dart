import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker/services/currency_service.dart';

part 'currency_event.dart';
part 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  CurrencyBloc() : super(CurrencyInitial()) {
    on<LoadCurrency>(_onLoadCurrency);
    on<ChangeCurrency>(_onChangeCurrency);
  }

  Future<void> _onLoadCurrency(
    LoadCurrency event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(CurrencyLoading());
    try {
      final currency = await CurrencyService.getCurrentCurrency();
      emit(CurrencyLoaded(currency));
    } catch (e) {
      emit(CurrencyError(e.toString()));
    }
  }

  Future<void> _onChangeCurrency(
    ChangeCurrency event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(CurrencyLoading());
    try {
      await CurrencyService.saveCurrency(event.currency);
      emit(CurrencyLoaded(event.currency));
    } catch (e) {
      emit(CurrencyError(e.toString()));
    }
  }
}
