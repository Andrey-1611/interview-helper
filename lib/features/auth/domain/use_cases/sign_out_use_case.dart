import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/interview/domain/repositories/local_repository.dart';

class SignOutUseCase {
  final AuthRepository _authRepository;
  final LocalRepository _localRepository;

  SignOutUseCase(this._authRepository, this._localRepository);

  Future<void> call() async {
    await _authRepository.signOut();
    await _localRepository.deleteUser();
  }
}
