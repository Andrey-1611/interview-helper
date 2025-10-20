import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/features/history/blocs/history_bloc/history_bloc.dart';
import '../../../../app/widgets/custom_interview_info.dart';
import '../../../core/utils/network_info.dart';
import '../../../data/models/interview/interview_data.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';

class InterviewInfoPage extends StatelessWidget {
  final InterviewData interview;
  final bool isCurrentUser;

  const InterviewInfoPage({
    super.key,
    required this.interview,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryBloc(
        GetIt.I<RemoteRepository>(),
        GetIt.I<LocalRepository>(),
        GetIt.I<NetworkInfo>(),
      ),
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomInterviewInfo(interview: interview),
        ),
      ),
    );
  }
}
