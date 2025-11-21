import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/utils/dialog_helper.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import 'package:interview_master/core/utils/toast_helper.dart';
import 'package:interview_master/features/interview/blocs/speech_cubit/speech_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../core/utils/network_info.dart';
import '../../../core/utils/stopwatch_info.dart';
import '../../../data/models/interview_info.dart';
import '../../../data/models/user_input.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../data/repositories/ai_repository.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';
import '../blocs/interview_bloc/interview_bloc.dart';

class InterviewPage extends StatefulWidget {
  final InterviewInfo interviewInfo;

  const InterviewPage({super.key, required this.interviewInfo});

  @override
  State<InterviewPage> createState() => _InterviewPageState();
}

class _InterviewPageState extends State<InterviewPage> {
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => InterviewBloc(
            GetIt.I<AIRepository>(),
            GetIt.I<RemoteRepository>(),
            GetIt.I<LocalRepository>(),
            GetIt.I<NetworkInfo>(),
            GetIt.I<StopwatchInfo>(),
          )..add(GetQuestions(interviewInfo: widget.interviewInfo)),
        ),
        BlocProvider(
          create: (context) =>
              SpeechCubit(GetIt.I<SpeechToText>(), GetIt.I<FlutterTts>()),
        ),
      ],
      child: BlocConsumer<InterviewBloc, InterviewState>(
        listener: (context, state) {
          if (state is InterviewQuestionsSuccess) {
            context.read<SpeechCubit>().speak(state.questions.first);
          } else if (state is InterviewNetworkFailure) {
            ToastHelper.networkError();
            context.pop();
          } else if (state is InterviewFailure) {
            ToastHelper.unknownError();
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is InterviewQuestionsSuccess) {
            return _InterviewPageView(
              answerController: _answerController,
              pageController: _pageController,
              answers: _answers,
              interviewInfo: widget.interviewInfo,
              questions: state.questions,
            );
          }
          return CustomLoadingIndicator();
        },
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
    final speech = context.watch<SpeechCubit>();
    _updateController(speech);
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
        actions: [
          IconButton(
            onPressed: () => speech.toggleSpeaking(),
            icon: Icon(speech.state.needSpeak ? Icons.mic : Icons.mic_off),
          ),
        ],
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

  void _updateController(SpeechCubit speech) {
    if (speech.state.text.isNotEmpty && answerController.text.length < 290) {
      answerController.text += speech.state.text;
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
        'Вы уверены, что хотите сбросить собседование?',
        style: theme.textTheme.displaySmall,
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
            context.pop();
          },
          child: Text('Да'),
        ),
        TextButton(onPressed: () => context.pop(), child: Text('Нет')),
      ],
    );
  }
}
