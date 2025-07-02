import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import '../../blocs/add_interview_bloc/add_interview_bloc.dart';
import '../../blocs/check_results_bloc/check_results_bloc.dart';
import '../../data/data_sources/firestore_data_sources/firestore_data_source.dart';
import '../../data/data_sources/remote_data_sources/remote_data_source.dart';
import '../../data/models/gemini_response.dart';
import '../../data/models/interview.dart';
import '../../data/models/question.dart';
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
    return BlocProvider(
      create:
          (context) =>
              CheckResultsBloc(RemoteDataSource(gemini: Gemini.instance))
                ..add(CheckResults(userInputs: userInputs)),
      child: _ResultsView(difficulty: difficulty),
    );
  }
}

class _ResultsView extends StatelessWidget {
  final int difficulty;

  const _ResultsView({super.key, required this.difficulty});

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
          } else if (state is CheckResultsFailure) {
            return const Center(
              child: Text(
                'На сервере ведутся работы \nПожалуйста попробуйте позже',
              ),
            );
          } else if (state is CheckResultsSuccess) {
            return _ResultsList(
              difficulty: difficulty,
              remoteDataSource: state.geminiResponse,
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}

class _ResultsList extends StatefulWidget {
  final List<GeminiResponses> remoteDataSource;
  final int difficulty;

  const _ResultsList({
    super.key,
    required this.remoteDataSource,
    required this.difficulty,
  });

  @override
  State<_ResultsList> createState() => _ResultsListState();
}

class _ResultsListState extends State<_ResultsList> {
  late final List<bool> _isShow;

  @override
  void initState() {
    super.initState();
    _isShow = List.generate(widget.remoteDataSource.length, (_) => false);
  }

  int _calculateAverageScore() {
    final totalScore =
        widget.remoteDataSource
            .map((response) => response.score)
            .reduce((score1, score2) => score1 + score2)
            .toInt();
    return totalScore ~/ widget.remoteDataSource.length;
  }

  Interview _addInterview() {
    final List<Question> questions =
        widget.remoteDataSource
            .map(
              (response) => Question(
                score: response.score,
                question: response.userInput.question,
                userAnswer: response.userInput.answer,
                correctAnswer: response.correctAnswer,
              ),
            )
            .toList();
    final Interview interview = Interview(
      score: _calculateAverageScore().toDouble(),
      difficulty: widget.difficulty,
      date: DateTime.now(),
      questions: questions,
    );
    return interview;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              AddInterviewBloc(FirestoreDataSource())
                ..add(AddInterview(interview: _addInterview())),
      child: BlocBuilder<AddInterviewBloc, AddInterviewState>(
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
                      'Результат: ${_calculateAverageScore()} %',
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
                              _isShow[index] = !_isShow[index];
                            });
                          },
                          child: CustomInterviewCard(
                            score: response.score.toInt(),
                            titleText:
                                'Вопрос ${index + 1} - ${response.userInput.question}',
                            firstText:
                                'Ваш ответ: ${response.userInput.answer}',
                            secondText:
                                'Правильный ответ: ${response.correctAnswer}',
                            titleStyle: Theme.of(context).textTheme.bodyMedium,
                            subtitleStyle: TextStyle(
                              overflow:
                                  _isShow[index]
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
      ),
    );
  }
}
