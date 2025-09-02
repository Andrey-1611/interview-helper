import 'package:interview_master/features/auth/data/models/my_user.dart';
import 'package:interview_master/features/interview/data/models/interview.dart';

abstract interface class LocalRepository {
  Future<void> loadInterviews(List<Interview> interviews);

  Future<void> addInterview(Interview interview);

  Future<List<Interview>> showInterviews();

  Future<void> loadUser(MyUser user);

  Future<MyUser?> getUser();

  Future<void> deleteUser();
}
