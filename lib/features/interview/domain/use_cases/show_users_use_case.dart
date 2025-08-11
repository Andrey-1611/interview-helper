import 'package:interview_master/app/global_services/user/data/models/user_data.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';

class ShowUsersUseCase {
  final RemoteRepository _remoteRepository;

  ShowUsersUseCase(this._remoteRepository);

  Future<List<UserData>> call() async {
    return await _remoteRepository.showUsers();
  }

}