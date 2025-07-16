import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/global_services/notifications/blocs/send_notification_bloc/send_notification_bloc.dart';
import 'package:interview_master/core/global_services/notifications/services/notifications_service.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../core/global_services/notifications/models/notification.dart';
import '../../../../core/global_services/user/blocs/clear_user/clear_user_bloc.dart';
import '../../../../core/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../core/global_services/user/services/user_interface.dart';
import '../../../interview/presentation/widgets/custom_button.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ClearUserBloc(context.read<UserInterface>()),
        ),
        BlocProvider(
          create: (context) =>
              GetUserBloc(context.read<UserInterface>())..add(GetUser()),
        ),
        BlocProvider(
          create: (context) => SendNotificationBloc(NotificationsService()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: BlocListener<ClearUserBloc, ClearUserState>(
            listener: (context, state) {
              if (state is ClearUserSuccess) {
                Navigator.pushReplacementNamed(context, AppRouterNames.signIn);
                context.read<SendNotificationBloc>().add(
                  SendNotification(
                    notification: MyNotification(
                      text: 'Вы успешно вышли из аккаунта!',
                      icon: Icon(Icons.star),
                    ),
                  ),
                );
              }
            },
            child: BlocBuilder<GetUserBloc, GetUserState>(
              builder: (context, state) {
                if (state is GetUserLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetUserFailure || state is GetUserNotAuth) {
                  return const Center(
                    child: Text('Произошла ошибка, опробуйте позже'),
                  );
                } else if (state is GetUserSuccess) {
                  if (state.userProfile.name == '') {
                    context.read<GetUserBloc>().add(GetUser());
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Ваше имя: ${state.userProfile.name}'),
                        Text('Ваша почта: ${state.userProfile.email}'),
                        CustomButton(
                          text: 'Выйти',
                          selectedColor: Colors.blue,
                          onPressed: () {
                            context.read<ClearUserBloc>().add(ClearUser());
                          },
                          textColor: Colors.white,
                          percentsHeight: 0.08,
                          percentsWidth: 0.35,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
