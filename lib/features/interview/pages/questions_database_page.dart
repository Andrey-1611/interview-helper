import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/router/app_router_names.dart';
import 'package:interview_master/core/constants/interviews_data.dart';
import '../../../core/constants/direction.dart';
import '../../../generated/l10n.dart';

class QuestionsDatabasePage extends StatelessWidget {
  const QuestionsDatabasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).questions_database)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 1.4,
        ),
        itemCount: InterviewsData.directions.length,
        itemBuilder: (context, index) {
          final direction = Direction(
            direction: InterviewsData.directions[index],
          );
          return GestureDetector(
            onTap: () => context.push(
              AppRouterNames.directionQuestionsDatabase,
              extra: direction,
            ),
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    direction.direction,
                    style: theme.textTheme.displayMedium,
                  ),
                  Text(s.questions_count(direction.questions.length)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
