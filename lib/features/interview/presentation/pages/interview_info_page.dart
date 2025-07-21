import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/interview.dart';
import '../widgets/custom_interview_card.dart';

class InterviewInfoPage extends StatefulWidget {
  const InterviewInfoPage({super.key});

  @override
  State<InterviewInfoPage> createState() => _InterviewInfoPageState();
}

class _InterviewInfoPageState extends State<InterviewInfoPage> {
  final List<bool> _isShow = List.generate(10, (_) => false);
  late final Interview interview;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    interview = ModalRoute.of(context)!.settings.arguments as Interview;
  }

  @override
  Widget build(BuildContext context) {
    return _InterviewInfoPageView(
      interview: interview,
      isShow: _isShow,
      changeShow: _changeShow,
    );
  }

  void _changeShow(int index) {
    setState(() {
      _isShow[index] = !_isShow[index];
    });
  }
}

class _InterviewInfoPageView extends StatelessWidget {
  final Interview interview;
  final List<bool> isShow;
  final ValueChanged<int> changeShow;

  const _InterviewInfoPageView({
    required this.interview,
    required this.isShow,
    required this.changeShow,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: [
              _AverageScoreContainer(interview: interview),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: interview.questions.length,
                  itemBuilder: (context, index) {
                    return _QuestionCard(
                      interview: interview,
                      index: index,
                      isShow: isShow,
                      changeShow: changeShow,
                    );
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
  final List<bool> isShow;
  final ValueChanged<int> changeShow;

  const _QuestionCard({
    required this.interview,
    required this.index,
    required this.isShow,
    required this.changeShow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => changeShow(index),
      child: CustomInterviewCard(
        score: interview.questions[index].score.toInt(),
        titleText: 'Вопрос ${interview.questions[index].question}',
        firstText: 'Ваш ответ: ${interview.questions[index].userAnswer}',
        secondText:
            'Правильный ответ: ${interview.questions[index].correctAnswer}',
        titleStyle: Theme.of(context).textTheme.bodyMedium,
        subtitleStyle: TextStyle(
          overflow: isShow[index]
              ? TextOverflow.visible
              : TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
