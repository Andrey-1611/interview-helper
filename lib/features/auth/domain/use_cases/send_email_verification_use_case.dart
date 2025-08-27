import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';

class SendEmailVerificationUseCase {
  final AuthRepository _authRepository;

  SendEmailVerificationUseCase(this._authRepository);

  Future<void> call() async {
    await _authRepository.sendEmailVerification();
  }
}