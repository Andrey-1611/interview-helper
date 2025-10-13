import 'package:flutter/material.dart';
import 'package:interview_master/app/widgets/custom_question_card.dart';
import 'package:interview_master/core/utils/time_formatter.dart';
import '../../data/models/interview/interview_data.dart';

class CustomInterviewInfo extends StatelessWidget {
  final InterviewData interview;

  const CustomInterviewInfo({super.key, required this.interview});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _MainResultPanel(
          data:
              '${interview.direction}, ${interview.difficulty}, ${interview.score} %',
          duration: 'Время:  ${TimeFormatter.time(interview.duration)}',
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: interview.questions.length,
            itemBuilder: (context, index) {
              return CustomQuestionCard(
                question: interview.questions[index],
                isCurrentUser: false,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MainResultPanel extends StatelessWidget {
  final String data;
  final String duration;

  const _MainResultPanel({required this.duration, required this.data});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Container(
        alignment: Alignment.center,
        width: size.width,
        height: size.height * 0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(data, style: textTheme.displayLarge),
            SizedBox(height: size.height * 0.01),
            Text(duration, style: textTheme.displaySmall),
          ],
        ),
      ),
    );
  }
}
