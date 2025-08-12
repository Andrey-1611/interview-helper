import 'package:flutter/material.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/app/navigation/app_router_names.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_result_panel.dart';
import '../../data/models/interview.dart';
import '../widgets/custom_question_card.dart';

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
        child: Center(
          child: Column(
            children: [
              CustomResultPanel(score: interview.score),
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
          ),
        ),
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
        color: interview.questions[index].isCorrect ? Colors.green : Colors.red,
        score: interview.questions[index].score,
      ),
    );
  }
}
