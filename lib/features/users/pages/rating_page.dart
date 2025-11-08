import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/utils/data_cubit.dart';
import 'package:interview_master/core/utils/filter_text_formatter.dart';
import 'package:interview_master/features/users/pages/friends_page.dart';
import 'package:interview_master/features/users/pages/users_page.dart';
import '../../../app/router/app_router_names.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../app/widgets/custom_dropdown_menu.dart';
import '../../../app/widgets/custom_filter_button.dart';
import '../../../core/constants/interviews_data.dart';
import '../../../core/theme/app_pallete.dart';
import '../../../core/utils/network_info.dart';
import '../../../../data/repositories/local/local.dart';
import '../../../../data/repositories/remote/remote.dart';
import '../blocs/filter_user_cubit/filter_user_cubit.dart';
import '../blocs/filter_users_cubit/filter_users_cubit.dart';
import '../blocs/users_bloc/users_bloc.dart';

class RatingPage extends StatelessWidget {
  const RatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final value = context.watch<DataCubit>().state;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          key: ValueKey(value),
          create: (context) =>
              UsersBloc(
                  GetIt.I<RemoteRepository>(),
                  GetIt.I<LocalRepository>(),
                  GetIt.I<NetworkInfo>(),
                )
                ..add(GetUser())
                ..add(GetFriends()),
        ),
        BlocProvider(create: (context) => FilterUserCubit()),
      ],
      child: DefaultTabController(length: 2, child: _RatingPageView()),
    );
  }
}

class _RatingPageView extends StatelessWidget {
  const _RatingPageView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final filter = context.watch<FilterUsersCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Рейтинг', style: theme.textTheme.displayLarge),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRouterNames.profile),
            icon: Icon(Icons.settings),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, size.height * 0.14),
          child: _RatingAppBar(filter: filter),
        ),
      ),
      body: TabBarView(
        children: [
          _KeepAlivePage(child: UsersPage()),
          _KeepAlivePage(child: FriendsPage()),
        ],
      ),
    );
  }
}

class _RatingAppBar extends StatelessWidget {
  final FilterUsersCubit filter;

  const _RatingAppBar({required this.filter});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomFilterButton(
            resetFilter: () => filter.resetUsers(),
            filterController: TextEditingController(
              text: FilterTextFormatter.users(
                filter.state.direction,
                filter.state.sort,
              ),
            ),
            filterDialog: _FilterDialog(filter: filter),
          ),
        ),
        TabBar(
          tabs: [
            Tab(text: 'Общий'),
            Tab(text: 'Друзья'),
          ],
        ),
      ],
    );
  }
}

class _FilterDialog extends StatelessWidget {
  final FilterUsersCubit filter;

  const _FilterDialog({required this.filter});

  @override
  Widget build(BuildContext context) {
    String? direction = filter.state.direction;
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
            hintText: 'Все направления',
          ),
          CustomDropdownMenu(
            value: sort,
            data: InterviewsData.usersSorts,
            change: (value) => sort = value,
            hintText: 'Сортировка',
          ),
          CustomButton(
            text: 'Применить',
            selectedColor: AppPalette.primary,
            onPressed: () {
              filter.filterUsers(direction, sort);
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
