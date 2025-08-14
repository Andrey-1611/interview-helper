import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        _AverageScoreContainer(interview: interview),
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

class _AverageScoreContainer extends StatelessWidget {
  final Interview interview;

  const _AverageScoreContainer({required this.interview});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0.sp),
        border: Border.all(color: Colors.blue, width: 4.0.sp),
      ),
      child: Text(
        'Результат: ${interview.score.toInt()} %',
        style: Theme.of(context).textTheme.displayLarge,
      ),
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
