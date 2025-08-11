import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import '../../../../app/global_services/user/data/models/my_user.dart';

class ChangePasswordUseCase {
  final AuthRepository _authRepository;

  ChangePasswordUseCase(this._authRepository);

  Future<void> call(MyUser user) async {
    await _authRepository.changePassword(user);
  }
}