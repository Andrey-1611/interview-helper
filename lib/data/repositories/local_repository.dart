import '../../data/models/interview.dart';
import '../../data/models/user_data.dart';

abstract interface class LocalRepository {
  Future<void> loadInterviews(List<Interview> interviews);

  Future<void> addInterview(Interview interview, UserData updatedUser);

  Future<List<Interview>> showInterviews();

  Future<void> loadUser(UserData user);

  Future<UserData?> getUser();

  Future<void> deleteUser();

  Future<int> getTotalInterviewsToady();
}
