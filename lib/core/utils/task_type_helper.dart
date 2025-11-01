import '../constants/interviews_data.dart';

class TaskTypeHelper {
  static String getType(int value, String type) {
    switch (type) {
      case InterviewsData.interviews:
        return _getInterviewWord(value);
      case InterviewsData.time:
        return _getTimeWord(value);
      case InterviewsData.score:
        return _getScoreWord(value);
      default:
        return '';
    }
  }

  static String _getInterviewWord(int value) {
    if (value % 10 == 1 && value % 100 != 11) return 'собеседование';
    if (value % 10 >= 2 &&
        value % 10 <= 4 &&
        (value % 100 < 10 || value % 100 >= 20)) {
      return 'собеседования';
    }
    return 'собеседований';
  }

  static String _getTimeWord(int value) {
    if (value % 10 == 1 && value % 100 != 11) return 'минута';
    if (value % 10 >= 2 &&
        value % 10 <= 4 &&
        (value % 100 < 10 || value % 100 >= 20)) {
      return 'минуты';
    }
    return 'минут';
  }

  static String _getScoreWord(int value) {
    if (value % 10 == 1 && value % 100 != 11) return 'очко';
    if (value % 10 >= 2 &&
        value % 10 <= 4 &&
        (value % 100 < 10 || value % 100 >= 20)) {
      return 'очка';
    }
    return 'очков';
  }
}
