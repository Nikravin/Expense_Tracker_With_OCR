part of 'user_bloc.dart';

abstract class UserEvent{}


class UserRequestSignup extends UserEvent{
  final String email;
  final String name;
  final String password;
  UserRequestSignup({required this.email, required this.name, required this.password});
}

class UserRequestSignin extends UserEvent{
  final String email;
  final String password;
  UserRequestSignin({required this.email, required this.password});
}

class UserLogoutRequest extends UserEvent{}
