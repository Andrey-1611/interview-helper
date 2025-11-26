import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/data/models/user_data.dart';
import 'package:interview_master/features/profile/blocs/profile_bloc/profile_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../../app/widgets/custom_loading_indicator.dart';
import '../../../app/widgets/custom_score_indicator.dart';
import '../../../app/widgets/custom_unknown_failure.dart';
import '../../../data/models/interview_data.dart';
import '../../../data/models/interview_info.dart';
import '../../../app/widgets/custom_network_failure.dart';
import '../blocs/filter_profile_cubit/filter_profile_cubit.dart';
import '../widgets/custom_empty_filter_history.dart';
import '../widgets/custom_empty_history.dart';

class InterviewsHistoryPage extends StatelessWidget {
  final UserData? user;

  const InterviewsHistoryPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = user == null;
    final onPressed = context.read<ProfileBloc>().add(
      GetProfile(userId: user?.id),
    );
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileNetworkFailure) {
          return CustomNetworkFailure(onPressed: () => onPressed);
        } else if (state is ProfileFailure) {
          return CustomUnknownFailure(onPressed: () => onPressed);
        } else if (state is ProfileSuccess) {
          if (state.interviews.isEmpty) {
            return CustomEmptyHistory(isCurrentUser: isCurrentUser);
          }
          final filter = context.watch<FilterProfileCubit>();
          final filteredInterviews = InterviewData.filterInterviews(
            filter.state.direction,
            filter.state.difficulty,
            filter.state.sort,
            filter.state.isFavourite,
            state.interviews,
          );
          if (filteredInterviews.isEmpty) {
            return CustomEmptyFilterHistory();
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: filteredInterviews.length,
              itemBuilder: (context, index) {
                return _InterviewCard(
                  interview: filteredInterviews[index],
                  isCurrentUser: isCurrentUser,
                );
              },
            ),
          );
        }
        return CustomLoadingIndicator();
      },
    );
  }
}

class _InterviewCard extends StatelessWidget {
  final InterviewData interview;
  final bool isCurrentUser;

  const _InterviewCard({required this.interview, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        context.push(AppRouterNames.interviewInfo, extra: interview);
      },
      child: Card(
        child: ListTile(
          leading: CustomScoreIndicator(score: interview.score),
          title: Text(
            '${interview.direction}, ${interview.difficulty}',
            style: theme.textTheme.bodyLarge,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd/MM/yyyy HH:mm').format(interview.date),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          trailing: isCurrentUser
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          StatefulNavigationShell.of(context).goBranch(0);
                          context.push(
                            AppRouterNames.interview,
                            extra: InterviewInfo(
                              userInputs: [],
                              direction: interview.direction,
                              difficulty: interview.difficulty,
                              id: interview.id,
                            ),
                          );
                        },
                        icon: Icon(Icons.refresh),
                      ),
                      IconButton(
                        onPressed: () => context.read<ProfileBloc>().add(
                          ChangeIsFavouriteInterview(interviewId: interview.id),
                        ),
                        icon: Icon(Icons.favorite),
                        color: interview.isFavourite
                            ? theme.colorScheme.error
                            : theme.hintColor,
                      ),
                    ],
                  ),
                )
              : Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
