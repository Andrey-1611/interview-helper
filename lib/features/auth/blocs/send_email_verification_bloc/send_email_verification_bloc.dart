import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../use_cases/send_email_verification_use_case.dart';

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
      } on NetworkException {
        emit(SendEmailVerificationNetworkFailure());
      } catch (e) {
        emit(SendEmailVerificationFailure());
      }
    });
  }
}
