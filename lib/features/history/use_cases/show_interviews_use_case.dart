import 'package:injectable/injectable.dart';
import 'package:interview_master/core/utils/network_info.dart';
import '../../../core/errors/exceptions.dart';
import '../../../data/models/interview/interview_data.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';

@injectable
class ShowInterviewsUseCase {
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;
  final NetworkInfo _networkInfo;

  ShowInterviewsUseCase(this._remoteRepository,
      this._localRepository,
      this._networkInfo,);

  Future<List<InterviewData>> call(String? userId) async {
    if (userId != null) {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) throw NetworkException();
      return await _remoteRepository.showInterviews(userId);
    }
    return await _localRepository.showInterviews();
  }
}
