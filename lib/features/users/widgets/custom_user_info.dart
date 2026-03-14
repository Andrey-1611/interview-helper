import 'package:flutter/material.dart';
import 'package:interview_master/app/widgets/custom_info_bloc.dart';
import 'package:interview_master/app/widgets/custom_info_row.dart';
import 'package:interview_master/core/utils/extentions.dart';
import 'package:interview_master/data/models/user_data.dart';
import '../../../generated/l10n.dart';

class CustomUserInfo extends StatelessWidget {
  final UserData user;

  const CustomUserInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Padding(
      padding: const .symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListView(
        children: [
          InfoBloc(
            title: s.results_data,
            children: [
              InfoRow(
                title: s.directions,
                value: user.directions.map((d) => d.name).toList().join(', '),
              ),
              InfoRow(
                title: s.interview,
                value: user.totalInterviews.toString(),
              ),
              InfoRow(title: s.total_score, value: user.totalScore.toString()),
              InfoRow(title: s.average_score, value: user.averageScore.percent),
              InfoRow(title: s.best_score, value: user.bestScore.percent),
            ],
          ),
          InfoBloc(
            title: s.time_data,
            children: [
              InfoRow(title: s.total_time, value: user.totalDuration.time),
              InfoRow(title: s.average_time, value: user.averageDuration.time),
              InfoRow(title: s.max_time, value: user.maxDuration.time),
              InfoRow(title: s.min_time, value: user.minDuration.time),
            ],
          ),
        ],
      ),
    );
  }
}
