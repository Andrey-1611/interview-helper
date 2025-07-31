import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/dependencies/di_container.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/app/navigation/app_router_names.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';
import 'package:interview_master/core/helpers/dialog_helpers/dialog_helper.dart';
import 'package:interview_master/core/helpers/notification_helpers/notification_helper.dart';
import 'package:interview_master/features/auth/blocs/sign_out_bloc/sign_out_bloc.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_text_form_field.dart';
import '../../blocs/change_email_bloc/change_email_bloc.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChangeEmailBloc(DiContainer.authRepository),
        ),
        BlocProvider(
          create: (context) => SignOutBloc(DiContainer.authRepository),
        ),
      ],
      child: _ChangeEmailPageView(
        emailController: _emailController,
        formKey: _formKey,
      ),
    );
  }
}

class _ChangeEmailPageView extends StatelessWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;

  const _ChangeEmailPageView({
    required this.emailController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                _EmailForm(emailController: emailController),
                _ChangeEmailButton(
                  emailController: emailController,
                  formKey: formKey,
                ),
                const Spacer(),
                _NavigationButton(),
              ],
            ),
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
  final GlobalKey<FormState> formKey;

  const _ChangeEmailButton({
    required this.emailController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChangeEmailBloc, ChangeEmailState>(
          listener: (context, state) {
            if (state is ChangeEmailLoading) {
              DialogHelper.showLoadingDialog(context);
            } else if (state is ChangeEmailSuccess) {
              context.read<SignOutBloc>().add(SignOut());
            } else if (state is ChangeEmailFailure) {
              AppRouter.pop();
              NotificationHelper.email.changeEmailError(context);
            }
          },
        ),
        BlocListener<SignOutBloc, SignOutState>(
          listener: (context, state) {
            if (state is SignOutSuccess) {
              AppRouter.pop();
              AppRouter.pushReplacementNamed(AppRouterNames.signIn);
              NotificationHelper.email.sendNewEmailVerification(context);
            }
          },
        ),
      ],
      child: _ChangeEmailButtonView(
        emailController: emailController,
        formKey: formKey,
      ),
    );
  }
}

class _ChangeEmailButtonView extends StatelessWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;

  const _ChangeEmailButtonView({
    required this.emailController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeEmailBloc, ChangeEmailState>(
      builder: (context, state) {
        if (state is ChangeEmailLoading) {
          return const CustomLoadingIndicator();
        }
        return CustomAuthButton(
          text: 'Подтвердить',
          onPressed: () {
            if (formKey.currentState!.validate()) {
              context.read<ChangeEmailBloc>().add(
                ChangeEmail(
                  userProfile: UserProfile(email: emailController.text.trim()),
                ),
              );
            }
          },
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
        AppRouter.pushReplacementNamed(AppRouterNames.emailVerification);
      },
      child: const Text('Вернуться на экран подтверджения почты'),
    );
  }
}
