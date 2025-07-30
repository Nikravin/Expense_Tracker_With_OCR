import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker/model/user_fetch_data.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc() : super(SplashScreenInitial()) {
    on<SplashScreenStarted>((event, emit) {
      emit(SplashScreenLoading());
        final userInfo = getUserLocalData();
        if(userInfo != null){
          emit(SplashScreenSuccess(userLogged: userInfo.userLogged!));      
        }else if(userInfo == null){
          emit(SplashScreenSuccess(userLogged: false));      
        }
        else{
          emit(SplashScreenError(message: "Facing an error on fetching user local data"));
        }
    });
  }
}