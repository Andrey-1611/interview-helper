import 'package:interview_master/app/global_services/user/data/models/user_data.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';

class SaveUserUseCase {
  final RemoteRepository _remoteRepository;

  SaveUserUseCase(this._remoteRepository);

  Future<void> call(UserData user) async {
    await _remoteRepository.saveUser(user);
  }
}