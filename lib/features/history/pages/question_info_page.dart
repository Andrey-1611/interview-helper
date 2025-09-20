import 'package:flutter/material.dart';
import '../../../data/models/interview/question.dart';
import '../../../app/widgets/custom_main_result_panel.dart';

class QuestionInfoPage extends StatelessWidget {
  final Question question;

  const QuestionInfoPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ListView(
            children: [
              CustomMainResultPanel(text: 'Точность: ${question.score} %'),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
              _InfoCard(titleText: 'Вопрос:', subtitleText: question.question),
              _InfoCard(
                titleText: 'Ваш ответ:',
                subtitleText: question.userAnswer,
              ),
              _InfoCard(
                titleText: 'Правильный ответ:',
                subtitleText: question.correctAnswer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String titleText;
  final String subtitleText;

  const _InfoCard({required this.titleText, required this.subtitleText});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: ListTile(
        title: Text(titleText, style: textTheme.displayMedium),
        subtitle: Text(subtitleText, style: textTheme.bodyLarge),
      ),
    );
  }
}
