import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/helpers/dialog_helper.dart';
import 'package:interview_master/features/interview/use_cases/check_results_use_case.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../../core/helpers/toast_helper.dart';
import '../../../data/models/interview_info.dart';
import '../blocs/check_results_bloc/check_results_bloc.dart';
import '../../../app/widgets/custom_interview_info.dart';

class ResultsPage extends StatelessWidget {
  final InterviewInfo interviewInfo;

  const ResultsPage({super.key, required this.interviewInfo});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CheckResultsBloc(GetIt.I<CheckResultsUseCase>())
                ..add(CheckResults(interviewInfo: interviewInfo)),
        ),
      ],
      child: _ResultsPageView(interviewInfo: interviewInfo),
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
          context.pop();
        } else if (state is CheckResultsFailure) {
          context.pop();
          context.pushReplacement(AppRouterNames.initial);
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
      onPressed: () => context.pushReplacement(AppRouterNames.initial),
    );
  }
}
