import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:interview_master/core/constants/hive_data.dart';
import '../models/interview/interview_data.dart';
import '../models/user/user_data.dart';
import '../repositories/local_repository.dart';

@LazySingleton(as: LocalRepository)
class HiveDataSource implements LocalRepository {
  final HiveInterface _hive;

  HiveDataSource(this._hive);

  Box<InterviewData> get _interviewsBox =>
      _hive.box<InterviewData>(HiveData.interviews);

  Box<UserData> get _usersBox => _hive.box<UserData>(HiveData.user);

  @override
  Future<void> loadInterviews(List<InterviewData> interviews) async {
    try {
      final data = {
        for (final interview in interviews) interview.id: interview,
      };
      await _interviewsBox.putAll(data);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> addInterview(
    InterviewData interview,
    UserData updatedUser,
  ) async {
    try {
      await _interviewsBox.put(interview.id, interview);
      await _usersBox.put(HiveData.userKey, updatedUser);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<InterviewData>> showInterviews() async {
    try {
      final interviews = _interviewsBox.values.toList();
      interviews.sort((a, b) => b.date.compareTo(a.date));
      return interviews;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> loadUser(UserData user) async {
    try {
      await _usersBox.put(HiveData.userKey, user);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserData?> getUser() async {
    try {
      return _usersBox.get(HiveData.userKey);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> deleteData() async {
    try {
      await _usersBox.clear();
      await _interviewsBox.clear();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<int> getTotalInterviewsToady() async {
    try {
      final interviews = _interviewsBox.values.toList();
      final time = DateTime.now();
      final todayInterviews = interviews.where(
        (interview) =>
            interview.date.year == time.year &&
            interview.date.month == time.month &&
            interview.date.day == time.day,
      );
      return todayInterviews.length;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
