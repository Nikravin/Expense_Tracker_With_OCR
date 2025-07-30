part of 'app_theme_bloc.dart';  

abstract class AppThemeEvent extends Equatable {
  const AppThemeEvent();

  @override
  List<Object?> get props => [];
}

class ChangeAppTheme extends AppThemeEvent {
  final bool isDark;
  const ChangeAppTheme({required this.isDark});

  @override
  List<Object?> get props => [isDark];
}
