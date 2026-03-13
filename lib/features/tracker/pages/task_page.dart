import 'package:flutter/material.dart';
import 'package:interview_master/core/utils/extentions.dart';
import 'package:interview_master/data/models/task.dart';
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
                  '${task.currentValue} / ${task.targetValue} ${task.type.localizedWord(task.targetValue, s)}',
            ),
            _DetailItem(
              leading: Icon(Icons.schedule),
              title: s.created,
              value: task.createdAt.hourFormat,
            ),
            _DetailItem(
              leading: Icon(Icons.check_circle),
              title: s.created,
              value: task.isCompleted ? task.completedAt!.hourFormat : '?',
            ),
            _DetailItem(
              leading: Icon(Icons.category),
              title: s.type,
              value: task.type.localizedName(s),
            ),
            _DetailItem(
              leading: Icon(Icons.explore),
              title: s.direction,
              value: task.direction.name,
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
