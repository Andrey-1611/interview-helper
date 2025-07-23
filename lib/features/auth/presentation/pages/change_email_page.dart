import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/app/navigation/app_router_names.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';
import 'package:interview_master/core/helpers/notification_helpers/email_notification_helepr.dart';
import 'package:interview_master/features/auth/blocs/sign_out_bloc/sign_out_bloc.dart';
import 'package:interview_master/features/auth/data/data_sources/auth_data_source.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_loading_indicator.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_text_form_field.dart';
import '../../blocs/change_email_bloc/change_email_bloc.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChangeEmailBloc(
            AuthDataSource(firebaseAuth: FirebaseAuth.instance),
          ),
        ),
        BlocProvider(
          create: (context) =>
              SignOutBloc(AuthDataSource(firebaseAuth: FirebaseAuth.instance)),
        ),
      ],
      child: _ChangeEmailPageView(
        emailController: _emailController,
      ),
    );
  }
}

class _ChangeEmailPageView extends StatelessWidget {
  final TextEditingController emailController;

  const _ChangeEmailPageView({
    required this.emailController,
  });

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
              _EmailForm(emailController: emailController),
              _ChangeEmailButton(
                emailController: emailController,
              ),
              const Spacer(),
              _NavigationButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailForm extends StatelessWidget {
  final TextEditingController emailController;

  const _EmailForm({required this.emailController});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: emailController,
      hintText: 'Почта',
      prefixIcon: Icon(Icons.email),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class _ChangeEmailButton extends StatelessWidget {
  final TextEditingController emailController;

  const _ChangeEmailButton({
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChangeEmailBloc, ChangeEmailState>(
          listener: (context, state) {
            if (state is ChangeEmailSuccess) {
              context.read<SignOutBloc>().add(SignOut());
            } else if (state is ChangeEmailFailure) {
              EmailNotificationHelper.changeEmailErrorNotification(context);
            }
          },
        ),
        BlocListener<SignOutBloc, SignOutState>(
          listener: (context, state) {
            if (state is SignOutSuccess) {
              AppRouter.pushReplacementNamed(
                AppRouterNames.splash,
              );
              EmailNotificationHelper.sendNewEmailVerificationNotification(
                context,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<ChangeEmailBloc, ChangeEmailState>(
        builder: (context, state) {
          if (state is ChangeEmailInitial || state is ChangeEmailSuccess) {
            return _ChangeEmailButtonView(
              emailController: emailController,
            );
          }
          return CustomLoadingIndicator();
        },
      ),
    );
  }
}

class _ChangeEmailButtonView extends StatelessWidget {
  final TextEditingController emailController;

  const _ChangeEmailButtonView({
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAuthButton(
      text: 'Подтвердить',
      onPressed: () {
        context.read<ChangeEmailBloc>().add(
          ChangeEmail(
            userProfile: UserProfile(email: emailController.text.trim()),
          ),
        );
      },
    );
  }
}

class _NavigationButton extends StatelessWidget {

  const _NavigationButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        AppRouter.pushReplacementNamed(
          AppRouterNames.emailVerification,
        );
      },
      child: const Text('Вернуться на экран подтверджения почты'),
    );
  }
}
