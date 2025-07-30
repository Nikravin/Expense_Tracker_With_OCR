part of 'app_theme_bloc.dart';
abstract class AppThemeState extends Equatable {
  const AppThemeState();
  @override
  List<Object?> get props => [];
}

class AppThemeInitialState extends AppThemeState {}

class AppThemeLoadedState extends AppThemeState {
  final bool isDark;
  const AppThemeLoadedState({required this.isDark});
  @override
  List<Object?> get props => [isDark];
}

