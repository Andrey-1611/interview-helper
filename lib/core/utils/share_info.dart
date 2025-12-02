import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:interview_master/core/constants/app_data.dart';
import 'package:interview_master/data/models/interview_data.dart';
import 'package:interview_master/generated/l10n.dart';
import 'package:share_plus/share_plus.dart';

@lazySingleton
class ShareInfo {
  final SharePlus _sharePlus;

  ShareInfo(this._sharePlus);

  void shareInterviewResults(InterviewData interview, BuildContext context) {
    final s = S.of(context);
    _sharePlus.share(
      ShareParams(
        text: s.share_interview_results(
          interview.direction,
          interview.difficulty,
          interview.score,
          AppData.url,
        ),
      ),
    );
  }
}
