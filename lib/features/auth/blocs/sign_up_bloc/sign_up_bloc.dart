import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';
import '../../data/repositories/auth_repository.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepository;

  SignUpBloc(this.authRepository) : super(SignUpInitial()) {
    on<SignUp>((event, emit) async {
      emit(SignUpLoading());
      try {
        final userProfile = await authRepository.signUp(
          event.userProfile,
          event.password,
        );
        emit(SignUpSuccess(userProfile: userProfile));
      } catch (e) {
        emit(SignUpFailure());
      }
    });
  }
}
