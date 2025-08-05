import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/core/helpers/dialog_helpers/dialog_helper.dart';
import 'package:interview_master/features/auth/blocs/send_email_verification_bloc/send_email_verification_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/global_services/user/models/user_profile.dart';
import '../../../../core/helpers/notification_helpers/notification_helper.dart';
import '../../blocs/sign_up_bloc/sign_up_bloc.dart';
import '../../data/repositories/auth_repository.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignUpBloc(context.read<AuthRepository>()),
        ),
        BlocProvider(
          create: (context) =>
              SendEmailVerificationBloc(context.read<AuthRepository>()),
        ),
      ],
      child: _SignUpPageView(
        formKey: _formKey,
        nameController: _nameController,
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
            const _SignInNavigationButton(),
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
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextFormField(
            controller: nameController,
            hintText: 'Имя',
            prefixIcon: const Icon(Icons.person),
            keyboardType: TextInputType.name,
          ),
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
          _SignUpButton(
            formKey: formKey,
            nameController: nameController,
            emailController: emailController,
            passwordController: passwordController,
          ),
        ],
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _SignUpButton({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignUpLoading) {
              DialogHelper.showLoadingDialog(context);
            } else if (state is SignUpSuccess) {
              context.read<SendEmailVerificationBloc>().add(
                SendEmailVerification(),
              );
            } else if (state is SignUpFailure) {
              AppRouter.pop();
              NotificationHelper.auth.signUpError(context);
            }
          },
        ),
        BlocListener<SendEmailVerificationBloc, SendEmailVerificationState>(
          listener: (context, state) {
            if (state is SendEmailVerificationSuccess) {
              AppRouter.pop();
              AppRouter.pushReplacementNamed(
                AppRouterNames.emailVerification,
                arguments: passwordController.text.trim(),
              );
              NotificationHelper.email.sendEmailVerification(context);
            } else if (state is SendEmailVerificationFailure) {
              AppRouter.pop();
              NotificationHelper.email.emailVerificationError(context);
            }
          },
        ),
      ],
      child: _CustomButtonView(
        formKey: formKey,
        nameController: nameController,
        emailController: emailController,
        passwordController: passwordController,
      ),
    );
  }
}

class _CustomButtonView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _CustomButtonView({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAuthButton(
      text: 'Зарегистрироваться',
      onPressed: () {
        if (formKey.currentState!.validate()) {
          context.read<SignUpBloc>().add(
            SignUp(
              userProfile: UserProfile(
                id: Uuid().v1(),
                email: emailController.text.trim(),
                name: nameController.text.trim(),
              ),
              password: passwordController.text.trim(),
            ),
          );
        }
      },
    );
  }
}

class _SignInNavigationButton extends StatelessWidget {
  const _SignInNavigationButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        AppRouter.pushReplacementNamed(AppRouterNames.signIn);
      },
      child: const Text('Уже есть аккаунт?  Войти в аккаунт'),
    );
  }
}
