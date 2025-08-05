import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/blocs/send_email_verification_bloc/send_email_verification_bloc.dart';
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
  late final String password;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    password = ModalRoute.of(context)!.settings.arguments as String;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SendEmailVerificationBloc(DiContainer.authRepository),
        ),
        BlocProvider(
          create: (context) =>
              IsEmailVerifiedBloc(DiContainer.authRepository)
                ..add(WatchEmailVerified()),
        ),
        BlocProvider(
          create: (context) => SetUserBloc(DiContainer.userRepository),
        ),
        BlocProvider(
          create: (context) => GetUserBloc(DiContainer.userRepository),
        ),
      ],
      child: _EmailVerificationPageView(password: password),
    );
  }
}

class _EmailVerificationPageView extends StatelessWidget {
  final String password;

  const _EmailVerificationPageView({required this.password});

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
              const _EmailVerificationForm(),
              const _SendEmailVerificationButton(),
              const Spacer(),
              _NavigationButton(password: password),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailVerificationForm extends StatelessWidget {
  const _EmailVerificationForm();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SendEmailVerificationBloc, SendEmailVerificationState>(
          listener: (context, state) {
            if (state is SendEmailVerificationSuccess) {
              NotificationHelper.email.sendEmailVerification(context);
            }
          },
        ),
        BlocListener<IsEmailVerifiedBloc, IsEmailVerifiedState>(
          listener: (context, state) {
            if (state is IsEmailVerifiedSuccess) {
              context.read<SetUserBloc>().add(
                SetUser(userProfile: state.result.userProfile),
              );
            } else if (state is IsEmailVerifiedFailure) {
              AppRouter.pushReplacementNamed(AppRouterNames.signUp);
              NotificationHelper.email.emailVerificationError(context);
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
              AppRouter.pushReplacementNamed(AppRouterNames.home);
              NotificationHelper.auth.greeting(
                context,
                state.userProfile.name!,
              );
            }
          },
        ),
      ],
      child: _EmailVerificationFormView(),
    );
  }
}

class _EmailVerificationFormView extends StatelessWidget {
  const _EmailVerificationFormView();

  @override
  Widget build(BuildContext context) {
    return Text('Подтвердите свою почту');
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
  final String password;

  const _NavigationButton({required this.password});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        AppRouter.pushReplacementNamed(
          AppRouterNames.changeEmail,
          arguments: password,
        );
      },
      child: const Text('Не приходит письмо?  Изменить почту'),
    );
  }
}
