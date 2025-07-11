import '../../models/interview.dart';

abstract interface class FirebaseFirestoreDataSourceInterface {
  Future<void> addInterview(Interview interview);
  Future<List<Interview>> showInterviews();
}
