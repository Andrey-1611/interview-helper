import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/utils/filter_user_cubit/filter_favourite_cubit.dart';
import 'package:interview_master/features/history/blocs/history_bloc/history_bloc.dart';
import 'package:interview_master/features/history/pages/questions_history_page.dart';
import 'package:interview_master/features/users/pages/user_info_page.dart';
import '../../../app/router/app_router_names.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../app/widgets/custom_dropdown_menu.dart';
import '../../../app/widgets/custom_filter_button.dart';
import '../../../core/constants/interviews_data.dart';
import '../../../core/theme/app_pallete.dart';
import '../../../core/utils/filter_user_cubit/filter_cubit.dart';
import '../../../core/utils/network_info.dart';
import '../../../../data/repositories/local/local.dart';
import '../../../../data/repositories/remote/remote.dart';
import '../../../data/models/user_data.dart';
import '../../../data/repositories/ai/ai.dart';
import '../../history/pages/interviews_history_page.dart';
import '../blocs/users_bloc/users_bloc.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UsersBloc(
            GetIt.I<RemoteRepository>(),
            GetIt.I<LocalRepository>(),
            GetIt.I<NetworkInfo>(),
          )..add(GetUser(widget.user)),
        ),
        BlocProvider(
          create: (context) => HistoryBloc(
            GetIt.I<RemoteRepository>(),
            GetIt.I<LocalRepository>(),
            GetIt.I<NetworkInfo>(),
          )..add(GetInterviews(userId: widget.user?.id)),
        ),
        BlocProvider(create: (context) => FilterUserCubit()),
        BlocProvider(create: (context) => FilterFavouriteCubit()),
      ],
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
        title: Text('Аналитика', style: theme.textTheme.displayLarge),
        actions: [
          if (!isCurrentUser)
            IconButton(
              onPressed: () =>
                  context.push(AppRouterNames.analysis, extra: user!),
              icon: Icon(Icons.compare_arrows),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, size.height * 0.14),
          child: _UserAppBar(
            filter: filter,
            filterController: filterController,
            isCurrentUser: isCurrentUser,
          ),
        ),
      ),
      body: TabBarView(
        children: [
          _KeepAlivePage(child: UserInfoPage(isCurrentUser: isCurrentUser)),
          _KeepAlivePage(
            child: InterviewsHistoryPage(
              filterController: filterController,
              isCurrentUser: isCurrentUser,
            ),
          ),
          _KeepAlivePage(
            child: QuestionsHistoryPage(
              filterController: filterController,
              isCurrentUser: isCurrentUser,
            ),
          ),
        ],
      ),
    );
  }

  bool get isCurrentUser => user == null;
}

class _UserAppBar extends StatelessWidget {
  final FilterUserCubit filter;
  final TextEditingController filterController;
  final bool isCurrentUser;

  const _UserAppBar({
    required this.filter,
    required this.filterController,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    final filterFavourite = context.watch<FilterFavouriteCubit>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: CustomFilterButton(
                  resetFilter: () => filter.resetUser(),
                  filterController: filterController,
                  filterDialog: _FilterDialog(
                    filterCubit: filter,
                    filterController: filterController,
                  ),
                ),
              ),
              isCurrentUser
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: IconButton(
                        onPressed: () => filterFavourite.changeFavourite(),
                        icon: Icon(
                          Icons.favorite,
                          color: filterFavourite.state
                              ? AppPalette.error
                              : AppPalette.textSecondary,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
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
            value: direction,
            data: InterviewsData.directions,
            change: (value) => direction = value,
            hintText: 'Все направления',
          ),
          CustomDropdownMenu(
            value: difficulty,
            data: InterviewsData.difficulties,
            change: (value) => difficulty = value,
            hintText: 'Все сложности',
          ),
          CustomDropdownMenu(
            value: sort,
            data: InterviewsData.interviewsSorts,
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
