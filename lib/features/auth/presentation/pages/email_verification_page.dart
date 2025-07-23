import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/helpers/notification_helpers/auth_notification_helper.dart';
import 'package:interview_master/features/auth/blocs/send_email_verification_bloc/send_email_verification_bloc.dart';
import 'package:interview_master/features/auth/data/data_sources/auth_data_source.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_loading_indicator.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../core/global_services/user/blocs/set_user_bloc/set_user_bloc.dart';
import '../../../../core/global_services/user/services/user_interface.dart';
import '../../../../core/helpers/notification_helpers/email_notification_helepr.dart';
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
          create: (context) => SendEmailVerificationBloc(
            AuthDataSource(firebaseAuth: FirebaseAuth.instance),
          ),
        ),
        BlocProvider(
          create: (context) => IsEmailVerifiedBloc(
            AuthDataSource(firebaseAuth: FirebaseAuth.instance),
          ),
        ),
        BlocProvider(
          create: (context) => SetUserBloc(context.read<UserInterface>()),
        ),
        BlocProvider(
          create: (context) => GetUserBloc(context.read<UserInterface>()),
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const _EmailVerificationButton(),
              const _SendEmailVerificationButton(),
              const Spacer(),
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
              EmailNotificationHelper.sendEmailVerificationNotification(context);
            }
          },
        ),
        BlocListener<IsEmailVerifiedBloc, IsEmailVerifiedState>(
          listener: (context, state) {
            if (state is IsEmailVerifiedSuccess) {
              context.read<SetUserBloc>().add(
                SetUser(userProfile: state.isEmailVerified.userProfile),
              );
            } else if (state is IsEmailNotVerified) {
              EmailNotificationHelper.emailNotVerifiedNotification(context);
            } else if (state is IsEmailVerifiedFailure) {
              AppRouter.pushReplacementNamed(AppRouterNames.signUp);
              EmailNotificationHelper.emailVerificationErrorNotification(context);
            }
          },
        ),
        BlocListener<SetUserBloc, SetUserState>(
          listener: (context, state) {
            if (state is SetUserSuccess) {
              AppRouter.pushReplacementNamed(AppRouterNames.home);
              context.read<GetUserBloc>().add(GetUser());
            }
          },
        ),
        BlocListener<GetUserBloc, GetUserState>(
          listener: (context, state) {
            if (state is GetUserSuccess) {
              AuthNotificationHelper.greetingNotification(context, state.userProfile.name!);
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
    return BlocBuilder<IsEmailVerifiedBloc, IsEmailVerifiedState>(
      builder: (context, state) {
        if (state is IsEmailVerifiedLoading) {
          return const CustomLoadingIndicator();
        }
        return CustomAuthButton(
          text: 'Подтвердил',
          onPressed: () {
            context.read<IsEmailVerifiedBloc>().add(IsEmailVerified());
          },
        );
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
