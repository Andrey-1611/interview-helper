import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:interview_master/core/constants/hive_data.dart';
import 'package:interview_master/core/constants/interviews_data.dart';
import 'package:interview_master/data/models/question.dart';
import 'package:interview_master/data/models/task.dart';
import '../../models/interview_data.dart';
import '../../models/user_data.dart';
import 'local_repository.dart';

@LazySingleton(as: LocalRepository)
class LocalDataSource implements LocalRepository {
  final HiveInterface _hive;

  LocalDataSource(this._hive);

  Box<InterviewData> get _interviewsBox =>
      _hive.box<InterviewData>(HiveData.interviewsBox);

  Box<UserData> get _usersBox => _hive.box<UserData>(HiveData.userBox);

  Box<Task> get _tasksBox => _hive.box<Task>(HiveData.tasksBox);

  @override
  Future<void> loadInterviews(List<InterviewData> interviews) async {
    final data = {for (final interview in interviews) interview.id: interview};
    await _interviewsBox.putAll(data);
  }

  @override
  Future<void> addInterview(
    InterviewData interview,
    UserData updatedUser,
  ) async {
    await _interviewsBox.put(interview.id, interview);
    await _usersBox.put(HiveData.userKey, updatedUser);

    final tasks = _tasksBox.values.toList();
    final filteredTasks = tasks.where(
      (task) => task.direction == interview.direction,
    );

    final updatedTasks = filteredTasks.map((task) {
      final addValue = switch (task.type) {
        InterviewsData.interviews => 1,
        InterviewsData.time => interview.duration.inMinutes,
        InterviewsData.score => interview.score,
        _ => 0,
      };

      final value = task.currentValue + addValue;
      final isCompleted = value >= task.targetValue;
      final completedAt = !task.isCompleted && isCompleted
          ? DateTime.now()
          : task.completedAt;
      return task.copyWith(currentValue: value, completedAt: completedAt);
    }).toList();

    final data = {for (final task in updatedTasks) task.id: task};
    await _tasksBox.putAll(data);
  }

  @override
  Future<List<InterviewData>> getInterviews() async {
    final interviews = _interviewsBox.values.toList();
    interviews.sort((a, b) => b.date.compareTo(a.date));
    return interviews;
  }

  @override
  Future<void> loadUser(UserData user) async {
    await _usersBox.put(HiveData.userKey, user);
  }

  @override
  Future<UserData?> getUser() async {
    return _usersBox.get(HiveData.userKey);
  }

  @override
  Future<void> deleteData() async {
    await _usersBox.clear();
    await _interviewsBox.clear();
  }

  @override
  Future<int> getTotalInterviewsToady() async {
    final interviews = _interviewsBox.values.toList();
    final time = DateTime.now();
    final todayInterviews = interviews.where(
      (interview) =>
          interview.date.year == time.year &&
          interview.date.month == time.month &&
          interview.date.day == time.day,
    );
    return todayInterviews.length;
  }

  @override
  Future<void> changeIsFavouriteInterview(String id) async {
    final interview = (_interviewsBox.get(id))!;
    final newInterview = interview.copyWith(
      isFavourite: !interview.isFavourite,
    );
    _interviewsBox.put(id, newInterview);
  }

  @override
  Future<void> changeIsFavouriteQuestion(String id) async {
    for (final interview in _interviewsBox.values) {
      final index = interview.questions.indexWhere((q) => q.id == id);
      if (index != -1) {
        final questions = List<Question>.from(interview.questions);
        questions[index] = questions[index].copyWith(
          isFavourite: !questions[index].isFavourite,
        );
        await _interviewsBox.put(
          interview.id,
          interview.copyWith(questions: questions),
        );
        return;
      }
    }
  }

  @override
  Future<void> createTask(Task task) async {
    await _tasksBox.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _tasksBox.delete(id);
  }

  @override
  Future<List<Task>> getTasks() async {
    final tasks = _tasksBox.values.toList();
    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return tasks;
  }

  @override
  Future<void> loadTasks(List<Task> tasks) async {
    final data = {for (final task in tasks) task.id: task};
    await _tasksBox.putAll(data);
  }
}
