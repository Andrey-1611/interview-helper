import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import 'package:interview_master/features/home/bloc/sign_out_bloc/sign_out_bloc.dart';
import 'package:interview_master/features/home/use_cases/sign_out_use_case.dart';
import 'package:interview_master/features/users/blocs/get_user_bloc/get_user_bloc.dart';
import 'package:interview_master/features/users/use_cases/get_user_use_case.dart';
import '../../../app/router/app_router_names.dart';
import '../../../app/widgets/custom_info_card.dart';
import '../../../core/helpers/toast_helper.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GetUserBloc(GetIt.I<GetUserUseCase>())
                ..add(GetUser(userData: null)),
        ),
        BlocProvider(
          create: (context) => SignOutBloc(GetIt.I<SignOutUseCase>()),
        ),
      ],
      child: _ProfilePageView(),
    );
  }
}

class _ProfilePageView extends StatelessWidget {
  const _ProfilePageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
            _UserData(),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
            _SignOutButton(),
          ],
        ),
      ),
    );
  }
}

class _UserData extends StatelessWidget {
  const _UserData();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserBloc, GetUserState>(
      builder: (context, state) {
        if (state is GetUserLoading) {
          return CustomLoadingIndicator();
        } else if (state is GetUserSuccess) {
          return Column(
            children: [
              CustomInfoCard(titleText: 'Имя', subtitleText: state.user.name),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
              CustomInfoCard(
                titleText: 'Почта',
                subtitleText: state.user.email,
              ),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignOutBloc, SignOutState>(
      listener: (context, state) {
        if (state is SignOutSuccess) {
          context.pushReplacement(AppRouterNames.signIn);
        } else if (state is SignOutNetworkFailure) {
          ToastHelper.networkError();
        } else if (state is SignOutFailure) {
          ToastHelper.unknownError();
        }
      },
      child: TextButton(
        onPressed: () => context.read<SignOutBloc>().add(SignOut()),
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(AppPalette.transparent),
          overlayColor: WidgetStateProperty.all(AppPalette.transparent),
        ),
        child: Text(
          'Выйти из аккаунта',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }
}
