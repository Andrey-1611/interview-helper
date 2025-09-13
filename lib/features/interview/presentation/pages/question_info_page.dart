import 'package:flutter/material.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_main_result_panel.dart';

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
              CustomMainResultPanel(text: 'Точность: ${question.score} %'),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
              _InfoCard(titleText: 'Вопрос:', subtitleText: question.question),
              _InfoCard(
                titleText: 'Ваш ответ:',
                subtitleText: question.userAnswer,
              ),
              _InfoCard(
                titleText: 'Правильный ответ:',
                subtitleText: question.correctAnswer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String titleText;
  final String subtitleText;

  const _InfoCard({required this.titleText, required this.subtitleText});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: ListTile(
        title: Text(titleText, style: textTheme.displayMedium),
        subtitle: Text(subtitleText, style: textTheme.bodyLarge),
      ),
    );
  }
}
