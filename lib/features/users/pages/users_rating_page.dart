import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/helpers/toast_helper.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import 'package:interview_master/features/users/blocs/filter_users_cubit/filter_users_cubit.dart';
import 'package:interview_master/features/users/use_cases/show_users_use_case.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../../app/widgets/custom_score_indicator.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../app/widgets/custom_dropdown_menu.dart';
import '../../../core/constants/data.dart';
import '../../../core/helpers/dialog_helper.dart';
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
      child: Scaffold(body: _UsersList(filterController: _filterController)),
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
          return BlocBuilder<FilterUsersCubit, FilterUsersState>(
            builder: (context, filterState) {
              return _UsersListView(
                users: UserData.filterUsers(
                  filterState.direction,
                  filterState.sort,
                  usersState.users,
                ),
                filterController: filterController,
              );
            },
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
  final TextEditingController filterController;

  const _UsersListView({required this.users, required this.filterController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FilterButton(filterController: filterController),
        Expanded(
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final UserData user = users[index];
              return Card(
                child: ListTile(
                  onTap: () =>
                      context.push(AppRouterNames.userInfo, extra: user),
                  leading: Text(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  title: Text(user.name),
                  subtitle: Row(
                    children: [
                      Text('${user.totalScore}  '),
                      Icon(Icons.star, color: AppPalette.primary),
                    ],
                  ),
                  trailing: CustomScoreIndicator(score: user.averageScore),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  final TextEditingController filterController;

  const _FilterButton({required this.filterController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        readOnly: true,
        focusNode: FocusNode(canRequestFocus: false),
        controller: filterController,
        onTap: () {
          final filterCubit = context.read<FilterUsersCubit>();
          DialogHelper.showCustomDialog(
            dialog: _FilterDialog(
              filterCubit: filterCubit,
              filterController: filterController,
            ),
            context: context,
          );
        },
        decoration: InputDecoration(
          hintText: 'Фильтр',
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: () {
              context.read<FilterUsersCubit>().resetFilter();
              filterController.text = '';
            },
            icon: Icon(Icons.close),
          ),
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
    String direction = filterCubit.state.direction;
    String sort = filterCubit.state.sort;
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

  void _filter(String direction, String sort) {
    filterCubit.runFilter(direction: direction, sort: sort);
    filterController.text = InterviewInfo.textInFilter(direction, '', sort);
  }
}
