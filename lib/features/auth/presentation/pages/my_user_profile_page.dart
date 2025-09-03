import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/helpers/toast_helpers/toast_helper.dart';
import 'package:interview_master/features/auth/domain/use_cases/get_user_use_case.dart';
import 'package:interview_master/features/auth/domain/use_cases/sign_out_use_case.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../blocs/get_user_bloc/get_user_bloc.dart';
import '../blocs/sign_out_bloc/sign_out_bloc.dart';
import '../widgets/custom_auth_button.dart';

class MyUserProfilePage extends StatelessWidget {
  const MyUserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignOutBloc(GetIt.I<SignOutUseCase>()),
        ),
        BlocProvider(
          create: (context) =>
              GetUserBloc(GetIt.I<GetUserUseCase>())..add(GetUser()),
        ),
      ],
      child: _MyUserProfilePageView(),
    );
  }
}

class _MyUserProfilePageView extends StatelessWidget {
  const _MyUserProfilePageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Spacer(), _UserInfo(), _SignOutButton(), Spacer()],
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
            if (state is GetUserFailure) {
              ToastHelper.unknownError();
            }
          },
        ),
        BlocListener<SignOutBloc, SignOutState>(
          listener: (context, state) {
            if (state is SignOutSuccess) {
              AppRouter.pushReplacementNamed(AppRouterNames.signIn);
            } else if (state is SignOutNetworkError) {
              ToastHelper.networkError();
            } else if (state is SignOutFailure) {
              ToastHelper.unknownError();
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
        if (state is GetUserLoading) {
          return CustomLoadingIndicator();
        } else if (state is GetUserSuccess) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ваше имя: ${state.user.name}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Ваша почта: ${state.user.email}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
