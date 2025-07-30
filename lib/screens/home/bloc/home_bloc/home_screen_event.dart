part of 'home_screen_bloc.dart';

abstract class HomeScreenEvent {}

class UserDetailsEvent extends HomeScreenEvent {}

abstract class UserTransactionEvent extends Equatable {
  const UserTransactionEvent();

  @override
  List<Object> get props => [];
}

class UserTransactionDetailsEvent extends UserTransactionEvent {
  final String transactionId;
  final String userId;

  const UserTransactionDetailsEvent({
    required this.transactionId,
    required this.userId,
  });

  @override
  List<Object> get props => [transactionId, userId];
}

class UserSearchTransactionEvent extends UserTransactionEvent {
  final String searchText;
  const UserSearchTransactionEvent({required this.searchText});
  @override
  List<Object> get props => [searchText];
}

class UserFilterTransactionEvent extends UserTransactionEvent {
  final String filterType;
  final String userId;

  const UserFilterTransactionEvent({required this.filterType, required this.userId});

  @override
  List<Object> get props => [filterType, userId];
}
