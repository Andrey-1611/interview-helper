import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/domain/use_cases/sign_up_use_case.dart';

import '../../../../../core/global_services/user/data/models/my_user.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpUseCase _signUpUseCase;

  SignUpBloc(this._signUpUseCase) : super(SignUpInitial()) {
    on<SignUp>((event, emit) async {
      emit(SignUpLoading());
      try {
        final user = await _signUpUseCase.call(
          event.myUser,
          event.password,
        );
        emit(SignUpSuccess(user: user));
      } catch (e) {
        emit(SignUpFailure());
      }
    });
  }
}
