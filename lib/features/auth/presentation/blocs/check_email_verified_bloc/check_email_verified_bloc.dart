import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/data/models/email_verification_result.dart';
import 'package:interview_master/features/auth/domain/use_cases/check_email_verified_use_case.dart';

part 'check_email_verified_event.dart';

part 'check_email_verified_state.dart';

class CheckEmailVerifiedBloc
    extends Bloc<CheckEmailVerifiedEvent, CheckEmailVerifiedState> {
  final CheckEmailVerifiedUseCase _checkEmailVerifiedUseCase;

  CheckEmailVerifiedBloc(this._checkEmailVerifiedUseCase)
    : super(CheckEmailVerifiedInitial()) {
    on<CheckEmailVerified>((event, emit) async {
      emit(CheckEmailVerifiedLoading());
      try {
        final EmailVerificationResult? result = await _checkEmailVerifiedUseCase
            .call();
        if (result?.isEmailVerified == true) {
          emit(CheckEmailVerifiedSuccess(result: result!));
        } else {
          emit(CheckEmailNotVerified());
        }
      } catch (e) {
        emit(CheckEmailVerifiedFailure());
      }
    });
  }
}
