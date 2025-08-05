import 'package:interview_master/core/global_services/user/models/user_profile.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _authRepository;

  SignUpUseCase(this._authRepository);

  Future<UserProfile> call(UserProfile userProfile, String password) async {
    return await _authRepository.signUp(userProfile, password);
  }
}
