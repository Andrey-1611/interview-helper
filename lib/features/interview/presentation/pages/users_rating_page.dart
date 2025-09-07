import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/app/navigation/app_router_names.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/helpers/toast_helpers/toast_helper.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import 'package:interview_master/features/interview/domain/use_cases/show_users_use_case.dart';
import 'package:interview_master/features/interview/presentation/blocs/show_users_bloc/show_users_bloc.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_score_indicator.dart';
import '../../../../app/global/models/user_data.dart';
import '../../../../app/global/providers/user_provider.dart';
import '../widgets/custom_network_failure.dart';

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
          ShowUsersBloc(GetIt.I<ShowUsersUseCase>())..add(ShowUsers()),
      child: const _UsersRatingView(),
    );
  }
}

class _UsersRatingView extends StatelessWidget {
  const _UsersRatingView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _UsersList(),
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

class _UsersListView extends ConsumerWidget {
  final List<UserData> users;

  const _UsersListView({required this.users});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final UserData user = users[index];
        return Card(
          child: ListTile(
            onTap: () {
              ref.read(userProvider.notifier).state = user;
              AppRouter.pushNamed(AppRouterNames.userInfo);
            },
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
