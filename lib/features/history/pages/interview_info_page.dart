import 'package:flutter/material.dart';
import '../../../../app/widgets/custom_interview_info.dart';
import '../../../data/models/interview/interview_data.dart';

class InterviewInfoPage extends StatelessWidget {
  final InterviewData interview;

  const InterviewInfoPage({super.key, required this.interview});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomInterviewInfo(interview: interview),
      ),
    );
  }
}
