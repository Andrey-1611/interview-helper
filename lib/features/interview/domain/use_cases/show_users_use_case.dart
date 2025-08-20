import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';

import '../../../../app/global/models/user_data.dart';

class ShowUsersUseCase {
  final RemoteRepository _remoteRepository;

  ShowUsersUseCase(this._remoteRepository);

  Future<List<UserData>> call() async {
    return await _remoteRepository.showUsers();
  }

}