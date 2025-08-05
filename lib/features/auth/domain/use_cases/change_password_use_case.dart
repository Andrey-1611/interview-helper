import 'package:interview_master/core/global_services/user/models/user_profile.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository _authRepository;

  ChangePasswordUseCase(this._authRepository);

  Future<void> call(UserProfile userProfile) async {
    await _authRepository.changePassword(userProfile);
  }
}