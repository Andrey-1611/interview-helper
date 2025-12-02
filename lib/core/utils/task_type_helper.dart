import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../constants/interviews_data.dart';

class TaskTypeHelper {
  static String getType(int value, String type, BuildContext context) {
    final s = S.of(context);
    return switch (type) {
      InterviewsData.interviews => s.interview_word(value),
      InterviewsData.time => s.minutes_word(value),
      InterviewsData.score => s.points_word(value),
      _ => '',
    };
  }
}
