import 'package:flutter/material.dart';
import '../../data/models/interview.dart';
import '../widgets/custom_interview_card.dart';

class InterviewInfoPage extends StatefulWidget {
  const InterviewInfoPage({super.key});

  @override
  State<InterviewInfoPage> createState() => _InterviewInfoPageState();
}

class _InterviewInfoPageState extends State<InterviewInfoPage> {
  late final List<bool> _isShow;
  late final Interview interview;

  @override
  void initState() {
    super.initState();
    _isShow = List.generate(10, (_) => false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    interview = ModalRoute.of(context)!.settings.arguments as Interview;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.blue, width: 4.0),
                ),
                child: Text(
                  'Результат: ${interview.score.toInt()} %',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: interview.questions.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _isShow[index] = !_isShow[index];
                        });
                      },
                      child: CustomInterviewCard(
                        score: interview.questions[index].score.toInt(),
                        titleText:
                            'Вопрос ${interview.questions[index].question}',
                        firstText:
                            'Ваш ответ: ${interview.questions[index].userAnswer}',
                        secondText:
                            'Правильный ответ: ${interview.questions[index].correctAnswer}',
                        titleStyle: Theme.of(context).textTheme.bodyMedium,
                        subtitleStyle: TextStyle(
                          overflow:
                              _isShow[index]
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                        ),
                      ),
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
