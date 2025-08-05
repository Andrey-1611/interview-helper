import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/data/models/email_verification_result.dart';
import 'package:interview_master/features/auth/data/repositories/auth_repository.dart';

part 'is_email_verified_event.dart';

part 'is_email_verified_state.dart';

class IsEmailVerifiedBloc
    extends Bloc<IsEmailVerifiedEvent, IsEmailVerifiedState> {
  final AuthRepository authRepository;

  IsEmailVerifiedBloc(this.authRepository) : super(IsEmailVerifiedInitial()) {
    on<CheckEmailVerified>((event, emit) async {
      emit(IsEmailVerifiedLoading());
      try {
        final EmailVerificationResult? result = await authRepository
            .checkEmailVerified();
        if (result?.isEmailVerified == true) {
          emit(IsEmailVerifiedSuccess(result: result!));
        } else {
          emit(IsEmailNotVerified());
        }
      } catch (e) {
        emit(IsEmailVerifiedFailure(e.toString()));
      }
    });

    on<WatchEmailVerified>((event, emit) async {
      emit(IsEmailVerifiedLoading());
      try {
        final EmailVerificationResult? result = await authRepository
            .watchEmailVerified();
        emit(IsEmailVerifiedSuccess(result: result!));
      } catch (e) {
        emit(IsEmailVerifiedFailure(e.toString()));
      }
    });
  }
}
