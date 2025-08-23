import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/app/navigation/app_router_names.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/helpers/toast_helpers/toast_helper.dart';
import 'package:interview_master/features/interview/presentation/blocs/show_users_bloc/show_users_bloc.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_score_indicator.dart';
import '../../../../app/dependencies/di_container.dart';
import '../../../../app/global/models/user_data.dart';
import '../../../../app/global/providers/user_provider.dart';

class UsersRatingPage extends StatefulWidget {
  const UsersRatingPage({super.key});

  @override
  State<UsersRatingPage> createState() => _UsersRatingPageState();
}

class _UsersRatingPageState extends State<UsersRatingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ShowUsersBloc(DIContainer.showUsers)..add(ShowUsers()),
      child: const _UsersRatingView(),
    );
  }
}

class _UsersRatingView extends StatelessWidget {
  const _UsersRatingView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(padding: EdgeInsets.all(16.0), child: _UsersList()),
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
          ToastHelper.custom(state.e);
        }
      },
      builder: (context, state) {
        if (state is ShowUsersSuccess) {
          return _UsersListView(users: state.users);
        } else if (state is ShowUsersLoading) {
          return const CustomLoadingIndicator();
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _UsersListView extends ConsumerWidget {
  final List<UserData> users;

  const _UsersListView({required this.users});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final UserData user = users[index];
          return Card(
            child: ListTile(
              onTap: () {
                ref.read(userProvider.notifier).state = user;
                AppRouter.pushNamed(AppRouterNames.userInfo);
              },
              leading: CustomScoreIndicator(score: user.averageScore),
              title: Text(user.name),
              subtitle: Text('${user.totalScore}'),
            ),
          );
        },
      ),
    );
  }
}
