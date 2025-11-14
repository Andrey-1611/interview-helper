import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/widgets/custom_loading_indicator.dart';
import '../../../data/models/user_data.dart';
import '../blocs/filter_users_cubit/filter_users_cubit.dart';
import '../blocs/users_bloc/users_bloc.dart';
import '../widgets/custom_network_failure.dart';
import '../widgets/custom_user_card.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UsersNetworkFailure) {
          return const CustomNetworkFailure();
        } else if (state is UsersSuccess) {
          if (state.friends.isEmpty) return _EmptyFriendsList();
          final filter = context.watch<FilterUsersCubit>();
          final filteredUsers = UserData.filterUsers(
            filter.state.direction,
            filter.state.sort,
            state.friends,
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
                return CustomUserCard(
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

class _EmptyFriendsList extends StatelessWidget {
  const _EmptyFriendsList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text('У вас еще нет друзей', style: theme.textTheme.displayLarge),
    );
  }
}
