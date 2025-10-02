import 'package:injectable/injectable.dart';
import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/data/repositories/auth_repository.dart';
import '../../../../../core/errors/exceptions.dart';

@injectable
class ChangeEmailUseCase {
  final AuthRepository _authRepository;
  final NetworkInfo _networkInfo;

  ChangeEmailUseCase(this._networkInfo, this._authRepository);

  Future<void> call(String email, String password) async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) throw NetworkException();
    await _authRepository.changeEmail(email, password);
    await _authRepository.sendEmailVerification();
  }
}
