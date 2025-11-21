import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/utils/data_cubit.dart';
import 'package:interview_master/core/utils/filter_text_formatter.dart';
import '../../../app/router/app_router_names.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../app/widgets/custom_dropdown_menu.dart';
import '../../../app/widgets/custom_filter_button.dart';
import '../../../app/widgets/custom_loading_indicator.dart';
import '../../../app/widgets/custom_network_failure.dart';
import '../../../app/widgets/custom_score_indicator.dart';
import '../../../app/widgets/custom_unknown_failure.dart';
import '../../../core/constants/interviews_data.dart';
import '../../../core/theme/app_pallete.dart';
import '../../../core/utils/dialog_helper.dart';
import '../../../core/utils/network_info.dart';
import '../../../data/models/user_data.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';
import '../blocs/filter_users_cubit/filter_users_cubit.dart';
import '../blocs/users_bloc/users_bloc.dart';
import '../widgets/custom_user_info.dart';

class RatingPage extends StatelessWidget {
  const RatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final value = context.watch<DataCubit>().state;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          key: ValueKey(value),
          create: (context) => UsersBloc(
            GetIt.I<RemoteRepository>(),
            GetIt.I<LocalRepository>(),
            GetIt.I<NetworkInfo>(),
          )..add(GetUsers()),
        ),
        BlocProvider(create: (context) => FilterUsersCubit()),
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
            onPressed: () => context.push(AppRouterNames.settings),
            icon: Icon(Icons.settings),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, size.height * 0.07),
          child: Padding(
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
    final onPressed = context.read<UsersBloc>().add(GetUsers());
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UsersNetworkFailure) {
          return CustomNetworkFailure(onPressed: () => onPressed);
        } else if (state is UsersFailure) {
          return CustomUnknownFailure(onPressed: () => onPressed);
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
                  currentUser: state.currentUser,
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
  final UserData currentUser;
  final int index;

  const _UserCard({
    required this.user,
    required this.filteredUser,
    required this.index,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCurrentUser = currentUser.id == user.id;
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
          style: Theme.of(context).textTheme.displayMedium,
        ),
        title: Text(
          isCurrentUser ? 'Вы' : user.name,
          style: theme.textTheme.displaySmall,
        ),
        subtitle: Row(
          children: [
            Text(
              '${filteredUser.totalScore} ',
              style: theme.textTheme.bodyLarge,
            ),
            Icon(Icons.star, color: AppPalette.primary),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            !isCurrentUser
                ? IconButton(
                    onPressed: () =>
                        context.push(AppRouterNames.analysis, extra: user),
                    icon: Icon(Icons.compare_arrows_outlined),
                  )
                : SizedBox.shrink(),
            CustomScoreIndicator(score: filteredUser.averageScore),
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
                  context.push(AppRouterNames.profile, extra: user);
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
