import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/widgets/custom_network_failure.dart';
import 'package:interview_master/app/widgets/custom_unknown_failure.dart';
import 'package:interview_master/core/utils/cubits/data_cubit.dart';
import 'package:interview_master/core/utils/helpers/dialog_helper.dart';
import 'package:interview_master/core/utils/services/share_service.dart';
import 'package:interview_master/data/models/interview_data.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../app/router/app_router_names.dart';
import '../../../core/utils/services/network_service.dart';
import '../../../core/utils/services/stopwatch_service.dart';
import '../../../core/utils/helpers/toast_helper.dart';
import '../../../data/models/interview_info.dart';
import '../../../data/repositories/ai_repository.dart';
import '../../../app/widgets/custom_interview_info.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../generated/l10n.dart';
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
        GetIt.I<SettingsRepository>(),
        GetIt.I<NetworkService>(),
        GetIt.I<StopwatchService>(),
        GetIt.I<Talker>(),
      )..add(FinishInterview(interviewInfo: interviewInfo)),
      child: _ResultsInfo(interviewInfo: interviewInfo),
    );
  }
}

class _ResultsInfo extends StatelessWidget {
  final InterviewInfo interviewInfo;

  const _ResultsInfo({required this.interviewInfo});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final bloc = context.read<InterviewBloc>();
    return BlocConsumer<InterviewBloc, InterviewState>(
      listener: (context, state) {
        if (state is InterviewLoading) {
          DialogHelper.showLoadingDialog(context, s.checking_answers);
        } else if (state is InterviewFinishSuccess) {
          context.pop();
        } else if (state is InterviewFailure) {
          context.pop();
          context.pushReplacement(AppRouterNames.initial);
          ToastHelper.unknownError();
        }
      },
      builder: (context, state) {
        if (state is InterviewNetworkFailure) {
          return CustomNetworkFailure(
            onPressed: () =>
                bloc.add(FinishInterview(interviewInfo: interviewInfo)),
          );
        } else if (state is InterviewFailure) {
          return CustomUnknownFailure(
            onPressed: () =>
                bloc.add(FinishInterview(interviewInfo: interviewInfo)),
          );
        } else if (state is InterviewFinishSuccess) {
          return _ResultsPageView(interview: state.interview);
        }
        return SizedBox.shrink();
      },
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
            onPressed: () => GetIt.I<ShareService>().shareInterviewResults(
              interview,
              context,
            ),
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
