import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/domain/use_cases/send_email_verification_bloc.dart';

part 'send_email_verification_event.dart';

part 'send_email_verification_state.dart';

class SendEmailVerificationBloc
    extends Bloc<SendEmailVerificationEvent, SendEmailVerificationState> {
  final SendEmailVerificationUseCase _sendEmailVerificationUseCase;

  SendEmailVerificationBloc(this._sendEmailVerificationUseCase)
    : super(SendEmailVerificationInitial()) {
    on<SendEmailVerification>((event, emit) async {
      emit(SendEmailVerificationLoading());
      try {
        await _sendEmailVerificationUseCase.call();
        emit(SendEmailVerificationSuccess());
      } catch (e) {
        emit(SendEmailVerificationFailure());
      }
    });
  }
}
