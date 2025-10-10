import 'package:injectable/injectable.dart';
import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/data/repositories/remote_repository.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/local_repository.dart';

@injectable
class SignOutUseCase {
  final AuthRepository _authRepository;
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;
  final NetworkInfo _networkInfo;

  SignOutUseCase(
    this._authRepository,
    this._remoteRepository,
    this._localRepository,
    this._networkInfo,
  );

  Future<void> call() async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) throw NetworkException();
    final user = await _localRepository.getUser();
    final interviews = await _localRepository.showInterviews();
    await _remoteRepository.updateInterviews(user!.id, interviews);
    await _authRepository.signOut();
    await _localRepository.deleteData();
  }
}
