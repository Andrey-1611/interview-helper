import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:interview_master/core/constants/hive_boxes.dart';
import 'package:interview_master/features/interview/data/models/interview.dart';

class HiveDataSource {
  final HiveInterface _hive;

  HiveDataSource(this._hive);

  Box<Interview> get _interviewsBox =>
      _hive.box<Interview>(HiveBoxes.interviews);

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

  Future<void> addInterview(Interview interview) async {
    try {
      await _interviewsBox.put(interview.id, interview);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<Interview>> showInterviews() async {
    try {
      return _interviewsBox.values.toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
