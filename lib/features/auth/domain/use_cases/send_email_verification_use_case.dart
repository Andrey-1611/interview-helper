import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import '../../../../core/errors/network_exception.dart';

class SendEmailVerificationUseCase {
  final AuthRepository _authRepository;
  final NetworkInfo _networkInfo;

  SendEmailVerificationUseCase(this._authRepository, this._networkInfo);

  Future<void> call() async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      throw NetworkException();
    }
    await _authRepository.sendEmailVerification();
  }
}