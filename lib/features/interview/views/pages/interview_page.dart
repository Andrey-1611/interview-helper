import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../core/constants/questions.dart';
import '../../data/models/user_input.dart';
import '../widgets/custom_button.dart';

class InterviewPage extends StatefulWidget {
  final Random random;
  final TextEditingController answerController;
  final PageController pageController;
  const InterviewPage({super.key, required this.random, required this.pageController, required this.answerController});

  @override
  State<InterviewPage> createState() => _InterviewPageState();
}

class _InterviewPageState extends State<InterviewPage> {
  int _currentPage = 0;
  late final int difficult;
  late List<String> _selectedQuestions;
  final List<String> _pageQuestions = [];
  final List<String> _answers = List.filled(10, '');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_pageQuestions.isEmpty) {
      difficult = ModalRoute.of(context)!.settings.arguments as int;
      final questions = FlutterInterviewQuestions();
      switch (difficult) {
        case 1:
          _selectedQuestions = questions.flutterInterviewQuestionsJunior;
        case 2:
          _selectedQuestions = questions.flutterInterviewQuestionsMiddle;
        case 3:
          _selectedQuestions = questions.flutterInterviewQuestionsSenior;
      }

      for (int i = 0; i < 10; i++) {
        final selectedQuestionIndex = widget.random.nextInt(
          _selectedQuestions.length,
        );
        _pageQuestions.add(_selectedQuestions[selectedQuestionIndex]);
      }
    }
  }

  void _saveCurrentAnswer() {
    _answers[_currentPage] = widget.answerController.text.trim();
  }

  void _navigateToPage(int page) {
    _saveCurrentAnswer();
    widget.pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    widget.pageController.dispose();
    widget.answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
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
          return Padding(
            padding: const EdgeInsets.only(top: 32.0, bottom: 8.0, left: 16.0, right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Вопрос ${index + 1} - ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  _pageQuestions[index],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    maxLines: null,
                    minLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    controller: widget.answerController,
                    onChanged: (value) {
                      _answers[_currentPage] = value.trim();
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Введите ваш ответ...'
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _currentPage == 0
                        ? const SizedBox.shrink()
                        : CustomButton(
                            textColor: Colors.white,
                            text: 'Назад',
                            selectedColor: Colors.blue,
                            percentsHeight: 0.07,
                            percentsWidth: 0.29,
                            onPressed: () => _navigateToPage(_currentPage - 1),
                          ),
                    CustomButton(
                      text: _currentPage == 9 ? 'Завершить' : 'Дальше',
                      textColor: Colors.white,
                      selectedColor: Colors.blue,
                      percentsHeight: 0.07,
                      percentsWidth: 0.29,
                      onPressed: () {
                        _saveCurrentAnswer();
                        if (_currentPage == 9) {
                          _showDialog(context);
                        } else {
                          _navigateToPage(_currentPage + 1);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
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
                    (index) => UserInput(
                      question: _pageQuestions[index],
                      answer: _answers[index],
                    ),
                  );
                  Navigator.pushNamed(
                    context,
                    AppRouterNames.results,
                    arguments: {
                      'userInputs': userInputs,
                      'difficulty': difficult,
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
