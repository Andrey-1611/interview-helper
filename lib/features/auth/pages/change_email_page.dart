import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/utils/dialog_helper.dart';
import 'package:interview_master/core/utils/toast_helper.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../core/utils/network_info.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../widgets/custom_auth_button.dart';
import '../widgets/custom_text_form_field.dart';

class ChangeEmailPage extends StatefulWidget {
  final String password;

  const ChangeEmailPage({super.key, required this.password});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
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
      child: _ChangeEmailPageView(
        emailController: _emailController,
        formKey: _formKey,
        password: widget.password,
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
      appBar: AppBar(title: Text('Смена почты')),
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
                _ChangeEmailButton(
                  emailController: emailController,
                  formKey: formKey,
                  password: password,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    context.pushReplacement(
                      AppRouterNames.emailVerification,
                      extra: password,
                    );
                  },
                  child: const Text('Вернуться на экран подтверджения почты'),
                ),
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          DialogHelper.showLoadingDialog(context, 'Смена почты...');
        } else if (state is AuthSuccess) {
          context.pop();
          context.pushReplacement(
            AppRouterNames.emailVerification,
            extra: password,
          );
        } else if (state is AuthNetworkFailure) {
          context.pop();
          ToastHelper.networkError(context);
        } else if (state is AuthFailure) {
          context.pop();
          ToastHelper.unknownError(context);
        }
      },
      child: CustomAuthButton(
        text: 'Подтвердить',
        onPressed: () {
          if (formKey.currentState!.validate()) {
            context.read<AuthBloc>().add(
              ChangeEmail(
                email: emailController.text.trim(),
                password: password,
              ),
            );
          }
        },
      ),
    );
  }
}
