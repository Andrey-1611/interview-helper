import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_question_card.dart';

class QuestionInfoPage extends StatefulWidget {
  const QuestionInfoPage({super.key});

  @override
  State<QuestionInfoPage> createState() => _QuestionInfoPageState();
}

class _QuestionInfoPageState extends State<QuestionInfoPage> {
  late final Question question;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    question = ModalRoute.of(context)!.settings.arguments as Question;
  }

  @override
  Widget build(BuildContext context) {
    return _QuestionInfoPageView(question: question);
  }
}

class _QuestionInfoPageView extends StatelessWidget {
  final Question question;

  const _QuestionInfoPageView({required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ListView(
            children: [
              _ScoreContainer(question: question),
              const SizedBox(height: 20),
              _Question(question: question),
              _UserAnswer(question: question),
              _CorrectAnswer(question: question),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreContainer extends StatelessWidget {
  final Question question;

  const _ScoreContainer({required this.question});

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
        'Точность: ${question.score.toInt()} %',
        style: Theme.of(context).textTheme.displayLarge,
      ),
    );
  }
}

class _Question extends StatelessWidget {
  final Question question;

  const _Question({required this.question});

  @override
  Widget build(BuildContext context) {
    return CustomQuestionCard(
      text: 'Вопрос: ${question.question}',
      isQuestionCard: false,
    );
  }
}

class _UserAnswer extends StatelessWidget {
  final Question question;

  const _UserAnswer({required this.question});

  @override
  Widget build(BuildContext context) {
    return CustomQuestionCard(
      text: 'Ваш ответ: ${question.userAnswer}',
      isQuestionCard: false,
    );
  }
}

class _CorrectAnswer extends StatelessWidget {
  final Question question;

  const _CorrectAnswer({required this.question});

  @override
  Widget build(BuildContext context) {
    return CustomQuestionCard(
      text: 'Правильный ответ: ${question.correctAnswer}',
      isQuestionCard: false,
    );
  }
}
