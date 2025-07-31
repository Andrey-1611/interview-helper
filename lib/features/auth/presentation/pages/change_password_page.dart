import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';
import 'package:interview_master/core/helpers/dialog_helpers/dialog_helper.dart';
import 'package:interview_master/core/helpers/notification_helpers/notification_helper.dart';
import 'package:interview_master/features/auth/data/data_sources/auth_data_source.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../blocs/change_password_bloc/change_password_bloc.dart';
import '../widgets/custom_auth_button.dart';
import '../widgets/custom_text_form_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChangePasswordBloc(AuthDataSource(FirebaseAuth.instance)),
      child: _ChangePasswordPageView(
        emailController: _emailController,
        formKey: _formKey,
      ),
    );
  }
}

class _ChangePasswordPageView extends StatelessWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;

  const _ChangePasswordPageView({
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
                _ChangePasswordButton(
                  emailController: emailController,
                  formKey: formKey,
                ),
                const Spacer(),
                const _NavigationButton(),
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

class _ChangePasswordButton extends StatelessWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;

  const _ChangePasswordButton({
    required this.emailController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordLoading) {
          DialogHelper.showLoadingDialog(context);
        } else if (state is ChangePasswordSuccess) {
          Navigator.pop(context);
          NotificationHelper.email.sendPasswordResetEmail(context);
        } else if (state is ChangePasswordFailure) {
          Navigator.pop(context);
          NotificationHelper.email.sendPasswordResetEmailError(context);
        }
      },
      child: _ChangePasswordButtonView(
        emailController: emailController,
        formKey: formKey,
      ),
    );
  }
}

class _ChangePasswordButtonView extends StatelessWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;

  const _ChangePasswordButtonView({
    required this.emailController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAuthButton(
      text: 'Подтвердить',
      onPressed: () {
        if (formKey.currentState!.validate()) {
          context.read<ChangePasswordBloc>().add(
            ChangePassword(
              userProfile: UserProfile(email: emailController.text.trim()),
            ),
          );
        }
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
        AppRouter.pushReplacementNamed(AppRouterNames.signIn);
      },
      child: const Text('Вернуться на экран входа'),
    );
  }
}
