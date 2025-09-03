import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';
import '../../../../app/global/models/user_data.dart';
import '../../../../core/errors/network_exception.dart';

class ShowUsersUseCase {
  final RemoteRepository _remoteRepository;
  final NetworkInfo _networkInfo;

  ShowUsersUseCase(this._remoteRepository, this._networkInfo);

  Future<List<UserData>> call() async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      throw NetworkException();
    }
    return await _remoteRepository.showUsers();
  }
}
