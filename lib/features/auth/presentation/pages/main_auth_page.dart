import 'package:flutter/material.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_auth_button.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../app/navigation/app_router_names.dart';

class MainAuthPage extends StatefulWidget {
  const MainAuthPage({super.key});

  @override
  State<MainAuthPage> createState() => _MainAuthPageState();
}

class _MainAuthPageState extends State<MainAuthPage> {
  @override
  Widget build(BuildContext context) {
    return _MainAuthPageView();
  }
}

class _MainAuthPageView extends StatelessWidget {
  const _MainAuthPageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_SignInButton(), _GoogleButton(), _SignUpButton()],
          ),
        ),
      ),
    );
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton();

  @override
  Widget build(BuildContext context) {
    return CustomAuthButton(
      text: 'Войти с паролем',
      onPressed: () {
        AppRouter.pushNamed(AppRouterNames.signIn);
      },
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton();

  @override
  Widget build(BuildContext context) {
    return CustomAuthButton(text: 'Продолжить с Google', onPressed: () {});
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton();

  @override
  Widget build(BuildContext context) {
    return CustomAuthButton(
      text: 'Регистрация',
      onPressed: () {
        AppRouter.pushNamed(AppRouterNames.signUp);
      },
    );
  }
}
