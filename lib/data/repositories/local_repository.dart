import '../models/interview/interview_data.dart';
import '../models/user/user_data.dart';

abstract interface class LocalRepository {
  Future<void> loadInterviews(List<InterviewData> interviews);

  Future<void> addInterview(InterviewData interview, UserData updatedUser);

  Future<List<InterviewData>> showInterviews();

  Future<void> loadUser(UserData user);

  Future<UserData?> getUser();

  Future<void> deleteData();

  Future<int> getTotalInterviewsToady();

  Future<void> changeIsFavouriteInterview(String id);

  Future<void> changeIsFavouriteQuestion(String id);
}
