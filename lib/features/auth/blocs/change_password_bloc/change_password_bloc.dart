import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';
import 'package:interview_master/features/auth/data/repositories/auth_repository.dart';

part 'change_password_event.dart';

part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final AuthRepository authRepository;

  ChangePasswordBloc(this.authRepository) : super(ChangePasswordInitial()) {
    on<ChangePassword>((event, emit) async {
      emit(ChangePasswordLoading());
      try {
        await authRepository.changePassword(event.userProfile);
        emit(ChangePasswordSuccess());
      } catch (e) {
        emit(ChangePasswordFailure());
      }
    });
  }
}
