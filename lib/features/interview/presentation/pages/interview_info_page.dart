import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/app/navigation/app_router_names.dart';
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
          ),
        ),
      ),
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
        trailing: true,
      ),
    );
  }
}
