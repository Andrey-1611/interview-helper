import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/utils/data_cubit.dart';
import 'package:interview_master/core/utils/filter_text_formatter.dart';
import 'package:interview_master/features/profile/pages/statistics_page.dart';
import 'package:interview_master/generated/l10n.dart';
import '../../../app/router/app_router_names.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../app/widgets/custom_dropdown_menu.dart';
import '../../../app/widgets/custom_filter_button.dart';
import '../../../core/constants/interviews_data.dart';
import '../../../core/utils/network_info.dart';
import '../../../data/models/user_data.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';
import '../blocs/filter_profile_cubit/filter_profile_cubit.dart';
import '../blocs/profile_bloc/profile_bloc.dart';
import 'interviews_history_page.dart';
import 'questions_history_page.dart';

class ProfilePage extends StatelessWidget {
  final UserData? user;

  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final value = context.watch<DataCubit>().state;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          key: ValueKey(value),
          create: (context) => ProfileBloc(
            GetIt.I<RemoteRepository>(),
            GetIt.I<LocalRepository>(),
            GetIt.I<NetworkInfo>(),
          )..add(GetProfile(userId: user?.id)),
        ),
        BlocProvider(create: (context) => FilterProfileCubit()),
      ],
      child: DefaultTabController(
        length: 3,
        child: _ProfilePageView(user: user),
      ),
    );
  }
}

class _ProfilePageView extends StatelessWidget {
  final UserData? user;

  const _ProfilePageView({required this.user});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final size = MediaQuery.sizeOf(context);
    final filter = context.watch<FilterProfileCubit>();
    final isCurrentUser = user == null;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.profile),
        actions: [
          if (!isCurrentUser)
            IconButton(
              onPressed: () =>
                  context.push(AppRouterNames.analysis, extra: user!),
              icon: Icon(Icons.compare_arrows),
            ),
          IconButton(
            onPressed: () => context.push(AppRouterNames.settings),
            icon: Icon(Icons.settings),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, size.height * 0.12),
          child: _ProfileAppBar(filter: filter, isCurrentUser: isCurrentUser),
        ),
      ),
      body: TabBarView(
        children: [
          _KeepAlivePage(child: StatisticsPage(user: user)),
          _KeepAlivePage(child: InterviewsHistoryPage(user: user)),
          _KeepAlivePage(child: QuestionsHistoryPage(user: user)),
        ],
      ),
    );
  }
}

class _ProfileAppBar extends StatelessWidget {
  final FilterProfileCubit filter;
  final bool isCurrentUser;

  const _ProfileAppBar({required this.filter, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: CustomFilterButton(
                  resetFilter: () => filter.reset(),
                  filterController: TextEditingController(
                    text: FilterTextFormatter.user(
                      filter.state.direction,
                      filter.state.difficulty,
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
                              ? theme.colorScheme.error
                              : theme.hintColor,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
        TabBar(
          tabs: [
            Tab(text: s.statistics),
            Tab(text: s.history),
            Tab(text: s.library),
          ],
        ),
      ],
    );
  }
}

class _FilterDialog extends StatelessWidget {
  final FilterProfileCubit filter;

  const _FilterDialog({required this.filter});

  @override
  Widget build(BuildContext context) {
    String? direction = filter.state.direction;
    String? difficulty = filter.state.difficulty;
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
            hintText: s.direction,
          ),
          CustomDropdownMenu(
            value: difficulty,
            data: List.generate(
              InterviewsData.difficulties.length,
              (i) => (value: InterviewsData.difficulties[i], text: null),
            ),
            change: (value) => difficulty = value,
            hintText: s.difficulty,
          ),
          CustomButton(
            text: s.apply,
            onPressed: () {
              filter.filter(direction, difficulty);
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
