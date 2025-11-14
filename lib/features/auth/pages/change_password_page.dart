import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/utils/toast_helper.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../core/utils/network_info.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
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
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        GetIt.I<AuthRepository>(),
        GetIt.I<RemoteRepository>(),
        GetIt.I<LocalRepository>(),
        GetIt.I<NetworkInfo>(),
      ),
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
                CustomTextFormField(
                  controller: emailController,
                  hintText: 'Почта',
                  prefixIcon: Icon(Icons.email),
                  keyboardType: TextInputType.emailAddress,
                ),
                _ChangePasswordButton(
                  emailController: emailController,
                  formKey: formKey,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () =>
                      context.pushReplacement(AppRouterNames.signIn),
                  child: const Text('Вернуться на экран входа'),
                ),
              ],
            ),
          ),
        ),
      ),
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ToastHelper.sendPasswordResetEmail(emailController.text);
          context.pushReplacement(AppRouterNames.signIn);
        } else if (state is AuthNetworkFailure) {
          ToastHelper.networkError();
        } else if (state is AuthFailure) {
          ToastHelper.unknownError();
        }
      },
      child: CustomAuthButton(
        text: 'Подтвердить',
        onPressed: () {
          if (formKey.currentState!.validate()) {
            context.read<AuthBloc>().add(
              ChangePassword(email: emailController.text.trim()),
            );
          }
        },
      ),
    );
  }
}
