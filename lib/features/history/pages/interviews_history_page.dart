import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/utils/filter_user_cubit/filter_cubit.dart';
import 'package:intl/intl.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../../app/widgets/custom_loading_indicator.dart';
import '../../../../app/widgets/custom_score_indicator.dart';
import '../../../../core/helpers/toast_helper.dart';
import '../../../data/models/interview/interview_data.dart';
import '../../users/widgets/custom_network_failure.dart';
import '../blocs/show_interviews_bloc/show_interviews_bloc.dart';

class InterviewsHistoryPage extends StatelessWidget {
  final TextEditingController filterController;

  const InterviewsHistoryPage({super.key, required this.filterController});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShowInterviewsBloc, ShowInterviewsState>(
      listener: (context, state) {
        if (state is ShowInterviewsFailure) {
          ToastHelper.loadingError();
        }
      },
      builder: (context, state) {
        if (state is ShowInterviewsNetworkFailure) {
          return NetworkFailure();
        } else if (state is ShowInterviewsSuccess) {
          if (state.interviews.isEmpty) return _EmptyHistory();
          final filterState = context.watch<FilterUserCubit>().state;
          final filteredInterviews = InterviewData.filterInterviews(
            filterState.direction,
            filterState.difficulty,
            filterState.sort,
            state.interviews,
          );
          if (filteredInterviews.isEmpty) {
            return _EmptyFilterHistory(filterController: filterController);
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: filteredInterviews.length,
              itemBuilder: (context, index) {
                return _InterviewCard(interview: filteredInterviews[index]);
              },
            ),
          );
        }
        return CustomLoadingIndicator();
      },
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'История пуста',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          TextButton(
            onPressed: () {
              StatefulNavigationShell.of(context).goBranch(0);
              context.push(AppRouterNames.initial);
            },
            child: Text('Пройти собеседование'),
          ),
        ],
      ),
    );
  }
}

class _EmptyFilterHistory extends StatelessWidget {
  final TextEditingController filterController;

  const _EmptyFilterHistory({required this.filterController});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'История пуста',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          TextButton(
            onPressed: () {
              context.read<FilterUserCubit>().resetUser();
              filterController.clear();
            },
            child: Text('Сбросить фильтр'),
          ),
        ],
      ),
    );
  }
}

class _InterviewCard extends StatelessWidget {
  final InterviewData interview;

  const _InterviewCard({required this.interview});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => context.push(AppRouterNames.interviewInfo, extra: interview),
      child: Card(
        child: ListTile(
          leading: CustomScoreIndicator(score: interview.score),
          title: Text(
            '${interview.direction}, ${interview.difficulty}',
            style: textTheme.bodyLarge,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd/MM/yyyy HH:mm').format(interview.date),
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
