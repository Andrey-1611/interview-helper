import 'package:flutter/material.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_main_result_panel.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../data/models/interview.dart';
import 'custom_question_card.dart';

class CustomInterviewInfo extends StatelessWidget {
  final Interview interview;

  const CustomInterviewInfo({super.key, required this.interview});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomMainResultPanel(text: 'Результат: ${interview.score} %',),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: interview.questions.length,
            itemBuilder: (context, index) {
              return _QuestionCard(interview: interview, index: index);
            },
          ),
        ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final Interview interview;
  final int index;

  const _QuestionCard({required this.interview, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRouter.pushNamed(
          AppRouterNames.questionInfo,
          arguments: interview.questions[index],
        );
      },
      child: CustomQuestionCard(
        text: 'Вопрос ${interview.questions[index].question}',
        isQuestionCard: true,
        score: interview.questions[index].score,
      ),
    );
  }
}
