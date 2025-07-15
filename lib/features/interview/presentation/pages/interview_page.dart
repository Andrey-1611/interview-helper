import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/interview/blocs/get_questions_bloc/get_questions_bloc.dart';
import 'package:interview_master/features/interview/data/data_sources/questions_data_source.dart';
import '../../../../app/navigation/app_router.dart';
import '../../data/models/user_input.dart';
import '../widgets/custom_button.dart';

class InterviewPage extends StatefulWidget {
  final Random random;
  final TextEditingController answerController;
  final PageController pageController;

  const InterviewPage({
    super.key,
    required this.random,
    required this.pageController,
    required this.answerController,
  });

  @override
  State<InterviewPage> createState() => _InterviewPageState();
}

class _InterviewPageState extends State<InterviewPage> {
  int _currentPage = 0;
  late final int difficulty;
  final List<String> _answers = List.filled(10, '');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    difficulty = ModalRoute.of(context)!.settings.arguments as int;
  }

  @override
  void dispose() {
    widget.pageController.dispose();
    widget.answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetQuestionsBloc(QuestionsDataSource(random: Random()))
            ..add(GetQuestions(difficulty: difficulty)),
      child: Scaffold(
        body: BlocBuilder<GetQuestionsBloc, GetQuestionsState>(
          builder: (context, state) {
            if (state is GetQuestionsSuccess) {
              return PageView.builder(
                itemCount: 10,
                controller: widget.pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                    widget.answerController.text = _answers[page];
                  });
                },
                itemBuilder: (context, index) {
                  return _InterviewQuestionPage(
                    currentPage: _currentPage,
                    answerController: widget.answerController,
                    answers: _answers,
                    pageController: widget.pageController,
                    difficulty: difficulty,
                    question: state.questions[_currentPage],
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class _InterviewQuestionPage extends StatelessWidget {
  final int currentPage;
  final TextEditingController answerController;
  final List<String> answers;
  final PageController pageController;
  final int difficulty;
  final String question;

  const _InterviewQuestionPage({
    required this.currentPage,
    required this.answerController,
    required this.answers,
    required this.pageController,
    required this.difficulty,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 32.0,
        bottom: 8.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Вопрос ${currentPage + 1} - ',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(question, style: Theme.of(context).textTheme.bodyMedium),
          Expanded(
            child: TextField(
              autofocus: true,
              maxLines: null,
              minLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              controller: answerController,
              onChanged: (value) {
                answers[currentPage] = value.trim();
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Введите ваш ответ...',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              currentPage == 0
                  ? const SizedBox.shrink()
                  : CustomButton(
                      textColor: Colors.white,
                      text: 'Назад',
                      selectedColor: Colors.blue,
                      percentsHeight: 0.07,
                      percentsWidth: 0.29,
                      onPressed: () => _navigateToPage(currentPage - 1),
                    ),
              CustomButton(
                text: currentPage == 9 ? 'Завершить' : 'Дальше',
                textColor: Colors.white,
                selectedColor: Colors.blue,
                percentsHeight: 0.07,
                percentsWidth: 0.29,
                onPressed: () {
                  _saveCurrentAnswer();
                  if (currentPage == 9) {
                    _showDialog(context);
                  } else {
                    _navigateToPage(currentPage + 1);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveCurrentAnswer() {
    answers[currentPage] = answerController.text.trim();
  }

  void _navigateToPage(int page) {
    _saveCurrentAnswer();
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Вы уверены что хотите завершить тестирование?',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          actions: [
            Center(
              child: CustomButton(
                text: 'Завершить',
                selectedColor: Colors.blue,
                textColor: Colors.white,
                percentsHeight: 0.07,
                percentsWidth: 1,
                onPressed: () {
                  final userInputs = List.generate(
                    10,
                    (index) =>
                        UserInput(question: question, answer: answers[index]),
                  );
                  Navigator.pushNamed(
                    context,
                    AppRouterNames.results,
                    arguments: {
                      'userInputs': userInputs,
                      'difficulty': difficulty,
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
