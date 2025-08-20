import '../../../../app/global/models/user_data.dart';
import '../../data/models/interview.dart';

abstract interface class RemoteRepository {
  Future<void> saveUser(UserData user);
  Future<List<UserData>> showUsers();
  Future<void> addInterview(Interview interview, String userId);
  Future<List<Interview>> showInterviews(String userId);
}
