part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String username;
  final String email;
  final double totalBalance;
  final double incomeBalance;
  final double expenseBalance;

  const ProfileLoaded({
    required this.username,
    required this.email,
    required this.totalBalance,
    required this.incomeBalance,
    required this.expenseBalance,
  });

  @override
  List<Object> get props => [username, email, totalBalance, incomeBalance, expenseBalance];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}
