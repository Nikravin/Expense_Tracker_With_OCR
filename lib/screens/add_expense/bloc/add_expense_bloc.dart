import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker/model/user_local_data_model.dart';
import 'package:expense_tracker/screens/add_expense/model/add_trancation_model.dart';
import 'package:expense_tracker/screens/add_expense/repository/transaction_repo.dart';
import 'package:expense_tracker/screens/home/repository/home_screen_repo.dart';
import 'package:hive/hive.dart';

part 'add_expense_event.dart';
part 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  AddExpenseBloc(String userId) : super(AddExpenseInitial()) {
    on<SubmitTrancation>((event, emit) async {
      emit(AddTransactionLoading());

      try {
        await TransactionRepo().addTrancation(
          userId,
          event.addTrancationModel.toMap(),
        );

        await HomeScreenRepo().calculateAndSaveBalance(userId);

        Map<String, dynamic>? userInfoData = await HomeScreenRepo()
            .getUserBalanceDetails(userId);

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


          emit(AddTransactionSuccess());
        }
      } catch (e) {
        emit(AddTransactionError(e.toString()));
      }
    });
  }
}
