import 'package:interview_master/core/global_services/user/models/user_profile.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  Future<UserProfile> call(UserProfile user, String password) async {
    return await _authRepository.signIn(user, password);
  }
}

