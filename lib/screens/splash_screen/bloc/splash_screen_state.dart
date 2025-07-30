part of 'splash_screen_bloc.dart';

abstract class SplashScreenState extends Equatable {
  const SplashScreenState();

  @override
  List<Object> get props => [];
}

class SplashScreenInitial extends SplashScreenState {}

class SplashScreenLoading extends SplashScreenState {}

class SplashScreenSuccess extends SplashScreenState {
  final bool userLogged;
  const SplashScreenSuccess({required this.userLogged});
}

class SplashScreenError extends SplashScreenState {
  final String message;
  const SplashScreenError({required this.message});
}
