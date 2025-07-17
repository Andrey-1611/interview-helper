import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/data/repositories/auth_repository.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository authRepository;

  SignInBloc(this.authRepository) : super(SignInInitial()) {
    on<SignIn>((event, emit) async {
      emit(SignInLoading());
      try {
        final userProfile = await authRepository.signIn(
          event.userProfile,
          event.password,
        );
        emit(SignInSuccess(userProfile: userProfile));
      } catch (e) {
        emit(SignInFailure(error: e.toString()));
      }
    });
  }
}
