import 'package:interview_master/features/auth/data/models/email_verification_result.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/interview/domain/repositories/local_repository.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';

import '../../data/models/my_user.dart';

class GetCurrentUserUseCase {
  final AuthRepository _authRepository;
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;

  GetCurrentUserUseCase(
    this._authRepository,
    this._remoteRepository,
    this._localRepository,
  );

  Future<MyUser?> call() async {
    EmailVerificationResult? result;
    final user = await _authRepository.getUser();
    if (user != null) {
      result = await _authRepository.checkEmailVerified();
      if (result!.isEmailVerified) {
        final interviews = await _remoteRepository.showInterviews(user.id!);
        _localRepository.loadInterviews(interviews);
        return user;
      }
      await _authRepository.signOut();
      return null;
    }
    return null;
  }
}
