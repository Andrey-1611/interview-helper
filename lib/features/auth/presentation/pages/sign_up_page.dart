import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interview_master/features/auth/blocs/is_email_verified_bloc/is_email_verified_bloc.dart';
import 'package:interview_master/features/auth/blocs/send_email_verification_bloc/send_email_verification_bloc.dart';
import 'package:interview_master/features/auth/data/data_sources/firebase_auth_data_sources/auth_data_source.dart';
import 'package:interview_master/features/auth/presentation/widgets/custom_email_dialog.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/global_services/notifications/blocs/send_notification_bloc/send_notification_bloc.dart';
import '../../../../core/global_services/notifications/models/notification.dart';
import '../../../../core/global_services/notifications/services/notifications_service.dart';
import '../../../../core/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../core/global_services/user/blocs/set_user/set_user_bloc.dart';
import '../../../../core/global_services/user/services/user_interface.dart';
import '../../../interview/presentation/widgets/custom_button.dart';
import '../../blocs/sign_up_bloc/sign_up_bloc.dart';
import '../../../../core/global_services/user/models/user_profile.dart';
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
          create: (context) => SetUserBloc(context.read<UserInterface>()),
        ),
        BlocProvider(
          create: (context) => GetUserBloc(context.read<UserInterface>()),
        ),
        BlocProvider(
          create: (context) => SendNotificationBloc(NotificationsService()),
        ),
        BlocProvider(
          create: (context) => SendEmailVerificationBloc(
            AuthDataSource(firebaseAuth: FirebaseAuth.instance),
          ),
        ),
        BlocProvider(
          create: (context) => IsEmailVerifiedBloc(
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
            Form(
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
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRouterNames.signIn);
              },
              child: const Text('Уже есть аккаунт?  Войти в аккаунт'),
            ),
          ],
        ),
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
            if (state is SignUpSuccess) {
              context.read<SendEmailVerificationBloc>().add(
                SendEmailVerification(),
              );
            } else if (state is SignUpFailure) {
              context.read<SendNotificationBloc>().add(
                _sendNotification('Ошибка регистрации!', Icon(Icons.error)),
              );
            }
          },
        ),
        BlocListener<SendEmailVerificationBloc, SendEmailVerificationState>(
          listener: (context, state) {
            if (state is SendEmailVerificationSuccess) {
              context.read<SendNotificationBloc>().add(
                _sendNotification(
                  'Писмо отправленно на указанную вами почту!',
                  Icon(Icons.info),
                ),
              );
              _showDialog(context);
            } else if (state is SendEmailVerificationFailure) {
              context.read<SendNotificationBloc>().add(
                _sendNotification('Ошибка регистрации!', Icon(Icons.error)),
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
              }
            } else if (state is IsEmailVerifiedFailure) {
              context.read<SendNotificationBloc>().add(
                _sendNotification('Ошибка регистрации!', Icon(Icons.error)),
              );
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
                _sendNotification('Ошибка регистрации!', Icon(Icons.error)),
              );
            }
          },
        ),
        BlocListener<GetUserBloc, GetUserState>(
          listener: (context, state) {
            if (state is GetUserSuccess) {
              context.read<SendNotificationBloc>().add(
                _sendNotification(
                  '${state.userProfile.name}, добро пожаловать!',
                  Icon(Icons.star),
                ),
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
          return const Center(child: CircularProgressIndicator());
        }
        return CustomButton(
          text: 'Зарегистрироваться',
          selectedColor: Colors.blue,
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
          textColor: Colors.white,
          percentsHeight: 0.06.sp,
          percentsWidth: 1.sp,
        );
      },
    );
  }
}
