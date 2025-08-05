import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/core/global_services/user/services/user_repository.dart';
import 'package:interview_master/core/helpers/dialog_helpers/dialog_helper.dart';
import 'package:interview_master/core/helpers/notification_helpers/notification_helper.dart';
import 'package:interview_master/features/interview/blocs/create_interview_bloc/create_interview_bloc.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:interview_master/features/interview/data/repositories/firestore_repository.dart';
import 'package:interview_master/features/interview/data/repositories/interview_repository.dart';
import 'package:interview_master/features/interview/data/repositories/remote_repository.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_question_card.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../blocs/add_interview_bloc/add_interview_bloc.dart';
import '../../blocs/check_results_bloc/check_results_bloc.dart';
import '../../data/models/gemini_response.dart';
import '../../data/models/interview.dart';
import '../../data/models/user_input.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late List<UserInput> _userInputs;
  late final int _difficulty;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _userInputs = data['userInputs'] as List<UserInput>;
    _difficulty = data['difficulty'] as int;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CheckResultsBloc(context.read<RemoteRepository>())
                ..add(CheckResults(userInputs: _userInputs)),
        ),
        BlocProvider(
          create: (context) =>
              CreateInterviewBloc(context.read<InterviewRepository>()),
        ),
        BlocProvider(
          create: (context) => GetUserBloc(context.read<UserRepository>()),
        ),
        BlocProvider(
          create: (context) =>
              AddInterviewBloc(context.read<FirestoreRepository>()),
        ),
      ],
      child: _ResultsPageView(difficulty: _difficulty),
    );
  }
}

class _ResultsPageView extends StatelessWidget {
  final int difficulty;

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
  final int difficulty;

  const _ResultsList({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    List<GeminiResponses>? remoteDataSource;
    Interview? interview;
    return MultiBlocListener(
      listeners: [
        BlocListener<CheckResultsBloc, CheckResultsState>(
          listener: (context, state) {
            if (state is CheckResultsLoading) {
              DialogHelper.showLoadingDialog(context);
            } else if (state is CheckResultsSuccess) {
              remoteDataSource = state.geminiResponse;
              context.read<CreateInterviewBloc>().add(
                CreateInterview(
                  remoteDataSource: remoteDataSource!,
                  difficulty: difficulty,
                ),
              );
            } else if (state is CheckResultsFailure) {
              AppRouter.pop();
              AppRouter.pushReplacementNamed(AppRouterNames.home);
              NotificationHelper.interview.checkInterviewsError(context);
            }
          },
        ),
        BlocListener<CreateInterviewBloc, CreateInterviewState>(
          listener: (context, state) {
            if (state is CreateInterviewSuccess) {
              interview = state.interview;
              context.read<GetUserBloc>().add(GetUser());
            }
          },
        ),
        BlocListener<GetUserBloc, GetUserState>(
          listener: (context, state) {
            if (state is GetUserSuccess) {
              context.read<AddInterviewBloc>().add(
                AddInterview(
                  interview: interview!,
                  userId: state.userProfile.id ?? '',
                ),
              );
            }
          },
        ),
        BlocListener<AddInterviewBloc, AddInterviewState>(
          listener: (context, state) {
            if (state is AddInterviewSuccess) {
              AppRouter.pop();
            } else if (state is AddInterviewFailure) {
              AppRouter.pop();
              NotificationHelper.interview.checkInterviewsError(context);
            }
          },
        ),
      ],
      child: BlocBuilder<CreateInterviewBloc, CreateInterviewState>(
        builder: (context, state) {
          if (state is CreateInterviewSuccess) {
            interview = state.interview;
            return BlocBuilder<CheckResultsBloc, CheckResultsState>(
              builder: (context, state) {
                if (state is CheckResultsSuccess) {
                  return _ListResultsView(
                    averageScore: interview!.score.toInt(),
                    remoteDataSource: state.geminiResponse,
                  );
                }
                return const SizedBox.shrink();
              },
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
  final List<GeminiResponses> remoteDataSource;

  const _ListResultsView({
    required this.averageScore,
    required this.remoteDataSource,
  });

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
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.blue, width: 4.0),
                  ),
                  child: Text(
                    'Результат: ${widget.averageScore} %',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.remoteDataSource.length,
                    itemBuilder: (context, index) {
                      final response = widget.remoteDataSource[index];
                      return _QuestionCard(response: response, index: index);
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
  final GeminiResponses response;
  final int index;

  const _QuestionCard({required this.response, required this.index});

  Question get question => Question(
    score: response.score,
    question: response.userInput.question,
    userAnswer: response.userInput.answer,
    correctAnswer: response.correctAnswer,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRouter.pushNamed(AppRouterNames.questionInfo, arguments: question);
      },
      child: CustomQuestionCard(
        text: 'Вопрос ${index + 1} - ${response.userInput.question}',
        isQuestionCard: true,
        score: response.score.toInt(),
      ),
    );
  }
}
