import 'package:interview_master/app/global_services/user/models/my_user.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';

class ChangeEmailUseCase {
  final AuthRepository _authRepository;

  ChangeEmailUseCase(this._authRepository);

  Future<void> call(String email, String password) async {
    final user = await _authRepository.getUser();
    await _authRepository.deleteAccount();
    await _authRepository.signUp(
      MyUser(email: email, name: user!.name),
      password,
    );
    await _authRepository.sendEmailVerification();
  }
}
