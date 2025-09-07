import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/interview/domain/repositories/local_repository.dart';

import '../../../../core/errors/exceptions.dart';

class SignOutUseCase {
  final AuthRepository _authRepository;
  final LocalRepository _localRepository;
  final NetworkInfo _networkInfo;

  SignOutUseCase(
    this._authRepository,
    this._localRepository,
    this._networkInfo,
  );

  Future<void> call() async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) throw NetworkException();
    await _authRepository.signOut();
    await _localRepository.deleteUser();
  }
}
