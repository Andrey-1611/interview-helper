import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/global_services/notifications/blocs/send_notification_bloc/send_notification_bloc.dart';
import 'package:interview_master/core/global_services/notifications/services/notifications_repository.dart';

class GlobalBlocProvider extends StatelessWidget {
  final Widget child;

  const GlobalBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SendNotificationBloc(context.read<NotificationsRepository>()),
        ),
      ],
      child: child,
    );
  }
}
