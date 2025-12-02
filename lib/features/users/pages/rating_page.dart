import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/utils/data_cubit.dart';
import '../../../app/router/app_router_names.dart';
import '../../../app/widgets/custom_loading_indicator.dart';
import '../../../app/widgets/custom_network_failure.dart';
import '../../../app/widgets/custom_score_indicator.dart';
import '../../../app/widgets/custom_unknown_failure.dart';
import '../../../core/utils/dialog_helper.dart';
import '../../../core/utils/network_info.dart';
import '../../../data/models/user_data.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';
import '../../../generated/l10n.dart';
import '../blocs/users_bloc/users_bloc.dart';
import '../widgets/custom_user_info.dart';

class RatingPage extends StatelessWidget {
  const RatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final value = context.watch<DataCubit>().state;
    return BlocProvider(
      key: ValueKey(value),
      create: (context) => UsersBloc(
        GetIt.I<RemoteRepository>(),
        GetIt.I<LocalRepository>(),
        GetIt.I<NetworkInfo>(),
      )..add(GetUsers()),
      child: DefaultTabController(length: 2, child: _RatingPageView()),
    );
  }
}

class _RatingPageView extends StatelessWidget {
  const _RatingPageView();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.rating),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRouterNames.settings),
            icon: Icon(Icons.settings),
          ),
        ],
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
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final filteredUser = state.users[index];
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
    final s = S.of(context);
    return Card(
      shape: RoundedRectangleBorder(
        side: isCurrentUser
            ? BorderSide(color: theme.primaryColor, width: 2.0)
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
          isCurrentUser ? s.you : user.name,
          style: theme.textTheme.displaySmall,
        ),
        subtitle: Row(
          children: [
            Text(
              '${filteredUser.totalScore} ',
              style: theme.textTheme.bodyLarge,
            ),
            Icon(Icons.star, color: theme.primaryColor),
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
    final s = S.of(context);
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
                child: Text(s.similar_information),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
