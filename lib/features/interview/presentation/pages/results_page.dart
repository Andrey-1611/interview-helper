import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:interview_master/core/global_services/notifications/services/notifications_service.dart';
import 'package:interview_master/features/interview/blocs/create_interview_bloc/create_interview_bloc.dart';
import 'package:interview_master/features/interview/data/data_sources/firestore_data_source.dart';
import 'package:interview_master/features/interview/data/data_sources/interview_data_source.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/global_services/notifications/blocs/send_notification_bloc/send_notification_bloc.dart';
import '../../../../core/global_services/notifications/models/notification.dart';
import '../../../../core/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../core/global_services/user/services/user_interface.dart';
import '../../blocs/add_interview_bloc/add_interview_bloc.dart';
import '../../blocs/check_results_bloc/check_results_bloc.dart';
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
  late List<UserInput> _userInputs;
  late final int _difficulty;
  final List<bool> _isShow = List.generate(10, (_) => false);

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
              CheckResultsBloc(RemoteDataSource(gemini: Gemini.instance))
                ..add(CheckResults(userInputs: _userInputs)),
        ),
        BlocProvider(
          create: (context) => CreateInterviewBloc(InterviewDataSource()),
        ),
        BlocProvider(
          create: (context) =>
              GetUserBloc(context.read<UserInterface>())..add(GetUser()),
        ),
        BlocProvider(
          create: (context) => AddInterviewBloc(
            FirestoreDataSource(firebaseFirestore: FirebaseFirestore.instance),
          ),
        ),
        BlocProvider(
          create: (context) => SendNotificationBloc(NotificationsService()),
        ),
      ],
      child: _ResultsPageView(
        difficulty: _difficulty,
        isShow: _isShow,
        changeShow: _changeShow,
      ),
    );
  }

  void _changeShow(int index) {
    setState(() {
      _isShow[index] = !_isShow[index];
    });
  }
}

class _ResultsPageView extends StatelessWidget {
  final int difficulty;
  final List<bool> isShow;
  final ValueChanged<int> changeShow;

  const _ResultsPageView({
    required this.difficulty,
    required this.isShow,
    required this.changeShow,
  });

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
      body: _ResultsList(
        difficulty: difficulty,
        isShow: isShow,
        changeShow: changeShow,
      ),
    );
  }
}

class _ResultsList extends StatelessWidget {
  final int difficulty;
  final List<bool> isShow;
  final ValueChanged<int> changeShow;

  const _ResultsList({
    required this.difficulty,
    required this.isShow,
    required this.changeShow,
  });

  @override
  Widget build(BuildContext context) {
    List<GeminiResponses>? remoteDataSource;
    Interview? interview;
    return MultiBlocListener(
      listeners: [
        BlocListener<CheckResultsBloc, CheckResultsState>(
          listener: (context, state) {
            if (state is CheckResultsSuccess) {
              remoteDataSource = state.geminiResponse;
              context.read<CreateInterviewBloc>().add(
                CreateInterview(
                  remoteDataSource: remoteDataSource!,
                  difficulty: difficulty,
                ),
              );
            } else if (state is CheckResultsFailure) {
              _errorMove(context);
            }
          },
        ),
        BlocListener<CreateInterviewBloc, CreateInterviewState>(
          listener: (context, state) {
            if (state is CreateInterviewSuccess) {
              interview = state.interview;
              context.read<GetUserBloc>().add(GetUser());
            } else if (state is CreateInterviewFailure) {
              _errorMove(context);
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
            } else if (state is GetUserNotAuth || state is GetUserFailure) {
              _errorMove(context);
            }
          },
        ),
        BlocListener<AddInterviewBloc, AddInterviewState>(
          listener: (context, state) {
            if (state is AddInterviewFailure) {
              _errorMove(context);
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
                    isShow: isShow,
                    changeShow: changeShow,
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _errorMove(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRouterNames.splash);
    context.read<SendNotificationBloc>().add(
      _sendNotification('Ошибка проверки результатов', Icon(Icons.error)),
    );
  }

  SendNotification _sendNotification(String text, Icon icon) {
    return SendNotification(
      notification: MyNotification(text: text, icon: icon),
    );
  }
}

class _ListResultsView extends StatefulWidget {
  final int averageScore;
  final List<GeminiResponses> remoteDataSource;
  final List<bool> isShow;
  final ValueChanged<int> changeShow;

  const _ListResultsView({
    required this.averageScore,
    required this.remoteDataSource,
    required this.isShow,
    required this.changeShow,
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
                      return _QuestionCard(
                        response: response,
                        isShow: widget.isShow,
                        index: index,
                        changeShow: widget.changeShow,
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

class _QuestionCard extends StatelessWidget {
  final GeminiResponses response;
  final List<bool> isShow;
  final int index;
  final ValueChanged<int> changeShow;

  const _QuestionCard({
    required this.response,
    required this.isShow,
    required this.index,
    required this.changeShow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => changeShow(index),
      child: CustomInterviewCard(
        score: response.score.toInt(),
        titleText: 'Вопрос ${index + 1} - ${response.userInput.question}',
        firstText: 'Ваш ответ: ${response.userInput.answer}',
        secondText: 'Правильный ответ: ${response.correctAnswer}',
        titleStyle: Theme.of(context).textTheme.bodyMedium,
        subtitleStyle: TextStyle(
          overflow: isShow[index]
              ? TextOverflow.visible
              : TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
