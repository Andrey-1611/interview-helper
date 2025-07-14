import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/global_services/notifications/blocs/send_notification_bloc.dart';
import 'package:interview_master/core/global_services/notifications/models/notification.dart';
import 'package:interview_master/core/global_services/notifications/services/notification_service.dart';
import 'package:interview_master/core/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../core/global_services/user/services/user_interface.dart';
import 'history_page.dart';
import 'initial_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GetUserBloc(context.read<UserInterface>())..add(GetUser()),
        ),
        BlocProvider(
          create: (context) => SendNotificationBloc(NotificationsService()),
        ),
      ],
      child: BlocListener<GetUserBloc, GetUserState>(
        listener: (context, state) {
          if (state is GetUserSuccess) {
            context.read<SendNotificationBloc>().add(
              SendNotification(
                notification: MyNotification(
                  text: '${state.userProfile.name}, добро пожаловать!',
                  icon: Icon(Icons.star),
                ),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRouterNames.userProfile);
                },
                icon: Icon(Icons.settings),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Собеседование',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'История',
              ),
            ],
          ),
          body: _currentIndex == 0 ? InitialPage() : HistoryPage(),
        ),
      ),
    );
  }
}
