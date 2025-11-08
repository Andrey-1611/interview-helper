import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/router/app_router_names.dart';
import 'package:interview_master/app/widgets/custom_filter_button.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/utils/data_cubit.dart';
import 'package:interview_master/core/utils/dialog_helper.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import 'package:interview_master/core/utils/filter_text_formatter.dart';
import '../../../../data/repositories/local/local.dart';
import '../../../../data/repositories/remote/remote.dart';
import 'package:interview_master/features/users/blocs/users_bloc/users_bloc.dart';
import 'package:interview_master/features/users/widgets/custom_user_info.dart';
import '../../../../app/widgets/custom_score_indicator.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../app/widgets/custom_dropdown_menu.dart';
import '../../../core/constants/interviews_data.dart';
import '../../../core/utils/network_info.dart';
import '../../../data/models/user_data.dart';
import '../blocs/filter_users_cubit/filter_users_cubit.dart';
import '../widgets/custom_network_failure.dart';

class UsersRatingPage extends StatelessWidget {
  const UsersRatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          key: ValueKey(context.watch<DataCubit>().state),
          create: (context) => UsersBloc(
            GetIt.I<RemoteRepository>(),
            GetIt.I<LocalRepository>(),
            GetIt.I<NetworkInfo>(),
          )..add(GetUsers()),
        ),
        BlocProvider(create: (context) => FilterUsersCubit()),
      ],
      child: _UsersRatingView(),
    );
  }
}

class _UsersRatingView extends StatelessWidget {
  const _UsersRatingView();

  @override
  Widget build(BuildContext context) {
    final filter = context.watch<FilterUsersCubit>();
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => context.push(AppRouterNames.profile),
            icon: Icon(Icons.settings),
          ),
        ],
        title: const Text('Рейтинг'),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, size.height * 0.077),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomFilterButton(
              resetFilter: filter.resetUsers,
              filterController: TextEditingController(
                text: FilterTextFormatter.users(
                  filter.state.direction,
                  filter.state.sort,
                ),
              ),
              filterDialog: _FilterDialog(filterCubit: filter),
            ),
          ),
        ),
      ),
      body: _UsersList(),
    );
  }
}

class _UsersList extends StatelessWidget {
  const _UsersList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UsersNetworkFailure) {
          return const CustomNetworkFailure();
        } else if (state is UsersSuccess) {
          final filter = context.watch<FilterUsersCubit>();
          final filteredUsers = UserData.filterUsers(
            filter.state.direction,
            filter.state.sort,
            state.users,
          );
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final filteredUser = filteredUsers[index];
                final user = state.users.firstWhere(
                  (user) => user.id == filteredUser.id,
                );
                return _UserCard(
                  user: user,
                  filteredUser: filteredUser,
                  isCurrentUser: user.id == state.currentUser.id,
                  index: index,
                );
              },
            ),
          );
        }
        return const CustomLoadingIndicator();
      },
    );
  }
}

class _UserCard extends StatelessWidget {
  final UserData user;
  final UserData filteredUser;
  final bool isCurrentUser;
  final int index;

  const _UserCard({
    required this.user,
    required this.filteredUser,
    required this.isCurrentUser,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(
        side: isCurrentUser
            ? BorderSide(color: AppPalette.primary, width: 2.0)
            : BorderSide.none,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        enabled: !isCurrentUser,
        onTap: () => !isCurrentUser
            ? DialogHelper.showCustomSheet(
                dialog: _UserSheet(user: user),
                context: context,
              )
            : null,
        leading: Text(
          '${index + 1}',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        title: Text(
          isCurrentUser ? 'Вы' : user.name,
          style: theme.textTheme.displayMedium,
        ),
        subtitle: Row(
          children: [
            Text(
              '${filteredUser.totalScore} ',
              style: theme.textTheme.displaySmall,
            ),
            Icon(Icons.star, color: AppPalette.primary),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomScoreIndicator(score: filteredUser.averageScore),
            !isCurrentUser
                ? IconButton(
                    onPressed: () =>
                        context.push(AppRouterNames.analysis, extra: user),
                    icon: Icon(Icons.compare_arrows_outlined),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class _UserSheet extends StatelessWidget {
  final UserData user;

  const _UserSheet({required this.user});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    return BottomSheet(
      onClosing: () {},
      builder: (context) => SizedBox(
        height: size.height * 0.5,
        child: Column(
          children: [
            Text(user.name, style: theme.textTheme.displayLarge),
            Expanded(child: CustomUserInfo(user: user)),
            SizedBox(
              width: size.width * 0.8,
              child: TextButton(
                onPressed: () {
                  context.pop();
                  context.push(AppRouterNames.user, extra: user);
                },
                child: Text('Подобная иноформация'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterDialog extends StatelessWidget {
  final FilterUsersCubit filterCubit;

  const _FilterDialog({required this.filterCubit});

  @override
  Widget build(BuildContext context) {
    String? direction = filterCubit.state.direction;
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
            value: sort,
            data: InterviewsData.usersSorts,
            change: (value) => sort = value,
            hintText: 'Сортировка',
          ),
          CustomButton(
            text: 'Применить',
            selectedColor: AppPalette.primary,
            onPressed: () {
              filterCubit.filterUsers(direction, sort);
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
