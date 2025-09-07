import 'package:interview_master/app/global/models/user_data.dart';
import 'package:interview_master/features/interview/data/models/interview.dart';

abstract interface class LocalRepository {
  Future<void> loadInterviews(List<Interview> interviews);

  Future<void> addInterview(Interview interview);

  Future<List<Interview>> showInterviews();

  Future<void> loadUser(UserData user);

  Future<UserData?> getUser();

  Future<void> deleteUser();
}
