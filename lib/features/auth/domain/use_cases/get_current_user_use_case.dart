import 'package:interview_master/app/global_services/user/models/my_user.dart';
import 'package:interview_master/features/auth/data/models/email_verification_result.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';

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
