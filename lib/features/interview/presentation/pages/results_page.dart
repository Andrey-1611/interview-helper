import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/core/helpers/dialog_helpers/dialog_helper.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_question_card.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_result_panel.dart';
import '../../../../app/dependencies/di_container.dart';
import '../../../../app/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/helpers/toast_helpers/toast_helper.dart';
import '../../data/models/interview.dart';
import '../../data/models/user_input.dart';
import '../blocs/add_interview_bloc/add_interview_bloc.dart';
import '../blocs/check_results_bloc/check_results_bloc.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late final List<UserInput> _userInputs;
  late final String _difficulty;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _userInputs = data['userInputs'] as List<UserInput>;
    _difficulty = data['difficulty'] as String;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CheckResultsBloc(DIContainer.checkResults)
                ..add(CheckResults(userInputs: _userInputs)),
        ),
        BlocProvider(create: (context) => GetUserBloc(DIContainer.getUser)),
        BlocProvider(
          create: (context) => AddInterviewBloc(DIContainer.addInterview),
        ),
      ],
      child: _ResultsPageView(difficulty: _difficulty),
    );
  }
}

class _ResultsPageView extends StatelessWidget {
  final String difficulty;

  const _ResultsPageView({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              AppRouter.pushReplacementNamed(AppRouterNames.home);
            },
            icon: Icon(Icons.home),
          ),
        ],
      ),
      body: _ResultsList(difficulty: difficulty),
    );
  }
}

class _ResultsList extends StatelessWidget {
  final String difficulty;

  const _ResultsList({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final List<Question> questions = [];
    return MultiBlocListener(
      listeners: [
        BlocListener<CheckResultsBloc, CheckResultsState>(
          listener: (context, state) {
            if (state is CheckResultsLoading) {
              DialogHelper.showLoadingDialog(context);
            } else if (state is CheckResultsSuccess) {
              questions.addAll(state.questions);
              context.read<GetUserBloc>().add(GetUser());
            } else if (state is CheckResultsFailure) {
              AppRouter.pop();
              AppRouter.pushReplacementNamed(AppRouterNames.home);
              ToastHelper.unknownError();
            }
          },
        ),
        BlocListener<GetUserBloc, GetUserState>(
          listener: (context, state) {
            if (state is GetUserSuccess) {
              context.read<AddInterviewBloc>().add(
                AddInterview(
                  interview: Interview.fromQuestions(questions, difficulty),
                  userId: state.user.id ?? '',
                ),
              );
            } else if (state is GetUserFailure) {
              AppRouter.pop();
              ToastHelper.unknownError();
            }
          },
        ),
        BlocListener<AddInterviewBloc, AddInterviewState>(
          listener: (context, state) {
            if (state is AddInterviewSuccess) {
              AppRouter.pop();
            } else if (state is AddInterviewFailure) {
              AppRouter.pop();
              ToastHelper.unknownError();
            }
          },
        ),
      ],
      child: BlocBuilder<CheckResultsBloc, CheckResultsState>(
        builder: (context, state) {
          if (state is CheckResultsSuccess) {
            final Interview interview = Interview.fromQuestions(
              state.questions,
              difficulty,
            );
            return _ListResultsView(
              averageScore: interview.score,
              questions: state.questions,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ListResultsView extends StatefulWidget {
  final int averageScore;
  final List<Question> questions;

  const _ListResultsView({required this.averageScore, required this.questions});

  @override
  State<_ListResultsView> createState() => _ListResultsViewState();
}

class _ListResultsViewState extends State<_ListResultsView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddInterviewBloc, AddInterviewState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
               CustomResultPanel(score: widget.averageScore,),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.questions.length,
                    itemBuilder: (context, index) {
                      final Question question = widget.questions[index];
                      return _QuestionCard(question: question, index: index);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final Question question;
  final int index;

  const _QuestionCard({required this.question, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRouter.pushNamed(AppRouterNames.questionInfo, arguments: question);
      },
      child: CustomQuestionCard(
        text: 'Вопрос ${index + 1} - ${question.question}',
        isQuestionCard: true,
        color: question.isCorrect ? Colors.green : Colors.red,
        score: question.score.toInt(),
      ),
    );
  }
}
