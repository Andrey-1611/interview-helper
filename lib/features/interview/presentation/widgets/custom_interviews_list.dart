import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/interview/data/models/interview_info.dart';
import 'package:intl/intl.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../app/widgets/custom_loading_indicator.dart';
import '../../../../core/helpers/toast_helpers/toast_helper.dart';
import '../../data/models/interview.dart';
import '../blocs/show_interviews_bloc/show_interviews_bloc.dart';
import 'custom_score_indicator.dart';

class CustomInterviewsList extends StatelessWidget {
  final InterviewInfo interviewInfo;

  const CustomInterviewsList({super.key, required this.interviewInfo});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShowInterviewsBloc, ShowInterviewsState>(
      listener: (context, state) {
        if (state is ShowInterviewsFailure) {
          ToastHelper.loadingError();
        }
      },
      builder: (context, state) {
        if (state is ShowInterviewsLoading) {
          return CustomLoadingIndicator();
        } else if (state is ShowInterviewsSuccess) {
          if (state.interviews.isEmpty) return _EmptyHistory();
          return _InterviewsListView(
            interviews: Interview.filterInterviews(
              interviewInfo.direction,
              interviewInfo.difficultly,
              state.interviews,
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'История пуста',
        style: Theme.of(context).textTheme.displayLarge,
      ),
    );
  }
}

class _InterviewsListView extends StatelessWidget {
  final List<Interview> interviews;

  const _InterviewsListView({required this.interviews});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: interviews.length,
        itemBuilder: (context, index) {
          final interview = interviews[index];
          return _InterviewCard(interview: interview);
        },
      ),
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
      child: Card(
        child: ListTile(
          leading: ScoreIndicator(score: interview.score),
          title: Text(
            '${interview.direction}, ${interview.difficulty}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd/MM/yyyy HH:mm').format(interview.date),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
