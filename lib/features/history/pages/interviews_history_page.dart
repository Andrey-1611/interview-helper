
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/utils/filter_favourite_cubit.dart';
import 'package:interview_master/core/utils/filter_user_cubit/filter_cubit.dart';
import 'package:interview_master/features/history/blocs/change_is_favourite_bloc/change_is_favourite_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../../app/widgets/custom_loading_indicator.dart';
import '../../../../app/widgets/custom_score_indicator.dart';
import '../../../../core/helpers/toast_helper.dart';
import '../../../core/theme/app_pallete.dart';
import '../../../data/models/interview/interview_data.dart';
import '../../users/widgets/custom_network_failure.dart';
import '../blocs/show_interviews_bloc/show_interviews_bloc.dart';

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
    return MultiBlocListener(
      listeners: [
        BlocListener<ShowInterviewsBloc, ShowInterviewsState>(
          listener: (context, state) {
            if (state is ShowInterviewsFailure) {
              ToastHelper.loadingError();
            }
          },
        ),
        BlocListener<ChangeIsFavouriteBloc, ChangeIsFavouriteState>(
          listener: (context, state) {
            if (state is ChangeIsFavouriteFailure) {
              ToastHelper.loadingError();
            } else if (state is ChangeIsFavouriteNetworkFailure) {
              ToastHelper.networkError();
            } else if (state is ChangeIsFavouriteSuccess) {
              context.read<ShowInterviewsBloc>().add(
                ShowInterviews(userId: null),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<ShowInterviewsBloc, ShowInterviewsState>(
        builder: (context, state) {
          if (state is ShowInterviewsNetworkFailure) {
            return NetworkFailure();
          } else if (state is ShowInterviewsSuccess) {
            if (state.interviews.isEmpty) {
              return _EmptyHistory(isCurrentUser: isCurrentUser);
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
              return _EmptyFilterHistory(filterController: filterController);
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
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  final bool isCurrentUser;

  const _EmptyHistory({required this.isCurrentUser});

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
          isCurrentUser
              ? TextButton(
                  onPressed: () {
                    StatefulNavigationShell.of(context).goBranch(0);
                    context.push(AppRouterNames.initial);
                  },
                  child: Text('Пройти собеседование'),
                )
              : SizedBox(),
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
            onPressed: () => _resetFilter(context),
            child: Text('Сбросить фильтр'),
          ),
        ],
      ),
    );
  }

  void _resetFilter(BuildContext context) {
    final favourite = context.read<FilterFavouriteCubit>();
    context.read<FilterUserCubit>().resetUser();
    filterController.clear();
    if (favourite.state == true) favourite.changeFavourite();
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
                    onPressed: () {
                      context.read<ChangeIsFavouriteBloc>().add(
                        ChangeIsFavouriteInterview(id: interview.id),
                      );
                    },
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
