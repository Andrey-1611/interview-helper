import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';

import '../../data/models/email_verification_result.dart';

class WatchEmailVerifiedUseCase {
  final AuthRepository _authRepository;

  WatchEmailVerifiedUseCase(this._authRepository);

  Future<EmailVerificationResult?> call() async {
    return await _authRepository.watchEmailVerified();
  }
}
