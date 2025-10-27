import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/utils/toast_helper.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../core/utils/network_info.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';
import '../../users/blocs/users_bloc/users_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersBloc(
        GetIt.I<RemoteRepository>(),
        GetIt.I<LocalRepository>(),
        GetIt.I<NetworkInfo>(),
      )..add(GetCurrentUser()),
      child: _SplashPageView(),
    );
  }
}

class _SplashPageView extends StatelessWidget {
  const _SplashPageView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<UsersBloc, UsersState>(
      listener: (context, state) {
        if (state is UserSuccess) {
          context.pushReplacement(AppRouterNames.initial);
        } else if (state is UserNotFound) {
          context.pushReplacement(AppRouterNames.signIn);
        } else if (state is UsersFailure) {
          ToastHelper.unknownError();
        }
      },
      child: Scaffold(
        body: Center(child: Text('SkillAI', style: theme.textTheme.titleLarge)),
      ),
    );
  }
}
