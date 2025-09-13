import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/domain/use_cases/sign_out_use_case.dart';

import '../../../../../core/errors/exceptions.dart';

part 'sign_out_event.dart';

part 'sign_out_state.dart';

class SignOutBloc extends Bloc<SignOutEvent, SignOutState> {
  final SignOutUseCase _signOutUseCase;

  SignOutBloc(this._signOutUseCase) : super(SignOutInitial()) {
    on<SignOut>((event, emit) async {
      emit(SignOutLoading());
      try {
        await _signOutUseCase.call();
        emit(SignOutSuccess());
      } on NetworkException {
        emit(SignOutNetworkFailure());
      } catch (e) {
        emit(SignOutFailure());
      }
    });
  }
}
