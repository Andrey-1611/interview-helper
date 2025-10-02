import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/helpers/toast_helper.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../../core/helpers/dialog_helper.dart';
import '../blocs/sign_in_bloc/sign_in_bloc.dart';
import '../use_cases/sign_in_use_case.dart';
import '../widgets/custom_auth_button.dart';
import '../widgets/custom_text_form_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(GetIt.I<SignInUseCase>()),
      child: _SignInPageView(
        formKey: _formKey,
        emailController: _emailController,
        passwordController: _passwordController,
        isObscure: _isObscure,
        isObscureChange: _isObscureChange,
      ),
    );
  }

  void _isObscureChange() => setState(() => _isObscure = !_isObscure);
}

class _SignInPageView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isObscure;
  final VoidCallback isObscureChange;

  const _SignInPageView({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isObscure,
    required this.isObscureChange,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Spacer(),
            _SignInForm(
              formKey: formKey,
              emailController: emailController,
              passwordController: passwordController,
              isObscure: isObscure,
              isObscureChange: isObscureChange,
            ),
            const _PasswordNavigationButton(),
            const Spacer(),
            const _SignUpNavigationButton(),
          ],
        ),
      ),
    );
  }
}

class _SignInForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isObscure;
  final VoidCallback isObscureChange;

  const _SignInForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isObscure,
    required this.isObscureChange,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomTextFormField(
            controller: emailController,
            hintText: 'Почта',
            prefixIcon: const Icon(Icons.email),
            keyboardType: TextInputType.emailAddress,
          ),
          CustomTextFormField(
            controller: passwordController,
            hintText: 'Пароль',
            prefixIcon: const Icon(Icons.lock),
            keyboardType: TextInputType.visiblePassword,
            obscureText: isObscure,
            iconButton: IconButton(
              onPressed: isObscureChange,
              icon: const Icon(Icons.remove_red_eye_outlined),
            ),
          ),
          _SignInButton(
            formKey: formKey,
            emailController: emailController,
            passwordController: passwordController,
          ),
        ],
      ),
    );
  }
}

class _SignInButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _SignInButton({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInLoading) {
          DialogHelper.showLoadingDialog(context, 'Вход в систему');
        } else if (state is SignInSuccess) {
          context.pop();
          context.pushReplacement(AppRouterNames.initial);
        } else if (state is SignInNoVerification) {
          context.pop();
          context.pushReplacement(
            AppRouterNames.emailVerification,
            extra: passwordController.text.trim(),
          );
          ToastHelper.sendEmailVerification(emailController.text);
        } else if (state is SignInNetworkFailure) {
          context.pop();
          ToastHelper.networkError();
        } else if (state is SignInFailure) {
          context.pop();
          ToastHelper.signInError();
        }
      },
      child: _SignInButtonView(
        formKey: formKey,
        emailController: emailController,
        passwordController: passwordController,
      ),
    );
  }
}

class _SignInButtonView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _SignInButtonView({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAuthButton(
      text: 'Войти',
      onPressed: () {
        if (formKey.currentState!.validate()) {
          context.read<SignInBloc>().add(
            SignIn(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            ),
          );
        }
      },
    );
  }
}

class _PasswordNavigationButton extends StatelessWidget {
  const _PasswordNavigationButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.pushReplacement(AppRouterNames.changePassword);
      },
      child: const Text('Забыли пароль?  Изменить пароль'),
    );
  }
}

class _SignUpNavigationButton extends StatelessWidget {
  const _SignUpNavigationButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.pushReplacement(AppRouterNames.signUp);
      },
      child: const Text('Еще нет аккаунта?  Создать аккаунт'),
    );
  }
}
