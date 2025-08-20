import 'package:interview_master/features/auth/data/models/email_verification_result.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';

import '../../data/models/my_user.dart';

class GetCurrentUserUseCase {
  final AuthRepository _authRepository;

  GetCurrentUserUseCase(this._authRepository);

  Future<MyUser?> call() async {
    EmailVerificationResult? result;
    final user = await _authRepository.getUser();
    if (user != null) {
      result = await _authRepository.checkEmailVerified();
      if (result!.isEmailVerified) return user;
      await _authRepository.signOut();
      return null;
    }
    return null;
  }
}
