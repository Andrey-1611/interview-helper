import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_button.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_interview_info.dart';
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
      body: BlocConsumer<CheckResultsBloc, CheckResultsState>(
        listener: (context, state) {
          if (state is CheckResultsFailure) {
            ToastHelper.unknownError();
          }
        },
        builder: (context, state) {
          if (state is CheckResultsLoading) {
            return CustomLoadingIndicator();
          } else if (state is CheckResultsSuccess) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomInterviewInfo(
                    interview: Interview.fromQuestions(
                      state.questions,
                      difficulty,
                    ),
                  ),
                  _SaveResultsButton(
                    questions: state.questions,
                    difficulty: difficulty,
                  ),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}

class _SaveResultsButton extends StatelessWidget {
  final List<Question> questions;
  final String difficulty;

  const _SaveResultsButton({required this.questions, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetUserBloc, GetUserState>(
          listener: (context, state) {
            if (state is GetUserSuccess) {
              context.read<AddInterviewBloc>().add(
                AddInterview(
                  interview: Interview.fromQuestions(questions, difficulty),
                  userId: state.user.id!,
                ),
              );
            } else if (state is GetUserFailure) {
              ToastHelper.unknownError();
              AppRouter.pushReplacementNamed(AppRouterNames.home);
            }
          },
        ),
        BlocListener<AddInterviewBloc, AddInterviewState>(
          listener: (context, state) {
            if (state is AddInterviewSuccess) {
              AppRouter.pushReplacementNamed(AppRouterNames.home);
            } else if (state is AddInterviewFailure) {
              ToastHelper.unknownError();
            }
          },
        ),
      ],
      child: _SaveResultsButtonView(),
    );
  }
}

class _SaveResultsButtonView extends StatelessWidget {
  const _SaveResultsButtonView();

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Сохранить результаты',
      selectedColor: AppPalette.primary,
      onPressed: () {
        context.read<GetUserBloc>().add(GetUser());
      },
      percentsHeight: 0.2,
      percentsWidth: 1,
    );
  }
}
