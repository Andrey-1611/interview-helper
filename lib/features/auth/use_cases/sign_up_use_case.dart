import 'package:injectable/injectable.dart';
import 'package:interview_master/core/utils/network_info.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../data/models/my_user.dart';
import '../../../data/repositories/auth_repository.dart';

@injectable
class SignUpUseCase {
  final AuthRepository _authRepository;
  final NetworkInfo _networkInfo;

  SignUpUseCase(this._authRepository, this._networkInfo);

  Future<MyUser> call(MyUser user, String password) async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) throw NetworkException();
    final myUser = await _authRepository.signUp(user, password);
    await _authRepository.sendEmailVerification();
    return myUser;
  }
}
