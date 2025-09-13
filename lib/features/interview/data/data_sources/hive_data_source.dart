import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interview_master/app/global/models/user_data.dart';
import 'package:interview_master/core/constants/hive_data.dart';
import 'package:interview_master/features/interview/data/models/interview.dart';

class HiveDataSource {
  final HiveInterface _hive;

  HiveDataSource(this._hive);

  Box<Interview> get _interviewsBox =>
      _hive.box<Interview>(HiveData.interviews);

  Box<UserData> get _usersBox => _hive.box<UserData>(HiveData.user);

  Future<void> loadInterviews(List<Interview> interviews) async {
    try {
      await _interviewsBox.clear();
      final data = {
        for (final interview in interviews) interview.id: interview,
      };
      await _interviewsBox.putAll(data);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> addInterview(Interview interview, UserData updatedUser) async {
    try {
      await _interviewsBox.put(interview.id, interview);
      await _usersBox.put(HiveData.userKey, updatedUser);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<Interview>> showInterviews() async {
    try {
      final interviews = _interviewsBox.values.toList();
      interviews.sort((a, b) => b.date.compareTo(a.date));
      return interviews;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> loadUser(UserData user) async {
    try {
      await _usersBox.put(HiveData.userKey, user);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<UserData?> getUser() async {
    try {
      return _usersBox.get(HiveData.userKey);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deleteUser() async {
    try {
      await _usersBox.delete(HiveData.userKey);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

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
