import '../models/interview.dart';

abstract interface class FirestoreRepository {
  Future<void> addInterview(Interview interview);
  Future<List<Interview>> showInterviews();
}
