import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:intl/intl.dart';
import '../../../../app/dependencies/di_container.dart';
import '../../../../app/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/helpers/toast_helpers/toast_helper.dart';
import '../../data/models/interview.dart';
import '../blocs/show_interviews_bloc/show_interviews_bloc.dart';
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
          create: (context) => GetUserBloc(DIContainer.getUser)..add(GetUser()),
        ),
        BlocProvider(
          create: (context) => ShowInterviewsBloc(DIContainer.showInterviews),
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
            if (state is GetUserSuccess) {
              context.read<ShowInterviewsBloc>().add(
                ShowInterviews(userId: state.user.id ?? ''),
              );
            } else if (state is GetUserFailure) {
              ToastHelper.unknownError();
            }
          },
        ),
        BlocListener<ShowInterviewsBloc, ShowInterviewsState>(
          listener: (context, state) {
            if (state is ShowInterviewsFailure) {
              ToastHelper.loadingError();
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
        if (state is ShowInterviewsLoading) {
          return CustomLoadingIndicator();
        } else if (state is ShowInterviewsSuccess) {
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
        titleText: 'Сложность: ${interview.difficulty}',
        firstText: DateFormat('dd/MM/yyyy HH:mm').format(interview.date),
        titleStyle: Theme.of(context).textTheme.bodyMedium,
        subtitleStyle: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
