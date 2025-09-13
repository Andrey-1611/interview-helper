import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/core/helpers/dialog_helpers/dialog_helper.dart';
import 'package:interview_master/features/interview/data/models/interview_info.dart';
import 'package:interview_master/features/interview/domain/use_cases/check_results_use_case.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_interview_info.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../../core/helpers/toast_helpers/toast_helper.dart';
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
              CheckResultsBloc(GetIt.I<CheckResultsUseCase>())
                ..add(CheckResults(interviewInfo: _interviewInfo)),
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
      appBar: AppBar(actions: [_HomeButton()]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _InterviewInfo(),
      ),
    );
  }
}

class _InterviewInfo extends StatelessWidget {
  const _InterviewInfo();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckResultsBloc, CheckResultsState>(
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
          return CustomInterviewInfo(interview: state.interview);
        }
        return SizedBox.shrink();
      },
    );
  }
}

class _HomeButton extends StatelessWidget {
  const _HomeButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.home),
      onPressed: () => AppRouter.pushReplacementNamed(AppRouterNames.home),
    );
  }
}
