import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';

class DeleteAccountUseCase {
  final AuthRepository _authRepository;

  DeleteAccountUseCase(this._authRepository);

  Future<void> call() async {
    await _authRepository.deleteAccount();
  }
}