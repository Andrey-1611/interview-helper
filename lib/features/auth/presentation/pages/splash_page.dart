import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/core/helpers/toast_helpers/toast_helper.dart';
import 'package:interview_master/features/auth/presentation/blocs/check_email_verified_bloc/check_email_verified_bloc.dart';
import '../../../../app/dependencies/di_container.dart';
import '../../../../app/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../app/navigation/app_router_names.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetUserBloc(DIContainer.getUser)..add(GetUser()),
        ),
        BlocProvider(
          create: (context) =>
              CheckEmailVerifiedBloc(DIContainer.checkEmailVerified),
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
              context.read<CheckEmailVerifiedBloc>().add(CheckEmailVerified());
            } else if (state is GetUserNotAuth) {
              AppRouter.pushReplacementNamed(AppRouterNames.signIn);
            } else if (state is GetUserFailure) {
              ToastHelper.unknownError();
            }
          },
        ),
        BlocListener<CheckEmailVerifiedBloc, CheckEmailVerifiedState>(
          listener: (context, state) {
            if (state is CheckEmailVerifiedSuccess) {
              AppRouter.pushReplacementNamed(AppRouterNames.home);
            } else if (state is CheckEmailNotVerified) {
              AppRouter.pushReplacementNamed(AppRouterNames.signIn);
            } else if (state is CheckEmailVerifiedFailure) {
              ToastHelper.unknownError();
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
