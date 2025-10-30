import 'package:injectable/injectable.dart';
import 'package:interview_master/core/constants/app_data.dart';
import 'package:interview_master/data/models/interview_data.dart';
import 'package:share_plus/share_plus.dart';

@lazySingleton
class ShareInfo {
  final SharePlus _sharePlus;

  ShareInfo(this._sharePlus);

  void shareInterviewResults(InterviewData interview) {
    _sharePlus.share(
      ShareParams(
        text:
            '🎯 Результаты моего интервью\n\n'
            '📊 ${interview.direction}, ${interview.difficulty}\n'
            '⭐ Результат: ${interview.score}%\n\n'
            '🔗 ${AppData.url}\n\n'
            'Сможешь побить? 💪',
      ),
    );
  }
}
