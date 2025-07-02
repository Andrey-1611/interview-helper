import '../../models/interview.dart';

abstract interface class LocalDataSourceInterface {
  Future<void> addInterview(Interview interview);
  Future<List<Interview>> showInterviews();
}
