import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/data/repositories/auth_repository.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';

part 'check_current_user_event.dart';
part 'check_current_user_state.dart';

class CheckCurrentUserBloc extends Bloc<CheckCurrentUserEvent, CheckCurrentUserState> {
  final AuthRepository authRepository;
  CheckCurrentUserBloc(this.authRepository) : super(CheckCurrentUserInitial()) {
    on<CheckCurrentUser>((event, emit) async {
      emit(CheckCurrentUserLoading());
      try {
        final user = await authRepository.checkCurrentUser();
        if (user != null) {
          emit(CheckCurrentUserExists(userProfile: user));
        } else {
          emit(CheckCurrentUserNotExists());
        }
      } catch (e) {
        emit(CheckCurrentUserFailure());
      }
    });
  }
}
