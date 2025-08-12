

import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';

import '../models/my_user.dart';

class GetUserUseCase {
  final AuthRepository _authRepository;

  GetUserUseCase(this._authRepository);

  Future<MyUser?> call() async {
    return await _authRepository.getUser();
  }
}
