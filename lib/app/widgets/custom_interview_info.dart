import 'package:flutter/material.dart';
import 'package:interview_master/app/widgets/custom_question_card.dart';
import '../../data/models/interview/interview_data.dart';
import 'custom_main_result_panel.dart';

class CustomInterviewInfo extends StatelessWidget {
  final InterviewData interview;

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
              return CustomQuestionCard(question: interview.questions[index]);
            },
          ),
        ),
      ],
    );
  }
}
