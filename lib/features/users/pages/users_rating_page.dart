import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/router/app_router_names.dart';
import 'package:interview_master/app/widgets/custom_filter_button.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/helpers/dialog_helper.dart';
import 'package:interview_master/core/helpers/toast_helper.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import 'package:interview_master/features/users/use_cases/show_users_use_case.dart';
import 'package:interview_master/features/users/widgets/custom_user_info.dart';
import '../../../../app/widgets/custom_score_indicator.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../app/widgets/custom_dropdown_menu.dart';
import '../../../core/constants/data.dart';
import '../../../core/utils/filter_users_cubit/filter_users_cubit.dart';
import '../../../data/models/interview/interview_info.dart';
import '../../../data/models/user/user_data.dart';
import '../widgets/custom_network_failure.dart';
import '../blocs/show_users_bloc/show_users_bloc.dart';

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
          create: (context) =>
              ShowUsersBloc(GetIt.I<ShowUsersUseCase>())..add(ShowUsers()),
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
        title: Text('Рейтинг'),
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
    return BlocConsumer<ShowUsersBloc, ShowUsersState>(
      listener: (context, usersState) {
        if (usersState is ShowUsersFailure) {
          ToastHelper.loadingError();
        }
      },
      builder: (context, usersState) {
        if (usersState is ShowUsersSuccess) {
          final state = context.watch<FilterUsersCubit>().state;
          return _UsersListView(
            users: usersState.users,
            filteredUsers: UserData.filterUsers(
              state.direction,
              state.sort,
              usersState.users,
            ),
            filterController: filterController,
          );
        } else if (usersState is ShowUsersLoading) {
          return const CustomLoadingIndicator();
        } else if (usersState is ShowUsersNetworkFailure) {
          return NetworkFailure();
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _UsersListView extends StatelessWidget {
  final List<UserData> users;
  final List<UserData> filteredUsers;
  final TextEditingController filterController;

  const _UsersListView({
    required this.filteredUsers,
    required this.filterController,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          final filteredUser = filteredUsers[index];
          return Card(
            child: ListTile(
              onTap: () => DialogHelper.showCustomSheet(
                dialog: _UserSheet(user: filteredUser),
                context: context,
              ),
              leading: Text(
                '${index + 1}',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              title: Text(
                filteredUser.name,
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
                  IconButton(
                    onPressed: () => context.push(
                      AppRouterNames.analysis,
                      extra: users[index],
                    ),
                    icon: Icon(Icons.compare_arrows_outlined),
                  ),
                ],
              ),
            ),
          );
        },
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
