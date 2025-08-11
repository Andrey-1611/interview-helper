import '../../../../app/global_services/user/data/models/my_user.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  Future<MyUser> call(MyUser user, String password) async {
    return await _authRepository.signIn(user, password);
  }
}

