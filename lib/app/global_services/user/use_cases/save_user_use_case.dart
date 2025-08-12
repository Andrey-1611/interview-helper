import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';

import '../models/user_data.dart';

class SaveUserUseCase {
  final RemoteRepository _remoteRepository;

  SaveUserUseCase(this._remoteRepository);

  Future<void> call(UserData user) async {
    await _remoteRepository.saveUser(user);
  }
}