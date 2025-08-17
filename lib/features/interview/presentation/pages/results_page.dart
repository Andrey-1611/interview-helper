import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/core/helpers/dialog_helpers/dialog_helper.dart';
import 'package:interview_master/features/interview/data/models/interview_info.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_interview_info.dart';
import '../../../../app/dependencies/di_container.dart';
import '../../../../app/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/helpers/toast_helpers/toast_helper.dart';
import '../../data/models/interview.dart';
import '../blocs/add_interview_bloc/add_interview_bloc.dart';
import '../blocs/check_results_bloc/check_results_bloc.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late final InterviewInfo _interviewInfo;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _interviewInfo =
        ModalRoute.of(context)!.settings.arguments as InterviewInfo;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CheckResultsBloc(DIContainer.checkResults)
                ..add(CheckResults(userInputs: _interviewInfo.userInputs)),
        ),
        BlocProvider(create: (context) => GetUserBloc(DIContainer.getUser)),
        BlocProvider(
          create: (context) => AddInterviewBloc(DIContainer.addInterview),
        ),
      ],
      child: _ResultsPageView(interviewInfo: _interviewInfo),
    );
  }
}

class _ResultsPageView extends StatelessWidget {
  final InterviewInfo interviewInfo;

  const _ResultsPageView({required this.interviewInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CheckResultsBloc, CheckResultsState>(
        listener: (context, state) {
          if (state is CheckResultsLoading) {
            DialogHelper.showLoadingDialog(context, 'Проверка ответов...');
          } else if (state is CheckResultsSuccess) {
            AppRouter.pop();
          } else if (state is CheckResultsFailure) {
            AppRouter.pop();
            AppRouter.pushReplacementNamed(AppRouterNames.home);
            ToastHelper.unknownError();
          }
        },
        builder: (context, state) {
          if (state is CheckResultsSuccess) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                actions: [
                  _SaveResultsButton(
                    questions: state.questions,
                    interviewInfo: interviewInfo,
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomInterviewInfo(
                  interview: Interview.fromQuestions(
                    state.questions,
                    interviewInfo,
                  ),
                ),
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
  final InterviewInfo interviewInfo;
  final List<Question> questions;

  const _SaveResultsButton({
    required this.interviewInfo,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetUserBloc, GetUserState>(
          listener: (context, state) {
            if (state is GetUserLoading) {
              DialogHelper.showLoadingDialog(
                context,
                'Сохранение результатов...',
              );
            }
            if (state is GetUserSuccess) {
              context.read<AddInterviewBloc>().add(
                AddInterview(
                  interview: Interview.fromQuestions(questions, interviewInfo),
                  userId: state.user.id!,
                ),
              );
            } else if (state is GetUserFailure) {
              AppRouter.pop();
              ToastHelper.unknownError();
              AppRouter.pushReplacementNamed(AppRouterNames.home);
            }
          },
        ),
        BlocListener<AddInterviewBloc, AddInterviewState>(
          listener: (context, state) {
            if (state is AddInterviewSuccess) {
              AppRouter.pop();
              AppRouter.pushReplacementNamed(AppRouterNames.home);
            } else if (state is AddInterviewFailure) {
              AppRouter.pop();
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
    return IconButton(
      icon: Icon(Icons.home),
      onPressed: () {
        context.read<GetUserBloc>().add(GetUser());
      },
    );
  }
}
