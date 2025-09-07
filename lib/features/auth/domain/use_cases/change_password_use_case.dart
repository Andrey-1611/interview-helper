import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import '../../../../core/errors/exceptions.dart';
import '../../data/models/my_user.dart';

class ChangePasswordUseCase {
  final AuthRepository _authRepository;
  final NetworkInfo _networkInfo;

  ChangePasswordUseCase(this._authRepository, this._networkInfo);

  Future<void> call(MyUser user) async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) throw NetworkException();
    await _authRepository.changePassword(user);
  }
}
