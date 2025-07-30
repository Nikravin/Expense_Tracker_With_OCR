import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker/model/user_fetch_data.dart';
import 'package:expense_tracker/screens/home/repository/home_screen_repo.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileData>(_onLoadProfileData);
  }

  Future<void> _onLoadProfileData(
    LoadProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    
    try {
      final userInfo = getUserLocalData();
      
      if (userInfo != null) {
        // Get balance details from repository
        Map<String, dynamic>? userBalanceData = await HomeScreenRepo()
            .getUserBalanceDetails(userInfo.id.toString());

        if (userBalanceData != null) {
          emit(ProfileLoaded(
            username: userInfo.name ?? 'Unknown User',
            email: userInfo.email ?? 'No email',
            totalBalance: (userBalanceData['totalBalance'] as num).toDouble(),
            incomeBalance: (userBalanceData['incomeBalance'] as num).toDouble(),
            expenseBalance: (userBalanceData['expenseBalance'] as num).toDouble(),
          ));
        } else {
          emit(ProfileError(message: 'Failed to load balance data'));
        }
      } else {
        emit(ProfileError(message: 'User data not found'));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
