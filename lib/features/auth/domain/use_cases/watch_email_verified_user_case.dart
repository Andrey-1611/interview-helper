import 'package:interview_master/app/global_services/user/models/my_user.dart';
import 'package:interview_master/app/global_services/user/models/user_data.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';

class WatchEmailVerifiedUseCase {
  final AuthRepository _authRepository;
  final RemoteRepository _remoteRepository;

  WatchEmailVerifiedUseCase(this._authRepository, this._remoteRepository);

  Future<MyUser> call() async {
    final result = await _authRepository.watchEmailVerified();
    await _remoteRepository.saveUser(UserData.fromMyUser(result!.user!));
    return result.user!;
  }
}
