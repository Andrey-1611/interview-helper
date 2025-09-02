import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/interview/domain/repositories/local_repository.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';
import '../../data/models/my_user.dart';
import '../../../../app/global/models/user_data.dart';

class WatchEmailVerifiedUseCase {
  final AuthRepository _authRepository;
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;

  WatchEmailVerifiedUseCase(
    this._authRepository,
    this._remoteRepository,
    this._localRepository,
  );

  Future<MyUser> call() async {
    final result = await _authRepository.watchEmailVerified();
    await _remoteRepository.saveUser(UserData.fromMyUser(result!.user!));
    await _localRepository.loadUser(result.user!);
    return result.user!;
  }
}
