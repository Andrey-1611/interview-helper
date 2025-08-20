import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/dependencies/di_container.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/app/navigation/app_router_names.dart';
import 'package:interview_master/core/helpers/dialog_helpers/dialog_helper.dart';
import 'package:interview_master/core/helpers/toast_helpers/toast_helper.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_text_form_field.dart';
import '../blocs/change_email_bloc/change_email_bloc.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final String password;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    password = ModalRoute.of(context)!.settings.arguments as String;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangeEmailBloc(DIContainer.changeEmail),
      child: _ChangeEmailPageView(
        emailController: _emailController,
        formKey: _formKey,
        password: password,
      ),
    );
  }
}

class _ChangeEmailPageView extends StatelessWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;
  final String password;

  const _ChangeEmailPageView({
    required this.emailController,
    required this.formKey,
    required this.password,
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
                  password: password,
                ),
                const Spacer(),
                _NavigationButton(password: password),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChangeEmailButton extends StatelessWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;
  final String password;

  const _ChangeEmailButton({
    required this.emailController,
    required this.formKey,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangeEmailBloc, ChangeEmailState>(
      listener: (context, state) {
        if (state is ChangeEmailLoading) {
          DialogHelper.showLoadingDialog(context, 'Смена почты...');
        } else if (state is ChangeEmailSuccess) {
          AppRouter.pop();
          AppRouter.pushReplacementNamed(
            AppRouterNames.emailVerification,
            arguments: password,
          );
        } else if (state is ChangeEmailFailure) {
          AppRouter.pop();
          ToastHelper.unknownError();
        }
      },
      child: _ChangeEmailButtonView(
        emailController: emailController,
        formKey: formKey,
        password: password,
      ),
    );
  }
}

class _ChangeEmailButtonView extends StatelessWidget {
  final TextEditingController emailController;
  final String password;
  final GlobalKey<FormState> formKey;

  const _ChangeEmailButtonView({
    required this.emailController,
    required this.formKey,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAuthButton(
      text: 'Подтвердить',
      onPressed: () {
        if (formKey.currentState!.validate()) {
          context.read<ChangeEmailBloc>().add(
            ChangeEmail(email: emailController.text.trim(), password: password),
          );
        }
      },
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

class _NavigationButton extends StatelessWidget {
  final String password;

  const _NavigationButton({required this.password});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        AppRouter.pushReplacementNamed(
          AppRouterNames.emailVerification,
          arguments: password,
        );
      },
      child: const Text('Вернуться на экран подтверджения почты'),
    );
  }
}
