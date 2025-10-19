import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_router_names.dart';

class CustomEmptyHistory extends StatelessWidget {
  final bool isCurrentUser;

  const CustomEmptyHistory({super.key, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('История пуста', style: theme.textTheme.displayLarge),
          isCurrentUser
              ? TextButton(
                  onPressed: () {
                    StatefulNavigationShell.of(context).goBranch(0);
                    context.push(AppRouterNames.initial);
                  },
                  child: Text('Пройти собеседование'),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
