import '../../data/models/email_verification_result.dart';
import '../repositories/auth_repository.dart';

class CheckEmailVerifiedUseCase {
  final AuthRepository _authRepository;

  CheckEmailVerifiedUseCase(this._authRepository);

  Future<EmailVerificationResult?> call() async {
    return await _authRepository.checkEmailVerified();
  }
}