import 'package:flutter/material.dart';
import '../../../app/widgets/custom_info_card.dart';
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
