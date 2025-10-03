import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/features/users/pages/user_info_page.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../app/widgets/custom_dropdown_menu.dart';
import '../../../app/widgets/custom_filter_button.dart';
import '../../../core/constants/data.dart';
import '../../../core/theme/app_pallete.dart';
import '../../../core/utils/filter_user_cubit/filter_cubit.dart';
import '../../../data/models/interview/interview_info.dart';
import '../../../data/models/user/user_data.dart';
import '../../history/pages/interviews_history_page.dart';

class UserPage extends StatefulWidget {
  final UserData? user;

  const UserPage({super.key, required this.user});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _filterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FilterUserCubit(),
      child: DefaultTabController(
        length: 3,
        child: _UserPageView(
          filterController: _filterController,
          user: widget.user,
        ),
      ),
    );
  }
}

class _UserPageView extends StatelessWidget {
  final TextEditingController filterController;
  final UserData? user;

  const _UserPageView({required this.filterController, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final filter = context.read<FilterUserCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPalette.background,
        title: Text('Аналитика', style: theme.textTheme.displayLarge),
        bottom: PreferredSize(
          preferredSize: Size(
            double.infinity,
            size.height * 0.14,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomFilterButton(
                  resetFilter: filter.resetUser,
                  filterController: filterController,
                  filterDialog: _FilterDialog(
                    filterCubit: filter,
                    filterController: filterController,
                  ),
                ),
              ),
              TabBar(
                tabs: [
                  Tab(text: 'Статистика'),
                  Tab(text: 'История'),
                  Tab(text: 'Библиотека'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        children: [
          _KeepAlivePage(child: UserInfoPage()),
          _KeepAlivePage(child: InterviewsHistoryPage(userId: user?.id, filterController: filterController)),
          _KeepAlivePage(child: Scaffold()),
        ],
      ),
    );
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
    String? sort = filterCubit.state.sort;
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
          CustomDropdownMenu(
            initialValue: sort,
            data: InitialData.interviewsSorts,
            change: (value) => sort = value,
            hintText: 'Сортировка',
          ),
          CustomButton(
            text: 'Применить',
            selectedColor: AppPalette.primary,
            onPressed: () {
              _filter(direction, difficulty, sort);
              context.pop();
            },
          ),
        ],
      ),
    );
  }

  void _filter(String? direction, String? difficulty, String? sort) {
    filterCubit.filterUser(direction, difficulty, sort);
    filterController.text = InterviewInfo.textInFilter(
      direction ?? '',
      difficulty ?? '',
      sort ?? '',
    );
  }
}

class _KeepAlivePage extends StatefulWidget {
  final Widget child;

  const _KeepAlivePage({required this.child});

  @override
  State<_KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<_KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
