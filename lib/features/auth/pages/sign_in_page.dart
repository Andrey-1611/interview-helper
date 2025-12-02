import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/core/utils/toast_helper.dart';
import '../../../core/utils/data_cubit.dart';
import 'package:interview_master/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:interview_master/features/auth/widgets/custom_google_button.dart';
import '../../../app/router/app_router_names.dart';
import '../../../core/utils/dialog_helper.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';
import '../../../generated/l10n.dart';
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
            DialogHelper.showLoadingDialog(context, s.signing_in);
          } else if (state is AuthSuccess) {
            context.pop();
            context.read<DataCubit>().updateKeyValue();
            context.go(AppRouterNames.initial);
          } else if (state is AuthEmailNotVerified) {
            context.pop();
            context.pushReplacement(
              AppRouterNames.emailVerification,
              extra: _passwordController.text.trim(),
            );
            ToastHelper.sendEmailVerification(_emailController.text, context);
          } else if (state is AuthWithoutDirections) {
            context.pop();
            context.pushReplacement(AppRouterNames.directions);
          } else if (state is AuthNetworkFailure) {
            context.pop();
            ToastHelper.networkError(context);
          } else if (state is AuthFailure) {
            context.pop();
            ToastHelper.signInError(context);
          }
        },
        child: _SignInPageView(
          formKey: _formKey,
          emailController: _emailController,
          passwordController: _passwordController,
          isObscure: _isObscure,
          isObscureChange: _isObscureChange,
        ),
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
    final s = S.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            _SignInForm(
              formKey: formKey,
              emailController: emailController,
              passwordController: passwordController,
              isObscure: isObscure,
              isObscureChange: isObscureChange,
            ),
            TextButton(
              onPressed: () =>
                  context.pushReplacement(AppRouterNames.changePassword),
              child: Text(s.forgot_password_change),
            ),
            CustomGoogleButton(),
            const Spacer(),
            TextButton(
              onPressed: () => context.pushReplacement(AppRouterNames.signUp),
              child: Text(s.no_account_create),
            ),
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
    final s = S.of(context);
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
            text: s.sign_in,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(
                  SignIn(
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
