import 'package:injectable/injectable.dart';
import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/data/models/user/user_data.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../data/repositories/auth_repository.dart';

@injectable
class SignUpUseCase {
  final AuthRepository _authRepository;
  final NetworkInfo _networkInfo;

  SignUpUseCase(this._authRepository, this._networkInfo);

  Future<UserData> call(String name, String email, String password) async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) throw NetworkException();
    final user = await _authRepository.signUp(name, email, password);
    await _authRepository.sendEmailVerification();
    return user;
  }
}
