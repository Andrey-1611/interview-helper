import 'package:flutter/material.dart';
import 'package:interview_master/core/utils/localization_data.dart';
import 'package:interview_master/core/utils/task_type_helper.dart';
import 'package:interview_master/data/models/task.dart';
import 'package:intl/intl.dart';
import 'package:interview_master/app/widgets/custom_score_indicator.dart';

import '../../../generated/l10n.dart';

class TaskPage extends StatelessWidget {
  final Task task;

  const TaskPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.task_details)),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailItem(
              leading: CustomScoreIndicator(
                score: task.progress,
                height: size.height * 0.05,
              ),
              title: s.progress,
              value:
                  '${task.currentValue} / ${task.targetValue} ${TaskTypeHelper.getType(task.targetValue, task.type, context)}',
            ),
            _DetailItem(
              leading: Icon(Icons.schedule),
              title: s.created,
              value: DateFormat('dd.MM.yyyy HH:mm').format(task.createdAt),
            ),
            _DetailItem(
              leading: Icon(Icons.check_circle),
              title: s.created,
              value: task.isCompleted
                  ? DateFormat('dd.MM.yyyy HH:mm').format(task.completedAt!)
                  : '?',
            ),
            _DetailItem(
              leading: Icon(Icons.category),
              title: s.type,
              value: LocalizationData(s).type(task.type),
            ),
            _DetailItem(
              leading: Icon(Icons.explore),
              title: s.direction,
              value: task.direction,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final Widget leading;
  final String title;
  final String value;

  const _DetailItem({
    required this.leading,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: leading,
        title: Text(title, style: theme.textTheme.bodyMedium),
        subtitle: Text(value, style: theme.textTheme.bodyLarge),
      ),
    );
  }
}
