import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/core/global_services/notifications/blocs/send_notification_bloc/send_notification_bloc.dart';
import 'package:interview_master/core/global_services/user/services/user_interface.dart';
import 'package:interview_master/features/auth/blocs/is_email_verified_bloc/is_email_verified_bloc.dart';
import 'package:interview_master/features/auth/data/data_sources/auth_data_source.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/global_services/notifications/models/notification.dart';
import '../../../../core/global_services/user/blocs/set_user_bloc/set_user_bloc.dart';
import '../../blocs/check_current_user_bloc/check_current_user_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CheckCurrentUserBloc(
            AuthDataSource(firebaseAuth: FirebaseAuth.instance),
          )..add(CheckCurrentUser()),
        ),
        BlocProvider(
          create: (context) => IsEmailVerifiedBloc(
            AuthDataSource(firebaseAuth: FirebaseAuth.instance),
          ),
        ),
        BlocProvider(
          create: (context) => SetUserBloc(context.read<UserInterface>()),
        ),
      ],
      child: _SplashPageView(),
    );
  }
}

class _SplashPageView extends StatelessWidget {
  const _SplashPageView();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CheckCurrentUserBloc, CheckCurrentUserState>(
          listener: (context, state) {
            if (state is CheckCurrentUserExists) {
              context.read<IsEmailVerifiedBloc>().add(IsEmailVerified());
            } else if (state is CheckCurrentUserNotExists) {
              AppRouter.pushReplacementNamed(AppRouterNames.signIn);
            } else if (state is CheckCurrentUserFailure) {
              _sendNotification('Ошибка входа!', Icon(Icons.error));
            }
          },
        ),
        BlocListener<IsEmailVerifiedBloc, IsEmailVerifiedState>(
          listener: (context, state) {
            if (state is IsEmailVerifiedSuccess) {
              context.read<SetUserBloc>().add(
                SetUser(userProfile: state.isEmailVerified.userProfile),
              );
            } else if (state is IsEmailNotVerified) {
              _sendNotification(
                'Пожалуйста, подтвердите свою почту!',
                Icon(Icons.error),
              );
              AppRouter.pushReplacementNamed(AppRouterNames.emailVerification);
            } else if (state is IsEmailVerifiedFailure) {
              _sendNotification('Ошибка входа!', Icon(Icons.error));
            }
          },
        ),
        BlocListener<SetUserBloc, SetUserState>(
          listener: (context, state) {
            if (state is SetUserSuccess) {
              AppRouter.pushReplacementNamed(AppRouterNames.home);
            } else if (state is SetUserFailure) {
              _sendNotification('Ошибка входа!', Icon(Icons.error));
            }
          },
        ),
      ],
      child: _SplashLogo(),
    );
  }

  SendNotification _sendNotification(String text, Icon icon) {
    return SendNotification(
      notification: MyNotification(text: text, icon: icon),
    );
  }
}

class _SplashLogo extends StatelessWidget {
  const _SplashLogo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Center(child: FlutterLogo(size: 128.0)));
  }
}
