import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';
import 'package:interview_master/features/auth/data/repositories/auth_repository.dart';

part 'change_email_event.dart';

part 'change_email_state.dart';

class ChangeEmailBloc extends Bloc<ChangeEmailEvent, ChangeEmailState> {
  final AuthRepository authRepository;

  ChangeEmailBloc(this.authRepository) : super(ChangeEmailInitial()) {
    on<ChangeEmail>((event, emit) async {
      emit(ChangeEmailLoading());
      try {
        await authRepository.changeEmail(event.userProfile);
        emit(ChangeEmailSuccess());
      } catch (e) {
        emit(ChangeEmailFailure());
      }
    });
  }
}
