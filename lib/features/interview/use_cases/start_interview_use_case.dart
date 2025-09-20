import 'package:injectable/injectable.dart';
import 'package:interview_master/core/utils/network_info.dart';
import '../../../core/errors/exceptions.dart';
import '../../../data/repositories/local_repository.dart';

@injectable
class StartInterviewUseCase {
  final LocalRepository _localRepository;
  final NetworkInfo _networkInfo;

  StartInterviewUseCase(this._localRepository, this._networkInfo);

  Future<bool> call() async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) throw NetworkException();
    final interviews = await _localRepository.getTotalInterviewsToady();
    if (interviews != 5) return true;
    return false;
  }
}
