import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/features/interview/data/models/interview.dart';
import 'package:interview_master/features/interview/domain/repositories/local_repository.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';
import '../../../../core/errors/network_exception.dart';

class ShowInterviewsUseCase {
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;
  final NetworkInfo _networkInfo;

  ShowInterviewsUseCase(this._remoteRepository,
      this._localRepository,
      this._networkInfo,);

  Future<List<Interview>> call(String? userId) async {
    if (userId != null) {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        throw NetworkException();
      }
      return await _remoteRepository.showInterviews(userId);
    }
    return await _localRepository.showInterviews();
  }
}
