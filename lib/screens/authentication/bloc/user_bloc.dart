import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker/model/user_local_data_model.dart';
import 'package:expense_tracker/screens/authentication/repository/user_signup.dart';
import 'package:expense_tracker/screens/home/repository/home_screen_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:random_string/random_string.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserRequestSignup>((event, emit) async {
      emit(UserLoading());
      try {
        await DataBaseMethods().userRegisterWithEmailAndPassword(
          event.email,
          event.password,
        );

        String id = randomAlphaNumeric(10);

        Map<String, dynamic> userInfo = {
          'userId': id,
          'userName': event.name,
          'userEmail': event.email,
        };
        await DataBaseMethods().userDetailsSave(userInfo, id);

        final userBox = Hive.box<UserLocalData>('userBox');
        final user = UserLocalData(
          id: id,
          email: event.email,
          name: event.name,
          userLogged: true,
        );
        await userBox.put('currentUser', user);

        final userBalanceBox = Hive.box<UserBalanceLocalData>('userBalanceBox');
        final userBalance = UserBalanceLocalData(
          userTotalAmount: 0.0,
          userExpenseAmount: 0.0,
          userIncomeAmount: 0.0,
        );
        await userBalanceBox.put('currentUserBalance', userBalance);

        emit(UserSuccess());
      } on FirebaseAuthException catch (e){
        String message;
        switch (e.code) {
          case 'weak-password':
            message = "Provided password is too weak.";
            break;
          case 'email-already-in-use':
            message = "Email is already in use.";
            break;
          case 'invalid-email':
            message = "The email address is not valid.";
            break;
          default:
            message = "Registration failed. ${e.message}";
        }
        emit(UserError(message));
      }
    });
  }
}

class UserLoginBloc extends Bloc<UserEvent, UserState> {
  UserLoginBloc() : super(UserInitial()) {
    on<UserRequestSignin>((event, emit) async {
      emit(UserLoading());
      try {
        await DataBaseMethods().userLoginWithEmailAndPassword(
          event.email,
          event.password,
        );

        final userInfoViaEmail = await DataBaseMethods()
            .fetchUserDetailsWithEmal(event.email);

        final userBalanceInfo = await HomeScreenRepo().getUserBalanceDetails(
          userInfoViaEmail!['userId'],
        );
        final userBox = Hive.box<UserLocalData>('userBox');

        final user = UserLocalData(
          id: userInfoViaEmail['userId'].toString(),
          email: userInfoViaEmail['userEmail'].toString(),
          name: userInfoViaEmail['userName'].toString(),
          userLogged: true,
        );

        await userBox.put('currentUser', user);

        await userBox.put('currentUser', user);

        final userBalanceBox = Hive.box<UserBalanceLocalData>('userBalanceBox');
        final userBalance = UserBalanceLocalData(
          userTotalAmount: (userBalanceInfo!["totalBalance"] as num?)
              ?.toDouble(),
          userExpenseAmount: (userBalanceInfo["expenseBalance"] as num?)
              ?.toDouble(),
          userIncomeAmount: (userBalanceInfo["incomeBalance"] as num?)
              ?.toDouble(),
        );
        await userBalanceBox.put('currentUserBalance', userBalance);

        emit(UserSuccess());
      } on FirebaseAuthException catch (e) {
        String message;

        switch (e.code) {
          case 'user-not-found':
            message = 'No user found for that email.';
            break;
          case 'wrong-password':
            message = 'Incorrect password.';
            break;
          case 'invalid-email':
            message = 'The email address is not valid.';
            break;
          case 'user-disabled':
            message = 'This user account has been disabled.';
            break;
          case 'too-many-requests':
            message = 'Too many login attempts. Try again later.';
            break;
          case 'network-request-failed':
            message = 'Network error. Please check your connection.';
            break;
          default:
            message = 'Login failed. ${e.message}';
        }
        emit(UserError(message));
      }
    });
  }
}

class UserLogoutBloc extends Bloc<UserEvent, UserState> {
  UserLogoutBloc() : super(UserInitial()) {
    on<UserLogoutRequest>((event, emit) async {
      emit(UserLoading());
      try {
        final userBox = Hive.box<UserLocalData>('userBox');
        await userBox.delete('currentUser');

        emit(UserSuccess());
      } catch (e) {
        emit(UserError("Find some error $e"));
      }
    });
  }
}
