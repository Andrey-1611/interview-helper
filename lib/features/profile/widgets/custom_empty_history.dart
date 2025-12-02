import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/generated/l10n.dart';
import '../../../app/router/app_router_names.dart';

class CustomEmptyHistory extends StatelessWidget {
  final bool isCurrentUser;

  const CustomEmptyHistory({super.key, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(s.empty_history, style: theme.textTheme.displayLarge),
          isCurrentUser
              ? TextButton(
                  onPressed: () {
                    StatefulNavigationShell.of(context).goBranch(0);
                    context.push(AppRouterNames.initial);
                  },
                  child: Text(s.take_interview),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
