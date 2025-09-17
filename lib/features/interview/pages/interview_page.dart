import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../data/models/interview_info.dart';
import '../../../data/models/user_input.dart';
import '../../../app/widgets/custom_button.dart';

class InterviewPage extends StatefulWidget {
  final InterviewInfo interviewInfo;

  const InterviewPage({super.key, required this.interviewInfo});

  @override
  State<InterviewPage> createState() => _InterviewPageState();
}

class _InterviewPageState extends State<InterviewPage> {
  int _currentPage = 0;
  late final List<String> _questions = InterviewInfo.selectQuestions(
    widget.interviewInfo,
  );
  final List<String> _answers = List.filled(10, '');

  final TextEditingController answerController = TextEditingController();
  final PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InterviewPageView(
      pageController: pageController,
      answerController: answerController,
      currentPage: _currentPage,
      answers: _answers,
      interviewInfo: widget.interviewInfo,
      changePage: _changePage,
      questions: _questions,
    );
  }

  void _changePage(int page) {
    setState(() {
      _currentPage = page;
      answerController.text = _answers[_currentPage];
    });
  }
}

class _InterviewPageView extends StatelessWidget {
  final PageController pageController;
  final TextEditingController answerController;
  final int currentPage;
  final List<String> answers;
  final List<String> questions;
  final InterviewInfo interviewInfo;
  final ValueChanged<int> changePage;

  const _InterviewPageView({
    required this.pageController,
    required this.answerController,
    required this.currentPage,
    required this.answers,
    required this.questions,
    required this.interviewInfo,
    required this.changePage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: 10,
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) => changePage(page),
        itemBuilder: (context, index) {
          return _InterviewQuestionPage(
            currentPage: currentPage,
            answerController: answerController,
            answers: answers,
            pageController: pageController,
            interviewInfo: interviewInfo,
            questions: questions,
          );
        },
      ),
    );
  }
}

class _InterviewQuestionPage extends StatelessWidget {
  final int currentPage;
  final TextEditingController answerController;
  final List<String> answers;
  final PageController pageController;
  final InterviewInfo interviewInfo;
  final List<String> questions;

  const _InterviewQuestionPage({
    required this.currentPage,
    required this.answerController,
    required this.answers,
    required this.pageController,
    required this.interviewInfo,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
          Text('Вопрос ${currentPage + 1} - ', style: textTheme.bodyMedium),
          Text(questions[currentPage], style: textTheme.bodyMedium),
          Expanded(
            child: TextField(
              autofocus: true,
              maxLines: null,
              minLines: null,
              expands: true,
              maxLength: 300,
              textAlignVertical: TextAlignVertical.top,
              controller: answerController,
              onChanged: (value) {
                answers[currentPage] = value.trim();
              },
              decoration: const InputDecoration(
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
                      text: 'Назад',
                      selectedColor: AppPalette.primary,
                      percentsWidth: 0.34,
                      onPressed: () => _navigateToPage(currentPage - 1),
                    ),
              CustomButton(
                text: currentPage == 9 ? 'Завершить' : 'Дальше',
                selectedColor: AppPalette.primary,
                percentsWidth: 0.34,
                onPressed: () {
                  _saveCurrentAnswer();
                  if (currentPage == 9) {
                    final argumentsData = InterviewInfo(
                      direction: interviewInfo.direction,
                      difficulty: interviewInfo.difficulty,
                      userInputs: UserInput.fromInput(questions, answers),
                    );
                    context.pushReplacement(
                      AppRouterNames.results,
                      extra: argumentsData,
                    );
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
}
