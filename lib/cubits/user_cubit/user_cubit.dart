import 'package:balagh/cubits/user_cubit/user_states.dart';
import 'package:balagh/core/shared/get_user_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  void updateUser(String userId) async {
    emit(UserLoading());

    try {
      final updatedUser = await getUserData(userId);

      if (updatedUser != null) {
        emit(UserLoaded(updatedUser));
      } else {
        emit(UserError("User not found."));
      }
    } catch (e) {
      emit(UserError("Failed to update user: $e"));
    }
  }

  void resetUser() {
    emit(UserInitial());
  }
}
