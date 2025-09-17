import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/helpers/toast_helper.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import 'package:interview_master/features/users/use_cases/show_users_use_case.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../../app/widgets/custom_score_indicator.dart';
import '../../../../data/models/user_data.dart';
import '../widgets/custom_network_failure.dart';
import '../blocs/show_users_bloc/show_users_bloc.dart';

class UsersRatingPage extends StatelessWidget {
  const UsersRatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ShowUsersBloc(GetIt.I<ShowUsersUseCase>())..add(ShowUsers()),
      child: const Scaffold(body: _UsersList()),
    );
  }
}

class _UsersList extends StatelessWidget {
  const _UsersList();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShowUsersBloc, ShowUsersState>(
      listener: (context, state) {
        if (state is ShowUsersFailure) {
          ToastHelper.loadingError();
        }
      },
      builder: (context, state) {
        if (state is ShowUsersSuccess) {
          return _UsersListView(users: state.users);
        } else if (state is ShowUsersLoading) {
          return const CustomLoadingIndicator();
        } else if (state is ShowUsersNetworkFailure) {
          return NetworkFailure();
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _UsersListView extends StatelessWidget {
  final List<UserData> users;

  const _UsersListView({required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final UserData user = users[index];
        return Card(
          child: ListTile(
            onTap: () => context.push(AppRouterNames.userInfo, extra: user),
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
    );
  }
}
