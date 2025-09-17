import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_router_names.dart';
import '../../data/models/interview.dart';
import '../../data/models/question.dart';
import 'custom_main_result_panel.dart';
import 'custom_score_indicator.dart';

class CustomInterviewInfo extends StatelessWidget {
  final Interview interview;

  const CustomInterviewInfo({super.key, required this.interview});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomMainResultPanel(
          type: '${interview.direction}, ${interview.difficulty}',
          text: 'Результат: ${interview.score} %',
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: interview.questions.length,
            itemBuilder: (context, index) {
              return _QuestionCard(question: interview.questions[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final Question question;

  const _QuestionCard({required this.question});

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
