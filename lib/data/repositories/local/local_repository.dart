import 'package:interview_master/data/models/task.dart';
import '../../models/interview_data.dart';
import '../../models/user_data.dart';

abstract interface class LocalRepository {
  Future<void> loadInterviews(List<InterviewData> interviews);

  Future<void> addInterview(InterviewData interview, UserData updatedUser);

  Future<List<InterviewData>> getInterviews();

  Future<void> loadUser(UserData user);

  Future<UserData?> getUser();

  Future<void> deleteData();

  Future<int> getTotalInterviewsToady();

  Future<void> changeIsFavouriteInterview(String id);

  Future<void> changeIsFavouriteQuestion(String id);

  Future<void> createTask(Task task);

  Future<List<Task>> getTasks();

  Future<void> deleteTask(String id);

  Future<void> loadTasks(List<Task> tasks);
}
