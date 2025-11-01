import 'package:flutter/material.dart';
import 'package:interview_master/core/utils/task_type_helper.dart';
import 'package:interview_master/data/models/task.dart';
import 'package:intl/intl.dart';
import 'package:interview_master/app/widgets/custom_score_indicator.dart';

class TaskPage extends StatelessWidget {
  final Task task;

  const TaskPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Детали задачи')),
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
              title: 'Прогресс',
              value:
                  '${task.currentValue} / ${task.targetValue} ${TaskTypeHelper.getType(task.targetValue, task.type)}',
            ),
            _DetailItem(
              leading: Icon(Icons.schedule),
              title: 'Создана',
              value: DateFormat('dd.MM.yyyy HH:mm').format(task.createdAt),
            ),
            _DetailItem(
              leading: Icon(Icons.check_circle),
              title: 'Завершена',
              value: task.isCompleted
                  ? DateFormat('dd.MM.yyyy HH:mm').format(task.completedAt!)
                  : '?',
            ),
            _DetailItem(
              leading: Icon(Icons.category),
              title: 'Тип',
              value: task.type,
            ),
            _DetailItem(
              leading: Icon(Icons.explore),
              title: 'Направление',
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
