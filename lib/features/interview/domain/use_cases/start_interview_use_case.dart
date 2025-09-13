import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/features/interview/domain/repositories/local_repository.dart';
import '../../../../core/errors/exceptions.dart';

class StartInterviewUseCase {
  final LocalRepository _localRepository;
  final NetworkInfo _networkInfo;

  StartInterviewUseCase(this._localRepository, this._networkInfo);

  Future<bool> call() async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) throw NetworkException();
    final interviews = await _localRepository.getTotalInterviewsToady();
    if (interviews != 3) return true;
    return false;
  }
}
