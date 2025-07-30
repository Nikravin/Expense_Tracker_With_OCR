import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker/model/user_fetch_data.dart';
import 'package:expense_tracker/model/user_local_data_model.dart';
import 'package:expense_tracker/screens/home/repository/home_screen_repo.dart';
import 'package:hive/hive.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenUserDetailBloc extends Bloc<UserDetailsEvent, HomeScreenState> {
  HomeScreenUserDetailBloc() : super(HomeScreenInitial()) {
    on<UserDetailsEvent>((event, emit) async {
      emit(HomeScreenLoading());
      try {
        final userInfo = getUserLocalData();
        if (userInfo != null) {
          Map<String, dynamic>? userInfoData = await HomeScreenRepo()
              .getUserBalanceDetails(userInfo.id.toString());

          if (userInfoData != null) {
           return emit(
              HomeScreenSuccess(
                userTotalBalance: (userInfoData['totalBalance'] as num)
                    .toDouble(),
                userExpenseBalance: (userInfoData['expenseBalance'] as num)
                    .toDouble(),
                userIncomeBalance: (userInfoData['incomeBalance'] as num)
                    .toDouble(),
              ),
            );
          }
        }
      } catch (e) {
        emit(HomeScreenError(message: e.toString()));
      }
    });
  }
}

class UserTransactionDetailBloc
    extends Bloc<UserTransactionDetailsEvent, UserTransactionState> {
  UserTransactionDetailBloc() : super(UserTransactionInitial()) {
    on<UserTransactionDetailsEvent>((event, emit) async {
      emit(UserTransactionLoading());
      try {
        await HomeScreenRepo().userTransactionDelete(
          event.userId,
          event.transactionId,
        );
        await HomeScreenRepo().calculateAndSaveBalance(event.userId);

        Map<String, dynamic>? userInfoData = await HomeScreenRepo()
            .getUserBalanceDetails(event.userId);

        if (userInfoData != null) {
          final userBalanceBox = Hive.box<UserBalanceLocalData>(
            'userBalanceBox',
          );
          final userBalance = UserBalanceLocalData(
            userTotalAmount: (userInfoData['totalBalance'] as num).toDouble(),
            userExpenseAmount: (userInfoData['expenseBalance'] as num)
                .toDouble(),
            userIncomeAmount: (userInfoData['incomeBalance'] as num).toDouble(),
          );
          await userBalanceBox.put('currentUserBalance', userBalance);

          emit(UserTransactionSuccess());
        }
      } catch (e) {
        emit(UserTransactionError(message: e.toString()));
      }
    });
  }
}

class UserSearchTransactionBloc
    extends Bloc<UserTransactionEvent, UserSearchTransactionState> {
  UserSearchTransactionBloc() : super(UserSearchTransactionInitial()) {
    on<UserFilterTransactionEvent>((event, emit) async {
      String filterName = event.filterType;
      emit(UserSearchTransactionLoading());
      try {
        final stream = HomeScreenRepo().getUserTrancationsDetailsByFilter(
          event.userId,
          event.filterType,
        );

        final snapshot = await stream.first;

        final alltransaction = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return data;
        }).toList();

        emit(
          UserSearchTransactionSuccess(
            transactions: alltransaction,
            filterType: filterName,
          ),
        );
      } catch (e) {
        emit(UserSearchTransactionError(message: e.toString()));
      }
    });

    on<UserSearchTransactionEvent>((event, emit) {
      emit(UserSearchTransactionLoading());
      final String searchText = event.searchText;
      emit(UserSearchTransactionLoaded(searchText: searchText));
    });
  }
}
