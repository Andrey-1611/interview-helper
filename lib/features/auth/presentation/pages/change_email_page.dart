import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/app/navigation/app_router_names.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';
import 'package:interview_master/features/auth/data/data_sources/auth_data_source.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_loading_indicator.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_text_form_field.dart';
import '../../../../core/global_services/notifications/blocs/send_notification_bloc/send_notification_bloc.dart';
import '../../../../core/global_services/notifications/models/notification.dart';
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
    return BlocProvider(
      create: (context) =>
          ChangeEmailBloc(AuthDataSource(firebaseAuth: FirebaseAuth.instance)),
      child: _ChangeEmailPageView(emailController: _emailController),
    );
  }
}

class _ChangeEmailPageView extends StatelessWidget {
  final TextEditingController emailController;

  const _ChangeEmailPageView({required this.emailController});

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
              _ChangeEmailButton(emailController: emailController),
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

  const _ChangeEmailButton({required this.emailController});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangeEmailBloc, ChangeEmailState>(
      listener: (context, state) {
        if (state is ChangeEmailSuccess) {
          _successMove(context);
        } else if (state is ChangeEmailFailure) {
          context.read<SendNotificationBloc>().add(
            _sendNotification('Ошибка изменения почты!', Icon(Icons.error)),
          );
        }
      },
      builder: (context, state) {
        if (state is ChangeEmailInitial || state is ChangeEmailSuccess) {
          return _ChangeEmailButtonView(emailController: emailController);
        }
        return CustomLoadingIndicator();
      },
    );
  }

  void _successMove(BuildContext context) {
    AppRouter.pushReplacementNamed(AppRouterNames.emailVerification);
    context.read<SendNotificationBloc>().add(
      _sendNotification(
        'Письмо с подтверждением отправлено на вашу новую почту!',
        Icon(Icons.star),
      ),
    );
  }

  SendNotification _sendNotification(String text, Icon icon) {
    return SendNotification(
      notification: MyNotification(text: text, icon: icon),
    );
  }
}

class _ChangeEmailButtonView extends StatelessWidget {
  final TextEditingController emailController;

  const _ChangeEmailButtonView({required this.emailController});

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
        AppRouter.pushReplacementNamed(AppRouterNames.emailVerification);
      },
      child: const Text('Вернуться на экран подтверджения почты'),
    );
  }
}
