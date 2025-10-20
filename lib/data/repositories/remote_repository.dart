import '../models/interview/interview_data.dart';
import '../models/user/user_data.dart';

abstract interface class RemoteRepository {
  Future<void> saveUser(UserData user);

  Future<List<UserData>> getUsers();

  Future<UserData> getUserData(String userId);

  Future<void> addInterview(InterviewData interview, UserData updatedUser);

  Future<List<InterviewData>> getInterviews(String userId);

  Future<void> updateInterviews(String userId, List<InterviewData> interviews);
}
