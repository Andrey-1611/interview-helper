import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interview_master/core/global_services/notifications/blocs/send_notification_bloc/send_notification_bloc.dart';
import 'package:interview_master/core/global_services/notifications/models/notification.dart';
import 'package:interview_master/core/global_services/notifications/services/notifications_service.dart';
import 'package:interview_master/features/auth/blocs/is_email_verified_bloc/is_email_verified_bloc.dart';
import 'package:interview_master/features/auth/data/data_sources/firebase_auth_data_sources/auth_data_source.dart';
import 'package:interview_master/core/global_services/user/models/user_profile.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_text_form_field.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../core/global_services/user/blocs/set_user/set_user_bloc.dart';
import '../../../../core/global_services/user/services/user_interface.dart';
import '../../../interview/presentation/widgets/custom_button.dart';
import '../../blocs/sign_in_bloc/sign_in_bloc.dart';
import '../widgets/custom_email_dialog.dart';

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
        BlocProvider(
          create: (context) => SendNotificationBloc(NotificationsService()),
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
            Form(
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
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRouterNames.signUp);
              },
              child: const Text('Еще нет аккаунта?  Создать аккаунт'),
            ),
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
              context.read<SendNotificationBloc>().add(
                _sendNotification('Ошибка входа', Icon(Icons.error)),
              );
            }
          },
        ),
        BlocListener<IsEmailVerifiedBloc, IsEmailVerifiedState>(
          listener: (context, state) {
            if (state is IsEmailVerifiedSuccess) {
              if (state.isEmailVerified.isEmailVerified) {
                context.read<SetUserBloc>().add(
                  SetUser(userProfile: state.isEmailVerified.userProfile),
                );
              } else {
                _sendNotification(
                  'Пожалуйста, подтвердите свою почту!',
                  Icon(Icons.error),
                );
                _showDialog(context);
              }
            } else if (state is IsEmailVerifiedFailure) {
              _sendNotification('Ошибка входа!', Icon(Icons.error));
            }
          },
        ),
        BlocListener<SetUserBloc, SetUserState>(
          listener: (context, state) {
            if (state is SetUserSuccess) {
              Navigator.pushReplacementNamed(context, AppRouterNames.home);
              context.read<GetUserBloc>().add(GetUser());
            } else if (state is SetUserFailure) {
              context.read<SendNotificationBloc>().add(
                SendNotification(
                  notification: MyNotification(
                    text: 'Ошибка входа',
                    icon: Icon(Icons.error),
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<GetUserBloc, GetUserState>(
          listener: (context, state) {
            if (state is GetUserSuccess) {
              context.read<SendNotificationBloc>().add(
                SendNotification(
                  notification: MyNotification(
                    text: '${state.userProfile.name}, добро пожаловать!',
                    icon: Icon(Icons.star),
                  ),
                ),
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

  SendNotification _sendNotification(String text, Icon icon) {
    return SendNotification(
      notification: MyNotification(text: text, icon: icon),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomEmailDialog();
      },
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
          return const Center(child: CircularProgressIndicator());
        }
        return CustomButton(
          text: 'Войти',
          selectedColor: Colors.blue,
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
          textColor: Colors.white,
          percentsHeight: 0.06.sp,
          percentsWidth: 1.sp,
        );
      },
    );
  }
}
