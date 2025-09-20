import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/errors/exceptions.dart';
import '../../../../data/models/user/my_user.dart';
import '../../use_cases/sign_in_use_case.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInUseCase signInUseCase;

  SignInBloc(this.signInUseCase) : super(SignInInitial()) {
    on<SignIn>((event, emit) async {
      emit(SignInLoading());
      try {
        final user = await signInUseCase.call(event.user, event.password);
        user != null
            ? emit(SignInSuccess(user: user))
            : emit(SignInNoVerification());
      } on NetworkException {
        emit(SignInNetworkFailure());
      }
      catch (e) {
        emit(SignInFailure(error: e.toString()));
      }
    });
  }
}
