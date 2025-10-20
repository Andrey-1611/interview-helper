import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/router/app_router_names.dart';
import 'package:interview_master/app/widgets/custom_filter_button.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/utils/dialog_helper.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import 'package:interview_master/data/repositories/local_repository.dart';
import 'package:interview_master/data/repositories/remote_repository.dart';
import 'package:interview_master/features/users/blocs/users_bloc/users_bloc.dart';
import 'package:interview_master/features/users/widgets/custom_user_info.dart';
import '../../../../app/widgets/custom_score_indicator.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../app/widgets/custom_dropdown_menu.dart';
import '../../../core/constants/data.dart';
import '../../../core/utils/network_info.dart';
import '../../../data/models/interview/interview_info.dart';
import '../../../data/models/user/user_data.dart';
import '../../../data/repositories/auth_repository.dart';
import '../blocs/filter_users_cubit/filter_users_cubit.dart';
import '../widgets/custom_network_failure.dart';

class UsersRatingPage extends StatefulWidget {
  const UsersRatingPage({super.key});

  @override
  State<UsersRatingPage> createState() => _UsersRatingPageState();
}

class _UsersRatingPageState extends State<UsersRatingPage> {
  final _filterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UsersBloc(
            GetIt.I<RemoteRepository>(),
            GetIt.I<LocalRepository>(),
            GetIt.I<AuthRepository>(),
            GetIt.I<NetworkInfo>(),
          )..add(GetUsers()),
        ),
        BlocProvider(create: (context) => FilterUsersCubit()),
      ],
      child: _UsersRatingView(filterController: _filterController),
    );
  }
}

class _UsersRatingView extends StatelessWidget {
  final TextEditingController filterController;

  const _UsersRatingView({required this.filterController});

  @override
  Widget build(BuildContext context) {
    final filter = context.read<FilterUsersCubit>();
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Рейтинг'),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, size.height * 0.077),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomFilterButton(
              resetFilter: filter.resetUsers,
              filterController: filterController,
              filterDialog: _FilterDialog(
                filterCubit: filter,
                filterController: filterController,
              ),
            ),
          ),
        ),
      ),
      body: _UsersList(filterController: filterController),
    );
  }
}

class _UsersList extends StatelessWidget {
  final TextEditingController filterController;

  const _UsersList({required this.filterController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, usersState) {
        if (usersState is UsersSuccess) {
          final filterState = context.watch<FilterUsersCubit>().state;
          final filteredUsers = UserData.filterUsers(
            filterState.direction,
            filterState.sort,
            usersState.users,
          );
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: usersState.users.length,
              itemBuilder: (context, index) {
                return _UserCard(
                  user: usersState.users[index],
                  filteredUser: filteredUsers[index],
                  isCurrentUser:
                      usersState.users[index].id == usersState.currentUser.id,
                  index: index,
                );
              },
            ),
          );
        } else if (usersState is UsersNetworkFailure) {
          return const CustomNetworkFailure();
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
            Expanded(child: CustomUserInfo(data: user)),
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
  final TextEditingController filterController;

  const _FilterDialog({
    required this.filterCubit,
    required this.filterController,
  });

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
            initialValue: direction,
            data: InitialData.directions,
            change: (value) => direction = value,
            hintText: 'Все направления',
          ),
          CustomDropdownMenu(
            initialValue: sort,
            data: InitialData.usersSorts,
            change: (value) => sort = value,
            hintText: 'Сортировка',
          ),
          CustomButton(
            text: 'Применить',
            selectedColor: AppPalette.primary,
            onPressed: () {
              _filter(direction, sort);
              context.pop();
            },
          ),
        ],
      ),
    );
  }

  void _filter(String? direction, String? sort) {
    filterCubit.filterUsers(direction, sort);
    filterController.text = InterviewInfo.textInFilter(
      direction ?? '',
      sort ?? '',
      '',
    );
  }
}
