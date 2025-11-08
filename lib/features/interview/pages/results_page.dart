import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/utils/data_cubit.dart';
import 'package:interview_master/core/utils/dialog_helper.dart';
import 'package:interview_master/core/utils/share_info.dart';
import 'package:interview_master/data/models/interview_data.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../core/utils/network_info.dart';
import '../../../core/utils/stopwatch_info.dart';
import '../../../core/utils/toast_helper.dart';
import '../../../data/repositories/ai/ai.dart';
import '../../../data/repositories/local/local.dart';
import '../../../data/repositories/remote/remote.dart';
import '../../../app/widgets/custom_interview_info.dart';
import '../blocs/interview_bloc/interview_bloc.dart';

class ResultsPage extends StatelessWidget {
  final InterviewInfo interviewInfo;

  const ResultsPage({super.key, required this.interviewInfo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InterviewBloc(
        GetIt.I<AIRepository>(),
        GetIt.I<RemoteRepository>(),
        GetIt.I<LocalRepository>(),
        GetIt.I<NetworkInfo>(),
        GetIt.I<StopwatchInfo>(),
      )..add(FinishInterview(interviewInfo: interviewInfo)),
      child: BlocConsumer<InterviewBloc, InterviewState>(
        listener: (context, state) {
          if (state is InterviewLoading) {
            DialogHelper.showLoadingDialog(context, 'Проверка ответов...');
          } else if (state is InterviewFinishSuccess) {
            context.pop();
          } else if (state is InterviewFailure) {
            context.pop();
            context.pushReplacement(AppRouterNames.initial);
            ToastHelper.unknownError();
          }
        },
        builder: (context, state) {
          if (state is InterviewFinishSuccess) {
            return _ResultsPageView(interview: state.interview);
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}

class _ResultsPageView extends StatelessWidget {
  final InterviewData interview;

  const _ResultsPageView({required this.interview});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () =>
                GetIt.I<ShareInfo>().shareInterviewResults(interview),
            icon: Icon(Icons.share),
          ),
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              context.pushReplacement(AppRouterNames.initial);
              context.read<DataCubit>().updateKeyValue();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomInterviewInfo(interview: interview),
      ),
    );
  }
}
