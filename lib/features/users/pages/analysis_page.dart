import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/router/app_router_names.dart';
import 'package:interview_master/app/widgets/custom_filter_button.dart';
import 'package:interview_master/core/utils/filter_text_formatter.dart';
import 'package:interview_master/core/utils/time_formatter.dart';
import 'package:interview_master/features/users/blocs/filter_analysis_cubit/filter_analysis_cubit.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../app/widgets/custom_dropdown_menu.dart';
import '../../../app/widgets/custom_loading_indicator.dart';
import '../../../app/widgets/custom_unknown_failure.dart';
import '../../../core/constants/interviews_data.dart';
import '../../../core/utils/network_info.dart';
import '../../../data/models/user_data.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';
import '../../../generated/l10n.dart';
import '../blocs/users_bloc/users_bloc.dart';

class AnalysisPage extends StatelessWidget {
  final UserData selectedUser;

  const AnalysisPage({super.key, required this.selectedUser});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UsersBloc(
            GetIt.I<RemoteRepository>(),
            GetIt.I<LocalRepository>(),
            GetIt.I<NetworkInfo>(),
          )..add(GetUser()),
        ),
        BlocProvider(create: (context) => FilterAnalysisCubit()),
      ],
      child: _AnalysisPageView(selectedUser: selectedUser),
    );
  }
}

class _AnalysisPageView extends StatelessWidget {
  final UserData selectedUser;

  const _AnalysisPageView({required this.selectedUser});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final filter = context.watch<FilterAnalysisCubit>();
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.analysis),
        bottom: PreferredSize(
          preferredSize: Size(size.width, size.height * 0.07),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomFilterButton(
              filterController: TextEditingController(
                text: FilterTextFormatter.analysis(
                  filter.state.direction,
                  filter.state.difficulty,
                ),
              ),
              filterDialog: _FilterDialog(filterCubit: filter),
              resetFilter: filter.reset,
            ),
          ),
        ),
      ),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          if (state is UsersFailure) {
            return CustomUnknownFailure(
              onPressed: () => context.read<UsersBloc>().add(GetUser()),
            );
          } else if (state is UserSuccess) {
            final filteredCurrentUser = UserData.filterUser(
              filter.state.direction,
              filter.state.difficulty,
              state.user,
            );
            final filteredSelectedUser = UserData.filterUser(
              filter.state.direction,
              filter.state.difficulty,
              selectedUser,
            );
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _TitleInfo(
                    user: selectedUser,
                    currentUserName: s.you,
                    selectedUserName: filteredSelectedUser.name,
                  ),
                  SizedBox(height: size.height * 0.03),
                  Expanded(
                    child: ListView(
                      children: [
                        _CompareCard(
                          title: s.interviews_count,
                          currentUserValue:
                              '${filteredCurrentUser.totalInterviews}',
                          selectedUserValue:
                              '${filteredSelectedUser.totalInterviews}',
                          icon: Icons.assignment_turned_in,
                        ),
                        _CompareCard(
                          title: s.total_score,
                          currentUserValue: '${filteredCurrentUser.totalScore}',
                          selectedUserValue:
                              '${filteredSelectedUser.totalScore}',
                          icon: Icons.score,
                        ),
                        _CompareCard(
                          title: s.average_score,
                          currentUserValue:
                              '${filteredCurrentUser.averageScore}',
                          selectedUserValue:
                              '${filteredSelectedUser.averageScore}',
                          icon: Icons.analytics,
                        ),
                        _CompareCard(
                          title: s.best_score,
                          currentUserValue: '${filteredCurrentUser.bestScore}',
                          selectedUserValue:
                              '${filteredSelectedUser.bestScore}',
                          icon: Icons.emoji_events,
                        ),
                        _CompareTimeCard(
                          title: s.total_time,
                          currentUserDuration:
                              filteredCurrentUser.totalDuration,
                          selectedUserDuration:
                              filteredSelectedUser.totalDuration,
                          icon: Icons.timer,
                        ),
                        _CompareTimeCard(
                          title: s.average_time,
                          currentUserDuration:
                              filteredCurrentUser.averageDuration,
                          selectedUserDuration:
                              filteredSelectedUser.averageDuration,
                          icon: Icons.av_timer,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const CustomLoadingIndicator();
        },
      ),
    );
  }
}

class _TitleInfo extends StatelessWidget {
  final UserData user;
  final String currentUserName;
  final String selectedUserName;

  const _TitleInfo({
    required this.currentUserName,
    required this.selectedUserName,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.person, size: size.height * 0.06),
                Text(
                  currentUserName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.compare_arrows, size: size.height * 0.045),
                Text('VS'),
              ],
            ),
            GestureDetector(
              onTap: () => context.push(AppRouterNames.profile, extra: user),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.person, size: size.height * 0.06),
                  Text(
                    selectedUserName,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompareCard extends StatelessWidget {
  final String title;
  final String currentUserValue;
  final String selectedUserValue;
  final IconData icon;

  const _CompareCard({
    required this.title,
    required this.currentUserValue,
    required this.selectedUserValue,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon),
                Text(title, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  currentUserValue,
                  style: style(theme, currentUserValue, selectedUserValue),
                ),
                const Text('vs'),
                Text(
                  selectedUserValue,
                  style: style(theme, selectedUserValue, currentUserValue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextStyle? style(ThemeData theme, String value1, String value2) {
    return int.parse(value1) >= int.parse(value2)
        ? theme.textTheme.displayMedium?.copyWith(color: theme.primaryColor)
        : theme.textTheme.displayMedium;
  }
}

class _CompareTimeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Duration currentUserDuration;
  final Duration selectedUserDuration;

  const _CompareTimeCard({
    required this.currentUserDuration,
    required this.selectedUserDuration,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon),
                Text(title, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  TimeFormatter.time(currentUserDuration, context),
                  style: style(
                    theme,
                    currentUserDuration,
                    selectedUserDuration,
                  ),
                ),
                const Text('vs'),
                Text(
                  TimeFormatter.time(selectedUserDuration, context),
                  style: style(
                    theme,
                    selectedUserDuration,
                    currentUserDuration,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextStyle? style(ThemeData theme, Duration value1, Duration value2) {
    return value1 >= value2
        ? theme.textTheme.bodySmall?.copyWith(color: theme.primaryColor)
        : theme.textTheme.bodySmall;
  }
}

class _FilterDialog extends StatelessWidget {
  final FilterAnalysisCubit filterCubit;

  const _FilterDialog({required this.filterCubit});

  @override
  Widget build(BuildContext context) {
    String? direction = filterCubit.state.direction;
    String? difficulty = filterCubit.state.difficulty;
    final s = S.of(context);
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDropdownMenu(
            value: direction,
            data: List.generate(
              InterviewsData.directions.length,
              (i) => (value: InterviewsData.directions[i], text: null),
            ),
            change: (value) => direction = value,
            hintText: s.all_directions,
          ),
          CustomDropdownMenu(
            value: difficulty,
            data: List.generate(
              InterviewsData.difficulties.length,
              (i) => (value: InterviewsData.difficulties[i], text: null),
            ),
            change: (value) => difficulty = value,
            hintText: s.all_difficulties,
          ),
          CustomButton(
            text: s.apply,
            onPressed: () {
              filterCubit.filter(direction, difficulty, null);
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
