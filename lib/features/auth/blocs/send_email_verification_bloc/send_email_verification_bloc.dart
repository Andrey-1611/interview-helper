import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/data/repositories/auth_repository.dart';

part 'send_email_verification_event.dart';
part 'send_email_verification_state.dart';

class SendEmailVerificationBloc extends Bloc<SendEmailVerificationEvent, SendEmailVerificationState> {
  final AuthRepository authRepository;
  SendEmailVerificationBloc(this.authRepository) : super(SendEmailVerificationInitial()) {
    on<SendEmailVerification>((event, emit) async {
      emit(SendEmailVerificationLoading());
      try {
        await authRepository.sendEmailVerification();
        emit(SendEmailVerificationSuccess());
      } catch (e) {
        emit(SendEmailVerificationFailure());
      }
    });
  }
}
