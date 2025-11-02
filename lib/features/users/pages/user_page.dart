import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/utils/filter_text_formatter.dart';
import 'package:interview_master/features/history/blocs/history_bloc/history_bloc.dart';
import 'package:interview_master/features/history/pages/questions_history_page.dart';
import 'package:interview_master/features/users/pages/user_info_page.dart';
import '../../../app/router/app_router_names.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../app/widgets/custom_dropdown_menu.dart';
import '../../../app/widgets/custom_filter_button.dart';
import '../../../core/constants/interviews_data.dart';
import '../../../core/theme/app_pallete.dart';
import '../../../core/utils/network_info.dart';
import '../../../../data/repositories/local/local.dart';
import '../../../../data/repositories/remote/remote.dart';
import '../../../data/models/user_data.dart';
import '../../history/pages/interviews_history_page.dart';
import '../blocs/filter_user_cubit/filter_user_cubit.dart';
import '../blocs/users_bloc/users_bloc.dart';

class UserPage extends StatelessWidget {
  final UserData? user;

  const UserPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UsersBloc(
            GetIt.I<RemoteRepository>(),
            GetIt.I<LocalRepository>(),
            GetIt.I<NetworkInfo>(),
          )..add(GetUser(user)),
        ),
        BlocProvider(
          create: (context) => HistoryBloc(
            GetIt.I<RemoteRepository>(),
            GetIt.I<LocalRepository>(),
            GetIt.I<NetworkInfo>(),
          )..add(GetInterviews(userId: user?.id)),
        ),
        BlocProvider(create: (context) => FilterUserCubit()),
      ],
      child: DefaultTabController(length: 3, child: _UserPageView(user: user)),
    );
  }
}

class _UserPageView extends StatelessWidget {
  final UserData? user;

  const _UserPageView({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final filter = context.watch<FilterUserCubit>();
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
          IconButton(
            onPressed: () => context.push(AppRouterNames.profile),
            icon: Icon(Icons.settings),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, size.height * 0.14),
          child: _UserAppBar(filter: filter, isCurrentUser: isCurrentUser),
        ),
      ),
      body: TabBarView(
        children: [
          _KeepAlivePage(child: UserInfoPage(isCurrentUser: isCurrentUser)),
          _KeepAlivePage(
            child: InterviewsHistoryPage(isCurrentUser: isCurrentUser),
          ),
          _KeepAlivePage(
            child: QuestionsHistoryPage(isCurrentUser: isCurrentUser),
          ),
        ],
      ),
    );
  }

  bool get isCurrentUser => user == null;
}

class _UserAppBar extends StatelessWidget {
  final FilterUserCubit filter;
  final bool isCurrentUser;

  const _UserAppBar({required this.filter, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: CustomFilterButton(
                  resetFilter: () => filter.resetUser(),
                  filterController: TextEditingController(
                    text: FilterTextFormatter.user(
                      filter.state.direction,
                      filter.state.difficulty,
                      filter.state.sort,
                    ),
                  ),
                  filterDialog: _FilterDialog(filter: filter),
                ),
              ),
              isCurrentUser
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: IconButton(
                        onPressed: () => filter.changeIsFavourite(),
                        icon: Icon(
                          Icons.favorite,
                          color: filter.state.isFavourite
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
  final FilterUserCubit filter;

  const _FilterDialog({required this.filter});

  @override
  Widget build(BuildContext context) {
    String? direction = filter.state.direction;
    String? difficulty = filter.state.difficulty;
    String? sort = filter.state.sort;
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDropdownMenu(
            value: direction,
            data: InterviewsData.directions,
            change: (value) => direction = value,
            hintText: 'Направление',
          ),
          CustomDropdownMenu(
            value: difficulty,
            data: InterviewsData.difficulties,
            change: (value) => difficulty = value,
            hintText: 'Сложность',
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
              filter.filterUser(direction, difficulty, sort);
              context.pop();
            },
          ),
        ],
      ),
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
