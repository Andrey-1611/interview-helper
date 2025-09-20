import 'package:injectable/injectable.dart';
import 'package:interview_master/core/utils/network_info.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../data/repositories/auth_repository.dart';

@injectable
class SendEmailVerificationUseCase {
  final AuthRepository _authRepository;
  final NetworkInfo _networkInfo;

  SendEmailVerificationUseCase(this._authRepository, this._networkInfo);

  Future<void> call() async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) throw NetworkException();
    await _authRepository.sendEmailVerification();
  }
}
