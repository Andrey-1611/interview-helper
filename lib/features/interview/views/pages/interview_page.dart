import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/questions.dart';
import '../../../../core/navigation/app_router.dart';
import '../../data/models/user_input.dart';
import '../widgets/custom_button.dart';

class InterviewPage extends StatefulWidget {
  const InterviewPage({super.key});

  @override
  State<InterviewPage> createState() => _InterviewPageState();
}

class _InterviewPageState extends State<InterviewPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final int difficult;
  final Random _random = Random();

  late List<String> _selectedQuestions;
  late int selectedQuestionIndex;
  late String selectedQuestion;
  final List<String> _pageQuestions = [];

  final TextEditingController _answerController = TextEditingController();
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
        selectedQuestionIndex = _random.nextInt(_selectedQuestions.length);
        selectedQuestion = _selectedQuestions[selectedQuestionIndex];
        _pageQuestions.add(selectedQuestion);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageView.builder(
        itemCount: 10,
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _answers[_currentPage] = _answerController.text.trim();
            _currentPage = page;
            _answerController.text = _answers[_currentPage];
          });
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ' Вопрос ${index + 1} - ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  _pageQuestions[index],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: TextField(
                        autofocus: true,
                        maxLines: null,
                        minLines: null,
                        expands: true,
                        controller: _answerController,
                        decoration: InputDecoration(
                          //filled: true,
                          //fillColor: Colors.,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _currentPage == 0
                        ? SizedBox.shrink()
                        : CustomButton(
                          textColor: Colors.white,
                          text: 'Назад',
                          selectedColor: Colors.blue,
                          percentsHeight: 0.07,
                          percentsWidth: 0.29,
                          onPressed: () {
                            _pageController.animateToPage(
                              _currentPage - 1,
                              duration: Duration(milliseconds: 1),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                    CustomButton(
                      text: _currentPage == 9 ? 'Завершить' : 'Дальше',
                      textColor: Colors.white,
                      selectedColor: Colors.blue,
                      percentsHeight: 0.07,
                      percentsWidth: 0.29,
                      onPressed: () {
                        _currentPage == 9
                            ? _showDialog(context)
                            : _pageController.animateToPage(
                              _currentPage + 1,
                              duration: Duration(milliseconds: 1),
                              curve: Curves.easeInOut,
                            );
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
                  final List<UserInput> userInputs = List.generate(10, (index) {
                    return UserInput(
                      question: _pageQuestions[index],
                      answer: _answers[index],
                    );
                  });
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
