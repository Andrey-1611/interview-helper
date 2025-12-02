import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/utils/dialog_helper.dart';
import 'package:interview_master/core/utils/toast_helper.dart';
import '../../../app/router/app_router_names.dart';
import '../../../core/utils/network_info.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';
import '../../../generated/l10n.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../widgets/custom_auth_button.dart';
import '../widgets/custom_text_form_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocProvider(
      create: (context) => AuthBloc(
        GetIt.I<AuthRepository>(),
        GetIt.I<RemoteRepository>(),
        GetIt.I<LocalRepository>(),
        GetIt.I<NetworkInfo>(),
      ),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            DialogHelper.showLoadingDialog(context, s.authorization);
          } else if (state is AuthSuccess) {
            context.pop();
            context.pushReplacement(
              AppRouterNames.emailVerification,
              extra: _passwordController.text.trim(),
            );
            ToastHelper.sendEmailVerification(_emailController.text, context);
          } else if (state is AuthNetworkFailure) {
            context.pop();
            ToastHelper.unknownError(context);
          } else if (state is AuthFailure) {
            context.pop();
            ToastHelper.unknownError(context);
          }
        },
        child: _SignUpPageView(
          formKey: _formKey,
          nameController: _nameController,
          emailController: _emailController,
          passwordController: _passwordController,
          isObscure: _isObscure,
          isObscureChange: isObscureChange,
        ),
      ),
    );
  }

  void isObscureChange() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }
}

class _SignUpPageView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isObscure;
  final VoidCallback isObscureChange;

  const _SignUpPageView({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.isObscure,
    required this.isObscureChange,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Spacer(),
            _SignUpForm(
              formKey: formKey,
              nameController: nameController,
              emailController: emailController,
              passwordController: passwordController,
              isObscure: isObscure,
              isObscureChange: isObscureChange,
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.pushReplacement(AppRouterNames.signIn),
              child: Text(s.already_have_account),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignUpForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isObscure;
  final VoidCallback isObscureChange;

  const _SignUpForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.isObscure,
    required this.isObscureChange,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextFormField(
            controller: nameController,
            hintText: s.name,
            prefixIcon: const Icon(Icons.person),
            keyboardType: TextInputType.name,
          ),
          CustomTextFormField(
            controller: emailController,
            hintText: s.email,
            prefixIcon: const Icon(Icons.email),
            keyboardType: TextInputType.emailAddress,
          ),
          CustomTextFormField(
            controller: passwordController,
            hintText: s.password,
            prefixIcon: const Icon(Icons.lock),
            keyboardType: TextInputType.visiblePassword,
            obscureText: isObscure,
            iconButton: IconButton(
              onPressed: isObscureChange,
              icon: const Icon(Icons.remove_red_eye_outlined),
            ),
          ),
          CustomAuthButton(
            text: s.sign_up,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(
                  SignUp(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
