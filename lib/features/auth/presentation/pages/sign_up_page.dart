import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/features/auth/blocs/send_email_verification_bloc/send_email_verification_bloc.dart';
import 'package:interview_master/features/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:interview_master/features/auth/data/data_sources/auth_data_source.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/global_services/notifications/blocs/send_notification_bloc/send_notification_bloc.dart';
import '../../../../core/global_services/notifications/models/notification.dart';
import '../../../../core/global_services/user/models/user_profile.dart';
import '../../blocs/sign_up_bloc/sign_up_bloc.dart';
import '../widgets/custom_auth_button.dart';
import '../widgets/custom_loading_indicator.dart';
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
          create: (context) =>
              SignUpBloc(AuthDataSource(firebaseAuth: FirebaseAuth.instance)),
        ),
        BlocProvider(
          create: (context) =>
              SignInBloc(AuthDataSource(firebaseAuth: FirebaseAuth.instance)),
        ),
        BlocProvider(
          create: (context) => SendEmailVerificationBloc(
            AuthDataSource(firebaseAuth: FirebaseAuth.instance),
          ),
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
            _SignInNavigationButton(),
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

class _SignInNavigationButton extends StatelessWidget {
  const _SignInNavigationButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, AppRouterNames.signIn);
      },
      child: const Text('Уже есть аккаунт?  Войти в аккаунт'),
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
            if (state is SignUpSuccess) {
              AppRouter.pushReplacementNamed(
                AppRouterNames.emailVerification,
              );
            } else if (state is SignUpFailure) {
              context.read<SendNotificationBloc>().add(
                _sendNotification('Ошибка регистрации!', Icon(Icons.error)),
              );
            }
          },
        ),
        BlocListener<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state is SignInSuccess) {
              context.read<SendEmailVerificationBloc>().add(
                SendEmailVerification(),
              );
            }
          },
        ),
        BlocListener<SendEmailVerificationBloc, SendEmailVerificationState>(
          listener: (context, state) {
            if (state is SendEmailVerificationSuccess) {
              AppRouter.pushReplacementNamed(AppRouterNames.emailVerification);
              _sendNotification(
                'Письмо с подтверждением отправлено на вашу почту',
                Icon(Icons.info),
              );
            } else if (state is SendEmailVerificationFailure) {
              context.read<SendNotificationBloc>().add(
                _sendNotification('Ошибка входа', Icon(Icons.error)),
              );
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

  SendNotification _sendNotification(String text, Icon icon) {
    return SendNotification(
      notification: MyNotification(text: text, icon: icon),
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
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        if (state is SignUpLoading) {
          return const CustomLoadingIndicator();
        }
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
      },
    );
  }
}
