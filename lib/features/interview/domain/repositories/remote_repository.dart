import '../../../../app/global/models/user_data.dart';
import '../../data/models/interview.dart';

abstract interface class RemoteRepository {
  Future<void> saveUser(UserData user);

  Future<List<UserData>> showUsers();

  Future<UserData> getUserData(String userId);

  Future<void> addInterview(Interview interview, UserData updatedUser);

  Future<List<Interview>> showInterviews(String userId);
}
