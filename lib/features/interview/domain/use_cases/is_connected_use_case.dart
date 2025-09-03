import 'package:interview_master/core/utils/network_info.dart';

class IsConnectedUseCase {
  final NetworkInfo _networkInfo;

  IsConnectedUseCase(this._networkInfo);

  Future<bool> call() async {
    return await _networkInfo.isConnected;
  }
}
