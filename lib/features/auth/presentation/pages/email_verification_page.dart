import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/helpers/dialog_helpers/dialog_helper.dart';
import 'package:interview_master/features/auth/blocs/send_email_verification_bloc/send_email_verification_bloc.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_auth_button.dart';
import '../../../../app/dependencies/di_container.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../core/global_services/user/blocs/set_user_bloc/set_user_bloc.dart';
import '../../../../core/helpers/notification_helpers/notification_helper.dart';
import '../../blocs/is_email_verified_bloc/is_email_verified_bloc.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SendEmailVerificationBloc(DiContainer.authRepository),
        ),
        BlocProvider(
          create: (context) => IsEmailVerifiedBloc(DiContainer.authRepository),
        ),
        BlocProvider(
          create: (context) => SetUserBloc(DiContainer.userRepository),
        ),
        BlocProvider(
          create: (context) => GetUserBloc(DiContainer.userRepository),
        ),
      ],
      child: _EmailVerificationPageView(),
    );
  }
}

class _EmailVerificationPageView extends StatelessWidget {
  const _EmailVerificationPageView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              _EmailVerificationButton(),
              _SendEmailVerificationButton(),
              Spacer(),
              _NavigationButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailVerificationButton extends StatelessWidget {
  const _EmailVerificationButton();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SendEmailVerificationBloc, SendEmailVerificationState>(
          listener: (context, state) {
            if (state is SendEmailVerificationSuccess) {
              NotificationHelper.email.sendEmailVerification(
                context,
              );
            }
          },
        ),
        BlocListener<IsEmailVerifiedBloc, IsEmailVerifiedState>(
          listener: (context, state) {
            if (state is IsEmailVerifiedLoading) {
              DialogHelper.showLoadingDialog(context);
            } else if (state is IsEmailVerifiedSuccess) {
              context.read<SetUserBloc>().add(
                SetUser(userProfile: state.isEmailVerified.userProfile),
              );
            } else if (state is IsEmailNotVerified) {
              AppRouter.pop();
              NotificationHelper.email.emailNotVerified(context);
            } else if (state is IsEmailVerifiedFailure) {
              AppRouter.pop();
              AppRouter.pushReplacementNamed(AppRouterNames.signUp);
              NotificationHelper.email.emailVerificationError(
                context,
              );
            }
          },
        ),
        BlocListener<SetUserBloc, SetUserState>(
          listener: (context, state) {
            if (state is SetUserSuccess) {
              context.read<GetUserBloc>().add(GetUser());
            }
          },
        ),
        BlocListener<GetUserBloc, GetUserState>(
          listener: (context, state) {
            if (state is GetUserSuccess) {
              AppRouter.pop();
              AppRouter.pushReplacementNamed(AppRouterNames.home);
              NotificationHelper.auth.greeting(
                context,
                state.userProfile.name!,
              );
            }
          },
        ),
      ],
      child: _EmailVerificationButtonView(),
    );
  }
}

class _EmailVerificationButtonView extends StatelessWidget {
  const _EmailVerificationButtonView();

  @override
  Widget build(BuildContext context) {
    return CustomAuthButton(
      text: 'Подтвердил',
      onPressed: () {
        context.read<IsEmailVerifiedBloc>().add(IsEmailVerified());
      },
    );
  }
}

class _SendEmailVerificationButton extends StatelessWidget {
  const _SendEmailVerificationButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<SendEmailVerificationBloc>().add(SendEmailVerification());
      },
      child: const Text('Отпраавить письмо повторно'),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        AppRouter.pushReplacementNamed(AppRouterNames.changeEmail);
      },
      child: const Text('Не приходит письмо?  Изменить почту'),
    );
  }
}
