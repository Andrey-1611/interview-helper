import 'package:flutter/material.dart';
import 'package:interview_master/core/utils/time_formatter.dart';
import 'package:interview_master/data/models/user_data.dart';
import '../../../generated/l10n.dart';

class CustomUserInfo extends StatelessWidget {
  final UserData user;

  const CustomUserInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListView(
        children: [
          _InfoCard(
            iconData: Icons.assignment_turned_in,
            title: '${s.directions}: ${user.directions.join(', ')}',
          ),
          _InfoCard(
            iconData: Icons.assignment_turned_in,
            title: '${s.interviews}:  ${user.totalInterviews}',
          ),
          _InfoCard(
            iconData: Icons.score,
            title: '${s.total_score}:  ${user.totalScore} ',
          ),
          _InfoCard(
            iconData: Icons.analytics,
            title: '${s.average_score}:  ${user.averageScore} % ',
          ),
          _InfoCard(
            iconData: Icons.emoji_events,
            title: '${s.best_score}:  ${user.bestScore} %',
          ),
          _InfoCard(
            iconData: Icons.timer,
            title:
                '${s.total_time}:  ${TimeFormatter.time(user.totalDuration, context)}',
          ),
          _InfoCard(
            iconData: Icons.av_timer,
            title:
                '${s.average_time}:  ${TimeFormatter.time(user.averageDuration, context)} ',
          ),
          _InfoCard(
            iconData: Icons.arrow_upward,
            title:
                '${s.max_time}:  ${TimeFormatter.time(user.maxDuration, context)}',
          ),
          _InfoCard(
            iconData: Icons.arrow_downward,
            title:
                '${s.min_time}:  ${TimeFormatter.time(user.minDuration, context)}',
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData iconData;
  final String title;

  const _InfoCard({required this.iconData, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        child: ListTile(
          leading: Icon(iconData),
          title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ),
    );
  }
}
