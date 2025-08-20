import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interview_master/app/global_services/providers/user_provider.dart';
import 'package:interview_master/core/helpers/toast_helpers/toast_helper.dart';
import 'package:interview_master/features/auth/presentation/blocs/watch_email_verified_bloc/watch_email_verified_bloc.dart';
import '../../../../app/dependencies/di_container.dart';
import '../../../../app/global_services/user/models/user_data.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../blocs/send_email_verification_bloc/send_email_verification_bloc.dart';

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
              SendEmailVerificationBloc(DIContainer.sendEmailVerification),
        ),
        BlocProvider(
          create: (context) =>
              WatchEmailVerifiedBloc(DIContainer.watchEmailVerified)
                ..add(WatchEmailVerified()),
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

class _EmailVerificationForm extends ConsumerWidget {
  const _EmailVerificationForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SendEmailVerificationBloc, SendEmailVerificationState>(
          listener: (context, state) {
            if (state is SendEmailVerificationSuccess) {
              ToastHelper.sendAgainEmailVerification();
            }
          },
        ),
        BlocListener<WatchEmailVerifiedBloc, WatchEmailVerifiedState>(
          listener: (context, state) {
            if (state is WatchEmailVerifiedSuccess) {
              ref.read(currentUserProvider.notifier).state =
                  UserData.fromMyUser(state.user);
              AppRouter.pushReplacementNamed(AppRouterNames.home);
            } else if (state is WatchEmailVerifiedFailure) {
              AppRouter.pushReplacementNamed(AppRouterNames.signUp);
              ToastHelper.unknownError();
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
    return Text(
      'Подтвердите свою почту',
      style: Theme.of(context).textTheme.bodyMedium,
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

