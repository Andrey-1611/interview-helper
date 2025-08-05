import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/core/helpers/dialog_helpers/dialog_helper.dart';
import 'package:intl/intl.dart';
import '../../../../app/dependencies/di_container.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../core/helpers/notification_helpers/notification_helper.dart';
import '../../blocs/show_interviews_bloc/show_interviews_bloc.dart';
import '../../data/models/interview.dart';
import '../widgets/custom_interview_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GetUserBloc(DIContainer.userRepository)..add(GetUser()),
        ),
        BlocProvider(
          create: (context) =>
              ShowInterviewsBloc(DIContainer.firestoreRepository),
        ),
      ],
      child: _HistoryList(),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetUserBloc, GetUserState>(
          listener: (context, state) {
            if (state is GetUserLoading) {
              DialogHelper.showLoadingDialog(context);
            }
            if (state is GetUserSuccess) {
              context.read<ShowInterviewsBloc>().add(
                ShowInterviews(userId: state.userProfile.id ?? ''),
              );
            }
          },
        ),
        BlocListener<ShowInterviewsBloc, ShowInterviewsState>(
          listener: (context, state) {
            if (state is ShowInterviewsSuccess) {
              AppRouter.pop();
            }
            if (state is ShowInterviewsFailure) {
              AppRouter.pop();
              NotificationHelper.interview.showInterviewsError(context);
            }
          },
        ),
      ],
      child: _HistoryListView(),
    );
  }
}

class _HistoryListView extends StatelessWidget {
  const _HistoryListView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowInterviewsBloc, ShowInterviewsState>(
      builder: (context, state) {
        if (state is ShowInterviewsSuccess) {
          if (state.interviews.isEmpty) {
            return const Center(child: Text('История пуста'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: state.interviews.length,
              itemBuilder: (context, index) {
                final interview = state.interviews[index];
                return _InterviewCard(interview: interview);
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _InterviewCard extends StatelessWidget {
  final Interview interview;

  const _InterviewCard({required this.interview});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRouter.pushNamed(AppRouterNames.interviewInfo, arguments: interview);
      },
      child: CustomInterviewCard(
        score: interview.score.toInt(),
        titleText: 'Сложность: ${_chooseDifficulty(interview.difficulty)}',
        firstText: DateFormat('dd/MM/yyyy HH:mm').format(interview.date),
        titleStyle: Theme.of(context).textTheme.bodyMedium,
        subtitleStyle: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  String _chooseDifficulty(int difficult) {
    String difficultly = '';
    switch (difficult) {
      case 1:
        difficultly = 'Junior';
      case 2:
        difficultly = 'Middle';
      case 3:
        difficultly = 'Senior';
    }
    return difficultly;
  }
}
