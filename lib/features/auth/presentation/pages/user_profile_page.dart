import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/core/helpers/dialog_helpers/dialog_helper.dart';
import 'package:interview_master/features/auth/blocs/sign_out_bloc/sign_out_bloc.dart';
import '../../../../app/dependencies/di_container.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/global_services/user/blocs/clear_user_bloc/clear_user_bloc.dart';
import '../../../../core/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../core/helpers/notification_helpers/notification_helper.dart';
import '../widgets/custom_auth_button.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignOutBloc(DiContainer.authRepository),
        ),
        BlocProvider(
          create: (context) => ClearUserBloc(DiContainer.userRepository),
        ),
        BlocProvider(
          create: (context) =>
              GetUserBloc(DiContainer.userRepository)..add(GetUser()),
        ),
      ],
      child: _UserProfilePageView(),
    );
  }
}

class _UserProfilePageView extends StatelessWidget {
  const _UserProfilePageView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            _UserInfo(),
            _SignOutButton(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SignOutBloc, SignOutState>(
          listener: (context, state) {
            if (state is SignOuLoading) {
              DialogHelper.showLoadingDialog(context);
            } else if (state is SignOutSuccess) {
              context.read<ClearUserBloc>();
            }
          },
        ),
        BlocListener<ClearUserBloc, ClearUserState>(
          listener: (context, state) {
            if (state is ClearUserSuccess) {
              AppRouter.pop();
              NotificationHelper.auth.signOutNotification(context);
              AppRouter.pushReplacementNamed(AppRouterNames.signIn);
            } else if (state is ClearUserFailure) {
              AppRouter.pop();
              NotificationHelper.auth.signOutErrorNotification(context);
            }
          },
        ),
      ],
      child: _SignOutButtonView(),
    );
  }
}

class _SignOutButtonView extends StatelessWidget {
  const _SignOutButtonView();

  @override
  Widget build(BuildContext context) {
    return CustomAuthButton(
      text: 'Выйти',
      onPressed: () {
        context.read<ClearUserBloc>().add(ClearUser());
      },
    );
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserBloc, GetUserState>(
      builder: (context, state) {
        if (state is GetUserSuccess) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Ваше имя: ${state.userProfile.name}'),
                Text('Ваша почта: ${state.userProfile.email}'),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
