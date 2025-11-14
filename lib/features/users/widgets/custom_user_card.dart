import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/features/users/blocs/friends_bloc/friends_bloc.dart';
import '../../../app/router/app_router_names.dart';
import '../../../app/widgets/custom_score_indicator.dart';
import '../../../core/theme/app_pallete.dart';
import '../../../core/utils/dialog_helper.dart';
import '../../../data/models/user_data.dart';
import 'custom_user_info.dart';

class CustomUserCard extends StatelessWidget {
  final UserData user;
  final UserData filteredUser;
  final UserData currentUser;
  final int index;

  const CustomUserCard({
    super.key,
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
                ? Row(
                    children: [
                      !user.isFriend(currentUser)
                          ? IconButton(
                              onPressed: () => DialogHelper.showCustomDialog(
                                dialog: _SendFriendRequestDialog(
                                  currentUser: currentUser,
                                  user: user,
                                  friendsBloc: context.read<FriendsBloc>(),
                                ),
                                context: context,
                              ),
                              icon: Icon(Icons.person_add_alt_1),
                            )
                          : Icon(Icons.person),
                      IconButton(
                        onPressed: () =>
                            context.push(AppRouterNames.analysis, extra: user),
                        icon: Icon(Icons.compare_arrows_outlined),
                      ),
                    ],
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

class _SendFriendRequestDialog extends StatelessWidget {
  final UserData currentUser;
  final UserData user;
  final FriendsBloc friendsBloc;

  const _SendFriendRequestDialog({
    required this.currentUser,
    required this.user,
    required this.friendsBloc,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      content: Text(
        'Добавить пользователя ${user.name} в друзья?',
        style: theme.textTheme.displaySmall,
      ),
      actions: [
        TextButton(
          onPressed: () {
            friendsBloc.add(
              SendFriendRequest(fromUser: currentUser, toUserId: user.id),
            );
            context.pop();
          },
          child: const Text('Да'),
        ),
        TextButton(onPressed: () => context.pop(), child: const Text('Нет')),
      ],
    );
  }
}
