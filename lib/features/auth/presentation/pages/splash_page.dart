import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interview_master/app/dependencies/di_container.dart';
import 'package:interview_master/core/helpers/toast_helpers/toast_helper.dart';
import 'package:interview_master/features/auth/presentation/blocs/get_current_user_bloc/get_current_user_bloc.dart';
import '../../../../app/global_services/providers/user_provider.dart';
import '../../../../app/global_services/user/models/user_data.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../app/navigation/app_router_names.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetCurrentUserBloc(DIContainer.getCurrentUser),
      child: _SplashPageView(),
    );
  }
}

class _SplashPageView extends ConsumerWidget {
  const _SplashPageView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlocListener<GetCurrentUserBloc, GetCurrentUserState>(
      listener: (context, state) {
        if (state is GetCurrentUserSuccess) {
          ref.read(currentUserProvider.notifier).state = UserData.fromMyUser(
            state.user,
          );
          AppRouter.pushReplacementNamed(AppRouterNames.home);
        } else if (state is GetCurrentUserNotAuth) {
          AppRouter.pushReplacementNamed(AppRouterNames.signIn);
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
    return Scaffold(body: const Center(child: FlutterLogo(size: 128.0)));
  }
}
