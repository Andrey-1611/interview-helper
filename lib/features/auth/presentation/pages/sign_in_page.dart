import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/dependencies/di_container.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/features/auth/blocs/is_email_verified_bloc/is_email_verified_bloc.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_text_form_field.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../core/global_services/user/blocs/set_user_bloc/set_user_bloc.dart';
import '../../../../core/helpers/dialog_helpers/dialog_helper.dart';
import '../../../../core/helpers/notification_helpers/notification_helper.dart';
import '../../blocs/sign_in_bloc/sign_in_bloc.dart';
import '../widgets/custom_auth_button.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignInBloc(DiContainer.authRepository),
        ),
        BlocProvider(
          create: (context) => IsEmailVerifiedBloc(DiContainer.authRepository),
        ),
        BlocProvider(
          create: (context) => SetUserBloc(DiContainer.userRepository),
        ),
        BlocProvider(
          create: (context) => GetUserBloc(DiContainer.userRepository),
        ),
      ],
      child: _SignInPageView(
        formKey: _formKey,
        emailController: _emailController,
        passwordController: _passwordController,
        isObscure: _isObscure,
        isObscureChange: _isObscureChange,
      ),
    );
  }

  void _isObscureChange() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }
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
      appBar: AppBar(),
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
    return MultiBlocListener(
      listeners: [
        BlocListener<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state is SignInLoading) {
              DialogHelper.showLoadingDialog(context);
            } else if (state is SignInSuccess) {
              context.read<IsEmailVerifiedBloc>().add(IsEmailVerified());
            }
            if (state is SignInFailure) {
              AppRouter.pop();
              NotificationHelper.auth.signInErrorNotification(context);
            }
          },
        ),
        BlocListener<IsEmailVerifiedBloc, IsEmailVerifiedState>(
          listener: (context, state) {
            if (state is IsEmailVerifiedSuccess) {
              context.read<SetUserBloc>().add(
                SetUser(userProfile: state.isEmailVerified.userProfile),
              );
            } else if (state is IsEmailNotVerified) {
              AppRouter.pop();
              AppRouter.pushReplacementNamed(AppRouterNames.emailVerification);
              NotificationHelper.email.emailNotVerifiedNotification(context);
            } else if (state is IsEmailVerifiedFailure) {
              AppRouter.pop();
              NotificationHelper.email.checkEmailErrorNotification(context);
            }
          },
        ),
        BlocListener<SetUserBloc, SetUserState>(
          listener: (context, state) {
            if (state is SetUserSuccess) {
              context.read<GetUserBloc>().add(GetUser());
            }
          },
        ),
        BlocListener<GetUserBloc, GetUserState>(
          listener: (context, state) {
            if (state is GetUserSuccess) {
              AppRouter.pop();
              AppRouter.pushReplacementNamed(AppRouterNames.home);
              NotificationHelper.auth.greetingNotification(context, state.userProfile.name!);
            }
          },
        ),
      ],
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
              userProfile: UserProfile(email: emailController.text.trim()),
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
        AppRouter.pushReplacementNamed(AppRouterNames.changePassword);
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
        AppRouter.pushReplacementNamed(AppRouterNames.signUp);
      },
      child: const Text('Еще нет аккаунта?  Создать аккаунт'),
    );
  }
}
