import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';
import 'package:interview_master/features/auth/domain/use_cases/sign_in_use_case.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInUseCase signInUseCase;

  SignInBloc(this.signInUseCase) : super(SignInInitial()) {
    on<SignIn>((event, emit) async {
      emit(SignInLoading());
      try {
        final userProfile = await signInUseCase.call(
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
