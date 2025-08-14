import 'package:flutter/material.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_interview_info.dart';
import '../../data/models/interview.dart';

class InterviewInfoPage extends StatefulWidget {
  const InterviewInfoPage({super.key});

  @override
  State<InterviewInfoPage> createState() => _InterviewInfoPageState();
}

class _InterviewInfoPageState extends State<InterviewInfoPage> {
  late final Interview interview;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    interview = ModalRoute.of(context)!.settings.arguments as Interview;
  }

  @override
  Widget build(BuildContext context) {
    return _InterviewInfoPageView(interview: interview);
  }
}

class _InterviewInfoPageView extends StatelessWidget {
  final Interview interview;

  const _InterviewInfoPageView({required this.interview});

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
