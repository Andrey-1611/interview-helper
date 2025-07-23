import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/core/helpers/notification_helpers/auth_notification_helper.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/global_services/user/blocs/clear_user_bloc/clear_user_bloc.dart';
import '../../../../core/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../core/global_services/user/services/user_interface.dart';
import '../widgets/custom_auth_button.dart';
import '../widgets/custom_loading_indicator.dart';

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
    return BlocListener<ClearUserBloc, ClearUserState>(
      listener: (context, state) {
        if (state is ClearUserSuccess) {
          AppRouter.pushReplacementNamed(AppRouterNames.signIn);
          AuthNotificationHelper.signOutNotification(context);
        } else if (state is ClearUserFailure) {
          AuthNotificationHelper.signOutErrorNotification(context);
        }
      },
      child: _SignOutButtonView(),
    );
  }
}

class _SignOutButtonView extends StatelessWidget {
  const _SignOutButtonView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClearUserBloc, ClearUserState>(
      builder: (context, state) {
        if (state is ClearUserLoading) return CustomLoadingIndicator();
        return CustomAuthButton(
          text: 'Выйти',
          onPressed: () {
            context.read<ClearUserBloc>().add(ClearUser());
          },
        );
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
          if (state.userProfile.name == '') {
            context.read<GetUserBloc>().add(GetUser());
          }
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
          return const CustomLoadingIndicator();
        }
      },
    );
  }
}
