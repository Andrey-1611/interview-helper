import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _authRepository;

  SignOutUseCase(this._authRepository);

  Future<void> call() async {
    await _authRepository.signOut();
  }
}