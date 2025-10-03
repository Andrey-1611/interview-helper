import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/interview/question.dart';
import '../router/app_router_names.dart';
import 'custom_score_indicator.dart';

class CustomQuestionCard extends StatelessWidget {
  final Question question;

  const CustomQuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRouterNames.questionInfo, extra: question),
      child: Card(
        child: ListTile(
          leading: CustomScoreIndicator(score: question.score),
          title: Text('Вопрос ${question.question}'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
