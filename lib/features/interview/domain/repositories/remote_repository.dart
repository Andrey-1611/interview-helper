import '../../data/models/interview.dart';

abstract interface class RemoteRepository {
  Future<void> addInterview(Interview interview, String userId);
  Future<List<Interview>> showInterviews(String userId);
}
