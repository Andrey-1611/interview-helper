import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/helpers/toast_helper.dart';
import 'package:interview_master/features/home/use_cases/get_current_user_use_case.dart';
import '../../../../app/router/app_router_names.dart';
import '../bloc/get_current_user_bloc/get_current_user_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetCurrentUserBloc(GetIt.I<GetCurrentUserUseCase>())
            ..add(GetCurrentUser()),
      child: _SplashPageView(),
    );
  }
}

class _SplashPageView extends StatelessWidget {
  const _SplashPageView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetCurrentUserBloc, GetCurrentUserState>(
      listener: (context, state) {
        if (state is GetCurrentUserSuccess) {
          context.pushReplacement(AppRouterNames.initial);
        } else if (state is GetCurrentUserNotAuth) {
          context.pushReplacement(AppRouterNames.signIn);
        } else if (state is GetCurrentUserFailure) {
          ToastHelper.unknownError();
        }
      },
      child: _SplashLogo(),
    );
  }
}

class _SplashLogo extends StatelessWidget {
  const _SplashLogo();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(child: Text('SkillAI', style: textTheme.titleLarge)),
    );
  }
}
