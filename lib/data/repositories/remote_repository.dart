import 'package:interview_master/data/models/friend_request.dart';
import 'package:interview_master/data/models/task.dart';
import '../models/interview_data.dart';
import '../models/user_data.dart';

abstract interface class RemoteRepository {
  Future<void> setUser(UserData user);

  Future<List<UserData>> getUsers();

  Future<List<UserData>> getFriends(List<String> friendsId);

  Future<UserData> getUserData(String userId);

  Future<void> addInterview(InterviewData interview, UserData updatedUser);

  Future<List<InterviewData>> getInterviews(String userId);

  Future<void> updateInterviews(String userId, List<InterviewData> interviews);

  Future<void> updateTasks(String userId, List<Task> tasks);

  Future<List<Task>> getTasks(String userId);

  Future<void> sendFriendRequest(FriendRequest request);

  Future<List<FriendRequest>> getFriendRequests(String userId);

  Future<void> updateFriendRequest(FriendRequest request);

  Future<List<UserData>> getUsersByIds(List<String> ids);
}
