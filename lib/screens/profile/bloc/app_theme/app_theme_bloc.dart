import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'app_theme_event.dart';
part 'app_theme_state.dart';

class AppThemeBloc extends Bloc<AppThemeEvent, AppThemeState> {
  AppThemeBloc() : super(AppThemeInitialState()) {
    on<ChangeAppTheme>(_changeAppTheme);
  }
  _changeAppTheme(ChangeAppTheme event, Emitter<AppThemeState> emit) {
    final bool isDark = event.isDark;
    print("--------------------------------------------- Print isDark in bloc file:- $isDark ---------------------------------------------");
    emit(AppThemeLoadedState(isDark: isDark));
  }
}
