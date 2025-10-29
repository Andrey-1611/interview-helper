import 'package:flutter/material.dart';
import '../../../app/widgets/custom_info_card.dart';
import '../../../data/models/question.dart';

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
              _MainResultPanel(result: 'Точность: ${question.score} %'),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
              CustomInfoCard(
                titleText: 'Вопрос:',
                subtitleText: question.question,
              ),
              CustomInfoCard(
                titleText: 'Ваш ответ:',
                subtitleText: question.userAnswer,
              ),
              CustomInfoCard(
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

class _MainResultPanel extends StatelessWidget {
  final String result;

  const _MainResultPanel({required this.result});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Container(
        alignment: Alignment.center,
        width: size.width,
        height: size.height * 0.2,
        child: Center(child: Text(result, style: textTheme.displayLarge)),
      ),
    );
  }
}
