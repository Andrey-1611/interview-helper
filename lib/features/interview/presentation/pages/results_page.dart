import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:interview_master/features/interview/blocs/create_interview_bloc/create_interview_bloc.dart';
import 'package:interview_master/features/interview/data/data_sources/interview_data_source.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../core/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../core/global_services/user/services/user_interface.dart';
import '../../blocs/add_interview_bloc/add_interview_bloc.dart';
import '../../blocs/check_results_bloc/check_results_bloc.dart';
import '../../data/data_sources/firestore_data_source.dart';
import '../../data/data_sources/remote_data_source.dart';
import '../../data/models/gemini_response.dart';
import '../../data/models/interview.dart';
import '../../data/models/user_input.dart';
import '../widgets/custom_interview_card.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late List<UserInput> userInputs;
  late final int difficulty;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    userInputs = data['userInputs'] as List<UserInput>;
    difficulty = data['difficulty'] as int;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CheckResultsBloc(RemoteDataSource(gemini: Gemini.instance))
                ..add(CheckResults(userInputs: userInputs)),
        ),
        BlocProvider(
          create: (context) =>
              GetUserBloc(context.read<UserInterface>())..add(GetUser()),
        ),
      ],
      child: _ResultsView(difficulty: difficulty),
    );
  }
}

class _ResultsView extends StatelessWidget {
  final int difficulty;

  const _ResultsView({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            icon: Icon(Icons.home),
          ),
        ],
      ),
      body: BlocBuilder<CheckResultsBloc, CheckResultsState>(
        builder: (context, state) {
          if (state is CheckResultsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CheckResultsSuccess) {
            return _ResultsList(
              difficulty: difficulty,
              remoteDataSource: state.geminiResponse,
            );
          } else if (state is CheckResultsFailure) {
            return const Center(
              child: Text(
                'На сервере ведутся работы \nПожалуйста попробуйте позже',
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _ResultsList extends StatefulWidget {
  final List<GeminiResponses> remoteDataSource;
  final int difficulty;

  const _ResultsList({
    required this.remoteDataSource,
    required this.difficulty,
  });

  @override
  State<_ResultsList> createState() => _ResultsListState();
}

class _ResultsListState extends State<_ResultsList> {
  late final List<bool> _isShow;
  late final Interview interview;

  @override
  void initState() {
    super.initState();
    _isShow = List.generate(widget.remoteDataSource.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateInterviewBloc(
        InterviewDataSource(
          remoteDataSource: widget.remoteDataSource,
          difficulty: widget.difficulty,
        ),
      )..add(CreateInterview()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<GetUserBloc, GetUserState>(
            listener: (context, state) {
              if (state is GetUserNotAuth || state is GetUserFailure) {
                Navigator.pushReplacementNamed(context, AppRouterNames.splash);
              }
            },
          ),
          BlocListener<CreateInterviewBloc, CreateInterviewState>(
            listener: (context, state) {
              if (state is CreateInterviewSuccess) {
                interview = state.interview;
              }
            },
          ),
        ],
        child: BlocBuilder<CreateInterviewBloc, CreateInterviewState>(
          builder: (context, state) {
            if (state is GetUserLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CreateInterviewSuccess) {
              return BlocBuilder<GetUserBloc, GetUserState>(
                builder: (context, state) {
                  if (state is GetUserLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is GetUserSuccess) {
                    final userId = state.userProfile.id ?? '';
                    return BlocProvider(
                      create: (context) => AddInterviewBloc(
                        FirestoreDataSource(
                          FirebaseFirestore.instance,
                          userId: userId,
                        ),
                      )..add(AddInterview(interview: interview)),
                      child: _ListResultsView(
                        averageScore: interview.score.toInt(),
                        remoteDataSource: widget.remoteDataSource,
                        isShow: _isShow,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _ListResultsView extends StatefulWidget {
  final int averageScore;
  final List<GeminiResponses> remoteDataSource;
  final List<bool> isShow;

  const _ListResultsView({
    required this.averageScore,
    required this.remoteDataSource,
    required this.isShow,
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
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.isShow[index] = !widget.isShow[index];
                          });
                        },
                        child: CustomInterviewCard(
                          score: response.score.toInt(),
                          titleText:
                              'Вопрос ${index + 1} - ${response.userInput.question}',
                          firstText: 'Ваш ответ: ${response.userInput.answer}',
                          secondText:
                              'Правильный ответ: ${response.correctAnswer}',
                          titleStyle: Theme.of(context).textTheme.bodyMedium,
                          subtitleStyle: TextStyle(
                            overflow: widget.isShow[index]
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
        );
      },
    );
  }
}
