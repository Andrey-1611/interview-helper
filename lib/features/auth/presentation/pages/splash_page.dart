import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/core/helpers/notification_helpers/notification_helper.dart';
import 'package:interview_master/features/auth/blocs/is_email_verified_bloc/is_email_verified_bloc.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../core/global_services/user/services/user_repository.dart';
import '../../data/repositories/auth_repository.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GetUserBloc(context.read<UserRepository>())..add(GetUser()),
        ),
        BlocProvider(
          create: (context) => IsEmailVerifiedBloc(context.read<AuthRepository>()),
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
        BlocListener<GetUserBloc, GetUserState>(
          listener: (context, state) {
            if (state is GetUserSuccess) {
              context.read<IsEmailVerifiedBloc>().add(CheckEmailVerified());
            } else if (state is GetUserNotAuth) {
              AppRouter.pushReplacementNamed(AppRouterNames.signIn);
            } else if (state is GetUserFailure) {
              NotificationHelper.auth.checkUserError(context);
            }
          },
        ),
        BlocListener<IsEmailVerifiedBloc, IsEmailVerifiedState>(
          listener: (context, state) {
            if (state is IsEmailVerifiedSuccess) {
              AppRouter.pushReplacementNamed(AppRouterNames.home);
            } else if (state is IsEmailNotVerified) {
              AppRouter.pushReplacementNamed(AppRouterNames.signIn);
            } else if (state is IsEmailVerifiedFailure) {
              NotificationHelper.email.emailVerificationError(context);
            }
          },
        ),
      ],
      child: _SplashLogo(),
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
