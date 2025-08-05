import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/core/helpers/dialog_helpers/dialog_helper.dart';
import '../../../../app/dependencies/di_container.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../core/helpers/notification_helpers/notification_helper.dart';
import '../blocs/sign_out_bloc/sign_out_bloc.dart';
import '../widgets/custom_auth_button.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignOutBloc(DIContainer.signOut)),
        BlocProvider(
          create: (context) =>
              GetUserBloc(DIContainer.userRepository)..add(GetUser()),
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
    return Scaffold(
      appBar: AppBar(),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            _UserInfo(),
            _SignOutButton(),
            Spacer(),
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
        BlocListener<GetUserBloc, GetUserState>(
          listener: (context, state) {
            if (state is GetUserLoading) {
              DialogHelper.showLoadingDialog(context);
            } else if (state is GetUserSuccess) {
              AppRouter.pop();
            } else if (state is GetUserFailure) {
              AppRouter.pop();
              NotificationHelper.auth.signOutError(context);
            }
          },
        ),
        BlocListener<SignOutBloc, SignOutState>(
          listener: (context, state) {
            if (state is SignOutLoading) {
              DialogHelper.showLoadingDialog(context);
            } else if (state is SignOutSuccess) {
              AppRouter.pop();
              //NotificationHelper.auth.signOut(context);
              AppRouter.pushReplacementNamed(AppRouterNames.signIn);
            } else if (state is SignOutFailure) {
              AppRouter.pop();
              NotificationHelper.auth.signOutError(context);
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
        context.read<SignOutBloc>().add(SignOut());
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
