import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/utils/dialog_helper.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import 'package:interview_master/features/interview/blocs/speech_cubit/speech_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../data/models/interview/interview_info.dart';
import '../../../data/models/interview/user_input.dart';
import '../../../app/widgets/custom_button.dart';

class InterviewPage extends StatefulWidget {
  final InterviewInfo interviewInfo;

  const InterviewPage({super.key, required this.interviewInfo});

  @override
  State<InterviewPage> createState() => _InterviewPageState();
}

class _InterviewPageState extends State<InterviewPage> {
  late final List<String> _questions = InterviewInfo.selectQuestions(
    widget.interviewInfo,
  );

  final List<String> _answers = List.filled(10, '');
  final TextEditingController _answerController = TextEditingController();
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SpeechCubit(GetIt.I<SpeechToText>(), GetIt.I<FlutterTts>())
            ..speak(_questions[0]),
      child: _InterviewPageView(
        answerController: _answerController,
        pageController: _pageController,
        answers: _answers,
        interviewInfo: widget.interviewInfo,
        questions: _questions,
      ),
    );
  }
}

class _InterviewPageView extends StatelessWidget {
  final TextEditingController answerController;
  final PageController pageController;
  final List<String> answers;
  final InterviewInfo interviewInfo;
  final List<String> questions;

  const _InterviewPageView({
    required this.answerController,
    required this.pageController,
    required this.answers,
    required this.interviewInfo,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    _updateController(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${interviewInfo.direction}, ${interviewInfo.difficulty}',
          style: theme.textTheme.displayMedium,
        ),
        leading: IconButton(
          onPressed: () => DialogHelper.showCustomDialog(
            dialog: _GoOutDialog(),
            context: context,
          ),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SmoothPageIndicator(
              controller: pageController,
              count: 10,
              onDotClicked: (page) => _jumpToPage(context, page),
              effect: WormEffect(
                radius: size.height * 0.025,
                dotHeight: size.height * 0.025,
                dotWidth: size.height * 0.025,
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: 10,
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _InterviewQuestionPage(
                  answerController: answerController,
                  pageController: pageController,
                  answers: answers,
                  interviewInfo: interviewInfo,
                  questions: questions,
                  currentPage: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _updateController(BuildContext context) {
    final speech = context.watch<SpeechCubit>();
    if (speech.state.text.isNotEmpty) {
      answerController.text += ' ${speech.state.text}';
      speech.clearText();
    }
  }

  void _jumpToPage(BuildContext context, int page) {
    context.read<SpeechCubit>().speak(questions[page]);
    answers[pageController.page?.round() ?? 0] = answerController.text.trim();
    answerController.text = answers[page];
    pageController.jumpToPage(page);
  }
}

class _InterviewQuestionPage extends StatelessWidget {
  final TextEditingController answerController;
  final PageController pageController;
  final List<String> answers;
  final InterviewInfo interviewInfo;
  final List<String> questions;
  final int currentPage;

  const _InterviewQuestionPage({
    required this.answerController,
    required this.pageController,
    required this.answers,
    required this.interviewInfo,
    required this.questions,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Text('Вопрос ${currentPage + 1}'),
          Text(questions[currentPage], style: theme.textTheme.bodyLarge),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: TextField(
              autofocus: true,
              maxLines: null,
              expands: true,
              maxLength: 300,
              textAlignVertical: TextAlignVertical.top,
              controller: answerController,
              decoration: const InputDecoration(
                hintText: 'Введите ваш ответ...',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: currentPage == 0
                    ? const SizedBox.shrink()
                    : CustomButton(
                        text: 'Назад',
                        selectedColor: AppPalette.primary,
                        percentsWidth: 0.34,
                        onPressed: () => _pop(context),
                      ),
              ),
              FloatingActionButton(
                onPressed: () => context.read<SpeechCubit>().toggleListening(),
                child: Icon(Icons.mic, color: AppPalette.textPrimary),
              ),
              Expanded(
                child: CustomButton(
                  text: currentPage == 9 ? 'Завершить' : 'Дальше',
                  selectedColor: AppPalette.primary,
                  percentsWidth: 0.34,
                  onPressed: () => _push(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _pop(BuildContext context) {
    answers[currentPage] = answerController.text.trim();
    answerController.text = answers[currentPage - 1];
    pageController.jumpToPage(currentPage - 1);
    context.read<SpeechCubit>().speak(questions[currentPage - 1]);
  }

  void _push(BuildContext context) {
    if (currentPage != 9) {
      answers[currentPage] = answerController.text.trim();
      answerController.text = answers[currentPage + 1];
      pageController.jumpToPage(currentPage + 1);
      context.read<SpeechCubit>().speak(questions[currentPage + 1]);
    } else {
      answers[currentPage] = answerController.text.trim();
      context.pushReplacement(
        AppRouterNames.results,
        extra: InterviewInfo(
          direction: interviewInfo.direction,
          difficulty: interviewInfo.difficulty,
          userInputs: UserInput.fromInput(questions, answers),
        ),
      );
    }
  }
}

class _GoOutDialog extends StatelessWidget {
  const _GoOutDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(
        'Вы уверены, что хотите выйти из аккаунта?',
        style: theme.textTheme.displaySmall,
      ),
      content: const Text('Текущий прогресс будет сброшен'),
      actions: [
        TextButton(
          onPressed: () => context.pushReplacement(AppRouterNames.initial),
          child: Text('Да'),
        ),
        TextButton(onPressed: () => context.pop(), child: Text('Нет')),
      ],
    );
  }
}
