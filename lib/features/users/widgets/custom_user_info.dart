import 'package:flutter/material.dart';
import 'package:interview_master/core/utils/time_formatter.dart';
import 'package:interview_master/data/models/user_data.dart';

class CustomUserInfo extends StatelessWidget {
  final UserData user;

  const CustomUserInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListView(
        children: [
          _InfoCard(
            iconData: Icons.assignment_turned_in,
            title: 'Направления:  ${user.directions.join(', ')}',
          ),
          _InfoCard(
            iconData: Icons.assignment_turned_in,
            title: 'Собеседования:  ${user.totalInterviews}',
          ),
          _InfoCard(
            iconData: Icons.score,
            title: 'Очки опыта:  ${user.totalScore} ',
          ),
          _InfoCard(
            iconData: Icons.analytics,
            title: 'Средний результат:  ${user.averageScore} % ',
          ),
          _InfoCard(
            iconData: Icons.emoji_events,
            title: 'Лучший результат:  ${user.bestScore} %',
          ),
          _InfoCard(
            iconData: Icons.timer,
            title: 'Общее время:  ${TimeFormatter.time(user.totalDuration)}',
          ),
          _InfoCard(
            iconData: Icons.av_timer,
            title: 'Среднее время:  ${TimeFormatter.time(user.averageDuration)} ',
          ),
          _InfoCard(
            iconData: Icons.arrow_upward,
            title:
                'Максимальное время:  ${TimeFormatter.time(user.maxDuration)}',
          ),
          _InfoCard(
            iconData: Icons.arrow_downward,
            title:
                'Минимальное время:  ${TimeFormatter.time(user.minDuration)}',
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
