import '../models/interview.dart';

abstract interface class FirestoreRepository {
  Future<void> addInterview(Interview interview, String userId);
  Future<List<Interview>> showInterviews(String userId);
}
