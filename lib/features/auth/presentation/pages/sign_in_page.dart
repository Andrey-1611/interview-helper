import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/core/helpers/notification_helpers/auth_notification_helper.dart';
import 'package:interview_master/core/helpers/notification_helpers/email_notification_helepr.dart';
import 'package:interview_master/features/auth/blocs/is_email_verified_bloc/is_email_verified_bloc.dart';
import 'package:interview_master/features/auth/data/data_sources/auth_data_source.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_text_form_field.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../core/global_services/user/blocs/set_user_bloc/set_user_bloc.dart';
import '../../../../core/global_services/user/services/user_interface.dart';
import '../../blocs/sign_in_bloc/sign_in_bloc.dart';
import '../widgets/custom_auth_button.dart';
import '../widgets/custom_loading_indicator.dart';

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
          create: (context) =>
              SignInBloc(AuthDataSource(firebaseAuth: FirebaseAuth.instance)),
        ),
        BlocProvider(
          create: (context) => IsEmailVerifiedBloc(
            AuthDataSource(firebaseAuth: FirebaseAuth.instance),
          ),
        ),
        BlocProvider(
          create: (context) => SetUserBloc(context.read<UserInterface>()),
        ),
        BlocProvider(
          create: (context) => GetUserBloc(context.read<UserInterface>()),
        ),
      ],
      child: _SignInPageView(
        formKey: _formKey,
        emailController: _emailController,
        passwordController: _passwordController,
        isObscure: _isObscure,
        isObscureChange: isObscureChange,
      ),
    );
  }

  void isObscureChange() {
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
            _PasswordNavigationButton(),
            const Spacer(),
            _SignUpNavigationButton(),
          ],
        ),
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
            if (state is SignInSuccess) {
              context.read<IsEmailVerifiedBloc>().add(IsEmailVerified());
            }
            if (state is SignInFailure) {
              AuthNotificationHelper.signInErrorNotification(context);
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
              AppRouter.pushReplacementNamed(AppRouterNames.emailVerification);
              EmailNotificationHelper.emailNotVerifiedNotification(context);
            } else if (state is IsEmailVerifiedFailure) {
              EmailNotificationHelper.checkEmailErrorNotification(context);
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
              AppRouter.pushReplacementNamed(AppRouterNames.home);
              AuthNotificationHelper.greetingNotification(
                context,
                state.userProfile.name!,
              );
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
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        if (state is SignInLoading) {
          return const CustomLoadingIndicator();
        }
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
      },
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
