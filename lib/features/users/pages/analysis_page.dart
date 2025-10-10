import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/widgets/custom_filter_button.dart';
import 'package:interview_master/core/theme/app_pallete.dart';

import '../../../app/widgets/custom_button.dart';
import '../../../app/widgets/custom_dropdown_menu.dart';
import '../../../app/widgets/custom_loading_indicator.dart';
import '../../../core/constants/data.dart';
import '../../../core/utils/filter_user_cubit/filter_cubit.dart';
import '../../../data/models/interview/interview_info.dart';
import '../../../data/models/user/user_data.dart';
import '../blocs/get_user_bloc/get_user_bloc.dart';
import '../use_cases/get_user_use_case.dart';

class AnalysisPage extends StatefulWidget {
  final UserData selectedUser;

  const AnalysisPage({super.key, required this.selectedUser});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  final _filterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GetUserBloc(GetIt.I<GetUserUseCase>())
                ..add(GetUser(userData: null)),
        ),
        BlocProvider(create: (context) => FilterUserCubit()),
      ],
      child: _AnalysisPageView(
        selectedUser: widget.selectedUser,
        filterController: _filterController,
      ),
    );
  }
}

class _AnalysisPageView extends StatelessWidget {
  final UserData selectedUser;
  final TextEditingController filterController;

  const _AnalysisPageView({
    required this.selectedUser,
    required this.filterController,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final filter = context.watch<FilterUserCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Анализ'),
        bottom: PreferredSize(
          preferredSize: Size(size.width, size.height * 0.07),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomFilterButton(
              filterController: filterController,
              filterDialog: _FilterDialog(
                filterCubit: filter,
                filterController: filterController,
              ),
              resetFilter: filter.resetUser,
            ),
          ),
        ),
      ),
      body: BlocBuilder<GetUserBloc, GetUserState>(
        builder: (context, state) {
          if (state is GetUserSuccess) {
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
                    currentUserName: 'Вы',
                    selectedUserName: filteredSelectedUser.name,
                  ),
                  SizedBox(height: size.height * 0.03),
                  Expanded(
                    child: ListView(
                      children: [
                        _CompareCard(
                          title: 'Количество собеседований',
                          currentUserValue:
                              '${filteredCurrentUser.totalInterviews}',
                          selectedUserValue:
                              '${filteredSelectedUser.totalInterviews}',
                          icon: Icons.assignment_turned_in,
                        ),
                        _CompareCard(
                          title: 'Общее количество очков',
                          currentUserValue: '${filteredCurrentUser.totalScore}',
                          selectedUserValue:
                              '${filteredSelectedUser.totalScore}',
                          icon: Icons.score,
                        ),
                        _CompareCard(
                          title: 'Средний результат',
                          currentUserValue:
                              '${filteredCurrentUser.averageScore}',
                          selectedUserValue:
                              '${filteredSelectedUser.averageScore}',
                          icon: Icons.analytics,
                        ),
                        _CompareCard(
                          title: 'Лучший результат',
                          currentUserValue: '${filteredCurrentUser.bestScore}',
                          selectedUserValue:
                              '${filteredSelectedUser.bestScore}',
                          icon: Icons.emoji_events,
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
  final String currentUserName;
  final String selectedUserName;

  const _TitleInfo({
    required this.currentUserName,
    required this.selectedUserName,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.person, size: size.height * 0.06),
                Text(
                  selectedUserName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
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
        ? theme.textTheme.displayMedium?.copyWith(color: AppPalette.primary)
        : theme.textTheme.displayMedium;
  }
}

class _FilterDialog extends StatelessWidget {
  final FilterUserCubit filterCubit;
  final TextEditingController filterController;

  const _FilterDialog({
    required this.filterCubit,
    required this.filterController,
  });

  @override
  Widget build(BuildContext context) {
    String? direction = filterCubit.state.direction;
    String? difficulty = filterCubit.state.difficulty;
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDropdownMenu(
            initialValue: direction,
            data: InitialData.directions,
            change: (value) => direction = value,
            hintText: 'Все направления',
          ),
          CustomDropdownMenu(
            initialValue: difficulty,
            data: InitialData.difficulties,
            change: (value) => difficulty = value,
            hintText: 'Все сложности',
          ),
          CustomButton(
            text: 'Применить',
            selectedColor: AppPalette.primary,
            onPressed: () {
              _filter(direction, difficulty);
              context.pop();
            },
          ),
        ],
      ),
    );
  }

  void _filter(String? direction, String? difficulty) {
    filterCubit.filterUser(direction, difficulty, null);
    filterController.text = InterviewInfo.textInFilter(
      direction ?? '',
      difficulty ?? '',
      '',
    );
  }
}
