import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/auth/data/data_sources/auth_data_source.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/global_services/notifications/blocs/send_notification_bloc/send_notification_bloc.dart';
import '../../../../core/global_services/notifications/models/notification.dart';
import '../../blocs/change_password_bloc/change_password_bloc.dart';
import '../widgets/custom_auth_button.dart';
import '../widgets/custom_loading_indicator.dart';
import '../widgets/custom_text_form_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordBloc(
        AuthDataSource(firebaseAuth: FirebaseAuth.instance),
      ),
      child: _ChangePasswordPageView(passwordController: _passwordController),
    );
  }
}

class _ChangePasswordPageView extends StatelessWidget {
  final TextEditingController passwordController;

  const _ChangePasswordPageView({required this.passwordController});

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
              _PasswordForm(passwordController: passwordController),
              _ChangePasswordButton(passwordController: passwordController),
              const Spacer(),
              const _NavigationButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordForm extends StatelessWidget {
  final TextEditingController passwordController;

  const _PasswordForm({required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: passwordController,
      hintText: 'Пароль',
      obscureText: true,
      prefixIcon: Icon(Icons.lock),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class _ChangePasswordButton extends StatelessWidget {
  final TextEditingController passwordController;

  const _ChangePasswordButton({required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          _successMove(context);
        } else if (state is ChangePasswordFailure) {
          context.read<SendNotificationBloc>().add(
            _sendNotification('Ошибка изменения пароля!', Icon(Icons.error)),
          );
        }
      },
      builder: (context, state) {
        if (state is ChangePasswordInitial || state is ChangePasswordSuccess) {
          return _ChangePasswordButtonView(
            passwordController: passwordController,
          );
        }
        return CustomLoadingIndicator();
      },
    );
  }

  void _successMove(BuildContext context) {
    AppRouter.pushReplacementNamed(AppRouterNames.emailVerification);
    context.read<SendNotificationBloc>().add(
      _sendNotification('Вы успешно изменили пароль!', Icon(Icons.star)),
    );
  }

  SendNotification _sendNotification(String text, Icon icon) {
    return SendNotification(
      notification: MyNotification(text: text, icon: icon),
    );
  }
}

class _ChangePasswordButtonView extends StatelessWidget {
  final TextEditingController passwordController;

  const _ChangePasswordButtonView({required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return CustomAuthButton(
      text: 'Подтвердить',
      onPressed: () {
        context.read<ChangePasswordBloc>().add(
          ChangePassword(password: passwordController.text.trim()),
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
      child: const Text('Вернуться на экран входа'),
    );
  }
}
