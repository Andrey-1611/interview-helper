import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/utils/filter_user_cubit/filter_favourite_cubit.dart';
import 'package:interview_master/core/utils/filter_user_cubit/filter_cubit.dart';
import 'package:interview_master/features/history/blocs/history_bloc/history_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../../app/widgets/custom_loading_indicator.dart';
import '../../../app/widgets/custom_score_indicator.dart';
import '../../../core/theme/app_pallete.dart';
import '../../../data/models/interview/interview_data.dart';
import '../../users/widgets/custom_network_failure.dart';
import '../widgets/custom_empty_filter_history.dart';
import '../widgets/custom_empty_history.dart';

class InterviewsHistoryPage extends StatelessWidget {
  final TextEditingController filterController;
  final bool isCurrentUser;

  const InterviewsHistoryPage({
    super.key,
    required this.filterController,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state is HistoryNetworkFailure) {
          return CustomNetworkFailure();
        } else if (state is HistorySuccess) {
          if (state.interviews.isEmpty) {
            return CustomEmptyHistory(isCurrentUser: isCurrentUser);
          }
          final filterState = context.watch<FilterUserCubit>().state;
          final isFavourite = context.watch<FilterFavouriteCubit>().state;
          final filteredInterviews = InterviewData.filterInterviews(
            filterState.direction,
            filterState.difficulty,
            filterState.sort,
            isFavourite,
            state.interviews,
          );
          if (filteredInterviews.isEmpty) {
            return CustomEmptyFilterHistory(filterController: filterController);
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
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        context.push(
          AppRouterNames.interviewInfo,
          extra: {'interview': interview, 'isCurrentUser': isCurrentUser},
        );
      },
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
          trailing: isCurrentUser
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: IconButton(
                    onPressed: () => context.read<HistoryBloc>().add(
                      ChangeIsFavouriteInterview(interviewId: interview.id),
                    ),
                    icon: Icon(
                      Icons.favorite,
                      color: interview.isFavourite
                          ? AppPalette.error
                          : AppPalette.textSecondary,
                    ),
                  ),
                )
              : SizedBox(),
        ),
      ),
    );
  }
}
