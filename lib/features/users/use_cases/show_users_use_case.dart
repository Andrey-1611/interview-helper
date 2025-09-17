import 'package:injectable/injectable.dart';
import 'package:interview_master/core/utils/network_info.dart';
import '../../../core/errors/exceptions.dart';
import '../../../data/models/user_data.dart';
import '../../../data/repositories/remote_repository.dart';

@injectable
class ShowUsersUseCase {
  final RemoteRepository _remoteRepository;
  final NetworkInfo _networkInfo;

  ShowUsersUseCase(this._remoteRepository, this._networkInfo);

  Future<List<UserData>> call() async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) throw NetworkException();
    return await _remoteRepository.showUsers();
  }
}
